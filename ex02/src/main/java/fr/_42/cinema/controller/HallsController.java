package fr._42.cinema.controller;


import fr._42.cinema.models.Hall;
import fr._42.cinema.services.HallsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/panel/halls")
public class HallsController {
    private HallsService hallsService;
    final private Logger logger = LoggerFactory.getLogger(HallsController.class);

    @Autowired
    public HallsController(HallsService hallsService) {
        this.hallsService = hallsService;
    }

    @GetMapping(value = {"/", ""})
    public String halls(Model model) {
        try {
            List<Hall> halls = hallsService.getHalls();
            model.addAttribute("halls", halls);
            return "halls";
        } catch (Exception e) {
            model.addAttribute("error", "An error occurred while fetching data from the database");
            return "halls";
        }
    }

    @PostMapping(value = {"", "/"})
    public String hallsPost(
            @RequestParam("serialNumber") String serialNumber,
            @RequestParam("seats") int seats,
            RedirectAttributes redirectAttributes
    ) {
        try {
            if (serialNumber == null || serialNumber.trim().isEmpty() || seats <= 0) {
                redirectAttributes.addFlashAttribute("error", "Please fill in all required fields.");
                return "redirect:/admin/panel/halls";
            }
            Hall hall = new Hall(null, serialNumber, seats);
            hallsService.addHall(hall);
            return "redirect:/admin/panel/halls";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving the hall into the database");
        }
        return "redirect:/admin/panel/halls";
    }
}

