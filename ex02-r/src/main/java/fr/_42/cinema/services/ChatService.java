package fr._42.cinema.services;

import fr._42.cinema.models.ChatMessage;
import fr._42.cinema.repository.ChatMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class ChatService {
    
    @Autowired
    private ChatMessageRepository chatMessageRepository;
    
    public ChatMessage saveMessage(ChatMessage message) {
        return chatMessageRepository.save(message);
    }
    
    public List<ChatMessage> getLast20Messages(Long filmId) {
        Pageable pageable = PageRequest.of(0, 20);
        List<ChatMessage> messages = chatMessageRepository.findTop20ByFilmIdOrderByTimestampDesc(filmId);
        // Reverse to show oldest first
        Collections.reverse(messages);
        return messages;
    }
    
    public List<ChatMessage> getAllMessagesForFilm(Long filmId) {
        return chatMessageRepository.findByFilmIdOrderByTimestampAsc(filmId);
    }
}
