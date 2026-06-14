#include <iostream>
#include <cxxabi.h> // разрешает использовать abi::
#include <string>
#include <cstdlib>
#include <typeinfo>

/*
   Это серьёзная тема. ABI это считай самые низкоуровневые функции, которые использует сам компилятор. Их очень много
*/

void ak() {
    std::cout << "End" << "\n";
}

int main() {
    std::atexit(ak); // эта функция запуститься.в конце программы, если не было ошибки
    
    int status = 0;
    const char* am = "Am";
    const char* mangled_name = typeid(am).name();
    
    // Деманглинг
    char* demangled = abi::__cxa_demangle(mangled_name, nullptr, 0, &status);
    
    if (status == 0) {
        std::cout << "Расшифрованное имя: " << demangled << std::endl; // char const*
    }
    
    // Очистка памяти, выделенной abi::__cxa_demangle
    std::free(demangled);
    
    return 0;
}

