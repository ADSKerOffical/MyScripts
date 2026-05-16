import math, sys, cmath
roundd = round; minn = min; maxx = max
            
funcs = {
   "fac": math.factorial,
   "sin": math.sin,
   "cos": math.cos,
   "log": math.log,
   "e": math.e,
   "pythagor": lambda a, b: math.sqrt(a ** 2 + b ** 2),
   "pi": math.pi,
   "round": roundd,
   "ceil": math.ceil,
   "floor": math.floor,
   "min": minn,
   "max": maxx
}

def D(a=0, b=0, c=0, withx=True):
    disc = (b ** 2) - (4 * a * c)
    if withx == True:
      if disc > 0:
          x1 = (-b + math.sqrt(disc)) / (2 * a)
          x2 = (-b - math.sqrt(disc)) / (2 * a)
          return round(x1, 3), round(x2, 3)
      elif disc == 0:
          x = -b / (2 * a)
          return x
      elif disc < 0:
          return "No solution"
    else:
      return disc
      
def sqrt(num, which=2):
    if num < 0:
      return cmath.unpack(num ** (1/ which))
    return num ** (1 / which)

def isqrt(num, which=2):
   if num <= 0 or which <= 0: return False
   return sqrt(num, which) == roundd(sqrt(num, which))
            
def pwd(*args):
   num = args[0]
   for number in args[1:]:
      num = num ** number
   return num
            
funcs["pow"] = pwd
funcs["sqrt"] = sqrt
funcs["D"] = D
funcs["isqrt"] = isqrt

result = eval(sys.argv[1].replace("^", "**"), {"__builtins__": None}, funcs)
print(result)
