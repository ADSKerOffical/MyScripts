import java.util.Properties;

public class AllProperties {
    public static void main(String[] args) {
        Properties properties = System.getProperties();
        properties.list(System.out); // Prints all key-value pairs to the console
    }
}

