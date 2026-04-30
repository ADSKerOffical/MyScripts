def to_faren(cels):
    if isinstance(cels, (int, float)):
        return cels * (9/5) + 32
    else:
        print("Разрешены только числа")
        return 0
        
def to_cels(faren):
    if isinstance(faren, (int, float)):
        return (faren - 32) * 5/9
    else:
        print("Разрешены только числа")
        return 0
print(to_cels(68), to_faren(20)) # 20.0 68.0
