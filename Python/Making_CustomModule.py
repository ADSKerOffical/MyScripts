module = __import__("types").ModuleType("CustomModule")

def get():
    return 1
module.get = get
__import__("sys").modules["CustomModule"] =  module

import CustomModule
print(CustomModule.get()) # 1
