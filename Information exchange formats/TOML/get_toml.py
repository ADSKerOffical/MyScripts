import tomllib # она только для чтения

with open("/sdcard/Download/toml_test.toml", "rb") as toml:
   config = tomllib.load(toml)
print(config["numbers"]) # [1, 2, 3, 4, 5]
