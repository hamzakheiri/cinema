package fr._42.cinema.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {
    private static final Logger logger = LoggerFactory.getLogger(TestController.class);
    
    public TestController() {
        logger.info("=== TESTCONTROLLER INITIALIZED ===");
    }
    
    @GetMapping("/simple-test")
    @ResponseBody
    public String simpleTest() {
        logger.info("=== SIMPLE TEST ENDPOINT CALLED ===");
        return "TestController is working!";
    }
}
