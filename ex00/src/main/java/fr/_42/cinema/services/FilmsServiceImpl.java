package fr._42.cinema.services;

import fr._42.cinema.models.Film;
import fr._42.cinema.repositories.FilmsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FilmsServiceImpl implements FilmsService {
    private final FilmsRepository filmsRepository;


    @Autowired
    public FilmsServiceImpl(@Qualifier("filmsRepository") FilmsRepository filmsRepository) {
        this.filmsRepository = filmsRepository;
    }

    @Override
    public void addFilm(Film film) {
        filmsRepository.save(film);
    }

    @Override
    public List<Film> getFilms() {
        return filmsRepository.findAll();
    }

    @Override
    public Film getFilmById(Long id) {
        return filmsRepository.findById(id).orElse(null);
    }
}
