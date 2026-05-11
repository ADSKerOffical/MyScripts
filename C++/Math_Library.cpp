#include <string>
#include <iostream>
#include <variant>
#include <cmath>
#include <type_traits>
#include <tuple>
#include <algorithm>

namespace Math {
       static double pow(double a, double b) {
           return std::pow(a, b);
       }
       
       static double sqrt(double num, int exp = 2) {
           return std::pow(num, 1.0 / exp);
       }
       
       static int round(double num) { return std::round(num); }
       static int ceil(double num) { return (int) num; }
       
       static bool isqrt(double num, int exp = 2) {
           return Math::sqrt(num, exp) == std::round(Math::sqrt(num, exp));
       }
       
       static double inf = INFINITY;
       static double nan = NAN;
       static double pi = 3.1415;
       static double e = 2.718;
       
       static bool isinf(double num) { return num == INFINITY; }
       static bool isnan(double num) { return num == NAN; }
       
       static std::tuple<double, double, double> D(double a = 0, double b = 0, double c = 0) {
           double disc = (std::pow(b, 2)) - (4 * a * c);
           if (disc == 0) {
               double x = -b / (2 * a);
               return {x, NAN, disc};
           } else if (disc < 0) {
               return {NAN, NAN, disc};
           } else if (disc > 0) {
               double x1 = (-b - std::sqrt(disc)) / (2 * a);
               double x2 = (-b + std::sqrt(disc)) / (2 * a);
               return {x1, x2, disc};
           }
       }
       
       static double perc(double num, double percs) {
          return (num / 100 * percs);
       }
       
       static double toDouble(const std::variant<int, float, double, long, short>& num) {
           return std::visit([](auto&& v) -> double {
               return static_cast<double>(v);
           }, num);
       }
       
       static double factorial(int num) {
          if (num < 0) {
             return NAN;
          } else if (num == 0) { return 1.0; }
          return std::tgamma(num + 1);
       }
       
       static double fromstring(std::string str) { return std::stod(str); }
       static double min(double num1, double num2) { return std::min(num1, num2); }
       static double max(double num1, double num2) { return std::max(num1, num2); }
       
       namespace geometry {
          static double sin(double degr) { return std::sin(degr); }
          static double cos(double degr) { return std::cos(degr); }
       };
};

int main() {
    auto [x1, x2, x3] = Math::D(1.0, -4.0, 4.0);
    std::cout << x1 << "\n";
    
    for (int i = 0; i < 1000; i++) {
       if (Math::isqrt(i)) {
         std::cout << i << " ";
       }
    }
}
