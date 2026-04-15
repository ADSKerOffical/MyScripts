import http.client
result = http.client.HTTPSConnection("httpbin.org")
result.request("GET", "/get")
response = result.getresponse().read()
print(__import__("json").loads(response))
