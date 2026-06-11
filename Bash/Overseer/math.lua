if arg[1] == "CONVERT" then
   local method = arg[2] or "bytes"
   local value = tonumber(arg[3])
   local from = arg[4]
   local to = arg[5]
   
   local length_rates = {
      m = 1, cm = 0.01, dm = 0.1, mm = 0.001, km = 1000,
      ["in"] = 0.0254, ft = 0.3048, yd = 0.9144, mile = 1609.344, nm = 1852,
      au = 149597870700, ls = 299792458, lm = 17987547480, ly = 9460730472580800, parsec = 9460730472580800 * 3.26
   }
   
   local weight_rates = {
      g = 1, mg = 0.001, gg = 100, dm = 10, kg = 1000, q = 100000, t = 1000000,
      mt = 1e12, gt = 1e15, kt = 1e9,
      lb = 453.59237, oz = 28.3495231, os_tr = 31.103, gr = 0.06479, st = 6350, ct = 0.2,
      earth = 5.9722e27, sun = 1.989e33, jup = 1.89e30
   }
   
   local bytes = {
      b = 1, byte = 1,
      kb = 1000, kilobyte = 1000,
      kib = 1024, kibibyte = 1024,
      mb = 1e6, megabyte = 1e6,
      mib = 2 ^ 20, mebibyte = 2 ^ 20,
      gb = 1e9, gigabyte = 1e9,
      gib = 2 ^ 30, gigibyte = 2 ^ 30,
      tb = 1e12, terabyte = 1e12,
      tib = 2 ^ 40, tebibyte = 2 ^ 40,
      pt = 1e15, petabyte = 1e15,
      pit = 2 ^ 50, pebibyte = 2 ^ 50
   }
   
   local times = {
      ms = 0.001, millisecond = 0.001,
      s = 1, second = 1,
      m = 60, minute = 60,
      h = 3600, hour = 3600,
      d = 86400, day = 86400,
      w = 604800, week = 604800,
      mo = 2628002, month = 2628002,
      y = 31536000, year = 31536000,
      de = 315360000, decade = 315360000,
      ce = 3153600000, century = 3153600000
   }
   
   value = math.max(value, 0)
   
   if method:lower() == "length" or method:lower() == "size" then
      method = length_rates
   elseif method:lower() == "weight" or method == "mass" then
      method = weight_rates
   elseif method:lower() == "bytes" then
      method = bytes
   elseif method:lower() == "time" or method == "clocks" then
      method = times
   end
   
   local from_rate = method[from:lower()]
   local to_rate = method[to:lower()]
   
   if not from_rate or not to_rate then
      print("Неправильное значение или метод")
      return 1
   end

   print((value * from_rate) / to_rate)
   return 0
end

local funcs = {
   pi = math.pi,
   e = math.exp(1),
   sin = math.sin, cos = math.cos, tan = math.tan,
   inf = math.huge,
   max = math.max, min = math.min,
   floor = math.floor, ceil = math.ceil,
   log = math.log, fmod = math.fmod, log10 = math.log10, sqrt = math.sqrt,
   
   round = function(num, which)
      return tonumber(string.format("%." .. tostring(math.floor(which or 1)) .. "f", num))
   end,
   
   root = function(num, which)
   local tee = which or 2; if tee <= 0 then return math.nan end
      return num ^ (1 / (which or tee))
   end,
   
   gamma = function(z)
     local p = {
        676.5203681218851, -1259.1392167224028, 771.32342877765313,
        -176.61502916214059, 12.507343278686905, -0.13857109526572012,
        9.9843695780195716e-6, 1.5056327351493116e-7
     }
     if z < 0.5 then
         return math.pi / (math.sin(math.pi * z) * gamma(1 - z))
     else
        z = z - 1
        local x = 0.99999999999980993
        for i, val in ipairs(p) do
            x = x + val / (z + i)
        end
        local t = z + #p - 0.5
        return math.sqrt(2 * math.pi) * t^(z + 0.5) * math.exp(-t) * x
     end
   end,
   
   ln = function(x)
      return math.log(x, math.exp(1))
   end,
   
   gcd = function(a, b)
    if b == 0 then
        return a
    end
    return funcs.gcd(b, a % b)
   end,

    lcm = function(a, b)
     function gcd(a, b)
       if b == 0 then
           return a
       end
       return gcd(b, a % b)
     end
    
      return math.abs(a * b) / math.floor(gcd(a, b))
   end,
   
   sectan = function(x)
       return math.sin(x) / (math.cos(x) ^ 2)
   end,

   sinh = function(x)
      local e = math.exp(1)
      return (e ^ x - e ^ -x) / 2
   end,

   cosh = function(x)
      local e = math.exp(1)
      return (e ^ x + e ^ -x) / 2
   end,

   tanh = function(x)
      local e = math.exp(1)
      return (e ^ x - e ^ -x) / (e ^ x + e ^ -x)
   end,
   
   scope = function(array)
      return math.max(table.unpack(array)) - math.min(table.unpack(array))
   end,
   
   median = function(array)
      local sorted, len = table.sort(array), rawlen(array)
      
      if len % 2 == 0 then
         return sorted[len / 2] + sorted[len / 2 + 1]
      else
         return sorted[math.ceil(len / 2)]
      end
   end,
   
   trunc = function(num)
      local numb, _ = math.modf(num); return numb
   end,
   
   hypot = function(a, b)
      return math.sqrt(a ^ 2 + b ^ 2)
   end,
   
   avg = function(array)
      local len, val = rawlen(array), 0
      for _, value in next, array do
         val = val + value
      end
      return val / len
   end,
   
   fac = function(n)
      if n < 0 then return 0 elseif n == 0 or n == 1 then return 1 end
        local result = 1
        for i = 2, n do
           result = result * i
        end
     return result
   end,
   
   perc = function(num, procs)
      return num * (procs / 100)
   end,
   
   sigma = function(n, i, formula)
     local expr, sum = load("return function(n) return " .. formula .. " end")(), 0
     for k = i, n do
        sum = sum + expr(k)
     end
     return sum
   end,
   
   prod = function(n, i, formula)
     local expr, result = load("return function(n) return " .. formula .. " end")(), 1
     for k = i, n do
        result = result * expr(k)
     end
     return result
   end,
   
   sinc = function(x)
      return math.sin(math.pi * x) / (math.pi * x)
   end,
   
   sum = function(...)
      local args = {...}
      
      if rawlen(args) == 1 and type(args[1]) == "table" then
         local val = 0
         for _, value in next, args[1] do
            val = val + value
         end
         return val
      else
         local val = 0
         for _, value in next, args do
            val = val + value
         end
         return val
      end
   end,
}

funcs.beta = function(x, y)
   if x <= 0 or y <= 0 then return math.nan end
   return (funcs.fac(x - 1) * funcs.fac(y - 1)) / funcs.fac(x + y - 1)
end

funcs.comb = function(n, k)
   return funcs.fac(n) / (funcs.fac(k) * funcs.fac(n - k))
end

funcs["*HELP"] = function()
   for index, value in next, funcs do
      if not (index == "*HELP") and type(value) == "function" then
         local info = debug.getinfo(value, "u")
         local args = {}
         
         for param = 1, info.nparams do
            local name = debug.getlocal(value, param)
            if name then
               table.insert(args, name)
            end
         end
         
         if info.isvararg then
            table.insert(args, "...")
         end
         
         print(index .. "(" .. table.concat(args, ", ") .. ")")
      end
   end
   return 0
end

local example = arg[2]
if example == "*HELP" then
   funcs["*HELP"]()
else
   if arg[1] == "CALCULATE" then
      print(load("return " .. example, "Example", "bt", funcs)())
   end
end
