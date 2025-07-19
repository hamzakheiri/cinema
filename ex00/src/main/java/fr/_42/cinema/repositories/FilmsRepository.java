package fr._42.cinema.repositories;

import fr._42.cinema.models.Film;
import org.hibernate.type.descriptor.converter.spi.JpaAttributeConverter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("filmsRepository")
public interface FilmsRepository extends JpaRepository<Film, Long> {
}
