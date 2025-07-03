package fr._42.cinema.services;

import fr._42.cinema.models.Session;
import fr._42.cinema.repositories.SessionsRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SessionsServiceImpl implements SessionsService {
    private SessionsRepository sessionsRepository;

    SessionsServiceImpl(SessionsRepository sessionsRepository) {
        this.sessionsRepository = sessionsRepository;
    }

    @Override
    public void addSession(Session session) {
        sessionsRepository.save(session);
    }

    @Override
    public List<Session> getSessions(){
        return sessionsRepository.findAll();
    }

    @Override
    public List<Session> muchThePatternFilmName(String filmName) {
        return sessionsRepository.findByFilm_TitleContainingIgnoreCase(filmName);
    }

    @Override
    public Session getSessionById(Long id) {
        return sessionsRepository.findById(id).orElse(null);
    }
}
