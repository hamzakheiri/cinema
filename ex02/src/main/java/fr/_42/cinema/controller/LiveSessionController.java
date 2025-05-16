package fr._42.cinema.controller;


import fr._42.cinema.models.Session;
import fr._42.cinema.services.SessionsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller()
@RequestMapping("/sessions")
public class LiveSessionController {
    private SessionsService sessionsService;
    private final Logger logger = LoggerFactory.getLogger(LiveSessionController.class);

    @Autowired
    public LiveSessionController(SessionsService sessionsService) {
        this.sessionsService = sessionsService;
    }

    @GetMapping({"", "/"})
    public String sessionPage() {
        return "liveSessionSearch";
    }

    @GetMapping("/search")
    @ResponseBody
    public Map<String, Object> searchSession(
            @RequestParam("filmName") String filmName
    ) {
        List<Session> sessions = sessionsService.muchThePatternFilmName(filmName);
        Map<String, Object> response = new HashMap<>();
        logger.info("searching result: {}" , sessions);
        response.put("sessions", sessions);
        return response;
    }
}
