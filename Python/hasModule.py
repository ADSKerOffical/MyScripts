def hasModule(name):
  try:
    import name
  except ModuleNotFoundError:
    return False
  else:
    return True
    
# print(hasModule("threading"))
