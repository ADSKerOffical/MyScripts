#include <iostream>

using namespace std;
class User {
  public:
    string login;
    string password;
  private: // нельзя обращаться к этим параметрам
    string cppcore = "AAA"; 
};

int main() {
    User a;
    a.password = "Abxc";
    a.login = "Hhs";
    
    std::cout << a.password << std::endl; // Abxc
}
