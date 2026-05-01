#include <iostream>

template<typename... Ts>
int calculate(Ts... args) {
  ( (std::cout << args << "\n"), ... );
  return (args + ... + 0);
}

int main() {
  std::cout << calculate(1, 3, 6, 9, 7) << "\n";
}
