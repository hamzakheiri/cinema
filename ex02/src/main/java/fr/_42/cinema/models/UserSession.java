package fr._42.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_sessions")
public class UserSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id", unique = true)
    private String userId;
    
    @Column(name = "ip_address")
    private String ipAddress;
    
    @Column(name = "login_time")
    private LocalDateTime loginTime;
    
    @Column(name = "last_activity")
    private LocalDateTime lastActivity;

    public UserSession() {
        this.loginTime = LocalDateTime.now();
        this.lastActivity = LocalDateTime.now();
    }

    public UserSession(String userId, String ipAddress) {
        this();
        this.userId = userId;
        this.ipAddress = ipAddress;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public LocalDateTime getLoginTime() { return loginTime; }
    public void setLoginTime(LocalDateTime loginTime) { this.loginTime = loginTime; }

    public LocalDateTime getLastActivity() { return lastActivity; }
    public void setLastActivity(LocalDateTime lastActivity) { this.lastActivity = lastActivity; }
}
