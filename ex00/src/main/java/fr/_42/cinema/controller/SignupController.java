package fr._42.cinema.controller;

import fr._42.cinema.services.UsersService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import fr._42.cinema.models.User;

@Controller
@RequestMapping("/admin/signup")
public class SignupController {
    private final UsersService usersService;

    public SignupController(UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping(value = {"/", ""})
    public String signup() {
        return "signup";
    }

    @PostMapping(value = {"", "/"})
    @ResponseBody
    public String signupPost(
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("phone") String phoneNumber,
            Model model
    ) {
        if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {

            model.addAttribute("error", "Please fill in all required fields.");
            // Return the signup view so the error can be displayed
            return "error"; // This should resolve to your signup.ftl
        }
        User user = new User(null, firstName, lastName, email, password, phoneNumber);
        try {
            usersService.signUp(user);
            return "done";
        } catch (Exception e) {
            model.addAttribute("error", "An error occurred during sign-up. Please try again.");
            return "error";
        }
    }
}
