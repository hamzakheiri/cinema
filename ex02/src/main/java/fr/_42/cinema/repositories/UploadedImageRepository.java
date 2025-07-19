package fr._42.cinema.repositories;

import fr._42.cinema.models.UploadedImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UploadedImageRepository extends JpaRepository<UploadedImage, Long> {
    Optional<UploadedImage> findByStoredFilename(String storedFilename);
    List<UploadedImage> findAllByOrderByUploadTimeDesc();
    List<UploadedImage> findByUserIdOrderByUploadTimeDesc(String userId);
}
