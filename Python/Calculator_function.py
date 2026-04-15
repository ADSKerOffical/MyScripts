def calculate():
    print("Введи свой пример")
    exam = input()
    
    try:
          exam = exam.replace("^", "**")
          print(eval(exam))
    except Exception as errorName:
          print("Error has occured: ", errorName)
    finally:
      calculate()
calculate()
