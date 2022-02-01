package org.apisix.newapi

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.support.beans
import org.springframework.web.servlet.function.ServerResponse
import org.springframework.web.servlet.function.router

@SpringBootApplication
class NewApiApplication

internal fun beans() = beans {
    bean {
        router {
            (GET("/hello") or GET("/hello/")) { ServerResponse.ok().body("Hello world (souped-up version!)") }
            GET("/hello/{who}") { ServerResponse.ok().body("Hello ${it.pathVariable("who")} (souped-up version!)") }
            GET("/**") {
                val logger = LoggerFactory.getLogger(NewApiApplication::class.java)
                logger.warn("Path not found: ${it.path()}")
                ServerResponse.notFound().build()
            }
        }
    }
}

fun main(args: Array<String>) {
    runApplication<NewApiApplication>(*args) {
        addInitializers(beans())
    }
}
