def request(url, method, headers={}, body=""):
  try:
    import http.client
    import urllib.parse
    
    def urlForRequest():
      if urllib.parse.urlsplit(url).query == "":
        return urllib.parse.urlsplit(url).path
      else:
        return urllib.parse.urlsplit(url).path + "?" + urllib.parse.urlsplit(url).query
        
    def urlProtocol():
      if urllib.parse.urlsplit(url).scheme == "https":
        return http.client.HTTPSConnection
      else:
        return http.client.HTTPConnection
    
    con = urlProtocol()(urllib.parse.urlsplit(url).hostname)
    con.request(method, urlForRequest(), headers=headers or {}, body = body or "")
    response = con.getresponse()
    
    result = {
      "status_code": response.status,
      "ok": response.reason,
      "headers": response.getheaders(),
      "body": response.read()
    }
    
    return result
  except Exception as errorType:
    print("Error has occurred: " + str(errorType))
    
# ass = request("https://httpbin.org/get", "GET")
# print(ass)
