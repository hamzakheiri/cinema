package fr._42.cinema.repositories;


import fr._42.cinema.models.AuthenticationLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthenticationRepository extends JpaRepository<AuthenticationLog, Long> {
    @Query("select a from AuthenticationLog a where a.user.id = ?1 order by a.id desc")
    List<AuthenticationLog> findByUserId(Long userId);
}
