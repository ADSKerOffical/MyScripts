#include <string>
#include <iostream>
#include <unordered_map>
#include <any>
#include <variant>

std::string text = "Text"; // include <string>
int num1 = 1;
double num2 = 1.3; // также и с float
bool boolean = true;
char symbol = 'C'; // нужно только через '
std::nullptr_t null; // nullptr (это типо null)
std::string array[ ] = {"A"}; // это теперь массив. Таблица принимает только указанный тип
std::unordered_map<std::string, int> dict = {{"A", 2}}; // Это создает словарь. Ты можешь указывать типы. Требуется unordered_map
std::any changeable = 7; // Эта переменная может быть любым типом. Нужно использовать include <any>. Чтобы получить значение нужно использовать std::any_cast<int>(changeable)
std::variant<int, double, std::string> var = "Text"; // Эта переменная может быть int, double, string и ничем либо. Если переменная не подходящего типа, то тебе напишет ошибку. Чтобы получить значение нужно использовать std::get<std::string>(var)
const int protec = 5; // это создаёт переменную, которую невозможно изменить
auto typeobj = 1; // auto автоматически определяет тип объекта

int main() {
    std::cout << text << " ";
    std::cout << std::get<std::string>(var) << std::endl;
}
