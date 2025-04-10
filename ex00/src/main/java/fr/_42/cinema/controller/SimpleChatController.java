package fr._42.cinema.controller;

import fr._42.cinema.models.ChatMessage;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SimpleChatController {

    private final SimpMessagingTemplate messagingTemplate;

    public SimpleChatController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @GetMapping("/simple-chat")
    public String getSimpleChatPage() {
        return "simple-chat";
    }

    @MessageMapping("/chat/{roomId}")
    @SendTo("/topic/chat/{roomId}")
    public ChatMessage processMessage(@DestinationVariable String roomId, ChatMessage message) {
        System.out.println("Received message in room " + roomId + ": " + message);
        return message;
    }

    @MessageMapping("/simple-test")
    @SendTo("/topic/simple-test")
    public String test(String message) {
        System.out.println("Received simple test message: " + message);
        return "Simple Echo: " + message;
    }
}
