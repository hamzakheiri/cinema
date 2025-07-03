package fr._42.cinema.controller;

import fr._42.cinema.models.Session;
import fr._42.cinema.services.SessionsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/session")
public class SessionDetailController {
    private final SessionsService sessionsService;
    private final Logger logger = LoggerFactory.getLogger(SessionDetailController.class);

    @Autowired
    public SessionDetailController(SessionsService sessionsService) {
        this.sessionsService = sessionsService;
    }

    @GetMapping("/{id}")
    public String getSessionDetail(@PathVariable("id") Long id, Model model) {
        logger.info("Fetching session details for ID: {}", id);
        
        try {
            Session session = sessionsService.getSessionById(id);
            
            if (session == null) {
                model.addAttribute("error", "Session not found");
                logger.warn("Session with ID {} not found", id);
                return "sessionDetail";
            }
            
            model.addAttribute("session", session);
            logger.info("Successfully fetched session: {}", session.getId());
            return "sessionDetail";
            
        } catch (Exception e) {
            logger.error("Error fetching session with ID {}: {}", id, e.getMessage());
            model.addAttribute("error", "An error occurred while fetching session details");
            return "sessionDetail";
        }
    }
}
