def hasModule(name):
    try:
        exec("import " + name)
    except ModuleNotFoundError:
        return False
    else:
        return True
print(hasModule("threading"))
