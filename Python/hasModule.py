def hasModule(name):
    try:
        import importlib
        test = importlib.import_module(name)
    except ModuleNotFoundError:
        return False
    else:
        return True
print(hasModule("threading"))
