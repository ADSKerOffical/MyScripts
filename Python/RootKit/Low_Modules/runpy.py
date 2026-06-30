import runpy

runpy._run_code('print("Hello")', globals()) # runpy
m = runpy.run_module("runpy") # делает модуль словарём
print(runpy._get_module_details("runpy")) # считай просто возвращает __spec__
print(runpy._get_code_from_file(runpy.__file__)) # превращает исходный код в CodeType
