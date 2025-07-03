package fr._42.cinema.services;

import fr._42.cinema.models.User;

public interface UsersService {
    String test();

    void signUp(User user);

    User singIn(String email, String password);
}
