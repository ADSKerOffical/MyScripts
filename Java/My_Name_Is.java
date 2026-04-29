public class Main { // это контейнер для всего
	public static Object jajs(Object a, Object b) {
		if (a instanceof String && b instanceof String) {
	  	return "My name is " + a + " with age " + b;
    	}
    	return "My name is UNKNOWN with age UNKNOWN";
	}
	
	public static void main(String[] args) { // main обязательно должен иметь какие нибудь аргументы
	     System.out.print(jajs("Denis", "15")); // My name is Denis
	}
}
