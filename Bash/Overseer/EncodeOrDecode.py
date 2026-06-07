import base64, codecs, binascii, hashlib, urllib.parse, sys, pathlib, os, re, string

method = sys.argv[1].lower()
stri = (len(sys.argv) > 2 and sys.argv[2]) or ""
saveToFile = sys.argv[4] if len(sys.argv) > 4 else None
decrypt = (len(sys.argv) > 3 and sys.argv[3].lower() == "true" and True) or False
rs = ""

methods = [
   "base64/b64", "hex/base16/b16", "octal", "rot13/rot-13", "rot47/rot-47/rot_47", "decimal", "sha256", "md5", "url/urlformat/base64url", "atbash", "a1z26"
]

MORSE_DICT = {
    'A': '.-',    'B': '-...',  'C': '-.-.',  'D': '-..',   'E': '.',
    'F': '..-.',  'G': '--.',   'H': '....',  'I': '..',    'J': '.---',
    'K': '-.-',   'L': '.-..',  'M': '--',    'N': '-.',    'O': '---',
    'P': '.--.',  'Q': '--.-',  'R': '.-.',   'S': '...',   'T': '-',
    'U': '..-',   'V': '...-',  'W': '.--',   'X': '-..-',  'Y': '-.--',
    'Z': '--..',  '1': '.----', '2': '..---', '3': '...--', '4': '....-',
    '5': '.....', '6': '-....', '7': '--...', '8': '---..', '9': '----.',
    '0': '-----'
}

if os.path.isfile(stri) == True:
    ahn = input(f"Найден файл ({os.path.abspath(stri)}). Использовать как текст или как содержимое в файле? (введи y если да и n если нет) ").lower()
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

if method == "hex" or method == "base16" or method == "b16":
   if decrypt == True:
           rs = codecs.getdecoder("hex_codec")(stri)
   else:
           rs = stri.encode("utf-8").hex()
elif method == "base32" or method == "b32":
   if decrypt == True:
           rs = base64.b32decode(stri).decode("utf-8")
   else:
           rs = base64.b32encode(stri.encode("utf-8")).decode("utf-8")
elif method == "morse":
   if decrypt == True:
    decoded_words = []
    standardized_message = stri.replace('   ', ' / ')
    words = standardized_message.split(' / ')
    
    for word in words:
        decoded_letters = []
        letters = word.split(' ')
        
        for letter in letters:
            if letter in MORSE_DICT:
                decoded_letters.append(MORSE_DICT[letter])
            elif letter == '':
                continue
            else:
                decoded_letters.append('?') 
        decoded_words.append(''.join(decoded_letters))
        rs = ' '.join(decoded_words)
   else:
    morse_words = []
    for word in stri.upper().split():
        morse_chars = []
        for char in word:
            if char in MORSE_DICT:
                morse_chars.append(MORSE_DICT[char])
        morse_words.append(" ".join(morse_chars))
    rs = " / ".join(morse_words)
elif method == "octal":
    if decrypt == True:
           rs = stri.encode("latin1").decode("unicode-escape").encode("latin1").decode("utf-8")
    else:
           rs = "".join(f"\\{oct(b)[2:].zfill(3)}" for b in stri.encode('utf-8'))
elif method == "decimal":
    if decrypt == True:
          pass
    else:
          pass
elif method == "base64" or method == "b64":
    if decrypt == True:
           rs = base64.b64decode(stri).decode("utf-8")
    else:
           rs = base64.b64encode(stri.encode("utf-8")).decode("utf-8")
elif method == "urlformat" or method == "url" or method == "base64url":
    if decrypt == True:
           rs = urllib.parse.unquote(stri)
    else:
           rs = urllib.parse.quote(stri)
elif method == "md5":
           rs = hashlib.md5(stri.encode()).hexdigest()
elif method == "sha256":
           rs = hashlib.sha256(stri.encode()).hexdigest()
elif method == "atbash":
           pass
elif method == "a1z26":
     if decrypt == True:
       decoded_chars = []
       tokens = stri.split('-')
    
       for token in tokens:
           if token.isdigit():
              letter = chr(int(token) + 96)
              decoded_chars.append(letter)
           else:
              decoded_chars.append(token)
       rs = "".join(decoded_chars)
     else:
         aman = [ord(char) - 96 for char in stri.lower() if char.isalpha()]
         rs = "-".join(str(ch) for ch in aman)
elif method == "rot13" or method == "rot-13" or method == "rot_13":
           rs = codecs.decode(stri, "rot-13")
elif method == "rot47" or method == "rot-47" or method == "rot_47":
           source = "".join(chr(i) for i in range(33, 127))
           target = "".join(chr(33 + (i - 33 + 47) % 94) for i in range(33, 127))
           table = str.maketrans(source, target)
           rs = stri.translate(table)
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
