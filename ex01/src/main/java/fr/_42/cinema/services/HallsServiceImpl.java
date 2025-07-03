package fr._42.cinema.services;

import fr._42.cinema.models.Hall;
import fr._42.cinema.repositories.HallsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("hallsService")
public class HallsServiceImpl implements HallsService {
    private HallsRepository hallsRepository;

    public HallsServiceImpl(HallsRepository hallsRepository) {
        this.hallsRepository = hallsRepository;
    }

    @Override
    public Hall getHallById(Long id) {
        return hallsRepository.findById(id).orElse(null);
    }

    @Override
    public Hall getHallBySerialNumber(String serialNumber) {
        return hallsRepository.findBySerialNumber(serialNumber).orElse(null);
    }

    @Override
    public List<Hall> getHalls() {
        return hallsRepository.findAll();
    }

    @Override
    public void addHall(Hall hall) {
        hallsRepository.save(hall);
    }
}
