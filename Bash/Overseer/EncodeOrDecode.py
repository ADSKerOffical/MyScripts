import base64, codecs, binascii, hashlib, urllib.parse, sys, pathlib, os

method = sys.argv[1].lower()
stri = sys.argv[2]
saveToFile = sys.argv[4] if len(sys.argv) > 4 else None
decrypt = (len(sys.argv) >= 3 and sys.argv[3].lower() == "true" and True) or False
rs = ""

if os.path.isfile(stri):
    with open(stri, "r") as f:
        stri = f.read().strip()

def save(text):
  if saveToFile is None or (type(saveToFile) is str and not saveToFile.strip()):
     return
  else:
    with open(saveToFile, "w", encoding="utf-8") as file:
       file.write(text)

if method == "hex":
   if decrypt == True:
           rs = codecs.getdecoder("hex_codec")(stri)
   else:
           rs = stri.encode("utf-8").hex()
elif method == "bytes" or method == "ascii":
    if decrypt == True:
           rs = stri.encode("ascii")
    else:
           rs = stri.encode("utf-8")
elif method == "base64" or method == "b64":
    if decrypt == True:
           rs = base64.b64decode(stri).decode("utf-8")
    else:
           rs = base64.b64encode(stri.encode("utf-8")).decode("utf-8")
elif method == "urlformat" or method == "url":
    if decrypt == True:
           rs = urllib.parse.unquote(stri)
    else:
           rs = urllib.parse.quote(stri)
elif method == "md5":
           rs = hashlib.md5(stri.encode()).hexdigest()
elif method == "sha256":
           rs = hashlib.sha256(stri.encode()).hexdigest()
else:
   print("Unknown method for string")
   os._exit(0)
print(rs)
save(rs)
