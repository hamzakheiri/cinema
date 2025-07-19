package fr._42.cinema.controller;

import fr._42.cinema.models.Film;
import fr._42.cinema.services.FilmsService;
import jdk.jshell.spi.ExecutionControl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/panel/films")
public class FilmsController {
    private final FilmsService filmsService;
    final private Logger logger = LoggerFactory.getLogger(FilmsController.class);

    @Value("${posterUpload.dir}")
    String uploadDirS;

    public FilmsController(FilmsService filmsService) {
        this.filmsService = filmsService;
    }

    @GetMapping(value = {"", "/"})
    public String getFilms(Model model) {
        try {
            List<Film> films = filmsService.getFilms();
            model.addAttribute("films", films);
            return "films";
        } catch (Exception e) {
            logger.info("error: " + e.getMessage());
            return "films";
        }
    }

    @PostMapping(value = {"", "/"})
    public String postFilms(
            @RequestParam("title") String title,
            @RequestParam("year") Integer year,
            @RequestParam("ageRestrictions") Integer ageRestrictions,
            @RequestParam("description") String description,
            @RequestParam("poster") MultipartFile poster,
            RedirectAttributes redirectAttributes
    )  {
        if (title == null || title.trim().isEmpty()
                || year == null || year == 0
                || ageRestrictions == null
                || description == null || description.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please fill in all required fields.");
            return "redirect:/admin/panel/films";
        }
        String posterUrl = null;
        if (!poster.isEmpty()){
            try {
                File uploadDir = new File(uploadDirS);
                if (!uploadDir.exists())
                    uploadDir.mkdirs();
                String originalFilename = poster.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf('.'));
                String uniqueFileName = UUID.randomUUID() + extension;
                File dest = new File(uploadDir, uniqueFileName);

                poster.transferTo(dest);
                posterUrl = uniqueFileName;
            } catch (SecurityException | IOException e) {
                redirectAttributes.addFlashAttribute("error", "error while saving the poster");
                return "redirect:/admin/panel/films";
            }

        }
        Film film = new Film(null, title, year, ageRestrictions, description, posterUrl);
        try {
            filmsService.addFilm(film);
            return "redirect:/admin/panel/films";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "error while saving the film into the data base");
            return "redirect:/admin/panel/films";
        }
    }
}
