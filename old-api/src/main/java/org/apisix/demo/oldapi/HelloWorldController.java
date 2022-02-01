package org.apisix.demo.oldapi;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController()
@RequestMapping(path = "/hello")
public class HelloWorldController {

    @GetMapping({"", "/"})
    public String hello() {
        return "Hello world";
    }

    @GetMapping("/{who}")
    public String hello(@PathVariable("who") String who) {
        return "Hello " + who;
    }
}
