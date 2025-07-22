package fr._42.cinema.controller;

import fr._42.cinema.models.ChatMessage;
import fr._42.cinema.models.UserSession;
import fr._42.cinema.services.ChatService;
import fr._42.cinema.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
public class FilmChatController {
    private final ChatService chatService;
    private final UserService userService;

    @Autowired
    public FilmChatController(ChatService chatService, UserService userService) {
        this.chatService = chatService;
        this.userService = userService;
    }

    @MessageMapping("/films/{filmId}/chat/send")
    @SendTo("/topic/films/{filmId}/chat/messages")
    public ChatMessage sendMessage(
            @DestinationVariable("filmId") Long filmId,
            @Payload ChatMessage chatMessage
    ) {
        chatMessage.setFilmId(filmId);
        return chatService.saveMessage(chatMessage);
    }

    @GetMapping("/films/{id}/chat")
    public String filmChatPage(
            @PathVariable("id") Long filmId,
            @CookieValue(value = "userId", required = false) String userId,
            Model model,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        String currentUserId = userService.getOrCreateUserId(userId, request.getRemoteAddr());
        if (!currentUserId.equals(userId)) {
            Cookie userCookie = new Cookie("userId", currentUserId);
            userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            userCookie.setPath("/");
            response.addCookie(userCookie);
        }

        List<ChatMessage> messages = chatService.getLast20Messages(filmId);
        List<UserSession> userSessions = userService.getAllUserSessions();
        String anonymousName = userService.generateAnonymousName(currentUserId);

        model.addAttribute("filmId", filmId);
        model.addAttribute("messages", messages);
        model.addAttribute("userIp", request.getRemoteAddr());
        model.addAttribute("userId", currentUserId);
        model.addAttribute("anonymousName", anonymousName);
        model.addAttribute("userSessions", userSessions);

        return "filmChat";
    }
}