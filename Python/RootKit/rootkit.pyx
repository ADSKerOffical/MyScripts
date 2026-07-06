from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF
from cpython.object cimport PyObject_Type, PyObject_SetAttrString
cimport cpython.object as c_py
cimport cython

cdef object _IMPORT_C(str name):
   cdef object result = __import__("importlib").import_module(name)
   return result

def _IMPORT(name):
   cdef object result = _IMPORT_C(name)
   return result

def getcallingfunction():
   import sys
   return sys._getframe(1).f_code
   
def getgc():
   gc = _IMPORT("gc")
   return gc.get_objects()

cpdef c_methods(object args):
   cdef str mode = args.get("mode")
   cdef object val = args.get("value")
   cdef object obj = args.get("obj")

   if mode == "PyObject_GetAttrString":
      result = c_py.PyObject_GetAttrString(obj, val)
      return result

def restorebuiltins():
    import builtins
    builtins.globals().update(vars(builtins))
   
def getloadedmodules():
  gc, types = _IMPORT("gc"), _IMPORT("types")
  modules = {}
  for modul in gc.get_objects():
      if isinstance(modul, types.ModuleType):
         try:
             modules[modul.__name__] = modul
         except Exception:
             pass
  return modules

def getmodules():
    pkgutil = _IMPORT("pkgutil")
    modules = []
    for module in pkgutil.iter_modules():
        if not module in modules:
            modules.append(module.name)
    return modules

def loadstring(code, mode="py", **kwargs):
    import sys, types
    globs = kwargs.get("globals", sys._getframe(1).f_globals)
    locs = kwargs.get("locals", sys._getframe(1).f_locals)
    
    try:
      if mode.lower() == "py" or mode.lower() == "python":
          code = compile(code, filename="<string>", mode="exec") if isinstance(code, str) else code
          return types.FunctionType(code, globs, "loadstring")
      elif mode.lower() == "cpy" or mode.lower() == "cython" or mode.lower() == "cpython":
          code = compile("return cython.inline(code)", filename="<string>", mode="exec")
          return types.FunctionType(code, globs, "loadstring")
      elif mode.lower() == "eval":
          code = compile("return eval(code, globs, locs)", filename="<string>", mode="exec")
          return types.FunctionType(code, globs, "loadstring")
    except Exception:
        return None
    
def _crash():
    import importlib, contextlib, io
    module = importlib.import_module("_testcapi")
    with contextlib.redirect_stdout(io.StringIO()):
        module.crash_no_current_thread()

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
    if hasattr(func, "__code__") or func == "any":
      def fortrace(frame, event, arg):
          if (event == traceName or event == "any") and (func.__code__ == frame.f_code or func == "any"):
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

def open_url(url):
  import webbrowser
  webbrowser.open_new(url)

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


class console:
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
  def printcolor(*args, color="white"):
    import os, warnings, math
    colors = {"red": "\033[31m","orange": "\033[38;2;255;165;0m", "yellow": "\033[33m", "green": "\033[32m", "cyan": "\033[36m", "blue": "\033[34m", "purple": "\033[35m", "white": "\033[37m", "black": "\033[30m", "gray": "\033[90m"}

    if isinstance(color, str) and color.lower() in colors:
      for txt in args:
        color_code = colors.get(color.lower())
        print(color_code, txt, "\033[0m", sep="")
    elif isinstance(color, (int, float)):
      color = math.trunc(color)
      for txt in args:
        color = max(0, min(round(color, 0), 255))
        print(f"\033[{str(color)}m", txt, "\033[0m", sep="")
    elif isinstance(color, str) and color[0] == "#":
      for txt in args:
        color = tuple(int(color.lstrip("#")[i:i+2], 16) for i in (0, 2, 4))
        print(f"\033[38;2;{color[0]};{color[1]};{color[2]}m", txt, "\033m", sep="")
    elif isinstance(color, (list, tuple)):
      for txt in args:
        print(f"\033[38;2;{color[0]};{color[1]};{color[2]}m", txt, "\033m", sep="")
    elif isinstance(color, dict):
      for txt in args:
        r, g, b = color.get("r", color.get("R")) or 255, color.get("g", color.get("G")), color.get("b", color.get("B"))
        print(f"\033[38;2;{r};{g};{b}m", txt, "\033[0m", sep="")

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



class fm:
  class FMConstants:
    __doc__ = "External storage of constants for user use"
    ANDROID_EXT_STORAGE = "/storage/emulated"
    ANDROID_MEMORY_DIR = "/sdcard"
    WINDOWS_STORAGES = ("C:\\", "D:\\", "E:\\")
    LINUX_MAX_NAME = 256
    LINUX_MAX_PATH = 4096
    CURRENT_EXPANSION = (".", "-+")
    PREVIOUS_EXPANSION = "~-"
    HOME_EXPANSION = "~"
    PARRENT_EXPANSION = ".."
    UNIX_NULL = "/dev/null"
    WIN_NULL = "NUL"
    MAGIC_BYTES = {
       "PNG": b"\x89PNG\r\n\x1a\n", "JPEG": b"\xff\xd8\xff\xe1", "ELF": b"\x7ELF", "PDF": b"%PDF", "BMP": b"BM", "GZIP": b"\x1f\x8b", "ZIP": b"\x50\x4b\x03\x04", "HTML": b"<!DOCTYPE html", "XML": b"<?xml", "WIN_PE": b"PE\0\0", "UTF8_BOM": b"\xef\xbb\xbf"
    }
    EXIT_CODES = {"0": "success", "1": "default error", "2": "error in CLI or wrong arg for CLI", "126": "no permissions for file", "127": "command not found", "130": "SIGINT"}
    FILE_PERMS = {"0": ("---", "no permissions"), "1": ("--x", "only using"), "2": ("-w-", "only write"), "3": ("-wx", "write and use"), "4": ("r--", "only reading"), "5": ("r-x", "read and using"), "6": ("rw-", "read and write"), "7": ("rwx", "all perms enabled")}
    IOS_MEMORY_DIR = "/var/mobile"
    DARWIN_USER_DIR = "/Users/username"
    DARWIN_APP_DIR = "/Applications"

  @staticmethod
  def readfile(path):
    with open(path, "rb") as file:
      return file.read().decode("utf-8", errors="ignore")

  @staticmethod
  def writefile(path, text=""):
    with open(path, "rb") as file:
      file.write(text)

  @staticmethod
  def find(fold, name, recursive=False):
    import pathlib
    if recursive:
      return pathlib.Path(fold).rglob(name)
    else:
      return pathlib.Path(fold).glob(name)

  @staticmethod
  def is_root():
    import platform, subprocess, ctypes, os
    if platform.system() == "Linux":
        return subprocess.run(["id", "-u"], text=True, capture_output=True) == "0"
    elif platform.system() == "Windows":
       try:
          return ctypes.windll.shell32.IsUserAnAdmin() != 0
       except Exception: return False
    elif platform.system() == "Darwin":
        return os.geteuid() == 0

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

cpdef object randomstring(int length=10, str mode="aA", int howMany = 1):
   import string, random
   cdef str result = ""
   cdef object to_iter = []

   if "a" in mode:
     to_iter.append(string.ascii_lowercase)
   if "A" in mode:
     to_iter.append(string.ascii_uppercase)
   if "aA" in mode or "Aa" in mode:
     to_iter.append(string.ascii_lowercase + string.ascii_uppercase)
   if "d" in mode:
     to_iter.append(string.digits)
   if "p" in mode:
     to_iter.append(string.punctuation)
   
   result_iter = "".join(to_iter)
   for _ in range(length):
     result += random.choice(result_iter)
   return result

cdef dict originals = {}
cdef dict hidden_table = {}

def hookfunction(func1, func2):
     import types, builtins
     codeobj = func2
     if isinstance(func2, str):
         codeobj = compile(func2, filename="<string>", mode="exec")
     elif isinstance(func2, types.CodeType):
         pass
     elif hasattr(func2, "__code__"):
         codeobj = func2.__code__
         
     if not id(func1) in originals:
         if hasattr(func1, "__code__"):
            originals[id(func1)] = func1.__code__
         elif isinstance(func1, types.BuiltinFunctionType):
             originals[id(func1)] = func1
     if isinstance(func1, types.BuiltinFunctionType):
         setattr(builtins, func1.__name__, func2)
         return
     elif func2 is None and id(func1) in originals:
         func1.__code__ = originals.get(id(func1))
         originals.pop(id(func1))
     else:
         func1.__code__ = codeobj

def ishooked(func):
    return func.__code__ in originals

cpdef hide(str name, object value):
  hidden_table[name] = value

cpdef reveal(str name):
  return hidden_table.get(name, None)

cpdef remove(str name):
  if name in hidden_table:
    hidden_table.pop(name)



class net:
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
    whois_serv = (net.is_ipv4(domain) and "whois.ripe.net") or (domain.rsplit(".", 1)[-1] in who_list and who_list.get(domain.rsplit(".", 1)[-1]))

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



cdef object POLY_C(object a, int x):
   cdef Py_ssize_t i
   cdef Py_ssize_t n = len(a)
   if n == 0: return 0

   cdef object result = a[n - 1]
   for i in range(n - 2, -1, -1):
      result = result * x + a[i]
   return result

cdef int LEV_C(str text1, str text2):
    cdef int len1 = len(text1)
    cdef int len2 = len(text2)
    cdef list previous_row = list(range(len2 + 1))
    cdef list current_row
    cdef int i, j
    cdef char c1, c2
    cdef int insertions, deletions, substitutions

    for i in range(len1):
        c1 = text1[i]
        current_row = [i + 1]
        for j in range(len2):
            c2 = text2[j]
            insertions = previous_row[j + 1] + 1
            deletions = current_row[j] + 1
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row

    return previous_row[-1]

class crypt:
   class CryptConstants:
     __doc__ = "External storage of constants for user use"
     FNV_32_OFFSET = 0x811C9DC5
     FNV_32_PRIME = 0x01000193
     FNV_64_OFFSET = 0xCBF29CE484222325
     FNV_64_PRIME = 0x100000001B3
     CRC32_NORMAL = 0x04C11DB7
     CRC32_REVERSED = 0xEDB88320
     CRC64_ECMA_NORMAL = 0x42F0E1EBA9EA3693
     CRC64_ECMA_REVERSED = 0xC96C5795D7870F42
     BIT_MASK_32 = 0xFFFFFFFF
     BIT_MASK_64 = 0xFFFFFFFFFFFFFFFF
     SHA256_HEX_LEN = 64
     MD5_HEX_LEN = 32
   
   @staticmethod
   def entropy(text):
    if not isinstance(text, (str, bytes, bytearray)) or len(text) == 0:
        return 0
    b = text.encode("utf-8") if isinstance(text, str) else bytes(text)
    if len(b) == 0:
        return 0
    from math import log2
    counts = {}
    for byte in b:
        counts[byte] = counts.get(byte, 0) + 1
    total = len(b)
    h = 0.0
    for count in counts.values():
        p = count / total
        h -= p * log2(p)
    return h

   @staticmethod
   def bitmask(mask):
    return 2 ** mask - 1

   @staticmethod
   def hex(text, encode=True):
     import codecs
     text = text.decode("utf-8", errors="ignore") if isinstance(text, bytes) else text
     if encode == True:
       return text.encode("utf-8").hex()
     else:
       return codecs.getdecoder("hex_codec")(text)

   @staticmethod
   def rot13(text):
     import codecs
     return codecs.decode(text, "rot-13")

   @staticmethod
   def rot47(text):
     source = "".join(chr(i) for i in range(33, 127))
     target = "".join(chr(33 + (i - 33 + 47) % 94) for i in range(33, 127))
     table = str.maketrans(source, target)
     return text.translate(table)

   @staticmethod
   def atbash(text):
    result = ""
    for char in text:
        if 'a' <= char <= 'z':
            result += chr(ord('z') - (ord(char) - ord('a')))
        elif 'A' <= char <= 'Z':
            result += chr(ord('Z') - (ord(char) - ord('A')))
        else:
            result += char
    return result

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
   def base32(text, encode=True):
     import base64
     text = text if isinstance(text, bytes) else text.encode("utf-8")

     if encode == True:
       return base64.b32encode(text).decode("utf-8")
     else:
       return base64.b32encode(text).decode("utf-8")

   @staticmethod
   def base64(text, encode=True):
     import base64
     text = text if isinstance(text, bytes) else text.encode("utf-8")

     if encode == True:
       return base64.b64encode(text).decode("utf-8")
     else:
       return base64.b64decode(text).decode("utf-8")

   @staticmethod
   def base85(text, encode=True):
     import base64

     if encode == True:
       return base64.b85encode(text).decode("utf-8")
     else:
       return base64.b85decode(text).decode("utf-8")

   @staticmethod
   def binary(text, encode=True):
     if encode == False:
           return "".join(chr(int(text[i:i+8], 2)) for i in range(0, len(text), 8))
     else:
           return "".join(format(ord(x), '08b') for x in text)

   @staticmethod
   def decimal(text, encode=True):
     import re
     if encode == True:
       return "".join(f"\\{char}" for char in list(text.encode("utf-8")))
     else:
       return re.sub(r"\\(\d+)", lambda m: chr(int(m.group(1))), text)

   @staticmethod
   def octal(text, encode=True):
     if encode == True:
       return "".join(f"\\{oct(b)[2:].zfill(3)}" for b in text.encode('utf-8'))
     else:
       return text.encode("latin1").decode("unicode-escape").encode("latin1").decode("utf-8")

   @staticmethod
   def sha256(text):
     import hashlib, types
     if isinstance(text, (bytes, str)):
        text = text if isinstance(text, bytes) else text.encode("utf-8")
        return hashlib.sha256(text).hexdigest()
     elif isinstance(text, (types.ModuleType, type, types.FunctionType)):
        result = "".join(str(getattr(text, atr)) for atr in dir(text)) + str(id(text))
        return hashlib.sha256(result.encode("utf-8", errors="ignore")).hexdigest()

   @staticmethod
   def adler32(text):
     import zlib
     text = text.encode("utf-8", errors="ignore") if isinstance(text, str) else text
     return zlib.adler32(text.encode("utf-8"))

   @staticmethod
   def crc32(text):
     import zlib
     text = text.encode("utf-8", errors="ignore") if isinstance(text, str) else text
     return zlib.crc32(text)

   @staticmethod
   def crc64(data):
    data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
    crc = 0x0000000000000000
    for byte in data:
        crc ^= (byte << 56)
        for _ in range(8):
            if crc & 0x8000000000000000:
                crc = (crc << 1) ^ 0xC96C5795D7870F42
            else:
                crc <<= 1
    return crc & 0xFFFFFFFFFFFFFFFF

   @staticmethod
   def blake2s(data):
     import hashlib
     data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
     obj = hashlib.blake2s()
     obj.update(data)
     return obj.hexdigest()

   @staticmethod
   def blake2b(data):
     import hashlib
     data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
     obj = hashlib.blake2b()
     obj.update(data)
     return obj.hexdigest()

   @staticmethod
   def xor_cipher(data, key):
    data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
    key = key.encode("utf-8", errors="ignore") if isinstance(key, str) else key

    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))

   @staticmethod
   def rc4(data, key):
    x = 0
    data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
    key = key.encode("utf-8", errors="ignore") if isinstance(key, str) else key

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

   @staticmethod
   def fnv1a_32(data):
     data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
     hash_val = 0x811C9DC5
     for byte in data:
        hash_val = hash_val ^ byte
        hash_val = (hash_val * 0x01000193) & 0xFFFFFFFF
     return hash_val

   @staticmethod
   def fnv1a_64(data):
     data = data.encode("utf-8", errors="ignore") if isinstance(data, str) else data
     hash_val = 0xCBF29CE484222325
     for byte in data:
        hash_val = hash_val ^ byte
        hash_val = (hash_val * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
     return hash_val

   @staticmethod
   def a1z26(text, encode=True, separator="-"):
    import re
    if encode == True:
        result = []
        for char in text:
            if char.isascii() and char.isalpha():
                result.append(str(ord(char.lower()) - 96))
            elif char == " ":
                result.append(" ")
        return separator.join(result).replace(f"{separator} {separator}", " ")
    else:
        result = []
        for num in re.findall(r"\d+|\s", text):
            if num.isdigit() and 1 <= int(num) <= 26:
                result.append(chr(96 + int(num)))
            elif num == " ":
                result.append(" ")
        return "".join(result)

   @staticmethod
   def poly(a, x):
     cdef double result = POLY_C(a, x)
     return result

   @staticmethod
   def lev(text1, text2):
     cdef int result = LEV_C(text1, text2)
     return result

   @staticmethod
   def is_base64(text):
    import re
    text = text.decode('utf-8') if isinstance(text, bytes) else text
    if len(text) % 4 != 0: return False
    return bool(re.compile(r"^[A-Za-z0-9+/]+={0,2}$").match(text))

   @staticmethod
   def is_base32(data):
    import re
    data = data.decode("utf-8", errors="ignore") if isinstance(data, bytes) else data
    return bool(re.compile(r"[A-Z2-7]+=*$").match(data) and len(data) % 8 == 0)

   @staticmethod
   def is_sha256(text):
    import re
    text = text.decode('utf-8') if isinstance(text, bytes) else text
    if len(text) != 64: return False
    return bool(re.compile(r"^[a-z0-9]").match(text))

   @staticmethod
   def is_hex(text):
    import re
    return (bool(re.fullmatch(r"[a-fA-F0-9]+", text)) and isinstance(int(text, 16), int)) or isinstance(int(text, 16), int)

class stego:
   class StegoConstants:
     __doc__ = "External storage of constants for user use"
     LATIN_LOWER = "abcdefghijklmnopqrstuvwxyz"
     LATIN_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
     DIGITS = "0123456789"
     HEX = "0123456789ABCDEF"
     PUNCTUATION = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
     MAX_UNICODE = 0x10FFFF
     UNSIGNED_CHAR_MAX = 255
     ASCII_MAX = 0x7F
     BMP_RANGE = (0x000, 0xFFFF)
     SMP_RANGE = (0x10000, 0x1FFFF)
     SIP_RANGE = (0x20000, 0x2FFFF)
     TIP_RANGE = (0x30000, 0x3FFFF)
     SSP_RANGE = (0xE0000, 0xEFFFF)
     UTC_RANGE = (0xE0000, 0xE007F)
     SURROGATE_RANGE = (0xDC00, 0xDFFF)
     PUA_RANGES = ((0xE000, 0xF8FF), (0xF0000, 0xFFFFD), (0x100000, 0x10FFFD))

   wingdings_table = {
     "A": chr(9996), "B": chr(128076), "C": chr(128077), "D": chr(128078), "E": chr(9756), "F": chr(9758), "G": chr(9757), "H": chr(9759), "I": chr(0x270B), "J": chr(9786), "K": chr(128528), "L": chr(9785), "M": chr(128163), "N": chr(9760), "O": chr(9872), "P": chr(127985), "Q": chr(9992), "R": chr(9788), "S": chr(128167), "T": chr(10052), "U": chr(128326), "V": chr(10014), "W": chr(128328), "X": chr(10016), "Y": chr(10017), "Z": chr(9770),
     "a": chr(9803), "b": chr(9804), "c": chr(9805), "d": chr(9806), "e": chr(9807), "f": chr(9808), "g": chr(9809), "h": chr(9810), "i": chr(9811), "j": chr(128624), "k": chr(128629), "l": chr(9679), "m": chr(128318), "n": chr(9632), "o": chr(9633), "p": chr(128912), "q": chr(10065), "r": chr(10066), "s": chr(11047), "t": chr(10731), "u": chr(9670), "v": chr(10070), "w": chr(11045), "x": chr(8999), "y": chr(11193), "z": chr(8984),
     "0": chr(128193), "1": chr(128194), "2": chr(128196), "3": chr(128463), "4": chr(128464), "5": chr(128452), "6": chr(8987), "7": chr(128430), "8": chr(128432), "9": chr(128434),
     "!": chr(128393), r'"': chr(9986), "#": chr(9985), "$": chr(128083), "%": chr(128365), "&": chr(128366), r"'": chr(128367), "(": chr(128383), ")": chr(9990), "*": chr(128386), "+": chr(128387), ",": chr(128234), "-": chr(128235), ".": chr(128236), "/": chr(128237), "?": chr(9997), "@": chr(128398), ">": chr(9991), "=": chr(128428), "<": chr(128427), ";": chr(128436), ":": chr(128435), "[": chr(9775), "\\": chr(2384), "]": chr(9784), "{": chr(127989), "}": chr(128630), "~": chr(128631)
   }

   @staticmethod
   def utc_encode(text, hiddenText):
     ghost = ""
     for ch in hiddenText:
       ghost += chr(0xE0000 + ord(ch))
     return text + ghost

   @staticmethod
   def utc_decode(text):
     decoded = ""
     for ch in text:
        codepoint = ord(ch)
        if 0xE0000 <= codepoint <= 0xE007F:
            decoded += chr(codepoint - 0xE0000)
     return decoded

   @staticmethod
   def wingdings(text, encode=True):
     if encode == True:
       return text.translate(str.maketrans(stego.wingdings_table))
     else:
       return text.translate(str.maketrans({v: k for k, v in stego.wingdings_table.items()}))

   @staticmethod
   def plane_of(cha):
    import math
    cha = cha[0] if isinstance(cha, str) else cha
    return math.trunc(ord(cha) / 0x10000)

   @staticmethod
   def plane_range_of(num):
     num = max(0, (min(16, __import__("math").trunc(num))))
     return (num * 0xFFFF + num, 0xFFFF * (1 + num) + num)

   @staticmethod
   def homoglyph(s):
    translation_table = str.maketrans({
        'a': '\u0430', 'b': '\U0001d5bb', 'c': '\u0441', 'd': '\u0501', 'g': '\u0261', 'e': '\u0435', 'o': '\u03bf', 'p': '\u0440', 'y': '\u2d16', 'x': '\U0001d5d1', 'i': '\u0456', 'n': '\u0578', 'm': '\U0001d5c6', 't': '\U0001d5cd', 'r': '\U0001d5cb', 'u': '\u057d', 'w': '\U0001d5d0', 'q': '\U0001d5ca', 's': '\U0001d5cc', 'v': '\u03bd', 'z': '\U0001d5d3', 'f': '\u0192', 'l': '\u0406', 'k': '\u03ba', 'j': '\u0458', 'h': '\U0001d5c1',
        "A": "\u0410", "B": "\u0391", "C": "\u2ca4", "D": "\ua4d3", "E": "\u2d39", "M": "\u03fa", "O": "\u0555", "P": "\u03a1", "I": "\u0406", "K": "\u2c94", "Y": "\u2ca8", "L": "\u2cd0", "U": "\ua4f4", "W": "\ua4ea", "F": "\ua4dd", "V": "\ua4e6", "N": "\ua4e0", "Z": "\ua4dc", "S": "\U00010343", "Q": "\u051a", "X": "\u2d5d", "H": "\U000102cf", "T": "\u0422", "R": "\ua4e3", "G": "\ua4d6", "J": "\U0001d5a9"
    })
    return s.translate(translation_table)

   @staticmethod
   def spec(select=None):
     info = {
       "rlo": bytes([226, 128, 174]).decode('utf-8'),
       "lro": chr(0x202D),
       "non_breaking_space": chr(0x00A0),
       "backspace": chr(8),
       "null": "\0",
       "etx": chr(3),
       "stx": chr(2),
       "delete": chr(0x7F),
       "wj": chr(0x2060),
       "invisible_separator": chr(0x2063),
       "esc": chr(0x1B),
       "form_feed": chr(0x0C),
       "vertical_tab": chr(0x0B),
       "replacement_char": chr(0xFFFD),
       "ideographic_comma": chr(0x3001),
       "en_dash": chr(0x2013), "em_dash": chr(0x2014),
       "full_width_space": chr(0x3000),
       "zwsp": chr(0x200B), "zwnj": chr(0x200C), "zwj": chr(0x200D), "lro": chr(0x200E), "rlm": chr(0x200F),
       "blank": chr(0x2080), "obj": chr(0xFFFC), "unknown": chr(0xFFFD),
       "biggest_name": chr(0xFBF9), "biggest_visual": chr(0xFDFD), "last": chr(0x10FFFF), "tiny_space": chr(0x2009), "cgj": chr(0x034F), "bom": chr(0xFEFF)
     }

     if select == "*" or select == "~":
       return info.keys()
     return info.get(select, info)

   @staticmethod
   def is_sus(text):
     spec_chars = stego.spec()
     if any(ch in {k: v for k, v in spec_chars.items() if k not in ["biggest_name", "biggest_visual", "last", "blank", "tiny_space", "obj", "unknown"]}.values() for ch in text) or any(0xE0000 <= ord(ch) <= 0xE007F for ch in text):
       return True
     return False

__author__ = "ADSKer"
__version__ = "1.0"
