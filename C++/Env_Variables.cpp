#include <iostream>
#include <cstdlib>

int main(int argc, char* argv[], char* envp[]) {
    // Можно получить значение конкретной переменной
    const char* storage = std::getenv("EXTERNAL_STORAGE");
    const char* pwd = std::getenv("PWD");
    std::cout << storage << "\n"; // в моём случае /sdcard
    std::cout << pwd << "\n"; // путь к home
    
    // Цикл по всем переменным окружения
    for (char** env = envp; *env != nullptr; ++env) {
        std::cout << *env << std::endl;
    }
    return 0;
}
