package fr._42.cinema.controller;

import fr._42.cinema.models.ChatMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class WebSocketTestController {
    private static final Logger logger = LoggerFactory.getLogger(WebSocketTestController.class);
    private final SimpMessagingTemplate messagingTemplate;

    public WebSocketTestController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @GetMapping("/socket-test")
    public String getTestPage() {
        logger.info("Serving socket test page");
        return "socket-test";
    }

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public String greeting(String message) {
        logger.info("Received message in /hello: {}", message);
        String response = "Hello, " + message + "!";
        logger.info("Sending response: {}", response);

        // Also send directly using messagingTemplate as a backup
        messagingTemplate.convertAndSend("/topic/greetings", response);

        return response;
    }

    @MessageMapping("/echo")
    @SendTo("/topic/echo")
    public String echo(String message) {
        logger.info("Received message in /echo: {}", message);
        String response = "Echo: " + message;
        logger.info("Sending response: {}", response);

        // Also send directly using messagingTemplate as a backup
        messagingTemplate.convertAndSend("/topic/echo", response);

        return response;
    }

    @GetMapping("/test-ws")
    @ResponseBody
    public String testWebSocket() {
        logger.info("Testing WebSocket broadcast");

        // Send messages to various topics
        messagingTemplate.convertAndSend("/topic/greetings", "Server broadcast message to greetings");
        messagingTemplate.convertAndSend("/topic/echo", "Server broadcast message to echo");
        messagingTemplate.convertAndSend("/topic/test", "Server broadcast message to test");
        messagingTemplate.convertAndSend("/topic/films/1/chat/messages", new ChatMessage("system", "Server broadcast message to chat"));

        return "Messages broadcast to all topics. Check your WebSocket client.";
    }
}
