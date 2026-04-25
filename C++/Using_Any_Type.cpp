#include <iostream>
#include <any>

void run(std::any arg) {
    int var = std::any_cast<int>(arg);
    std::cout << var << std::endl;
}

int main() {
    std::any var = 5;
    int ab = std::any_cast<int>(var); // без этого не будет работать
    run(10); 
    std::cout << ab << std::endl;
} // Это выведет 10 \n 5
