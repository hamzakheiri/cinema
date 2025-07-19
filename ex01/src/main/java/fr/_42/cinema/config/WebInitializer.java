package fr._42.cinema.config;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRegistration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.support.ResourcePropertySource;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import java.io.IOException;

/**
 * Application initializer that sets up the Spring application context
 * when deployed to a servlet container like Tomcat.
 */
public class WebInitializer implements WebApplicationInitializer {
    private static final Logger logger = LoggerFactory.getLogger(WebInitializer.class);

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        logger.info("Starting web application initialization");

        // Root context (AppConfig - JPA, services)
        AnnotationConfigWebApplicationContext rootContext = new AnnotationConfigWebApplicationContext();
        rootContext.register(AppConfig.class);
        servletContext.addListener(new ContextLoaderListener(rootContext));
        logger.info("Root context initialized with AppConfig");
        String webInfPath = servletContext.getRealPath("/WEB-INF");

        // Set a system property to store the WEB-INF path
        System.setProperty("webinf.path", webInfPath);

        // Register configuration classes
        rootContext.register(AppConfig.class);

        // Load properties from WEB-INF
        try {
            ResourcePropertySource propertySource = new ResourcePropertySource(
                    "file:" + webInfPath + "/application.properties");
            rootContext.getEnvironment().getPropertySources().addFirst(propertySource);
            logger.info("Application properties loaded from WEB-INF");
        } catch (IOException e) {
            // Log error
            System.err.println("Could not load properties: " + e.getMessage());
            logger.error("Could not load properties: " + e.getMessage());
        }       // Web context (WebConfig - controllers, view resolvers, WebSocket)

        AnnotationConfigWebApplicationContext webContext = new AnnotationConfigWebApplicationContext();
        webContext.register(WebConfig.class);
        logger.info("Web context initialized with WebConfig and WebSocketConfig");

        // DispatcherServlet for web components
        DispatcherServlet dispatcherServlet = new DispatcherServlet(webContext);
        ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher", dispatcherServlet);
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");

        // Configure multipart support for file uploads
        dispatcher.setMultipartConfig(new MultipartConfigElement("/tmp", 2097152, 4194304, 0));


        // Enable async support for WebSocket
        dispatcher.setAsyncSupported(true);

        logger.info("Web application initialization completed");
    }
}
