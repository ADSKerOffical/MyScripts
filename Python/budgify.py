import types; import ctypes; import os; import subprocess; import urllib.request; import urllib.parse; import http.client;
import warnings; import pathlib; import importlib; import sys; import platform; import pkgutil; import importlib.util; import gc; import socket;
import site; import random; import time; import math; import string; import copy; import functools

Exploit = types.ModuleType("budgify")

def getcallingfunction():
  return sys._getframe(1).f_code
getcallingfunction.__doc__ = "Gets the function that calls this function"
  
def getcallingscript(with_source=False):
  if with_source == True:
     return pathlib.Path(sys.argv[0]).read_text()
  else:
     return sys.argv[0]
getcallingscript.__doc__ = "Gets the path to the file that contains current script"
  
Exploit.getcallingfunction = getcallingfunction
Exploit.getcallingscript = getcallingscript
Exploit.getgenv = globals
# Exploit.getgenv.__doc__ = "Equivalent to the globals function"

def getmodules():
    modules = []
    for module in pkgutil.iter_modules():
        if not module in modules:
            modules.append(module.name)
    return modules
getmodules.__doc__ = "Gets all available modules"
    
def iscclosure(funct):
    try:
      code = funct.__code__
      closure = funct.__closure__
      return False
    except Exception as a:
      return True
iscclosure.__doc__ = "Checks whether a function with C closure (written on C) or is it built-in"
      
def newcclosure(funct):
    if not isinstance(funct, types.FunctionType):
      warnings.warn("Function expected but got " + type(funct).__name__)
      return None
    return ctypes.CFUNCTYPE(None)(funct)
newcclosure.__doc__ = "Gets a version of the function with C closure (cleans up __code__ and __closure__)"
    
def getloadedmodules():
  modules = []
  for modul in gc.get_objects():
      if isinstance(modul, types.ModuleType):
         try:
             exec("test = " + modul.__name__)
             modules.append(modul.__name__)
         except Exception:
             pass
  return modules
getloadedmodules.__doc__ = "Gets a list of all modules that were loaded via <import> in current script"
  
def clonefunction(func):
    if not Exploit.iscclosure(func):
      return types.FunctionType(func.__code__, func.__globals__, name=func.__name__)
    else:
        return functools.partial(func)
clonefunction.__doc__ = "It clones a function, but it is different for all comparisons, but it executes the same code"

def isreadonly(obj):
    if type(obj) is tuple:
        return True
    elif isinstance(obj, types.ModuleType):
        return  "FrozenImporter" in str(importlib.util.find_spec(obj).loader) != None
    else:
        return False
isreadonly.__doc__ = "Checks if a module or table is frozen. Under development"
        
def readfile(path):
  filepath = pathlib.Path(path)
  if filepath.exists():
    try:
      return filepath.read_text()
    except UnicodeDecodeError:
      return filepath.read_binary()
  else:
    return ""
readfile.__doc__ = "Gets the source code of a file. For .so files returns binary code"
    
def executebash(script):
  return subprocess.run(script, shell=True)
executebash.__doc__ = "Runs a bash script"
  
def request(link, method="GET", **options):
    splited = urllib.parse.urlsplit(link)
    headers = options.get("headers") or {}
    body = options.get("body") or ""
    
    def getFullPath():
        path = splited.path
        if splited.query != "":
            path = path + "?" + splited.query
        return path
    
    req = http.client.HTTPSConnection(splited.hostname)
    req.request(method, getFullPath(), headers=headers, body=body)
    response = req.getresponse(); body = response.read()
    req.close()
    
    return {
      "success": (response.reason == "OK" and True) or False,
      "headers": response.headers,
      "body": body,
      "status_code": response.status,
      "ip": socket.gethostbyname(splited.hostname),
      "fqdn": socket.getfqdn(socket.gethostbyname(splited.hostname)),
      "version": response.version
    }
request.__doc__ = "Makes an HTTP request and returns detailed information"

def hooktrace(func, traceName, onFire):
    if hasattr(func, "__code__"):
      def fortrace(frame, event, arg):
          if event == traceName and func.__code__ == frame.f_code:
              # arg → what return event 'return'
              onFire(arg, frame.f_code)
          return fortrace
      sys._settraceallthreads(fortrace)
    else:
        warnings.warn("This feature is not yet available on C functions")
hooktrace.__doc__ = "Hooking a trace event (for example return) and it returning given args. This feature under development"

def getconstants(func):
	if isinstance(func, types.FunctionType):
		if hasattr(func, "__code__"):
			return func.__code__.co_consts
		else:
			return []
getconstants.__doc__ = "Getting all constants of function"

def kill_thread():
	while True:
		pass
kill_thread.__doc__ = "Stops the current flow forever"

Exploit.getmodules = getmodules
Exploit.getloadedmodules = getloadedmodules
Exploit.iscclosure = iscclosure
Exploit.newcclosure = newcclosure
Exploit.clonefunction = clonefunction
Exploit.isreadonly = isreadonly
Exploit.readfile = readfile
Exploit.getgc = gc.get_objects
Exploit.run_shell = executebash
Exploit.request = request
Exploit.hooktrace = hooktrace
Exploit.getconstants = getconstants 
Exploit.kill_thread = kill_thread

def listfiles(path, fullname=False):
    paths = []
    if os.path.exists(path):
        for file in os.listdir(path):
            if os.path.isfile(path + "/" + file):
                paths.append(fullname == True and (path + "/" + file) or file)
        return paths
    else:
        warnings.warn("Such path not exists")
        return paths
listfiles.__doc__ = "Gets a list of files in the given folder. You can set it to return the full path"

def isfile(path):
    return (os.path.exists(path) and os.path.isfile(path))
isfile.__doc__ = "Checks if the given file exists"

def isfolder(path):
    return (os.path.exists(path) and os.path.isdir(path))
isfolder.__doc__ = "Checks if the given folder exists"
    
def writefile(path, newsource):
    if os.path.exists(path) and os.path.isfile(path):
       pathlib.Path(path).write_text(newsource)
    else:
       warnings.warn("File not found or path is not file")
writefile.__doc__ = "Changes the contents of a file. Need to confirm to change"
    
def makefile(folderpath, name=("python-file: " + str(random.randint(1000000, 90000000)) + ".txt"), source=""):
	"""
    foldpath = pathlib.Path(folderpath)
    if foldpath.exists():
        .write_text(source)
        print(f"Created file with name {name} in folder in path {foldpath}")
        return newfile
    else:
    	warnings.warn("Folder not exists")"""
makefile.__doc__ = "Creates a file in a folder with the given name and content"
    
def delfile(path):
    if os.path.exists(path) and os.path.isfile(path):
        if input("Confirm the action y/N? ") == "y":
          pathlib.Path(path).unlink()
    else:
        warnings.warn("File not found or path is not file")
delfile.__doc__ = "Deleting the file"

def save_module(module):
    if isinstance(module, types.ModuleType):
        path = site.getsitepackages()[0]
        modulName = hasattr(module, "__name__") and getattr(module, "__name__") or "UnknowModule" + str(len(listfiles(path))) + ".py"
        (pathlib.Path(path) / modulName).write_text(__import__("inspect").getsource(module))
        print("Module saved with which " + path + "/" + modulName + ".py")
    else:
        warnings.warn("You can save only modules")
save_module.__doc__ = "Saves this module to a folder site-packages and you can use this module in any script. The name of the created file is printed in the console. If it is not possible to obtain the module name, its name will be something like UnknownModule17. The feature is under development"

def remove_module(moduleName):
    path = site.getsitepackages()[0]
    if type(moduleName) is str:
       if os.path.exists(path + "/" + moduleName + ".py"):
           if input("Confirm the action y/N? ") == "y":
               pathlib.Path(path + "/" + moduleName + ".py").unlink()
       else:
           warnings.warn("Module not found in site-packages")
    elif isinstance(moduleName, types.ModuleType):
        if hasattr(moduleName, "__file__") and pathlib.Path(module.__file__).parent.find(path) != -1:
            if input("Confirm the action y/N? ") == "y":
                pathlib.Path(module.__file__).unlink()
        else:
            warnings("Module not found in site-packages")
remove_module.__doc__ = "Removes this module from the site-packages by its name if he was there. User confirm is required for deletion"

def randomvar(value, inglobal=True):
    randomname = ""
    for iw in range(15):
      randomname = randomname + random.choice("abcdefjhgnmsrtyuiopqwzxvkl1234567890")
    if inglobal == True:
        globals()[randomname] = value
    else:
        sys._getframe(1).f_globals[randomname] = value
        
    return randomname
randomvar.__doc__ = "Creates variable with absolute random name. 2 argument can create argument in global env (if True) or in current env. Returns name of variable"
    
def randomstring(length=10):
    word = ""
    for _ in range(length):
        word = word + random.choice(string.ascii_letters)
    return word
randomstring.__doc__ = "Creates random string with Latin chars with target length"

def cloneref(obj):
    if isinstance(obj, types.FunctionType) or isinstance(obj, types.BuiltinFunctionType):
        if hasattr(obj, "__code__"):
            return types.FunctionType(obj.__code__, obj.__globals__, name=obj.__name__)
        else:
            return obj
    elif type(obj).__name__ in ["tuple", "list", "dict"] or (hasattr(obj, "__module__") and hasattr(obj, "__dict__")):
            return copy.deepcopy(obj)
    elif isinstance(obj, types.ModuleType):
        newModule = types.ModuleType(obj.__name__)
        for atr in dir(obj):
            setattr(newModule, atr, getattr(obj, atr))
        return newModule
cloneref.__doc__ = "Receives the same object but with a new address"
        
def isthirdparty(module):
    if hasattr(module, "__file__"):
        if module.__file__.find(site.getsitepackages()[0]) > -1:
            return True
        else:
            return False
    else:
        return True
isthirdparty.__doc__ = "Checks if the given module is not built-in"
            
def getfilesource(path):
   import pathlib, os, struct
   
   if os.path.exists(path):
     try:
         source = pathlib.Path(path).read_text()
         if type(source) is bytes:
             source = source.decode("utf-8")
         return source
     except UnicodeDecodeError:
         with open(path, "rb") as fil:
           return fil.read().decode("ascii", errors="ignore")
   else:
       raise OSError("Path not found")
getfilesource.__doc__ = "Getting source code of file by path. For C files trying decode bytes"
       
def encode_string(stri, format="hex"):
    import base64, binascii, codecs, urllib.parse, hashlib
    
    if format.lower() == "hex":
        return stri.encode("utf-8").hex()
    elif format.lower() == "base64":
        return (base64.b64encode(stri.encode("utf-8"))).decode("utf-8")
    elif format.lower() == "rot13" or format.lower() == "rot_13":
        return codecs.encode(stri, "rot_13")
    elif format.lower() == "urlencode":
        return urllib.parse.quote(stri)
    elif format.lower() == "sha256":
        return hashlib.sha256(stri.encode()).hexdigest()
    elif format.lower() == "md5":
        return hashlib.md5(stri.encode()).hexdigest()
    else:
        return stri.encode(format.lower())
encode_string.__doc__ = r"""
  Encoding string to different format: hex, base64, rot13, md5 and more
  Examples:
      Hex: Hello! → 48656c6c6f21
      Base64: Hello! → SGVsbG8h
      ROT13: Hello! → Uryyb!
      SHA256: Hello! → 334d016f755cd6dc58c53a86e183882f8ec14f52fb05345887c8a5edd42c87b7
      MD5: Hello! → 952d2c56d0485958336747bcdd98590d
      ASCII: Hello! → Hello! (bytes)
"""
        
def getinfo(obj):
    infotable = {}
    
    infotable["is_global"] = obj in globals().values()
    infotable["in_gc"] = obj in gc.get_objects()
    infotable["used_memory"] = sys.getsizeof(obj)
    infotable["python_type"] = type(obj).__name__
    
    if isinstance(obj, type):
        infotable["kind_type"] = "class"
    elif isinstance(obj, list) or isinstance(obj, dict) or isinstance(obj, tuple):
        infotable["kind_type"] = "table"
    elif isinstance(obj, types.ModuleType):
         infotable["kind_type"] = "module"
    elif isinstance(obj, types.FunctionType) or isinstance(obj, types.BuiltinFunctionType) or isinstance(obj, types.CFunctionType):
         infotable["kind_type"] = "function"
    else:
         infotable["kind_type"] = type(obj).__name__
    infotable["is_descriptor"] = any(hasattr(obj, method) for method in ["__get__", "__delete__"])
    infotable["address"] = hex(id(obj))
    
    if infotable["kind_type"] == "class":
        infotable["mro"] = (hasattr(obj, "mro") and obj.mro()) or "unknown"
    
    return infotable
getinfo.__doc__ = r"""
  Getting information about object. Parameters:
     is_global: bool – object in globals or no
     in_gc: bool – object in garage collector or no
     used_memory: int – size of object (equivalent to sys.getsizeof)
     python_type: str – how type(obj) seen type of object
     kind_type: str – abstract class of object (table, string, class, module)
     is_descriptor: bool – object is descriptor or no
     address: str – id of object in hex format
"""
    
def rawget(obj, atr):
    try:
        return eval("obj." + atr)
    except Exception as err:
        if isinstance(obj, types.ModuleType):
          try:
              exec("from " + obj.__name__ + " import " + atr, globals(), locals())
              return atr
          except Exception as err:
              print(err)
              return None
        elif isinstance(obj, (list, dict, tuple)):
            try:
                return obj[atr]
            except Exception as err:
                print(err)
                return None
        else:
            print(err)
            return None
rawget.__doc__ = "Getting attribute value of object"
            
def loadstring(code_str):
	return exec(code_str, globals(), locals())

class kernel:
  def getbyid(id_obj):
    if type(id_obj) is int:
        return ctypes.cast(id_obj, ctypes.py_object).value
    elif type(id_obj) is str:
        return ctypes.cast(int(id_obj, 16), ctypes.py_object).value

  def setbyid(target_id, new_value):
    try:
        target_obj = ctypes.cast(target_id, ctypes.py_object).value
    except:
        return False

    referrers = gc.get_referrers(target_obj)

    for ref in gc.get_referrers(target_obj):
        if isinstance(ref, dict):
            for key in list(ref.keys()):
                if ref[key] is target_obj:
                    ref[key] = new_value
        
        elif isinstance(ref, list):
            for i, item in enumerate(ref):
                if item is target_obj:
                    ref[i] = new_value
       
        elif isinstance(ref, set):
            ref.remove(target_obj)
            ref.add(new_value)
    return True
    
def hookfunction(peet, hook_func=None):
    def hok(*args, **kwargs):
        try:
           hook_func(*args, **kwargs)
        except Exception as err:
            print(f"Budgify | WARN: error in hook with id <{id(hok)}> with error: {err}")
        return peet(*args, **kwargs)
    setbyid(id(peet), hok)
    return hok
            
Exploit.listfiles = listfiles
Exploit.isfile = isfile
Exploit.isfolder = isfolder
Exploit.writefile = writefile
Exploit.makefile = makefile 
Exploit.delfile = delfile
Exploit.save_module = save_module
Exploit.remove_module = remove_module
Exploit.randomvar = randomvar
Exploit.randomstring = randomstring
Exploit.loadstring = loadstring
Exploit.cloneref = cloneref
Exploit.is_third_party = isthirdparty
Exploit.getfilesource = getfilesource
Exploit.encode_string = encode_string
Exploit.getinfo = getinfo
Exploit.rawget = rawget
Exploit.hookfunction = hookfunction

class console:
  def print(text, color="white"):
    colors = {"white": "37", "red": "91", "green": "92", "yellow": "93", "blue": "34", "cyan": "96", "black": "30", "purple": "95"}
    print("\033[" + colors[color] + "m" + text + "\033[0m")
  
  def warn(text):
    warnings.warn(text)
    
  def error(errorType, text):
    exec("class " + errorType + "(Exception):\n  pass\nraise " + errorType + "(\"" + text + "\")")
    
  def clear():
    os.system('cls' if os.name == 'nt' else 'clear')
    
  def set_logs(text):
    os.system('cls' if os.name == 'nt' else 'clear')
    print(text)

Exploit.console = console
Exploit.kernel = kernel
console.__doc__ = "Class for control console"

Exploit.__author__ = "ADSKer / Budgify Project"
Exploit.__version__ = "1.0"
Exploit.__doc__ = """
   Budgify – module, designed to work with environments and the engine itself. This module will help you go against the rules of the engine itself, even if it work on its rules. This module was made for 7 days of learning Python. Before that, I studied Luau for 3 years, on my phone and without any help
   
   Main function:
      version 1:
         • getcallingfunction(): CodeType – getting
         • getcallingscript(only_source=False): str – getting file path of current script or source of file with current script
         • getgenv(): dict – equal function globals()
         • getmodules(): list – get names of all loaded modules which you have
         • getloadedmodules(): list – getting all imported modules
         • iscclosure(func: function): bool – function was written on C or no
         • newcclosure(func: function): CFunctionType – getting C Closure version of function. This function under development 
         • clonefunction(func: function): function or functools.partial(func)
         • isreadonly(table | module | class): bool – check if type is frozen
         • getgc(): list – getting all objects in current session
         • run_shell(shell_script: str, return_result=False) – executing shell (bash) script
         • request(url, method="GET", headers={}, body=""): dict – making request and gets response from request:
         	
             success: bool – request was successful or no
             headers: dict – headers getting from server
             body: str – body of response
             status_code: int – status code of response
             ip: str – ip address of host from url
             fqdn: str – getting FQDN (full dns name) of host from url
             version – version of protocol (1.0 or 1.1)
             
        • hooktrace(target_func: not c closure function, traceName: str, logFunc) – hooking trace event of function and getting results to logFunc. This not working on C function yet
        • getconstants(function) – getting constants of Py function
        • kill_thread() – stopping current thread forever. This function under development
        • listfiles(path, fullname=False): list – getting names of all files in this folder. If you want full path, then set fullname on True
        • isfile(path): bool – this path is file or no
        • isfolder(path): bool – this path is folder or no
        • save_module(module | class) – saving this module in site-packages folder and you can use import this module in your any sessions. When is success in console displaying name of module. This function in developing
        • remove_module(module | moduleName: str) – deleting this file by name of by object if his found in site-packages. When launched, it asks for confirmation of the operation
        • is_third_party(module): bool – check if this module is third party (downloaded)
        • cloneref(object): object – copies this object with new address
        • getfilesource(path): str – getting source of this file
        • encode_string(string, format="hex") – returns string in this format (hex, base64, MD5 and more)
        • rawget(obj, attribute: str): variant – getting attribute of this object
        • loadstring(code: str): variant – executing code from string
        • getbyid(id: int | str): variant – getting object by his id or id in hex format
        • setbyid(id: int | str, newValue: variant) – set value of object by his id
        • hookfunction(target, newFunc): function – hooking this function and getting args from target function. This function under development 
"""

sys.modules["budgify"] = Exploit
