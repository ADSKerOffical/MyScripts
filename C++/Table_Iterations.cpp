#include <vector>
#include <iostream>
#include <unordered_map>

int main() {
   // итерация массива
   std::vector<std::string> items = {"Budgify", "Identify", "Kernel"};
   for (const auto& item : items) {
     std::cout << item << std::endl;
   }

  // итерация словаря
  std::unordered_map<std::string, int> power_levels = {{"ADSKer", 9000}, {"NPC", 10}};
  for (auto const& [name, level] : power_levels) {
    std::cout << name << " has power: " << level << std::endl;
  }
}
