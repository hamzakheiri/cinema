package fr._42.cinema.controller;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
public class ImageController {

    @Value("${posterUpload.dir}")
    private String imageDir;
    private final Logger logger = LoggerFactory.getLogger(ImageController.class);

    @GetMapping("/images/{filename:.+}")
    public ResponseEntity<byte[]> serveImage(@PathVariable("filename") String filename) {
        logger.info("imageDir: {}", imageDir);
        logger.info("Serving image: " + filename);
        try {
            Path file = Paths.get(imageDir).resolve(filename);
            byte[] image = Files.readAllBytes(file);

            // Determine MediaType dynamically
            String mimeType = Files.probeContentType(file);
            MediaType mediaType = mimeType != null ? MediaType.parseMediaType(mimeType) : MediaType.APPLICATION_OCTET_STREAM;
            logger.info("Detected MediaType: " + mediaType); // Add logging

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(mediaType);

            return new ResponseEntity<>(image, headers, HttpStatus.OK);
        } catch (IOException e) {
            logger.error("Error serving image: " + filename, e); // Log the exception
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }
}
