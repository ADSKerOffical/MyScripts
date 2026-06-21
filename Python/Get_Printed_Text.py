import dis
import sys
import io

def get_disassembly(func_or_code_obj) -> str:
    # 1. Создаем буфер в памяти для перехвата вывода
    output_buffer = io.StringIO()

    # 2. Временно перенаправляем sys.stdout на наш буфер
    old_stdout = sys.stdout
    sys.stdout = output_buffer

    try:
        # 3. Вызываем dis.dis, который теперь будет печатать в наш буфер
        dis.dis(func_or_code_obj)
    finally:
        # 4. ВОССТАНАВЛИВАЕМ sys.stdout (ОЧЕНЬ ВАЖНО, даже если произошла ошибка!)
        sys.stdout = old_stdout

    # 5. Получаем содержимое буфера как строку
    return output_buffer.getvalue()

# Пример использования:
def my_func(a, b):
    if a > b:
        return a + b
    return a - b

disassembly_str = get_disassembly(my_func)
print("--- Перехваченный дизассемблированный код ---")
print(disassembly_str)
