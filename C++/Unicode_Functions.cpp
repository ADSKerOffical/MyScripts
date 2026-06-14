#include <iostream>
#include <string>
#include <locale>
#include <codecvt>

template <typename T>
int codepoint(T value) {
    std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
    std::u32string unicode_str = converter.from_bytes(value);
    return (int) unicode_str[0];
}

std::string to_char(int codep) {
    std::u32string u32_char(1, static_cast<char32_t>(codep));
    std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
    return converter.to_bytes(u32_char);
}

int main() {
    std::cout << codepoint('A') << "\n"; // 65
    std::cout << codepoint("A") << "\n"; // 65
    std::cout << codepoint("ę") << "\n"; // 281
    std::cout << codepoint("😀") << "\n"; // 128512
    
    std::cout << to_char(65) << "\n"; // A
    std::cout << to_char(281) << "\n"; // ę
    std::cout << to_char(128512) << "\n"; // 😀
    return 0;
}
