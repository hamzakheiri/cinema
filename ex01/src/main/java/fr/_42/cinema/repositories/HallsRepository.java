package fr._42.cinema.repositories;

import fr._42.cinema.models.Hall;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HallsRepository extends JpaRepository<Hall, Long> {
    Optional<Hall> findBySerialNumber(String serialNumber);
}