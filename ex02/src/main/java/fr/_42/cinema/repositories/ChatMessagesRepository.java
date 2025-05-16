//package fr._42.cinema.repositories;
//
//import fr._42.cinema.models.ChatMessage;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.stereotype.Repository;
//
//import java.util.List;
//
//@Repository
//public interface ChatMessagesRepository extends JpaRepository<ChatMessage, Long> {
//    List<ChatMessage> findTop20ByFilmIdOrderByDateTimeDesc(Long filmId);
//}