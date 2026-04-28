import string, random
def randomstring(length=10):
   strin = ""
   for _ in range(1, length):
     strin = strin + random.choice(string.ascii_letters + string.digits)
   return strin
# print(randomstring())
