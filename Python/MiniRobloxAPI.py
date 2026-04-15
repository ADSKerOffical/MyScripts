class game:
  class HttpService:
    def GetAsync(link):
      return __import__("requests").get(link).text
    
    def JSONDecode(text):
      return __import__("json").loads(text)
    
    def JSONEncode(tabl):
      return __import__("json").dumps(tabl)
      
    def UrlEncode(url):
      import urllib.parse
      return urllib.parse.quote(url)
      
  class LogService:
    def ClearOutput():
      print("\033c", end="")
    ExecuteScript = exec
  
  class DebugService:
    Version = __import__("platform").python_version()
    _ENV = __import__("threading").current_thread().name
    Globals = globals
    def GetSource(obj):
      return __import__("inspect").getsource(obj)
