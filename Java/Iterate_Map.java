public class Main {
	public static void main(String[] args) {
		// Get a specific environment variable
String path = System.getenv("PATH");

// Get all environment variables as a Map
System.getenv().forEach((k, v) -> System.out.println(k + ":" + v));
	}
}
