#include <iostream>
#include <iomanip>
#include <string>

using namespace std;
int main() {
    ios::fmtflags flags = cout.flags(); // сохраняет все флаги
    /*
      Примечание: все эти манипуляции являются липкими, тоесть их нужно выключать чтобы они перестали действовать (на некоторых)
    */
    
    cout << hex << 255 << "\n"; // ff, тоесть переводит число в HEX
    cout << oct << 100 << "\n"; // 144
    cout << showbase << hex << 255 << noshowbase << "\n"; // 0xff, тоесть он добавляет префикс системы счисления
    cout << boolalpha << true << noboolalpha << "\n"; // делает так, чтобы true был именно true, а не 1. Также работает с false
    cout << fixed << setprecision(2) << 3.1415 << "\n"; // 3.14
    cout << hex << uppercase << 255 << "\n"; // FF
    
    cout.flags(flags); // возвращает всё на свои места 
    cout << 12345 << "\n"; // 12345
    
    return 0;
}
