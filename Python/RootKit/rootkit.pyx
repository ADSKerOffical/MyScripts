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

def iscclosure(obj):
  return not hasattr(obj, "__code__")

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



cdef class net:
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

__author__ = "ADSKer"
__version__ = "1.0"
