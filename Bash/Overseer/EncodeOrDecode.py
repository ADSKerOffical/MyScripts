import base64, codecs, binascii, hashlib, urllib.parse, sys, pathlib, os, re

method = sys.argv[1].lower()
stri = sys.argv[2]
saveToFile = sys.argv[4] if len(sys.argv) > 4 else None
decrypt = (len(sys.argv) >= 3 and sys.argv[3].lower() == "true" and True) or False
rs = ""

methods = [
   "base64/b64", "hex", "octal", "rot13/rot-13", "rot47/rot-47", "decimal", "sha256", "md5", "url/urlformat"
]

if os.path.isfile(stri):
    ahn = input("Это файл. Использовать как текст или как содержимое в файле? (введи y если да и n если нет)").lower()
    if ahn == "y":
      with open(stri, "r") as f:
          stri = f.read().strip()
    else:
       pass

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
elif method == "octal":
    if decrypt == True:
           rs = stri.encode("latin1").decode("unicode-escape").encode("latin1").decode("utf-8")
    else:
           rs = "".join(f"\\{oct(b)[2:].zfill(3)}" for b in stri.encode('utf-8'))
elif method == "decimal":
    if decrypt == True:
          pass
    else:
          rs = "".join(f"\\{ord(b)}" for b in stri)
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
elif method == "rot13" or method == "rot-13":
           rs = codecs.decode(stri, "rot-13")
elif method == "rot47" or method == "rot-47":
           source = "".join(chr(i) for i in range(33, 127))
           target = "".join(chr(33 + (i - 33 + 47) % 94) for i in range(33, 127))
           table = str.maketrans(source, target)
           rs = text.translate(table)
elif method == "*list":
           print("".join(f"{util}\n" for util in methods))
           os._exit(0)
else:
    try:
       if decrypt == True:
          rs = codecs.decode(stri, method)
       else:
          rs = codecs.encode(stri, method)
    except Exception:
       print(f"Формата {method} не существует")

print(rs)
save(rs)
