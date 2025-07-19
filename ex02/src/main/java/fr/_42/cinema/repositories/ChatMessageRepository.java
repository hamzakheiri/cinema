package fr._42.cinema.repositories;

import fr._42.cinema.models.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    
    @Query("SELECT cm FROM ChatMessage cm WHERE cm.filmId = :filmId ORDER BY cm.timestamp DESC")
    List<ChatMessage> findTop20ByFilmIdOrderByTimestampDesc(@Param("filmId") Long filmId);
    
    @Query("SELECT cm FROM ChatMessage cm WHERE cm.filmId = :filmId ORDER BY cm.timestamp ASC")
    List<ChatMessage> findByFilmIdOrderByTimestampAsc(@Param("filmId") Long filmId);
}
