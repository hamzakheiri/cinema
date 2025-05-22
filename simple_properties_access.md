# Simplest Way to Access WEB-INF/application.properties

This guide shows the simplest approach to access properties from `WEB-INF/application.properties` in both configuration classes and controllers.

## Step 1: Configure Property Loading in WebInitializer

First, set up property loading in your WebInitializer:

```java
public class WebInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        // Create application context
        AnnotationConfigWebApplicationContext rootContext = new AnnotationConfigWebApplicationContext();
        
        // Get the real path to WEB-INF
        String webInfPath = servletContext.getRealPath("/WEB-INF");
        
        // Set a system property to store the WEB-INF path
        System.setProperty("webinf.path", webInfPath);
        
        // Register configuration classes
        rootContext.register(AppConfig.class);
        
        // Load properties from WEB-INF
        try {
            PropertySource propertySource = new ResourcePropertySource(
                "file:" + webInfPath + "/application.properties");
            rootContext.getEnvironment().getPropertySources().addFirst(propertySource);
        } catch (IOException e) {
            // Log error
            System.err.println("Could not load properties: " + e.getMessage());
        }
        
        // Continue with servlet configuration...
        servletContext.addListener(new ContextLoaderListener(rootContext));
        
        // Web context
        AnnotationConfigWebApplicationContext webContext = new AnnotationConfigWebApplicationContext();
        webContext.register(WebConfig.class);
        
        // DispatcherServlet
        DispatcherServlet dispatcherServlet = new DispatcherServlet(webContext);
        ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher", dispatcherServlet);
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");
    }
}
```

## Step 2: Create a PropertyConfig Class

Create a dedicated configuration class for properties:

```java
@Configuration
@PropertySource("file:${webinf.path}/application.properties")
public class PropertyConfig {
    
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
}
```

## Step 3: Access Properties in AppConfig

In your AppConfig class, simply use @Value:

```java
@Configuration
@Import(PropertyConfig.class)  // Import the property configuration
public class AppConfig {
    
    @Value("${database.url}")
    private String dbUrl;
    
    @Value("${database.username}")
    private String dbUsername;
    
    @Value("${database.password}")
    private String dbPassword;
    
    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUsername);
        config.setPassword(dbPassword);
        return new HikariDataSource(config);
    }
}
```

## Step 4: Access Properties in Controllers

In your controllers, use the same @Value annotation:

```java
@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Value("${app.name}")
    private String appName;
    
    @Value("${app.admin.email}")
    private String adminEmail;
    
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("appName", appName);
        model.addAttribute("adminEmail", adminEmail);
        return "admin/dashboard";
    }
}
```

## Example application.properties

Place this file in your WEB-INF directory:

```properties
# Application info
app.name=My Cinema Application
app.version=1.0.0
app.admin.email=admin@example.com

# Database configuration
database.url=jdbc:postgresql://localhost:5432/cinema
database.username=postgres
database.password=postgres

# Other settings
max.sessions.per.day=10
default.seats.per.hall=100
```

## Why This Approach Is Simple

1. **Single Configuration Point**: The PropertyConfig class handles loading the properties file
2. **Consistent Access**: Both configuration classes and controllers use the same @Value annotation
3. **No Autowiring Complexity**: No need to inject Environment or custom property holders
4. **Minimal Code**: Just a few annotations and one configuration class
5. **Type Conversion**: Spring automatically converts property values to the required type

This approach provides a clean, simple way to access your WEB-INF/application.properties throughout your application with minimal configuration.
