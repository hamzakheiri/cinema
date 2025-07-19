package fr._42.cinema.controller;

import fr._42.cinema.models.Film;
import fr._42.cinema.models.Hall;
import fr._42.cinema.models.Session;
import fr._42.cinema.services.FilmsService;
import fr._42.cinema.services.HallsService;
import fr._42.cinema.services.SessionsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/panel/sessions")
public class SessionsController {
    private final SessionsService sessionsService;
    private final HallsService hallsService;
    private final FilmsService filmsService;
    private final Logger logger = LoggerFactory.getLogger(SessionsController.class);

    @Autowired
    public SessionsController(
            SessionsService sessionsService,
            HallsService hallsService,
            FilmsService filmsService
    ) {
        this.filmsService = filmsService;
        this.hallsService = hallsService;
        this.sessionsService = sessionsService;
    }

    @GetMapping(value = {"", "/"})
    public String getSessions(Model model) {
        try {
            List<Film> films = filmsService.getFilms();
            List<Session> sessions = sessionsService.getSessions();
            List<Hall> halls = hallsService.getHalls();
            model.addAttribute("films", films);
            model.addAttribute("sessions", sessions);
            model.addAttribute("halls", halls);
        } catch (Exception e) {
            model.addAttribute("error", "An error occurred while fetching data from the database");
        }
        return "sessions";

    }

    @PostMapping(value = {"", "/"})
    public String postSessions(
            @RequestParam("filmId") Long filmId,
            @RequestParam("hallId") Long hallId,
            @RequestParam("sessionTime") @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") LocalDateTime sessionTime,
            @RequestParam("ticketPrice") Double ticketPrice,
            RedirectAttributes redirectAttributes
    ) {
        if (filmId == null || hallId == null || sessionTime == null || ticketPrice == null) {
            redirectAttributes.addFlashAttribute("error", "Please fill in all required fields.");
            return "sessions";
        }

        try {
            Film film = filmsService.getFilmById(filmId);
            Hall hall = hallsService.getHallById(hallId);

            Session session = new Session(null, ticketPrice, sessionTime, film, hall);
            sessionsService.addSession(session);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving the session into the database");
        }
        return "redirect:/admin/panel/sessions";
    }
}
