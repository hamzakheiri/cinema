package fr._42.cinema.models;

import jakarta.persistence.*;

import java.util.Objects;

@Entity
@Table(name = "halls")
public class Hall {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "serial_number", nullable = false, unique = true)
    private String serialNumber;

    @Column(name = "seats", nullable = false)
    private int seats;

    public Hall() {
    }

    public Hall(Long id, String serialNumber, int seats) {
        this.serialNumber = serialNumber;
        this.seats = seats;
    }

    @Override
    public String toString() {
        return "Hall{" +
                "id=" + id +
                ", serialNumber='" + serialNumber + '\'' +
                ", seats=" + seats +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Hall hall = (Hall) o;
        return seats == hall.seats && Objects.equals(id, hall.id) && Objects.equals(serialNumber, hall.serialNumber);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, serialNumber, seats);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }
}