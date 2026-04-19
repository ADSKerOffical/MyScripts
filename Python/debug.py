import types; import ctypes; import socket; import urllib.request; import urllib.parse
import importlib.util; import warnings; import pathlib; import importlib; import sys
import os; import json; import pwd; import platform

debug = types.ModuleType("debug")

def identifytype(obj):
  return type(obj).__name__
  
def getsource(obj):
   if hasattr(obj, "__file__"):
     try:
       return pathlib.Path(getattr(obj, "__file__")).read_text()
     except UnicodeDecodeError:
       return pathlib.Path(getattr(obj, "__file__")).read_bytes()
   else:
     return __import__("inspect").getsource(obj)

class module:
  def isfrozen(module):
    if identifytype(module) == "str":
      return "FrozenImporter" in str(importlib.util.find_spec(module).loader) != None
    elif identifytype(module) == "module":
      return "FrozenImporter" in str(importlib.util.find_spec(module.__name__).loader) != None
  
  def get(moduleName):
    if not type(moduleName) is str:
      warnings.warn("Expected string. Function was stopped")
      return
      
    try:
      return importlib.import_module(moduleName)
    except ModuleNotFoundError:
      return None
 
  def has_module(moduleName):
    try:
      exec("import " + moduleName)
      return True
    except ModuleNotFoundError:
      return False
      
  def getmodules():
    modules = []
    for module in sys.modules:
      if not module in modules:
        modules.insert(len(modules) - 1, module)
     
    for module in __import__("pkgutil").iter_modules():
        if not module in modules:
            modules.insert(len(modules) - 1, module.name)
    return modules

class func:
  def iscclosure(funct):
    try:
      code = funct.__code__
      closure = funct.__closure__
      return False
    except Exception as a:
      return True
      
  def getinfo(funct):
    if isinstance(funct, types.FunctionType) and not func.iscclosure(funct):
      return {
        "name": funct.__code__.co_name,
        "constants": funct.__code__.co_consts,
        "variables": funct.__code__.co_varnames,
        "args": funct.__code__.co_argcount,
        "source": funct.__code__.co_code
      }
    else:
      warnings.warn("Object not function or function is a C closure")
      return {}
      
  def newcclosure(funct):
    if not isinstance(funct, types.FunctionType):
      warnings.warn("Function expected but got " + type(funct).__name__)
      return None
    return ctypes.CFUNCTYPE(None)(funct)
    
class console:
  def warn(text):
    warnings.warn(text)
    
  def error(errorType, text):
    exec("class " + errorType + "(Exception):\n  pass\nraise " + errorType + "(\"" + text + "\")")
    
  def clear():
    print("\033c", end="")
    
class web:
  def hostname(host):
    return socket.gethostbyname(host)
    
  def is_valid(url):
    try:
      hs = urllib.parse.urlsplit(url)
      return all([hs.scheme, hs.netloc])
    except ValueError:
      return False
      
  def valid_methods(url):
    try:
      response = urllib.request.Request(url, method="OPTIONS")
      with urllib.request.urlopen(response, timeout=15) as result:
        return result.headers.get("Allow")
    except Exception as err:
      debug.console.warn("Something went wrong. Error: " + str(err))
      
class files:
  def read(path):
    try:
      return pathlib.Path(path).read_text()
    except UnicodeDecodeError:
      return pathlib.Path(path).read_bytes()
      
  def listelem(path):
    return pathlib.Path(path).iterdir()
    
  def getcurrentexecution():
    return sys.argv[0]
    
class deviceinfo:
  is64bit = (sys.maxsize > 2 ** 32)
  system = platform.system()
  user = pwd.getpwuid(os.getuid()).pw_name
  def getdirectory():
    return os.getcwd()
    
  posix = os.name
  machine = platform.machine()
  PYV = platform.python_version()
  def getipinfo():
    import ipaddress
    response = urllib.request.Request("https://httpbin.org/get", method="GET")
    with urllib.request.urlopen("https://httpbin.org/get") as result:
      ip = json.loads(result.read()).get("origin")
      wu = ipaddress.ip_address(ip)
      
      try:
          host = socket.gethostbyaddr(ip)
      except Exception as h:
          host = "not found"
      
      return {
        "ip": ip,
        "isprivate": wu.is_private,
        "isglobal": wu.is_global,
        "multicast": wu.is_multicast,
        "host": host or "not found"
      }
  RAM = os.sysconf("SC_PAGE_SIZE") * os.sysconf("SC_PHYS_PAGES")
  
debug.module = module
debug.type = identifytype
debug.func = func
debug.console = console
debug.web = web
debug.files = files
debug.device = deviceinfo
sys.modules["debug"] = debug

del module; del func; del identifytype; del console; del web; del files; del deviceinfo; del debug; del getsource
