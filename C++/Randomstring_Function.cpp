#include <iostream>
#include <string>
#include <random>

std::string randomstring(int length = 10) {
    std::string saved = "";
    std::string alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> distrib(1, alphabet.length());
    
    for (int i = 0; i < length; i++) {
       int random_index = distrib(gen) - 1;
       char newChar = alphabet.at(random_index);
       saved += newChar;
    }
    
    return saved;
}

int main() {
    std::cout << randomstring(6) << "\n";
    return 0;
}
