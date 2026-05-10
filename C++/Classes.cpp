#include <iostream>

class ab {
    int a = 1; // это приватная переменная
    // еще́ тут нельзя использовать auto. Только в статических member
    
    public:
      int b = 2;
      static int val;
    
       ab() {
           val++;
           std::cout << "Loaded" << "\n";
       }
       ~ab() {
           val--;
           std::cout << "Deleted" << "\n";
       }
};

int ab::val = 0; // объявляют статическую переменную. Тоесть эта переменная для всех clmn
int main() {
    ab* clmn = new ab(); // запускается ab и к val прибавляется 1
    std::cout << (clmn -> b) << "\n"; // 2 (стрелка получает атрибут у класса) (скобки не обязательны если что)
    
    clmn -> b = 3; // теперь это 3
    
    delete clmn; // вызывается событие ~ab (настоящий ab нельзя удалить). val уменьшается на 1
    return 0;
}
