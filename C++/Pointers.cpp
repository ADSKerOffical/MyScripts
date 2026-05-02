#include <iostream>

using namespace std; // теперь при каждом вызове cout автоматически будет вызываться std::
int main() {
    int myVar = 10;
    int* ptr = &myVar;   // получает системный адресс переменной myVar

    cout << ptr;         // Выводит системный адресс
    cout << *ptr;        // Выводит 10 (тоесть получает значение по адрессу)

    *ptr = 20;           // myVar теперь 20
    cout << myVar;
    return 0;
}
