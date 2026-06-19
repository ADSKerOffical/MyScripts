import site, sys, pathlib, setuptools, os, pathlib
from Cython.Build import cythonize

os.chdir(os.path.join(os.path.expanduser('~'), "cython_projects")) # создаёт новую папку в Home
with open("my_rootkit_module_test.pyx", "w") as rtkit:
    rtkit.write(pathlib.Path("/storage/emulated/0/Download/rootkit_file.txt").read_text()) # скрипт этого модуля

with open("setup.py", "w") as setu:
   setu.write("""
from setuptools import setup
from Cython.Build import cythonize

setup(
   ext_modules = cythonize("my_rootkit_module_test.pyx")
)
""") # это обязательно 

sys.argv = ["setup.py", "build_ext", "--inplace"]
setuptools.setup(
   ext_modules = cythonize("my_rootkit_module_test.pyx")
)
# потом у тебя добавиться новый модуль my_rootkit_module_test, который ты можешь импортировать через import
