package fr._42.cinema.services;

import fr._42.cinema.models.UserSession;
import fr._42.cinema.repositories.UserSessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserService {
    
    @Autowired
    private UserSessionRepository userSessionRepository;
    
    public String getOrCreateUserId(String existingUserId, String ipAddress) {
        if (existingUserId != null && !existingUserId.isEmpty()) {
            Optional<UserSession> session = userSessionRepository.findByUserId(existingUserId);
            if (session.isPresent()) {
                UserSession userSession = session.get();
                userSession.setLastActivity(LocalDateTime.now());
                userSessionRepository.save(userSession);
                return existingUserId;
            }
        }

        String newUserId = UUID.randomUUID().toString();
        UserSession userSession = new UserSession(newUserId, ipAddress);
        userSessionRepository.save(userSession);
        return newUserId;
    }

    public String generateAnonymousName(String userId) {
        if (userId == null || userId.isEmpty()) {
            return "Anonymous";
        }

       String shortId = userId.substring(0, Math.min(8, userId.length()));
        return "User_" + shortId;
    }
    
    public List<UserSession> getAllUserSessions() {
        return userSessionRepository.findAll();
    }
}
