//package fr._42.cinema.services;
//
//import fr._42.cinema.models.ChatMessage;
//import fr._42.cinema.repositories.ChatMessagesRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Service
//public class ChatMessagesServiceImpl implements ChatMessagesService {
//    private final ChatMessagesRepository chatMessagesRepository;
//
//    @Autowired
//    public ChatMessagesServiceImpl(ChatMessagesRepository chatMessagesRepository) {
//        this.chatMessagesRepository = chatMessagesRepository;
//    }
//
//    @Override
//    public ChatMessage saveMessage(ChatMessage chatMessage) {
//        return chatMessagesRepository.save(chatMessage);
//    }
//
//    @Override
//    public List<ChatMessage> getChatMessages(Long filmId) {
//        return chatMessagesRepository.findTop20ByFilmIdOrderByDateTimeDesc(filmId);
//    }
//}
