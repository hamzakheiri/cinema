package fr._42.cinema.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.AsyncSupportConfigurer;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

import java.util.List;
import java.util.Properties;

@Configuration
@EnableWebMvc  // Enable Spring MVC
@ComponentScan(basePackages = "fr._42.cinema.controller")  // Scan controllers
public class WebConfig implements WebMvcConfigurer {
    private static final Logger logger = LoggerFactory.getLogger(WebConfig.class);

    @Autowired
    private ObjectMapper objectMapper;

    @Bean
    public ViewResolver viewResolver() {
        FreeMarkerViewResolver resolver = new FreeMarkerViewResolver();
        resolver.setCache(true);
        resolver.setPrefix("");
        resolver.setSuffix(".ftl");
        resolver.setExposeRequestAttributes(true); // Expose HttpServletRequest attributes to the model
        resolver.setExposeSessionAttributes(true);  // Optionally, expose HttpSession attributes too
        resolver.setRequestContextAttribute("request");

        return resolver;
    }

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("/WEB-INF/JSP/");

        // Configure date and time formatting
        Properties freemarkerSettings = new Properties();
        freemarkerSettings.setProperty("date_format", "yyyy-MM-dd");
        freemarkerSettings.setProperty("time_format", "HH:mm");
        freemarkerSettings.setProperty("datetime_format", "yyyy-MM-dd HH:mm");
        freemarkerSettings.setProperty("locale", "en_US");

        configurer.setFreemarkerSettings(freemarkerSettings);
        return configurer;
    }

    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        // Enable default servlet handler for static resources
        configurer.enable();
        logger.info("Default servlet handling enabled");
    }

    @Override
    public void configureAsyncSupport(AsyncSupportConfigurer configurer) {
        // Configure async support for WebSocket
        configurer.setDefaultTimeout(30000); // 30 seconds
        logger.info("Async support configured with timeout: 30000ms");
    }

    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        // Configure Jackson message converter to use our custom ObjectMapper
        // This extends the default converters instead of replacing them
        MappingJackson2HttpMessageConverter jsonConverter = new MappingJackson2HttpMessageConverter();
        jsonConverter.setObjectMapper(objectMapper);

        // Remove any existing Jackson converter and add our custom one
        converters.removeIf(converter -> converter instanceof MappingJackson2HttpMessageConverter);
        converters.add(jsonConverter);
        logger.info("Jackson message converter configured with custom ObjectMapper");
    }
}