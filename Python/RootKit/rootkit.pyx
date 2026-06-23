from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF
cimport cython

def getcallingfunction():
   import sys
   return sys._getframe(1).f_code
   
def getgc():
   import gc
   return gc.get_objects()
   
def getloadedmodules():
  import gc, types
  modules = []
  for modul in gc.get_objects():
      if isinstance(modul, types.ModuleType):
         try:
             modules.append(modul.__name__)
         except Exception:
             pass
  return modules

def getmodules():
    import pkgutil
    modules = []
    for module in pkgutil.iter_modules():
        if not module in modules:
            modules.append(module.name)
    return modules

def is_c_obj(obj):
  import types, inspect, pathlib
  import importlib.machinery

  if isinstance(obj, (types.BuiltinFunctionType, types.BuiltinMethodType)) or type(obj).__name__ == "PyCFuncPtrType":
    return True
  elif inspect.isfunction(obj) and not hasattr(obj, "__code__"):
    return True
  elif isinstance(obj, types.ModuleType):
    if hasattr(obj, "__file__") and pathlib.Path(obj.__file__).suffix in importlib.machinery.EXTENSION_SUFFIXES:
      return True
  return False
      

def hooktrace(func, traceName, onFire):
    import sys, warnings
    if hasattr(func, "__code__"):
      def fortrace(frame, event, arg):
          if event == traceName and func.__code__ == frame.f_code:
              # arg → what return event 'return'
              onFire(arg, frame.f_code)
          return fortrace
      sys._settraceallthreads(fortrace)
    else:
        warnings.warn("This feature is not yet available on C functions")

def run_bash(script):
  import subprocess
  if isinstance(script, str):
    script = script.split()
  result = subprocess.run(script, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
  
  return {
    'exit': result.returncode,
    'stdout': result.stdout,
    'stderr': (result.stderr if hasattr(result, "stderr") else None)
  }

def my_device():
  import platform, sys, os, subprocess, re
  all_info = {}
  all_info["env"] = os.environ
  all_info["conf"] = lambda: { (t := " ".join(l.split())).partition(' ')[0] : (int(v) if re.match(r'^-?\d+$', v := t.partition(' ')[2]) else v) for l in subprocess.check_output(['getconf','-a'], text=True).splitlines() if (t := " ".join(l.split())) }

  all_info["cpu"] = {
    "bit": sys.maxsize.bit_length() + 1,
    "count": os.cpu_count(),
    "total_ram": subprocess.check_output("free -h | awk '/^Mem:/ {print $2}'", shell=True, text=True).strip(),
    "available_ram": str(round(float(subprocess.check_output("awk '/^MemAvailable:/ {print $2}' /proc/meminfo", shell=True, text=True).strip()) / 1048576, 1)) + "G"
  }

  all_info["arch"] = platform.machine()
  all_info["kernel_os"] = platform.system()
  all_info["os_name"] = subprocess.run(["uname", "-o"], check=False, text=True, capture_output=True).stdout.strip()
  all_info["is64bit"] = sys.maxsize >= 2 ^ 63
  return all_info

def is_termux():
   import os
   return os.environ.get('TERMUX_VERSION') is not None

def is_vs_code():
  import os
  return os.environ.get("TERM_PROGRAM") == "vscode"

def clonefunction(func):
    import functools, types
    try:
      return types.FunctionType(func.__code__, func.__globals__, name=func.__name__)
    except Exception:
        return functools.partial(func)

def cloneref(obj):
    import types, copy
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

def dump(func):
  import dis, io, sys, inspect 
  from types import SimpleNamespace

  info = {}
  info["args"] = lambda: list(func.__code__.co_varnames[:func.__code__.co_argcount])
  info["source_in_module"] = lambda: inspect.getsourcelines(func) if (hasattr(func, "__module__") and func.__module__ != "__main__") else None
  info["dis"] = lambda: {"dis": list(dis.get_instructions(func.__code__)), "code": func.__code__}
  return SimpleNamespace(**info)


cdef class console:
  @staticmethod
  def error(typeErr, text):
    if isinstance(typeErr, type) and issubclass(typeErr, Exception):
      raise typeErr(text)
    elif isinstance(typeErr, str):
      exec(f"class {typeErr}(Exception): pass\n{typeErr}.__module__ = 'builtins'\nraise {typeErr}('{text}')\ndel {typeErr}")

  @staticmethod
  def if_condition(condition, text=""):
    if condition == False:
      class ConditionError(Exception): pass
      ConditionError.__module__ = "builtins"
      raise ConditionError(text)

  @staticmethod
  def is_truecolor():
    import os
    if os.getenv("COLORTERM", "") == "":
      return False

  @staticmethod
  def printcolor(text, color):
    import os, warnings
    colors = {"red": "\033[31m","orange": "\033[38;2;255;165;0m", "yellow": "\033[33m", "green": "\033[32m", "cyan": "\033[36m", "blue": "\033[34m", "purple": "\033[35m", "white": "\033[37m", "black": "\033[30m", "gray": "\033[90m"}

    if isinstance(color, str) and color.lower() in colors:
      color_code = colors.get(color.lower())
      print(color_code, text, "\033[0m", sep="")
    elif isinstance(color, (int, float)):
      color = max(0, min(round(color, 0), 255))
      print(f"\033[{str(color)}m", text, "\033[0m", sep="")
    elif isinstance(color, str) and color[0] == "#":
      color = tuple(int(color.lstrip("#")[i:i+2], 16) for i in (0, 2, 4))
      print(f"\033[38;2;{color[0]};{color[1]};{color[2]}m", text, "\033m", sep="")
    elif isinstance(color, (list, tuple)):
      print(f"\033[38;2;{color[0]};{color[1]};{color[2]}m", text, "\033m", sep="")
    elif isinstance(color, dict):
      r, g, b = color.get("r", color.get("R")) or 255, color.get("g", color.get("G")), color.get("b", color.get("B"))
      print(f"\033[38;2;{r};{g};{b}m", text, "\033[0m", sep="")

  @staticmethod
  def gradual_print(text, delay=0.05):
    import time, sys
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()

  @staticmethod
  def loading(text="Loading...", loading_chars=["\\", "|", "/"], sleep_time=1, callback=None):
    import itertools, time
    savedTime = time.time()
    iter_chars = itertools.cycle(loading_chars)
    
    while time.time() - savedTime <= sleep_time:
      for _ in range(len(loading_chars)):
        print(f"\r{text}{next(iter_chars)}", end="", flush=True)
        time.sleep(0.1)

    if not callback is None and callable(callback):
       callback()

  @staticmethod
  def clear(terminal=False):
    import platform, os

    if terminal == True:
      os.system("cls" if platform.system() == "Windows" else "clear")
    else:
      print("\033c", end="")



cdef class fm:
  def readfile(path):
    with open(path, "rb") as file:
      return file.read().decode("utf-8", errors="ignore")

  def writefile(path, text=""):
    with open(path, "rb") as file:
      file.write(text)

  def find(fold, name, recursive=False):
    import pathlib
    if recursive:
      return pathlib.Path(fold).rglob(name)
    else:
      return pathlib.Path(fold).glob(name)

  @staticmethod
  def get_lib_dynload():
    import sys
    return next((p for p in sys.path if p.endswith('lib-dynload')), None)

  @staticmethod
  def get_site_packages():
    import site
    return site.getsitepackages()[0]

  def isfile(path):
    import pathlib
    return pathlib.Path(path).is_file()

  def isfolder(path):
    import pathlib
    return pathlib.Path(path).is_dir()

  def sha256sum(path):
    import subprocess
    return subprocess.check_output("sha256sum " + path + " | grep ' ' | awk '{print $1}'", text=True, shell=True)

  def listfiles(path, fullPath=False):
    import pathlib, os
    pathes = []

    if pathlib.Path(path).is_dir():
      if path == ".": path = os.getcwd()
      for pat in os.listdir(path):
        if fullPath:
          pathes.append(path + "/" + pat)
        else:
          pathes.append(pat)
    else:
      raise NotADirectoryError("Expected a folder, but received a file or non-existent object")
    return pathes



cpdef object get_from_id(size_t addr):
  cdef PyObject* ptr = <PyObject*> addr

  if ptr != NULL:
    return <object>ptr
  else:
    return None

cpdef void set_by_id(size_t addr, object newValue):
   cdef PyObject* ptr = <PyObject*> addr

   if ptr != NULL:
     obj = <object>newValue
     obj = newValue
   else:
     pass

def newcclosure(func):
  def wrapped(*args, **kwargs):
    return func(*args, **kwargs)
  return wrapped



cdef class net:
  @staticmethod
  def is_ipv4(addr):
    if not isinstance(addr, str):
        return False
    parts = addr.split('.')
    if len(parts) != 4:
        return False
    for p in parts:
        if not p:
            return False
        if not p.isdigit():
            return False
        v = int(p)
        if v < 0 or v > 255:
            return False
    return True

  @staticmethod
  def port_name(obj):
    import socket

    for proto in ("tcp", "udp"):
      try:
        return socket.getservbyport(obj, proto)
      except OSError:
        continue
    return None

  @staticmethod
  def whois_list():
    import json, urllib.request
    with urllib.request.urlopen("https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Python/RootKit/Whois_List.json") as result:
      return json.loads(result.read().decode("utf-8"))

  @staticmethod
  def is_port_open(domain, port, timeout=2):
    if port > 65536 or port < 0: return False
    import socket
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
      s.settimeout(timeout)
      return s.connect_ex((domain.encode("idna").decode("ascii"), port)) == 0

  @staticmethod
  def whois(domain):
    import socket, traceback
    who_list = net.whois_list()
    whois_serv = (net.is_ipv4(domain) and "whois.ripe.net") or (domain.split(".", 1)[-1] in who_list and who_list.get(domain.split(".", 1)[-1]))

    try:
      sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      sock.connect((whois_serv, 43))
      sock.sendall(f"{domain}\r\n".encode("utf-8"))

      response = b""
      while True:
        data = sock.recv(4096)
        if not data: 
          break
        response += data
      return response.decode("utf-8", errors="ignore")
    except Exception:
      print(traceback.format_exc())
      return ""

  @staticmethod
  def low_request(**kwargs):
    import socket, ssl, json
    from urllib.parse import urlsplit as split
    
    params = {
      "url": {
        "url": kwargs.get("url"),
        "host": split(kwargs.get("url")).hostname.encode("idna").decode("ascii"),
        "path": split(kwargs.get("url")).query != "" and (split(kwargs.get("url")).path + "?" + split(kwargs.get("url")).query) or split(kwargs.get("url")).path
      },
      "method": kwargs.get("method") or "GET",
      "headers": kwargs.get("headers") or {},
      "body": kwargs.get("body") or "",
      "port": "port" in kwargs and max(0, min(kwargs.get("port"), 65536)) or 443,
      "timeout": "timeout" in kwargs and max(0, min(kwargs.get("timeout"), 3600)) or 20
    }

    context = ssl.create_default_context()
    with socket.create_connection((params["url"]["host"], params["port"]), timeout=params["timeout"]) as sock:
      with context.wrap_socket(sock, server_hostname=params["url"]["host"]) as ssock:
        if not "Host" in params["headers"]:
          params["headers"]["Host"] = params["url"]["host"]
        sock_headers = ("\r\n" + "\r\n".join(f"{k}: {v}" for k, v in params["headers"].items())) if params["headers"] else ""
        req_res = f"{params["method"]} /{params["url"]["path"]} HTTP/1.1{sock_headers}\r\n\r\n" + params["body"]
        ssock.sendall(req_res.encode())
        
        response, peer = b"", ssock.getpeercert()
        while b"\r\n\r\n" not in response:
          chunk = ssock.recv(4096)
          if not chunk:
            break
          response += chunk
        header_part, body_part = response.split(b"\r\n\r\n", 1)
        status_line = response.split(b"\r\n", 1)[0].decode("utf-8")
        realstatus = status_line.split(" ")[2]
        status_code = int(status_line.split(" ")[1])
        ssock.close()

        info = {
          "server_headers": header_part,
          "body": body_part,
          "status_code": status_code,
          "reason": realstatus,
          "aa": lambda: socket.gethostbyname_ex(params["url"]["host"])[2],
          "aaaa": lambda: [item[4][0] for item in socket.getaddrinfo(params["url"]["host"], None, family=socket.AF_INET6)]
        }

        return info

  @staticmethod
  def request(**kwargs):
    import http.client, urllib.parse
    
    params = {
      "url": kwargs.get("url"),
      "method": kwargs.get("method") or "GET",
      "server_headers": kwargs.get("headers") or {},
      "body": kwargs.get("body") or ""
    }

    if params.get("method") == "HEAD" or params.get("method") == "GET":
      params.pop("body", None)

    fullPath = (urllib.parse.urlsplit(params.get("url")).query != "" and urllib.parse.urlsplit(params.get("url")).path + "?" + urllib.parse.urlsplit(params.get("url")).query) or urllib.parse.urlsplit(params.get("url")).path
    req = http.client.HTTPSConnection(urllib.parse.urlsplit(params["url"]).hostname)
    req.request(params["method"], fullPath)

    if "body" in params:
      req.send(params.get("body"))
    response = req.getresponse()

    info = {
      "headers": response.getheaders(),
      "body": response.read().decode("utf-8"),
      "status_code": response.status,
      "success": True if response.reason == "OK" else False
    }
    
    req.close()
    return info

cdef class crypt:
   @staticmethod
   def ripemd160(text):
     import hashlib
     text = text if isinstance(text, bytes) else text.encode("utf-8")
     hasher = hashlib.new("ripemd160")
     hasher.update(text)
     return hasher.hexdigest()

   @staticmethod
   def md5(text):
     import hashlib
     text = text if isinstance(text, bytes) else text.encode("utf-8")
     return hashlib.md5(text).hexdigest()

   @staticmethod
   def base64(text, encode=True):
     import base64
     text = text if isinstance(text, bytes) else text.encode("utf-8")

     if encode == True:
       return base64.b64encode(text).decode("utf-8")
     else:
       return base64.b64decode(text).decode("utf-8")

   @staticmethod
   def sha256(text):
     import hashlib
     text = text if isinstance(text, bytes) else text.encode("utf-8")
     return hashlib.sha256(text).hexdigest()

   @staticmethod
   def rc4(key, data):
    x = 0
    box = list(range(256))
    for i in range(256):
        x = (x + box[i] + key[i % len(key)]) % 256
        box[i], box[x] = box[x], box[i]

    x = y = 0
    result = []
    for byte in data:
        x = (x + 1) % 256
        y = (y + box[x]) % 256
        box[x], box[y] = box[y], box[x]
        result.append(byte ^ box[(box[x] + box[y]) % 256])

    return bytes(result)

__author__ = "ADSKer"
__version__ = "1.0"
