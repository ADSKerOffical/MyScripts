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
