def hasModule(name):
  try:
    module = __import__(name)
  except ModuleNotFoundError:
    return False
  else:
    return True
    
# print(hasModule("threading"))
