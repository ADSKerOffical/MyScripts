import json, requests

jsn = requests.get("https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Information%20exchange%20formats/JSON/example.json").text # в JSON нельзя добавлять коментарии
real_json = json.loads(jsn)
print(real_json["json_array"], real_json["adsker_name"]) # [1, 2, 3, 4, 5] Denis

# можно сделать таблицу в JSON с помощью json.dumps(table): str
