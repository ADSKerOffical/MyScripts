class MyClass {
private:
    int value = 10;
    mutable int counter = 0; // Исключение из правил

public:
    void testFunc() const {
        // value = 20;    // ОШИБКА! Компилятор не разрешит изменить value.
        
        int x = value;    // МОЖНО: чтение данных разрешено.
        
        counter++;        // МОЖНО: переменные с модификатором mutable менять можно.
    }
};
