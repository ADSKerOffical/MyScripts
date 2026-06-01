import unicodedata

def get_unicode_info(unicode):
    unic = unicode
    if isinstance(unicode, str) and not (ord(unicode) is None):
        pass
    elif isinstance(unicode, (int, float)):
        unic = chr(unicode)
        
    return {
       "name": unicodedata.name(unic),
       "category": unicodedata.category(unic)
    }
