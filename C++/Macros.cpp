#include <iostream>
#include <string>

// Макросы – это фрагменты кода, которые обрабатываются перед компиляцией
//

#define PI 3.14159
#define square(x) ((x) * (x))

/*
  А также есть внутренние макросы:
  
  __FILE__ – путь к текущему файлу
  __LINE__ – текущая линия
  __func__ – имя текущей функции
  __cplusplus – целочисленный индификатор (у каждой версии он разный)
  __DATE__ – текущая дата (имя месяца, день, год)
  __TIME__ – текущее локальное время
  
  А также у некоторых комплияторов есть свои макросы:
  
  Clang: __clang__
  GCC: __GNUC__
  Microsoft Visual C++: _MSC_VER
*/

int main() {
    std::string time = __DATE__;
    
    std::cout << PI * square(5) << std::endl;
    std::cout << time
}
