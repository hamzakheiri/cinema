package fr._42.cinema.controller;

import fr._42.cinema.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HelloController {
    private final UsersService usersService;

    @Autowired
    public HelloController(@Qualifier("usersService") UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping("/")
    @ResponseBody
    public String hello() {
        return usersService.test();
    }
}