package fr._42.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "uploaded_images")
public class UploadedImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "original_filename")
    private String originalFilename;
    
    @Column(name = "stored_filename")
    private String storedFilename;
    
    @Column(name = "upload_time")
    private LocalDateTime uploadTime;
    
    @Column(name = "user_id")
    private String userId;

    public UploadedImage() {
        this.uploadTime = LocalDateTime.now();
    }

    public UploadedImage(String originalFilename, String storedFilename, String userId) {
        this();
        this.originalFilename = originalFilename;
        this.storedFilename = storedFilename;
        this.userId = userId;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOriginalFilename() { return originalFilename; }
    public void setOriginalFilename(String originalFilename) { this.originalFilename = originalFilename; }

    public String getStoredFilename() { return storedFilename; }
    public void setStoredFilename(String storedFilename) { this.storedFilename = storedFilename; }

    public LocalDateTime getUploadTime() { return uploadTime; }
    public void setUploadTime(LocalDateTime uploadTime) { this.uploadTime = uploadTime; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
}
