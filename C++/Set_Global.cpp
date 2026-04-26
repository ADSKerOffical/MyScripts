int g_counter = 0; // Global variable
#include <iostream>

void run() {
    g_counter++; g_counter = 5;
}

int main() {
    std::cout << g_counter << std::endl; // 0
    run();
    std::cout << g_counter << std::endl; // 5
}

// Метод 2 (уже лучше)

#include <iostream>
void upgrade(int &level) { // Значок & означает, что мы взяли адрес оригинала. Если его убрать, то значение глобально не изменится
    level += 100;
}

int my_power = 10;
int main() {
  upgrade(my_power);
  std::cout << my_power << std::endl; // 110
}
