import pathlib
import sys

path = pathlib.Path(sys.path[len(sys.path) -1]) / "CustomModule.py" # created new module in stie-packages with name CustomModule.py
path.write_text("""
def a():
    return 1
""", encoding="utf-8") # fist arg is functions of 
# activate this if you want delete module: path.unlink()

import CustomModule
print(CustomModule.a())
# now you can use it in anyone runtime script
