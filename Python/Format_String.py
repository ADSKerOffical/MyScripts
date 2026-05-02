import base64, codecs, binascii, hashlib, urllib.parse

def formatStr(stri, method="hex", decrypt=True):
    if method.lower() == "hex":
        if decrypt == True:
           return codecs.getdecoder("hex_codec")(stri)
        else:
           return stri.encode("utf-8").hex()
    elif method.lower() == "bytes" or method.lower() == "ascii":
        if decrypt == True:
           return stri.encode("ascii")
        else:
           return stri.encode("utf-8")
    elif method.lower() == "base64":
        if decrypt == True:
           return base64.b64decode(stri).decode("utf-8")
        else:
           return base64.b64encode(stri.encode("utf-8")).decode("utf-8")
    elif method.lower() == "urlformat" or method.lower() == "url":
        if decrypt == True:
           return urllib.parse.unquote(stri)
        else:
           return urllib.parse.quote(stri)
    elif method.lower() == "md5":
        return hashlib.md5(stri.encode()).hexdigest()
    elif method.lower() == "sha256":
        return hashlib.sha256(stri.encode()).hexdigest()
           
