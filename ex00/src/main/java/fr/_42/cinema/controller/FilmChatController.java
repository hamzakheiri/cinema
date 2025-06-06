package fr._42.cinema.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import fr._42.cinema.models.ChatMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class FilmChatController {
    private static final Logger log = LoggerFactory.getLogger(FilmChatController.class);
    private final SimpMessagingTemplate messagingTemplate;
    private final Logger logger = LoggerFactory.getLogger(FilmChatController.class);
    private final ObjectMapper objectMapper;

    @Autowired
    public FilmChatController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
        this.objectMapper = new ObjectMapper();
    }

    @MessageMapping("/films/{filmId}/chat/send")
    @SendTo("/topic/films/{filmId}/chat/messages")
    public ChatMessage sendMessage(
            @DestinationVariable("filmId")  Long filmId,
            @Payload ChatMessage chatMessage
    ) {
        // Enhanced logging to debug message receipt
        logger.info("========== CHAT MESSAGE RECEIVED (OBJECT) ==========");
        logger.info("Received chat message for film {}: {}", filmId, chatMessage);
        System.out.println("Chat message received for film " + filmId + ": " + chatMessage);

        // Also send directly using messagingTemplate as a backup
        messagingTemplate.convertAndSend("/topic/films/" + filmId + "/chat/messages", chatMessage);

        // Return the message for broadcasting
        logger.info("Returning message for broadcasting");
        return chatMessage;
    }

    // Serve the chat page for a specific film
    @GetMapping("/films/{id}/chat")
    public String filmChatPage(@PathVariable("id") Long filmId, Model model) {
        // Optionally load last 20 messages and other film details
        model.addAttribute("filmId", filmId);
        return "filmChat"; // This resolves to filmChat.ftl
    }

    // REST endpoint to test messaging
    @GetMapping("/test-message")
    @ResponseBody
    public Map<String, Object> testMessage() {
        logger.info("REST endpoint /test-message called");
        Map<String, Object> response = new HashMap<>();

        try {
            // Send a test message to the chat topic
            ChatMessage testMessage = new ChatMessage("system", "Test message from REST endpoint: " + System.currentTimeMillis());
            messagingTemplate.convertAndSend("/topic/films/1/chat/messages", testMessage);
            logger.info("Test message sent to chat topic: {}", testMessage);

            // Send a test message to the test topic
            String testString = "Test message from REST endpoint: " + System.currentTimeMillis();
            messagingTemplate.convertAndSend("/topic/test", testString);
            logger.info("Test message sent to test topic: {}", testString);

            response.put("success", true);
            response.put("message", "Test messages sent successfully");
        } catch (Exception e) {
            logger.error("Error sending test messages: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }

    // REST endpoint to send a message to a specific topic
    @GetMapping("/send-to-topic/{topic}")
    @ResponseBody
    public Map<String, Object> sendToTopic(@PathVariable("topic") String topic) {
        logger.info("REST endpoint /send-to-topic/{} called", topic);
        Map<String, Object> response = new HashMap<>();

        try {
            // Determine the full topic path
            String fullTopic;
            if (topic.equals("test")) {
                fullTopic = "/topic/test";
            } else {
                fullTopic = "/topic/films/" + topic + "/chat/messages";
            }

            // Send a test message to the specified topic
            String message = "Direct message to " + fullTopic + ": " + System.currentTimeMillis();
            messagingTemplate.convertAndSend(fullTopic, message);
            logger.info("Message sent to {}: {}", fullTopic, message);

            response.put("success", true);
            response.put("message", "Message sent to " + fullTopic);
            response.put("topic", fullTopic);
        } catch (Exception e) {
            logger.error("Error sending message to topic: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }
}
