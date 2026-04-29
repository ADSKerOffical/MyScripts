public class RuntimeInfo {
	public static void main(String[] args) {
		Runtime runtime = Runtime.getRuntime();
		
		System.out.println(System.getProperty("os.arch")); // архитектура устройства
		System.out.println(System.getProperty("os.name")); // название операционной системы 
		System.out.println(System.getProperty("os.version")); // версия устройства
		System.out.println(System.getProperty("user.name")); // текущее имя юзера
		System.out.println(System.getProperty("user.home")); // текущий файл содержащий данный скрипт
		System.out.println(System.getProperty("user.dir")); // полный путь окружения
		System.out.println(System.getProperty("sun.arch.data.model")); // является ли операционная система 32 битная или 64 битная
		// System.getenv().forEach((k, v) -> System.out.println(k + ":" + v)); // то же самое что и команда set в Shell
		
		System.out.println(runtime.freeMemory()); // свободная память
		System.out.println(runtime.maxMemory()); // сколько максимум памяти может потреблять
		System.out.println(runtime.availableProcessors()); // сколько используется процессоров
	}
}
