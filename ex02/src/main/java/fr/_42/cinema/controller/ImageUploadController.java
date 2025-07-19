package fr._42.cinema.controller;

import fr._42.cinema.models.UploadedImage;
import fr._42.cinema.repositories.UploadedImageRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
public class ImageUploadController {
    private static final Logger logger = LoggerFactory.getLogger(ImageUploadController.class);
    private UploadedImageRepository uploadedImageRepository;

    @Value("${posterUpload.dir}")
    private String uploadDir;

    @Autowired
    public ImageUploadController(UploadedImageRepository uploadedImageRepository) {
        this.uploadedImageRepository = uploadedImageRepository;
    }

    @PostMapping("/images")
    @ResponseBody
    public String uploadImage(
            @RequestParam("file") MultipartFile file,
            @CookieValue(value = "userId", required = false) String userId,
            HttpServletRequest request
    ) {
        if (file.isEmpty()) {
            return "Error: No file selected";
        }

        try {
            // Create upload directory if it doesn't exist (same as FilmsController)
            File uploadDirectory = new File(uploadDir);
            if (!uploadDirectory.exists()) {
                uploadDirectory.mkdirs();
            }

            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf('.'));
            String uniqueFilename = UUID.randomUUID() + extension;
            File dest = new File(uploadDirectory, uniqueFilename);

            // Save file using transferTo (same as FilmsController)
            file.transferTo(dest);

            // Save metadata to database
            UploadedImage uploadedImage = new UploadedImage(originalFilename, uniqueFilename, userId);
            uploadedImageRepository.save(uploadedImage);

            logger.info("File uploaded: {} -> {}", originalFilename, uniqueFilename);
            return "Success: File uploaded as " + originalFilename;

        } catch (SecurityException | IOException e) {
            logger.error("Failed to upload file", e);
            return "Error: Failed to upload file";
        }
    }
    
    @GetMapping("/images/list")
    @ResponseBody
    public List<Map<String, String>> listImages(@CookieValue(value = "userId", required = false) String userId) {
        List<Map<String, String>> imageList;

        if (userId != null) {
            // Get images for this specific user only
            imageList = uploadedImageRepository.findByUserIdOrderByUploadTimeDesc(userId)
                    .stream()
                    .map(img -> {
                        Map<String, String> imageInfo = new HashMap<>();
                        imageInfo.put("originalName", img.getOriginalFilename());
                        imageInfo.put("storedName", img.getStoredFilename());
                        imageInfo.put("uploadTime", img.getUploadTime().toString());
                        return imageInfo;
                    })
                    .toList();
        } else {
            // No user ID - return empty list
            imageList = new ArrayList<>();
        }

        return imageList;
    }


}
