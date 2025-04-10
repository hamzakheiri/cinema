package fr._42.cinema.config;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRegistration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.util.WebUtils;

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

        // Web context (WebConfig - controllers, view resolvers, WebSocket)
        AnnotationConfigWebApplicationContext webContext = new AnnotationConfigWebApplicationContext();
        webContext.register(WebConfig.class, WebSocketConfig.class);
        logger.info("Web context initialized with WebConfig and WebSocketConfig");

        // DispatcherServlet for web components
        DispatcherServlet dispatcherServlet = new DispatcherServlet(webContext);
        ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher", dispatcherServlet);
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");
        dispatcher.setMultipartConfig(new MultipartConfigElement("/tmp", 2097152, 4194304, 0));

        // Enable async support for WebSocket
        dispatcher.setAsyncSupported(true);

        logger.info("DispatcherServlet configured with mappings: /");
        logger.info("Web application initialization completed");
    }
}
