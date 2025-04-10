package fr._42.cinema.services;

import fr._42.cinema.models.ChatMessage;

import java.util.List;

public interface ChatMessagesService {
    ChatMessage saveMessage(ChatMessage chatMessage);

    List<ChatMessage> getChatMessages(Long filmId);
}
