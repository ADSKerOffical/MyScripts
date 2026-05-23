local funcs = {
   pi = math.pi,
   e = math.exp(1),
   sin = math.sin, cos = math.cos, tan = math.tan,
   inf = math.huge,
   max = math.max, min = math.min,
   floor = math.floor, ceil = math.ceil,
   log = math.log, fmod = math.fmod, log10 = math.log10,
   
   round = function(num, which)
      return tonumber(string.format("%." .. tostring(math.floor(which or 1)) .. "f", num))
   end,
   
   sqrt = function(num, which)
   local tee = which or 2; if tee <= 0 then return math.nan end
      return num ^ (1 / (which or tee))
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

local example = arg[1]
if example == "*HELP" then
   funcs["*HELP"]()
else
   print(load("return " .. example, "Example", "bt", funcs)())
end
