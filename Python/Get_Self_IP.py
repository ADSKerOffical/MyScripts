# Это встроенный способ

import urllib.request as request, json
req = request.Request("https://httpbin.org/get", method="GET")
with request.urlopen("https://httpbin.org/get") as response:
    print(json.loads(response.read()).get("origin"))
