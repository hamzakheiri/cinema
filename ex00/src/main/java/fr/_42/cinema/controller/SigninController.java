package fr._42.cinema.controller;

import fr._42.cinema.models.User;
import fr._42.cinema.services.UsersService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/signin")
public class SigninController {
    private UsersService usersService;

    @Autowired
    public SigninController(UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping(value = {"", "/"})
    public String getSignIn() {
        return "signIn";
    }

    @PostMapping(value = {"", "/"})
    @ResponseBody
    public String signIn(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {

        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Please fill in all required fields.");
            return "error";
        }

        try {
            User user = usersService.singIn(email, password);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(60 * 20);
//            return "redirect:/profile";
            return "SignIn Successfully";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "error";
        }
    }
}
