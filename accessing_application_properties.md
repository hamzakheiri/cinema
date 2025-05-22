# Accessing application.properties from WEB-INF in Spring Controllers and Configs

When your `application.properties` file is located in the `webapp/WEB-INF` directory instead of the classpath, you need special configuration to access it. Here are the best approaches to access these properties in your Spring controllers and configuration classes:

## 1. Using `@Value` Annotation (Simplest Approach)

The `@Value` annotation is the most straightforward way to inject individual properties:

```java
@Controller
public class MyController {

    @Value("${my.property}")
    private String myProperty;

    @Value("${my.number:42}")  // With default value 42
    private int myNumber;

    // Use the properties in your methods
}
```

## 2. Using `@ConfigurationProperties` (Type-safe Configuration)

For a more structured approach with type safety:

1. Create a configuration properties class:

```java
@Component
@ConfigurationProperties(prefix = "app")
public class AppProperties {

    private String name;
    private String version;
    private Database database = new Database();

    // Getters and setters

    public static class Database {
        private String url;
        private String username;
        // Getters and setters
    }
}
```

2. Use it in your controller or config:

```java
@Controller
public class MyController {

    private final AppProperties appProperties;

    @Autowired
    public MyController(AppProperties appProperties) {
        this.appProperties = appProperties;
    }

    @GetMapping("/info")
    public String getInfo(Model model) {
        model.addAttribute("appName", appProperties.getName());
        model.addAttribute("dbUrl", appProperties.getDatabase().getUrl());
        return "info";
    }
}
```

## 3. Using Environment Object

For more dynamic access to properties:

```java
@Controller
public class MyController {

    @Autowired
    private Environment env;

    @GetMapping("/config")
    public String getConfig(Model model) {
        String dbUrl = env.getProperty("spring.datasource.url");
        int serverPort = env.getProperty("server.port", Integer.class, 8080);

        model.addAttribute("dbUrl", dbUrl);
        model.addAttribute("serverPort", serverPort);

        return "config";
    }
}
```

## 4. Using PropertySourcesPlaceholderConfigurer with WEB-INF Properties

For accessing properties in WEB-INF directory:

```java
@Configuration
@PropertySource("file:${catalina.home}/webapps/YOUR_APP_NAME/WEB-INF/application.properties")
// OR for relative path from webapp root
// @PropertySource("file:${webapp.root}/WEB-INF/application.properties")
public class AppConfig {

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Value("${datasource.url}")
    private String dbUrl;

    @Bean
    public DataSource dataSource() {
        // Use dbUrl to configure your DataSource
    }
}
```

## 5. Accessing WEB-INF Properties in WebInitializer

To access properties from WEB-INF in a `WebApplicationInitializer` implementation:

```java
public class WebInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        // Create application context
        AnnotationConfigWebApplicationContext rootContext = new AnnotationConfigWebApplicationContext();

        // Register configuration classes
        rootContext.register(AppConfig.class);

        // Get the real path to WEB-INF
        String webInfPath = servletContext.getRealPath("/WEB-INF");

        // Load properties from WEB-INF
        try {
            PropertySource propertySource = new ResourcePropertySource(
                "file:" + webInfPath + "/application.properties");
            rootContext.getEnvironment().getPropertySources().addFirst(propertySource);

            // Now you can access properties
            String property = rootContext.getEnvironment().getProperty("my.property");
        } catch (IOException e) {
            // Handle exception
        }

        // Continue with servlet configuration...
    }
}
```

## 6. Using a Custom PropertySourcesPlaceholderConfigurer

For more control over property loading from WEB-INF:

```java
@Configuration
public class PropertyConfig {

    @Autowired
    private ServletContext servletContext;

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        configurer.setLocation(new ServletContextResource(servletContext, "/WEB-INF/application.properties"));
        configurer.setIgnoreResourceNotFound(false);
        configurer.setIgnoreUnresolvablePlaceholders(false);
        return configurer;
    }
}
```

## 7. Setting System Property in web.xml

You can also set a system property in web.xml to make the WEB-INF path available:

```xml
<context-param>
    <param-name>webAppRootKey</param-name>
    <param-value>webapp.root</param-value>
</context-param>

<listener>
    <listener-class>org.springframework.web.util.WebAppRootListener</listener-class>
</listener>
```

Then access it in your configuration:

```java
@PropertySource("file:${webapp.root}/WEB-INF/application.properties")
```

## Best Practices for WEB-INF Properties

1. **Secure Configuration**: Placing properties in WEB-INF keeps them secure from direct web access
2. **Environment Awareness**: Use different property files for different environments
3. **Fallback Mechanism**: Implement a fallback to classpath properties if WEB-INF properties aren't found
4. **Early Loading**: Load properties early in the application lifecycle
5. **Error Handling**: Implement proper error handling for missing properties

## Example application.properties

```properties
# Application Configuration
app.name=My Spring Application
app.version=1.0.0

# Database Configuration
app.database.url=jdbc:postgresql://localhost:5432/mydb
app.database.username=postgres
app.database.password=secret

# Server Configuration
server.port=8080
server.servlet.context-path=/api
```

By following these approaches, you can effectively access and use properties from your application.properties file located in the WEB-INF directory throughout your Spring application. This approach provides better security for sensitive configuration data while still maintaining the flexibility of externalized configuration.
