module = __import__("types").ModuleType("RBXApi")

class game:
  def GetService(serv):
    return getattr(game, serv)
    
  class HttpService:
    def GetAsync(link):
      import urllib.parse
      import http.client
      
      def getpath():
        if urllib.parse.urlsplit(link).query == "":
          return urllib.parse.urlsplit(link).path
        else:
          return urllib.parse.urlsplit(link).path + "?" + urllib.parse.urlsplit(link).query
      
      con = http.client.HTTPSConnection(urllib.parse.urlsplit(link).hostname); con.request("GET", getpath()); con = con.getresponse().read()
      return con
    
    def JSONDecode(text):
      return __import__("json").loads(text)
    
    def JSONEncode(tabl):
      return __import__("json").dumps(tabl)
      
    def RequestAsync(link, method, headers={}, body=""):
      import http.client
      import urllib.parse
      
      def getPath():
        if urllib.parse.urlsplit(link).query == "":
          return urllib.parse.urlsplit(link).path 
        else:
          return urllib.parse.urlsplit(link).path + "?" + urllib.parse.urlsplit(link).query
      
      def getProtocol():
        if urllib.parse.urlsplit(link).scheme == "https":
          return http.client.HTTPSConnection
        else:
          return http.client.HTTPConnection
        
      con = getProtocol()(urllib.parse.urlsplit(link).hostname)
      con.request(method, getPath(), headers=headers, body=body)
      response = con.getresponse()
      con.close()
      
      return {
        "status_code": response.status,
        "ok": response.reason,
        "headers": response.getheaders(),
        "body": response.read()
      }
      
    def UrlEncode(url):
      import urllib.parse
      return urllib.parse.quote(url)
      
  class LogService:
    def ClearOutput():
      print("\033c", end="")
    ExecuteScript = exec

class debug:
   PyVersion = __import__("platform").python_version()
   ProcessCores = __import__("os").cpu_count
   OsIs64Bit = (__import__("sys").maxsize > 2 ** 32)
   OsPlatform = __import__("platform").system()
   OsVer = __import__("platform").release()
   def getSource(obj):
      return __import__("inspect").getsource(obj)
  
module.game = game
module.debug = debug

__import__("sys").modules["RBXApi"] =  module

# it only for runtime
