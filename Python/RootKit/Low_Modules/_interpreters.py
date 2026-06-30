import _interpreters as im
inn = im.create() # 1
print(im.get_current() == im.get_main()) # True

def codetest():
    print("A", __file__)

im.set___main___attrs(1, {"__file__": "ammm"}) # нельзя изменять атрибуты если этот интерпретатор уже запускается, но 1 пока что нет
im.exec(1, codetest.__code__) # A ammm
im.call(1, codetest) # A ammm
print(im.whence(1)) # 5

for newC in im.list_all():
    if newC != im.get_current():
        im.destroy(newC[0])
