public class Main {
	public static void main(String[] args) {
		// Пример 1
		for (int i = 0; i < 5; i++) {
		    System.out.print(i);
		}
		
		// Пример 2
		int b = 0;
		while (b < 10) {
		    System.out.println(b);
		    b += 1;
		}
	    
	    // Пример 3
		int n = 0;
		do {
		    System.out.println("Добавляю текст " + String.valueOf(n));
		    n += 1;
		} while (n < 5);
	}
}
