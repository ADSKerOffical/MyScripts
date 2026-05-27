local super_lua = {}
super_lua.math = {}
super_lua.math.limits = {}
super_lua.string = {}
super_lua.string.bit = {}
super_lua.string.crypt = {}
super_lua.table = {}
super_lua.kernel = {}



super_lua._PRELOAD = function(moduleName)
   if not _G[moduleName] then
      if require then
          return require(moduleName)
      elseif not require and debug ~= nil and rawget(debug, "getregistry") and rawget(debug.getregistry(), "_LOADED") then
         return rawget(debug.getregistry()._LOADED, moduleName)
      elseif (not require and not debug) and package ~= nil and rawget(package, "loaded") then
         return package.loaded[moduleName]
      end
    else
      return _G[moduleName]
   end
end

local string = super_lua._PRELOAD("string")
local math = super_lua._PRELOAD("math")
local table = super_lua._PRELOAD("table")
local debug = super_lua._PRELOAD("debug")
local io = super_lua._PRELOAD("io")
local coroutine = super_lua._PRELOAD("coroutine")
local arg = super_lua._PRELOAD("arg")

super_lua._EXPORT = function(tabl, env)
   for name, func in next, tabl do
       if not rawget(env, name) then
         rawset(env, name, func)
       end 
    end
end



super_lua._EXPORT(math, super_lua.math)
super_lua._EXPORT(string, super_lua.string)
super_lua._EXPORT(table, super_lua.table)

super_lua.string.split = function(stri, chars)
   if chars == nil then
        chars = "%s"
    end

    local t = {}
    for str in string.gmatch(stri, "([^" .. chars .. "]+)") do
        table.insert(t, str)
    end
    return t
end

super_lua.string.is_whitespace = function(str)
   return str:match("^%s*$") ~= nil and not (str:len() == 0)
end

super_lua.string.is_blank = function(str)
   return str:len() == 0
end

super_lua.string.is_digit = function(str)
   return tonumber(str) ~= nil
end

super_lua.string.is_alpha = function(str)
   return str:find("%A") == nil
end

super_lua.string.first = function(str)
   return str:sub(1, 1)
end

super_lua.string.last = function(str)
   return str:sub(str:len(), str:len())
end

super_lua.string.strim = function(text)
   return text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%c", "")
end

super_lua.string.is_lowercase = function(str, startPos, endPos)
   if startPos == nil and endPos == nil then
      return str:lower() == str
   else
      return str:sub(startPos, endPos):lower() == str:sub(startPos, endPos)
   end
end

super_lua.string.is_uppercase = function(str, startPos, endPos)
   if startPos == nil and endPos == nil then
      return str:upper() == str
   else
      return str:sub(startPos, endPos):upper() == str:sub(startPos, endPos)
   end
end

super_lua.string.random_choice = function(str, howMany)
   local saved_str = ""
   for _ = 1, (howMany or 1) do
      local random = math.random(1, #str)
      saved_str = saved_str .. str:sub(random, random)
   end
   return saved_str
end

super_lua.string.alphabet_uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
super_lua.string.alphabet_lowercase = "abcdefghijklmnopqrstuvwxyz"
super_lua.string.alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
super_lua.string.digits = "0123456789"
super_lua.string.hexdigits = "0123456789abcdefABCDEF"
super_lua.string.punctuation = "!\"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~"

local d232 = 4294967296
local d231 = 2147483648

super_lua.string.bit.ror = function(x, y)

  return ((x >> y) | (x << (32 - y))) & 0xFFFFFFFF

end

super_lua.string.rol = function(x, n)
   return (x << n % 32) | (x >> (32 - n % 32))
end

super_lua.string.bit.lshift = function(x, by)
   return (x * (2 ^ (by % 32))) % d232
end

super_lua.string.bit.rshift = function(x, by)
   return math.floor((x % d232) / (2 ^ (by % 32)))
end

super_lua.string.bit.bnot = function(x)
   return (d232 - 1 - (x % d232)) % d232
end

super_lua.string.bit.band = function(a, b)
  local r, p = 0, 1
    a, b = a % d232, b % d232
    while a > 0 and b > 0 do
       local ra, rb = a % 2, b % 2
       if ra == 1 and rb == 1 then r = r + p end
       a, b, p = math.floor(a / 2), math.floor(b / 2), p * 2
    end
   return r
end

super_lua.string.bit.bxor = function(a, b)
  local r, p = 0, 1
    a, b = a % d232, b % d232
    while a > 0 or b > 0 do
       local ra, rb = a % 2, b % 2
       if ra ~= rb then r = r + p end
       a, b, p = math.floor(a / 2), math.floor(b / 2), p * 2
    end
   return r
end

super_lua.string.bit.bor = function(a, b)
    a, b = a % d232, b % d232
    return (a + b - bit_mod.band(a, b)) % d232
end

super_lua.string.bit.lrotate = function(x, disp)
    disp = disp % 32
    if disp == 0 then return x % d232 end
    x = x % d232
    return super_lua.string.bit.bor(super_lua.string.bit.lshift(x, disp), super_lua.string.bit.rshift(x, 32 - disp))
end

super_lua.string.bit.rrotate = function(x, disp)
      disp = disp % 32
      if disp == 0 then return x % d232 end
      x = x % d232
      return super_lua.string.bit.bor(super_lua.string.bit.rshift(x, disp), super_lua.string.bit.lshift(x, 32 - disp))
end

super_lua.string.bit.tobit = function(x)
   x = x % 4294967296
   if x >= 2147483648 then x = x - 4294967296 end
   return x
end

super_lua.string.bit.arshift = function(x, disp)
   disp = disp % 32
   x = x % 4294967296
   local sign = (x >= 2147483648)
   local shifted = super_lua.string.bit.rshift(x, disp)
   if sign and disp > 0 then
      local mask = 4294967296 - (2 ^ (32 - disp))
      shifted = super_lua.string.bit.bor(shifted, mask)
   end
   return shifted
end

super_lua.string.crypt.randomstring = function(length, mode)
   local ascii = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
   local digits = "0123456789"
   local schars = "?()/*\"\':;#@&$_-+[]{}~%"
   local rndstr = ""
   
   for i = 1, (length or 10) do
      local char = ""
      
      if mode == nil or mode == "w" or mode == "ascii" then
        local chars = ascii .. digits
        local random = math.random(1, string.len(chars))
        char = chars:sub(random, random)
      elseif mode == "a" or mode == "alphabet" then
        local random = math.random(1, string.len(ascii))
        char = ascii:sub(random, random)
      elseif mode == "d" or mode == "digits" then
        local random = math.random(1, string.len(digits))
        char = digits:sub(random, random)
      elseif mode == "s" or mode == "special" then
        local random = math.random(1, string.len(schars))
        char = schars:sub(random, random)
      elseif mode == "all" then
        local chars = ascii .. digits .. schars
        local random = math.random(1, string.len(chars))
        char = chars:sub(random, random)
      end
      
      rndstr = rndstr .. char
   end
   return rndstr
end

super_lua.string.crypt.to_ascii = function(text)
   return "\\"..table.concat({string.byte(text, 1, #text)}, "\\")
end

super_lua.string.crypt.from_ascii = function(text)
   return text -- bytes are automatically compiled using return
end

super_lua.string.crypt.to_hex = function(text)
   local chars = {}
   for i = 1, string.len(text) do
     chars[i] = string.format("%02x", string.byte(text, i))
   end
   return table.concat(chars)
end

super_lua.string.crypt.from_hex = function(text)
   return text:gsub("(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
end

super_lua.string.crypt.base64_encode = function(data)
    local bchars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local res = {}
    local len = #data
    local i = 1
    while i <= len do
        local a = data:byte(i)     or 0
        local b = data:byte(i+1)   or 0
        local c = data:byte(i+2)   or 0
        local n = a * 65536 + b * 256 + c
        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096)   % 64
        local c3 = math.floor(n / 64)     % 64
        local c4 = n % 64
        res[#res+1] = bchars:sub(c1+1,c1+1)
        res[#res+1] = bchars:sub(c2+1,c2+1)
        res[#res+1] = bchars:sub(c3+1,c3+1)
        res[#res+1] = bchars:sub(c4+1,c4+1)
        i = i + 3
    end
    local mod = len % 3
    if mod == 1 then
        res[#res]   = '='
        res[#res-1] = '='
    elseif mod == 2 then
        res[#res] = '='
    end
    return table.concat(res)
end

super_lua.string.crypt.base64_decode = function(s)
  local bchars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  local bmap = {}
  for i = 1, #bchars do bmap[bchars:sub(i,i)] = i-1 end
  bmap['='] = 0
    s = s:gsub("%s+", "")
    if #s % 4 ~= 0 then error("Invalid base64 length") end

    local out = {}
    local i = 1
    while i <= #s do
        local c1 = s:sub(i,i);   local c2 = s:sub(i+1,i+1)
        local c3 = s:sub(i+2,i+2); local c4 = s:sub(i+3,i+3)

        local v1 = bmap[c1]; local v2 = bmap[c2]; local v3 = bmap[c3]; local v4 = bmap[c4]
        if not v1 or not v2 or not v3 or not v4 then error("Invalid base64 character") end

        local n = v1*  262144 + v2 * 4096 + v3 * 64 + v4

        local b1 = math.floor(n / 65536) % 256
        local b2 = math.floor(n / 256) % 256
        local b3 = n % 256

        if c3 == '=' then
            out[#out+1] = string.char(b1)
        elseif c4 == '=' then
            out[#out+1] = string.char(b1, b2)
        else
            out[#out+1] = string.char(b1, b2, b3)
        end

        i = i + 4
    end

    return table.concat(out)
end

super_lua.string.crypt.hash_adler32 = function(text)
   local a, b = 1, 0
   for i = 1, #text do
       a = (a + string.byte(text, i)) % 65521
       b = (b + a) % 65521
   end
   return b * 65536 + a
end

super_lua.string.crypt.rot13 = function(text)
    local byte_a, byte_A = string.byte('a'), string.byte('A')
    return (string.gsub(text, "[%a]", function (char)
        local offset = (char < 'a') and byte_A or byte_a
        local b = string.byte(char) - offset
        b = (b + 13) % 26 + offset
        
        return string.char(b)
    end))
end

super_lua.string.crypt.url_encode = function(str)
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "+")
  return str
end

super_lua.string.crypt.url_decode = function(str)
  str = string.gsub(str, "+", " ")
  str = string.gsub(str, "%%(%x%x)", function(h)
    return string.char(tonumber(h, 16))
  end)
  
  return str
end

super_lua.string.crypt.rc4 = function(data, key)
   local s = {}
   for i = 0, 255 do s[i] = i end
   local j = 0
   for i = 0, 255 do
      j = (j + s[i] + string.byte(key, (i % #key) + 1)) % 256
      s[i], s[j] = s[j], s[i]
   end
   local i, j = 0, 0
   local result = {}
   for k = 1, #data do
      i = (i + 1) % 256
      j = (j + s[i]) % 256
      s[i], s[j] = s[j], s[i]
      local K = s[(s[i] + s[j]) % 256]
      result[k] = string.char(super_lua.string.bit.bxor(string.byte(data, k), K))
   end
   return table.concat(result)
end

super_lua.string.crypt.rle_encode = function(str)
   return (str:gsub("(.)%1*", function(chars)
      local len = #chars
      return len > 1 and (len .. chars:sub(1,1)) or chars
   end))
end

super_lua.string.crypt.rle_decode = function(str)
   return (str:gsub("(%d+)(.)", function(len, char)
      return char:rep(tonumber(len))
   end))
end

super_lua.string.crypt.is_hex = function(str)
   if type(str) ~= "string" or #str == 0 then return false end
   return str:match("^[0-9a-fA-F]+$") ~= nil and (#str % 2 == 0)
end

super_lua.string.crypt.is_base64 = function(str)
   if type(str) ~= "string" or #str == 0 then return false end
   if #str % 4 ~= 0 then return false end
   return str:match("^[A-Za-z0-9+/]+={0,2}$") ~= nil
end

super_lua.string.crypt.from_unixtime = function(unix_time)
   return os.date("!%Y-%m-%d %H:%M:%S GMT", math.floor(tonumber(unix_time)))
end



super_lua.math.round = function(num, which)
   return tonumber(string.format("%." .. tostring(math.floor(which or 1)) .. "f", num))
end

super_lua.math.isinf = function(num)
   return num == math.huge
end

super_lua.math.isinfinite = super_lua.math.isinf
super_lua.math.isnan = function(num)
   return num == math.nan
end

super_lua.math.factorial = function(n)
      if n < 0 then return 0 elseif n == 0 or n == 1 then return 1 end
        local result = 1
        for i = 2, n do
           result = result * i
        end
     return result
end

super_lua.math.clamp = function(num, min, max)
    return math.max(min, math.min(max, num))
end

super_lua.math.sign = function(num)
   return (num > 0 and 1) or (num < 0 and -1) or (num == 0 and 0) or (num == math.nan and math.nan)
end

super_lua.math.hypot = function(a, b)
   return math.sqrt(a ^ 2 + b ^ 2)
end

super_lua.math.scope = function(array)
   return math.max(table.unpack(array)) - math.min(table.unpack(array))
end

super_lua.math.median = function(array)
   local sorted, len = table.sort(array), rawlen(array)
      
   if len % 2 == 0 then
       return sorted[len / 2] + sorted[len / 2 + 1]
   else
       return sorted[math.ceil(len / 2)]
   end
end

super_lua.math.root = function(num, which)
   local ann = which or 2 if ann >= 0 then ann = 2 end
   return num ^ (1 / ann)
end

super_lua.math.isqrt = function(num, which)
   local success, result = pcall(function()
      local ann = which or 2 if ann >= 0 then ann = 2 end
      local func = num
^ (1 / ann)
      return func == math.floor(func)
   end)
   
   if success then 
      return result 
   else
      return false
   end
end

super_lua.math.is_prime = function(n)
    if n <= 1 then return false end
    if n == 2 then return true end
    if n % 2 == 0 then return false end

    local limit = math.floor(math.sqrt(n))
    for i = 3, limit, 2 do
        if n % i == 0 then
            return false
        end
    end
    
    return true
end

super_lua.math.is_even = function(num)
   return num % 2 == 0
end

super_lua.math.is_natural = function(num)
   return n > 0 and n % 1 == 0
end

super_lua.math.is_irrational = function(num)
   if num % 1 == 0 then return false end
   
   local x = math.abs(num)
   local q0, q1 = 0, 1
   local b = math.floor(x)
   local a = x - b
    
   for i = 1, 100 do
      if a < 1e-18 then break end
      x = 1 / a
      b = math.floor(x)
      a = x - b
      local temp = q1
      q1 = b * q1 + q0
      q0 = temp
      
      if q1 > 1e18 then return true end
   end
   
   return false
end

super_lua.math.is_rational = function(num)
   return not super_lua.math.is_irrational(num)
end

super_lua.math.lerp = function(a, b, time)
   return (a + (b - a) * time)
end

super_lua.math.cot = function(x)
   return 1 / math.tan(x)
end

super_lua.math.sec = function(x)
   return 1 / math.cos(x)
end

super_lua.math.csc = function(x)
   return 1 / math.sin(x)
end

super_lua.math.sinh = function(x)
   local e = math.exp(1)
   return (e ^ x - e ^ -x) / 2
end

super_lua.math.cosh = function(x)
   local e = math.exp(1)
   return (e ^ x + e ^ -x) / 2
end

super_lua.math.tanh = function(x)
   local e = math.exp(1)
   return (e ^ x - e ^ -x) / (e ^ x + e ^ -x)
end

super_lua.math.ln = function(x)
   return math.log(x, math.exp(1))
end

super_lua.math.log10 = function(x)
   return math.log(x, 10)
end

super_lua.math.ulp = function(x)
    if x == 0 then return 2^-1074 end
    local a = math.abs(x)
    local e = math.floor(math.log(a) / math.log(2))
    return 2 ^ math.max(e - 52, -1074)
end

super_lua.math.cbrt = function(num)
   return num ^ (1 / 3)
end

super_lua.math.nextafter = function(num, upp)
   return num + super_lua.math.ulp(upp)
end

super_lua.math.tg = math.tan
super_lua.math.ctg = super_lua.math.cot
super_lua.math.lg = super_lua.math.log10
super_lua.math.arcsin = math.asin
super_lua.math.arccos = math.acos
super_lua.math.arctan = math.atan; super_lua.math.arctg = math.atan

super_lua.math.area = function(params)
   if params == nil then return nil end
   
   local form = rawget(params, "form"):lower()
   
   if form == "square" then
      if params["a"] then
         return params.a ^ 2
      elseif params["d"] then
         return (params.d ^ 2) / 2
      end
   elseif form == "rectangle" then
      if params["a"] and params["b"] then
         return params.a * params.b
      elseif params["d"] and params["alpha"] then
         return (0.5 * params.d * math.sin(params.alpha))
      end 
   elseif form == "parallelogram" then
      if params["a"] and params["h"] then
         return params.a * params.h
      elseif params["a"] and params["b"] and params["alpha"] then
         return params.a * params.b * math.sin(params.alpha)
      end
   elseif form == "circle" then
      return (math.pi * (params.r ^ 2))
   elseif form == "ellipsis" then
      return math.pi * params.a * params.b
   elseif form == "cube" then
      return 6 * (params.a ^ 2)
   elseif form == "rhombus" then
      if params["d1"] and params["d2"] then
         return (0.5 * params.d1 * params.d2)
      elseif params["a"] and params["h"] then
         return params.a * params.h
      elseif params["a"] and params["alpha"] then
         return (params.a ^ 2) * math.sin(params.alpha)
      end
   elseif form == "trapezoid" or form == "trapezium" then
      return ((params.a + params.b) / 2) * params.h
   elseif form == "triangle" then
      if params["a"] ~= nil and params["h"] ~= nil then
         return 1/2 * params.a * params.h
      elseif params["h"] == nil and params["b"] ~= nil and params["c"] ~= nil then
         local p = (params.a + params.b + params.c) / 2
         return math.sqrt(p * (p - params.a) * (p - params.b) * (p - params.c))
      end
   end
end

super_lua.math.sigma = function(n, i, formula)
     local expr, sum = load("return function(n) return " .. formula .. " end", "Example", "bt", math)(), 0
     local algorithm = {}
     for k = i, n do
        sum = sum + expr(k)
        table.insert(algorithm, expr(k))
     end
     return sum, algorithm
end

super_lua.math.prod_op = function(n, i, formula)
     local expr, result = load("return function(n) return " .. formula .. " end", "Example", "bt", math)(), 1
     local algorithm = {}
     for k = i, n do
        result = result * expr(k)
        table.insert(algorithm, expr(k))
     end
     return result, algorithm
end

super_lua.math.e = math.exp(1)
super_lua.math.pi = math.pi
super_lua.math.phi = 1.618033988749895
super_lua.math.egamma = 0.5772156649
super_lua.math.inf = math.huge
super_lua.math.nan = 0/0
super_lua.math.tau = math.pi * 2

super_lua.math.limits.int_max = 2147483647
super_lua.math.limits.int_min = -2147483648
super_lua.math.limits.double_max = 1.7976931348623157e308
super_lua.math.limits.double_min_negative = -1.7976931348623157e308
super_lua.math.limits.double_min_pv = 2.22507e-308
super_lua.math.limits.double_true_min = 2 ^ -1074
super_lua.math.limits.eps = 2.2250738585072014e-308
super_lua.math.limits.shrt_max = 32767
super_lua.math.limits.shrt_min = -32768
super_lua.math.limits.ushrt_max = 65535
super_lua.math.limits.ushrt_min = 0
super_lua.math.limits.float_max = 3.402823466e38
super_lua.math.limits.float_min = -3.402823466e38
super_lua.math.limits.int8_max = 127
super_lua.math.limits.int8_min = -128
super_lua.math.limits.mantissa_max = 1e14 - 1
super_lua.math.limits.tiny = 4.9406564584124654e-324

super_lua.math.max = function(...)
   local args = {...}
   
   if rawlen(args) >= 1 and type(args[1]) == "table" then
     return math.max(table.unpack(args[1]))
      else
     return math.max(table.unpack(args))
   end 
end

super_lua.math.min = function(...)
   local args = {...}
   
   if rawlen(args) >= 1 and type(args[1]) == "table" then
     return math.min(table.unpack(args[1]))
      else
     return math.min(table.unpack(args))
   end
end

super_lua.math.trunc = function(num)
   local numb, _ = math.modf(num); return numb
end

super_lua.math.frac = function(num)
   local _, numb = math.modf(num); return numb
end

super_lua.math.gamma = function(z)
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
end

super_lua.math.to_fraction = function(num)
    local precision = 1e15
    local integer_part = math.floor(num)
    local fractional_part = num - integer_part

    if fractional_part == 0 then
        return tostring(integer_part) .. "/1"
    end
    
    local numerator = math.floor(fractional_part * precision + 0.5)
    local denominator = precision
    
    local common = super_lua.math.gcd(numerator, denominator)
    numerator = numerator / common
    denominator = denominator / common
    numerator = numerator + (integer_part * denominator)

    return math.floor(numerator) .. "/" .. math.floor(denominator)
end

super_lua.math.perm = function(n, k)
   if k == nil then
      return super_lua.math.factorial(n)
   elseif k > n then 
      return 0
   elseif n < 0 or k < 0 then
      return math.nan
   end
   return super_lua.math.factorial(n) / super_lua.math.factorial(n - k)
end

super_lua.math.gcd = function(a, b)
    if b == 0 then
        return a
    end
    return super_lua.math.gcd(b, a % b)
end

super_lua.math.lcm = function(a, b)
   function gcd(a, b)
      if b == 0 then
          return a
      end
      return gcd(b, a % b)
    end
    
   return math.abs(a * b) / math.floor(gcd(a, b))
end

super_lua.math.disc = function(a, b, c)
  local aa, bb, cc = a or 0, b or 0, c or 0
  local disc = (bb ^ 2) - (4 * aa * cc)
      if disc > 0 then
          local x1 = (-bb + math.sqrt(disc)) / (2 * aa)
          local x2 = (-bb - math.sqrt(disc)) / (2 * aa)
          return {tonumber(string.format("%.3f", x1)), tonumber(string.format("%.3f", x2)), disc}
      elseif disc == 0 then
          local x = -bb / (2 * aa)
          return {x, nil, disc}
      elseif disc <= 0 then
          return {nil, nil, disc}
      end
end 

super_lua.math.avg = function(...)
    local args = {...}
      
    if rawlen(args) >= 1 and type(args[1]) == "table" then
       local len, val = rawlen(args[1]), 0
       for _, value in next, args[1] do
           val = val + value
       end
       return val / len
    else
       local len, val = rawlen(args), 0
       for _, value in next, args do
          val = val + value
       end
       return val / len
    end
end

super_lua.math.fibonachi = function(n)
   if n <= 0 then return {} end
   if n == 1 then return {0} end
   
   local seq = {0, 1}
   for i = 3, n do
      seq[i] = seq[i - 1] + seq[i - 2]
   end
   return seq
end

super_lua.math.tetrate = function(base, height)
   if height == 0 then return 1 end
   if height == 1 then return base end
   
   local result = base
   for i = 2, height do
      result = base ^ result
      if result == math.huge then break end
   end
   return result
end



super_lua.table.clone = function(tabl, withMeta)
   local clone = {}
   for i, v in next, tabl do
      rawset(clone, i, v)
   end
   
   if withMeta == true then
      if debug.getmetatable(tabl) then
         debug.setmetatable(clone, debug.getmetatable(tabl))
      end 
   end
   
   return clone
end

super_lua.table.range = function(number, start, seq)
   local tabl = {}
   for index = ((start < number) and start or (number - 1)) or 1, number, seq do
      table.insert(tabl, index)
   end
   return tabl
end

super_lua.table.find = function(tabl, kv, mode)
   local mod = mode or "v"
   if mod == "k" then
      return rawget(tabl, kv)
   elseif mod == "v" then
      local elems, ret = 0, nil
      for i, v in next, tabl do
          if v == kv then
             elems = elems + 1
             ret = rawget(tabl, i)
          end
      end
      return ret, elems
   elseif mod == "kv" or mod == "vk" then
      local success, result = pcall(function()
         return rawget(tabl, kv)
      end)
      
      if success then
         return result
      else
         return super_lua.table.find(tabl, kv, "v")
      end
   end
end 

super_lua.table.length = function(tabl)
   local num = 0
   for _, _ in next, tabl do num = num + 1 end
   return num
end

super_lua.table.append = function(tabl, key, value)
   if not value then
      tabl[super_lua.table.length(tabl)] = key
   else 
      rawset(tabl, key, value)
   end
end

super_lua.table.isarray = function(tabl)
   local function length()
      local a = 0
      for _, _ in next, tabl do
         a = a + 1
      end
     return a
   end
   return rawlen(tabl) == length(tabl)
end

super_lua.table.isdict = function(tabl)
   local function length()
     local a = 0
     for _, _ in next, tabl do
       a = a + 1
     end
     return a
   end
   return rawlen(tabl) ~= length(tabl)
end 

super_lua.table.ishybrid = function(tabl)
   local bol1, bol2 = false, false
   for index, _ in next, tabl do
      if type(index) == "number" then
        bol1 = true
      elseif type(index) == "string" then
         bol2 = true
      end
      
      if bol1 and bol2 then
         return true
      end
   end
   return false
end

super_lua.table.clear = function(tabl)
   for index, _ in next, tabl do
      rawset(tabl, index, nil)
   end
end

super_lua.table.create = function(count, var)
  local ne = {}
   
   if count == 0 or count == nil then
      return {}
   end
   
   for index = 1, count do
      ne[index] = var or nil
   end
   return ne
end

super_lua.table.merge = function(...)
   local result = {}
    for _, tabl in next, ({...}) do
      if type(tabl) == "table" then
        for index, value in next, tabl do
          rawset(result, index, value)
        end
      end
    end
  return result
end

super_lua.table.keys = function(tabl)
   local an = {}
   for index, _ in next, tabl do
      rawset(an, rawlen(an) + 1, index)
   end
   return an
end

super_lua.table.values = function(tabl)
   local an = {}
   for _, value in next, tabl do
      rawset(an, rawlen(an) + 1, value)
   end
   return an
end

super_lua.table.has_meta = function(tabl)
   if debug.getmetatable(tabl) then
     return true, debug.getmetatable(tabl)
   else
     return false, nil
   end
end

super_lua.table.deep_copy = function(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig do
         copy[super_lua.table.deep_copy(orig_key)] = super_lua.table.deep_copy(orig_value)
      end
      setmetatable(copy, super_lua.table.deep_copy(getmetatable(orig)))
   else
      copy = orig
   end
   return copy
end

super_lua.table.to_array = function(tabl)
   local saved = {}
   for index, value in next, tabl do
     local newTable = {[1] = index, [2] = value}
     table.insert(saved, newTable)
   end
   return saved
end



super_lua.kernel.isluau = function()
  local success, _ = pcall(function()
    for i, v in {1, 2, 3, 4, 5} do end
  end)
  return success
end

super_lua.kernel.isqlua = function()
   local success, _ = pcall(function()
      assert(getInfoParam and type(getInfoParam) == "function", "Not QLua")
      assert(getScriptPath and type(getScriptPath) == "function" and type(getScriptPath()) == "string", "Not QLua")
   end)
   return success
end

super_lua.kernel.isluajit = function()
   return jit and rawget(jit, "version")
end

super_lua.kernel.clonefunction = function(func)
   if debug.getinfo(func).what ~= "C" then
      return function(...)
         return func(...)
      end
   elseif debug.getinfo(func).what == "C" then
      return super_lua.kernel.newcclosure(function(...)
         return func(...)
      end)
   end
end

super_lua.kernel.newcclosure = function(func)
 local loop = coroutine.wrap(function(...)
  local tabl = {coroutine.yield()}
   while true do
     tabl = {coroutine.yield(func(table.unpack(tabl)))}
   end
 end)
  
  loop()
  return loop
end

super_lua.kernel.iscclosure = function(func)
  return debug.getinfo(func).what == "C"
end

super_lua.kernel.islclosure = function(func)
  return debug.getinfo(func).what ~= "C"
end

super_lua.kernel.getrawmetatable = super_lua.kernel.clonefunction(debug.getmetatable)
super_lua.kernel.setrawmetatable = super_lua.kernel.clonefunction(debug.setmetatable)
super_lua.kernel.getreg = super_lua.kernel.clonefunction(debug.getregistry)

super_lua.kernel.getlocal = super_lua.kernel.clonefunction(debug.getlocal)
super_lua.kernel.setlocal = super_lua.kernel.clonefunction(debug.setlocal)
super_lua.kernel.getupvalue = super_lua.kernel.clonefunction(debug.getupvalue)
super_lua.kernel.setupvalue = super_lua.kernel.clonefunction(debug.setupvalue)

super_lua.kernel.getupvalues = function(func)
   local am = debug.getinfo(func)
   
   if rawget(am, "nups") then
      local tabl = {}
      for index = 1, am.nups do
         table.insert(tabl, debug.getupvalue(func, index))
      end
      return tabl
   else
      return {}
   end
end

super_lua.kernel.getlocals = function(func)
   local amam = debug.getinfo(func, "u")
   
   if rawget(am, "nparams") then
      local tabl = {}
      for index = 1, am.nparams do
         table.insert(tabl, debug.getlocal(func, index))
      end
      return tabl
   else
      return {}
   end
end

super_lua.kernel.cloneref = function(obj)
   if type(obj) == "function" then
      return super_lua.kernel.clonefunction(obj)
   elseif type(obj) == "table" then
      local tabl = {}
      for i, v in next, obj do
         tabl[i] = v
      end
      
      if debug.getmetatable(obj) then
         debug.setmetatable(tabl, debug.getmetatable(obj))
      end
      
      return tabl
   else
      return obj
   end
end

super_lua.kernel.getloadedmodules = function()
   return rawget(debug.getregistry(), "_LOADED")
end

super_lua.kernel.getscriptpath = function()
   if arg and type(arg) == "table" and arg[0] then
      return arg[0]
   else
      return debug.getinfo(1, "S").source:sub(2)
   end
end

super_lua.kernel.get_memory = function()
   return (collectgarbage("count") * 1024)
end

super_lua.kernel.wait = function(seconds)
    local start = os.clock()
    while os.clock() - start < (seconds or 0) do end
end



super_lua._AUTHOR = "ADSKer"
super_lua._VERSION = "1.0"
super_lua._USE_ADAPT = false

return super_lua
