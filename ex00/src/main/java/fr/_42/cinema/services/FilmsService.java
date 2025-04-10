package fr._42.cinema.services;

import fr._42.cinema.models.Film;

import java.util.List;

public interface FilmsService {
    void addFilm(Film film);
    List<Film> getFilms();

    Film getFilmById(Long id);
}