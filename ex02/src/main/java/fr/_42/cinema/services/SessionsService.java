package fr._42.cinema.services;

import fr._42.cinema.models.Session;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface SessionsService {
    void addSession(Session session);

    List<Session> getSessions();

    List<Session> muchThePatternFilmName(String filmName);
}
