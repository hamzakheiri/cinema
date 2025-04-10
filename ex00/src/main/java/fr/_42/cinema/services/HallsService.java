package fr._42.cinema.services;

import fr._42.cinema.models.Hall;

import java.util.List;

public interface HallsService {

    Hall getHallById(Long id);
    Hall getHallBySerialNumber(String serialNumber);

    List<Hall> getHalls();
    void addHall(Hall hall);
}
