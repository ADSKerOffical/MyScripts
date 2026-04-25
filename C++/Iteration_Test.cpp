#include <iostream>
#include <vector>

int main() {
    // обычная итерация
    for (int i = 0; i < 10; i++) {
        std::cout << i << std::endl; // от 0 до 9 с новых строк
    }
     // итерация таблицы
    std::vector<std::vector<int>> table = {{1, 2, 3, 4, 5}};
    for (const auto & row : table) {
        for (int x : row) {
            std::cout << x << ' ';
        }
        std::cout << "\n";
    } // 1 2 3 4 5
}
