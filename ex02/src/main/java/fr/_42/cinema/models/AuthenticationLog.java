package fr._42.cinema.models;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "authentication_logs")
public class AuthenticationLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "login_time", nullable = false, updatable = false, columnDefinition = "timestamp default current_timestamp")
    @CreationTimestamp
    private Timestamp loginTime;

    @Column(name = "ip_addr", nullable = false)
    private String ipAddr;


    public AuthenticationLog() {

    }

    @Override
    public String toString() {
        return "AuthenticationLog{" +
                "id=" + id +
                ", user=" + user +
                ", loginTime=" + loginTime +
                ", ipAddr='" + ipAddr + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        AuthenticationLog that = (AuthenticationLog) o;
        return Objects.equals(id, that.id) && Objects.equals(user, that.user) && Objects.equals(loginTime, that.loginTime) && Objects.equals(ipAddr, that.ipAddr);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, user, loginTime, ipAddr);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Timestamp getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(Timestamp loginTime) {
        this.loginTime = loginTime;
    }

    public String getIpAddr() {
        return ipAddr;
    }

    public void setIpAddr(String ipAddr) {
        this.ipAddr = ipAddr;
    }
}
