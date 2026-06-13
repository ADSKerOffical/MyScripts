#include <iostream>

int main(int argc, char* argv[], char* envp[]) {
    // Цикл по всем переменным окружения, переданным процессу
    for (char** env = envp; *env != nullptr; ++env) {
        std::cout << *env << std::endl;
    }
    return 0;
}
