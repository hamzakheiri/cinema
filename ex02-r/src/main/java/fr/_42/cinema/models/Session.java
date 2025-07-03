package fr._42.cinema.models;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "sessions")
public class Session {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ticket_cost", nullable = false)
    private Double ticketCost;

    @Column(name = "session_time", nullable = false)
    private LocalDateTime sessionTime;

    @ManyToOne
    @JoinColumn(name = "film_id", nullable = false)
    private Film film;

    @ManyToOne
    @JoinColumn(name = "hall_id", nullable = false)
    private Hall hall;

    public Session() {
    }

    public Session(Long id, Double ticketCost, LocalDateTime sessionTime, Film film, Hall hall) {
        this.id = id;
        this.ticketCost = ticketCost;
        this.sessionTime = sessionTime;
        this.film = film;
        this.hall = hall;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Session session = (Session) o;
        return Objects.equals(id, session.id) && Objects.equals(ticketCost, session.ticketCost) && Objects.equals(sessionTime, session.sessionTime) && Objects.equals(film, session.film) && Objects.equals(hall, session.hall);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, ticketCost, sessionTime, film, hall);
    }

    @Override
    public String toString() {
        return "Session{" +
                "id=" + id +
                ", ticketCost=" + ticketCost +
                ", sessionTime=" + sessionTime +
                ", film=" + film +
                ", hall=" + hall +
                '}';
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getTicketCost() {
        return ticketCost;
    }

    public void setTicketCost(Double ticketCost) {
        this.ticketCost = ticketCost;
    }

    public LocalDateTime getSessionTime() {
        return sessionTime;
    }

    public void setSessionTime(LocalDateTime sessionTime) {
        this.sessionTime = sessionTime;
    }

    public Film getFilm() {
        return film;
    }

    public void setFilm(Film film) {
        this.film = film;
    }

    public Hall getHall() {
        return hall;
    }

    public void setHall(Hall hall) {
        this.hall = hall;
    }
}

