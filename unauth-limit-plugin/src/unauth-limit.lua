local plugin_name = "unauth-limit"
local limit_local_new = require("resty.limit.count").new
local core = require("apisix.core")
local consumer_mod = require("apisix.consumer")
local lrucache = core.lrucache.new({
    type = 'plugin', serial_creating = true,
})


local schema = {
    type = "object",
    properties = {
        count = {type = "integer", exclusiveMinimum = 0},
        time_window = {type = "integer",  exclusiveMinimum = 0},
        key = {type = "string", default = "remote_addr"},
        key_type = {type = "string",
                    enum = {"var", "var_combination"},
                    default = "var",
        },
        rejected_code = {
            type = "integer", minimum = 200, maximum = 599, default = 503
        },
        rejected_msg = {
            type = "string", minLength = 1
        },
        allow_degradation = {type = "boolean", default = false},
        show_limit_quota_header = {type = "boolean", default = true},
        header = {
            type = "string",
            default = "apikey",
        }
    },
    required = {"count", "time_window"},
}


local _M = {
    version = 1.0,
    priority = 100,
    name = plugin_name,
    schema = schema
}


function _M.check_schema(conf)
    local ok, err = core.schema.check(schema, conf)
    if not ok then
        return false, err
    end

    return true
end


local function create_limit_obj(conf)
    core.log.info("create new limit-count plugin instance")

    return limit_local_new("plugin-" .. plugin_name, conf.count, conf.time_window)
end

local create_consume_cache
do
    local consumer_names = {}

    function create_consume_cache(consumers)
        core.table.clear(consumer_names)

        for _, consumer in ipairs(consumers.nodes) do
            core.log.info("consumer node: ", core.json.delay_encode(consumer))
            consumer_names[consumer.auth_conf.key] = consumer
        end

        return consumer_names
    end
end

function _M.access(conf, ctx)
    core.log.info("ver: ", ctx.conf_version)

    -- no limit if the request is authenticated
    local key = core.request.header(ctx, conf.header)
    if key then
        local consumer_conf = consumer_mod.plugin("key-auth")
        if consumer_conf then
            local consumers = lrucache("consumers_key", consumer_conf.conf_version,
                    create_consume_cache, consumer_conf)
            local consumer = consumers[key]
            if consumer then
                return
            end
        end
    end

    local lim, err = core.lrucache.plugin_ctx(lrucache, ctx, conf.policy, create_limit_obj, conf)
    if not lim then
        core.log.error("failed to fetch limit.count object: ", err)
        if conf.allow_degradation then
            return
        end
        return 500
    end

    local conf_key = conf.key
    local key
    if conf.key_type == "var_combination" then
        local err, n_resolved
        key, err, n_resolved = core.utils.resolve_var(conf_key, ctx.var);
        if err then
            core.log.error("could not resolve vars in ", conf_key, " error: ", err)
        end

        if n_resolved == 0 then
            key = nil
        end
    else
        key = ctx.var[conf_key]
    end

    if key == nil then
        core.log.info("The value of the configured key is empty, use client IP instead")
        -- When the value of key is empty, use client IP instead
        key = ctx.var["remote_addr"]
    end

    key = key .. ctx.conf_type .. ctx.conf_version
    core.log.info("limit key: ", key)

    local delay, remaining = lim:incoming(key, true)
    if not delay then
        local err = remaining
        if err == "rejected" then
            if conf.rejected_msg then
                return conf.rejected_code, { error_msg = conf.rejected_msg }
            end
            return conf.rejected_code
        end

        core.log.error("failed to limit count: ", err)
        if conf.allow_degradation then
            return
        end
        return 500, {error_msg = "failed to limit count"}
    end

    if conf.show_limit_quota_header then
        core.response.set_header("X-RateLimit-Limit", conf.count,
                "X-RateLimit-Remaining", remaining)
    end
end

return _M
