local rootkit = {}

rootkit.newcclosure = function(func)
 local loop = coroutine.wrap(function(...)
  local tabl = {coroutine.yield()}
   while true do
     tabl = {coroutine.yield(func(table.unpack(tabl)))}
   end
 end)
  
  loop()
  return loop
end

rootkit.newcclosure = rootkit.newcclosure(rootkit.newcclosure)
rootkit.iscclosure = rootkit.newcclosure(function(func)
  return debug.getinfo(func).what == "C"
end)

rootkit.islclosure = rootkit.newcclosure(function(func)
   return debug.getinfo(func).what ~= "C"
end)

rootkit.randomstring = rootkit.newcclosure(function(length, mode)
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
end)

rootkit.getreg = rootkit.newcclosure(function()
   return debug.getregistry()
end)

rootkit.clonefunction = rootkit.newcclosure(function(func)
   if rootkit.islclosure(func) then
      return function(...)
         return func(...)
      end
   elseif rootkit.iscclosure(func) then
      return rootkit.newcclosure(function(...)
         return func(...)
      end)
   end
end)

rootkit.cloneref = rootkit.newcclosure(function(obj)
   if type(obj) == "function" then
      return rootkit.clonefunction(obj)
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
end)

rootkit.getrawmetatable = debug.getmetatable

rootkit.getgenv = rootkit.newcclosure(function()
   return _G
end)

rootkit.setrawmetatable = debug.setmetatable
rootkit.loadstring = load
rootkit.delfile = os.remove

rootkit.writefile = rootkit.newcclosure(function(fileName, source)
   local file = io.open(fileName, "w")
   file:write(source)
   file:close()
end)

rootkit.readfile = rootkit.newcclosure(function(fileName)
   local file = io.open(fileName, "r")
   local src = file:read("*all")
   file:close()
   
   return src
end)

rootkit.appendfile = rootkit.newcclosure(function(fileName, source)
   local file = io.open(fileName, "a")
   file:write(source)
   file:close()
end)

rootkit.listfiles = rootkit.newcclosure(function(folder)
   local files = io.popen("ls -a " .. folder)
   local lines = files:lines()
   
   files:close()
end)

local function isexist(path)
   local scr = io.popen([[
   if [ -e ]] .. path .. [[ ]; then
     echo true
   fi
   ]])
   return (scr:read("*all"):gsub("\n", "") == "true" and true or false)
end

rootkit.execute = rootkit.newcclosure(function(script, language, ...)
   if language == nil or language:lower() == "lua" then
      if isexist(script) then
         return loadfile(script)()
      else
         return load(script)()
      end
   elseif language:lower() == "shell" or language:lower() == "sh" then
      local _, result = pcall(function()
        local ex = io.popen(script)
        local output = ex:read("*all"):gsub("\n$", "")
        local exitCode = ex:close()
        return output
      end)
      
      return result
   elseif language:lower() == "python" or language:lower() == "py" then
      if isexist(script) then
         local _, result = pcall(function()
            return io.popen('python3 ' .. script, "r"):read("*a"):gsub("\n$", "")
         end)
         return result
      else
         local random = rootkit.randomstring(15) .. ".py"
         local file = io.open(random, "w")
         file:write(script)
      
         local _, result = pcall(function()
           return io.popen("python3 " .. random, "r"):read("*a")
         end)
      
         os.remove(random)
         return result
      end
   elseif language:lower() == "cpp" or language:lower() == "c++" then
   if isexist(script) then
      local randomName = rootkit.randomstring(10, "a")
      local stdout = io.popen("g++ " .. script .. " -o " .. randomName  .. " && ./" .. randomName)
      os.remove(randomName)
      return stdout:read("*a"):gsub("\n$", "")
   else
     local random = rootkit.randomstring(15, "a")
     local newFile = io.open(random .. ".cpp", "w")
     newFile:write(script)

     local result = io.popen("g++ " .. random .. ".cpp -o " .. random .. " && ./" .. random)
     os.remove(random)
     newFile:close()
     return result:read("*a"):gsub("\n$", "")
   end
  elseif language:lower() == "c" then

  elseif language:lower() == "nodejs" or language:lower() == "node.js" or language:lower() == "njs" then
   end
end)

rootkit.makereadonly = rootkit.newcclosure(function(tabl)
   debug.setmetatable(tabl, {
     __index = tabl,
     __newindex = function() error("Attempt to modify read only table", 0) end,
     __metatable = "readonly"
   })
end)

rootkit.getloadedmodules = rootkit.newcclosure(function()
   return rawget(debug.getregistry(), "_LOADED")
end)

rootkit.isfile = rootkit.newcclosure(function(path)
   if type(path) == "string" then
     local success, _ = pcall(function()
         local test = io.open(path, "r")
         test:close()
      end)
      return success
   elseif type(path) == "userdata" then
      return (debug.getmetatable(path) and debug.getmetatable(path).__name == "FILE*")
   end
end)

rootkit.makefolder = rootkit.newcclosure(function(name)
   os.execute("mkdir " .. name)
end)

rootkit.delfolder = rootkit.newcclosure(function(path)
   os.execute("rm -rf " .. path)
end)

rootkit.isluau = rootkit.newcclosure(function()
   local success, _ = pcall(function() 
     for i, v in {1, 2, 3, 4, 5} do
       local b = v
     end
   end)
   return success
end)

rootkit.getinfo = rootkit.newcclosure(function(data, include_files)
   local info = {
      id = (type(data) ~= "string" and type(data) ~= "number") and tostring(data):match("0x%x+") or "unknown",
      type = type(data),
      is_global = (function() for _, v in next, _G do if v == data then return true end end return false end)()
   }
   
   if type(data) == "table" then
       info["has_meta"] = (function() return debug.getmetatable(data) ~= nil, debug.getmetatable(data) end)()
       info["length"] = (function() local num = 0 for _, _ in next, data do num = num + 1 end return num end)()
       info["table_type"] = (function() if rawlen(data) == info["length"] then return "array" elseif rawlen(data) ~= info["length"] then return "dict" else return "hybrid" end end)()
       info["is_module"] = (function() for i, v in next, rootkit.getreg()._LOADED do if v == data then return true, i end end return false end)()
   elseif type(data) == "function" then
      for index, value in next, debug.getinfo(data) do
         rawset(info, index, value)
      end
   elseif type(data) == "number" then
      info["number_type"] = math.type(data)
   elseif type(data) == "string" then
      if include_files == nil or (include_files == false and not rootkit.isfile(data)) then
         info["length"] = data:len()
         info["is_namespace"] = (data:match("^%s*$") ~= nil)
         info["is_blank"] = (data:len() == 0)
         info["z_chars"] = string.find(data, "%z") 
         info["is_digit"] = tonumber(data) ~= nil
      elseif include_files == true and rootkit.isfile(data) then
         info["file_size"] = (function() local file = io.open(data, "r") local source = string.len(file:read("*a")) file:close() return source end)()
         info["owner"] = (function() local file = io.popen("stat -c %U " .. data) local source = file:read("*a"):gsub("\n$", "") file:close() return source end)()
         info["perms"] = (function() local file = io.popen("stat -c %a " .. data) local source= file:read("*a"):gsub("\n$", "") file:close() return source end)()
         info["inode"] = (function() local file = io.popen("stat -c %i " .. data) local source = file:read("*a"):gsub("\n$", "") file:close() return source end)()
         info["format"] = (function() local file = io.popen("file -b " .. data) local source = file:read("*a"):gsub("\n$", "") file:close() return source end)()
      end
   end
   
   return info
end)

rootkit.setclipboard = rootkit.newcclosure(function(text)
   coroutine.wrap(function()
   if rootkit.execute("command -v termux-clipboard-set", "shell"):gsub("\n$", "") ~= "" then
      local randomName = rootkit.randomstring(20) .. ".txt"
      local newFile = io.open(randomName, "w")
      newFile:write(text)
      
      rootkit.execute("termux-clipboard-set \"$(cat " .. randomName .. ")\"", "shell")
      newFile:close()
      os.remove(randomName)
      return 0
    elseif rootkit.execute("command -v xclip"):gsub("\n$", "") ~= "" then
      local randomName = rootkit.randomstring(20) .. ".txt"
      local newFile = io.open(randomName, "w")
      newFile:write(text)
      
      rootkit.execute("xclip -selection c < " .. randomName, "shell")
      newFile:close()
      os.remove(randomName)
      return 0
   elseif rootkit.execute("command -v clip", "shell"):gsub("\n$", "") ~= "" then
      local randomName = rootkit.randomstring(20) .. ".txt"
      local newFile = io.open(randomName, "w")
      newFile:write(text)
      
      rootkit.execute("clip " .. randomName, "shell")
      newFile:close()
      os.remove(randomName)
      return 0
   elseif rootkit.execute("command -v pbcopy", "shell"):gsub("\n$", "") ~= "" then
      local randomName = rootkit.randomstring(20) .. ".txt"
      local newFile = io.open(randomName, "w")
      newFile:write(text)
      
      rootkit.execute("cat " .. randomName .. " | pbcopy", "shell")
      newFile:close()
      os.remove(randomName)
      return 0
   end
   end)()
end)

rootkit.getclipboard = rootkit.newcclosure(function()
   if rootkit.execute("command -v termux-clipboard-get", "shell"):gsub("\n$", "") ~= "" then
     return rootkit.execute("termux-clipboard-get", "shell"):gsub("\n$", "")
   elseif rootkit.execute("command -v xclip", "shell"):gsub("\n$", "") ~= "" then
      return rootkit.execute("xclip -o | xclip -selection clipboard -i", "shell"):gsub("\n$", "")
   elseif rootkit.execute("command -v pbpaste", "shell"):gsub("\n$", "") ~= "" then
      return rootkit.execute("echo \"$(pbpaste | cat)\"", "shell"):gsub("\n$", "")
   end
end)

rootkit.request = rootkit.newcclosure(function(options)
   local randomName = randomstring(15) .. ".py"
   local file = io.open(randomName, "w")
   local url, method = options.Url, options.Method
   
   file:write([[
import urllib.request, json
req = urllib.request.Request("]] .. url .. [[", method="]] .. method .. [[")
with urllib.request.urlopen("]] .. url .. [[") as response:
   totalInfo = {
     "body": response.read().decode("utf-8"),
     "headers": response.getheaders(),
     "status_code": response.status
   }
   print(json.dumps(totalInfo))
   ]])
   
   local _, result = pcall(function()
      return io.popen("python3 " .. randomName, "r"):read("*a")
   end)
   
   file:close()
   os.remove(randomName)
   return result
end)

rootkit.getupvalue = debug.getupvalue
rootkit.setupvalue = debug.setupvalue
rootkit.getlocal = debug.getlocal
rootkit.setlocal = debug.setlocal

rootkit.getlocals = rootkit.newcclosure(function(func)
   assert(type(func) == "function" or type(func) == "number", "Argument #1 must be function or number type but got " .. type(func))
   
   local locs = {}
   
   for index = 1, 255 do
      local success, result = pcall(function()
         return debug.getlocal(func, index)
      end)
      
      if success then
         rawset(locs, index, result)
      else
         print(result)
         break
      end
   end
   return locs
end)

rootkit.getupvalues = rootkit.newcclosure(function(func)
   assert(type(func) == "function" or type(func) == "number", "Argument #1 must be function or number type but got " .. type(func))
   
   local ups = {}
   
   for index = 1, 255 do
      local success, result = pcall(function()
         return debug.getupvalue(func, index)
      end)
      
      if success then
        rawset(ups, index, result)
      else
         break
      end
   end
   return ups
end)



rootkit._EXPORT = rootkit.newcclosure(function(tabl, env)
   for name, func in next, (tabl or rootkit) do
       if not rawget(env, name) then
         rawset(env, name, func)
       end 
    end
end)

rootkit._SAVE = rootkit.newcclosure(function(tabl, name)
   rawset(debug.getregistry()._LOADED, name, tabl)
end)

rootkit._REMOVE = rootkit.newcclosure(function(tabl_or_name)
   for index, value in next, debug.getregistry()._LOADED do
      if index == tabl_or_name or value == tabl_or_name then
         rawset(debug.getregistry()._LOADED, index, nil)
      end
   end
end)

rootkit.getcallingscript = rootkit.newcclosure(function()
   return debug.getinfo(1, "S").source:sub(2)
end)

local _, caller = pcall(function()
   return debug.getinfo(1, "S").source:sub(2), rootkit.getcallingscript()
end)

rootkit.checkcaller = rootkit.newcclosure(function()
   local c1, c2 = caller
   return (debug.getinfo(1, "S").source:sub(2) == c1) or (rootkit.getcallingscript() == c2)
end)

rootkit.myself = rootkit.newcclosure(function()
   local device = {}
   
   if not rootkit.checkcaller() then
      error("Access denied", 0)
   end 
   
   local indexx = {
      ["_USER"] = rootkit.execute("whoami", "shell"):gsub("\n$", ""),
      ["_VERSION"] = rootkit.execute("getprop ro.build.id", "shell"):gsub("\n$", ""),
      ["_OS"] = rootkit.execute("uname -so", "shell"):gsub("\n$", ""),
      ["_ARCH"] = rootkit.execute("uname -m", "shell"):gsub("\n$", ""),
      ["_LANG"] = rootkit.execute("getprop ro.product.locale.region", "shell"):gsub("\n$", ""),
      ["_BIT_DEPTH"] = rootkit.execute("getconf LONG_BIT", "shell"):gsub("\n$", ""),
      ["_CORES"] = rootkit.execute("getconf _NPROCESSORS_CONF", "shell"):gsub("\n$", ""),
      ["_CPU_ABILIST"] = rootkit.execute("getprop ro.vendor.product.cpu.abilist", "shell"):gsub("\n$", "")
   }
   
   debug.setmetatable(device, {
   	__index = indexx,
      __metatable = "locked"
   })
   return device
end)

rootkit.version = "1.0"
rootkit.author = "ADSKer"
rootkit._USE_ADAPT = false



rootkit._GLOT = {}
rootkit._GLOT.table = {}
rootkit._GLOT.string = {}
rootkit._GLOT.math = {}

rootkit._EXPORT(string, rootkit._GLOT.string)
rootkit._GLOT.string.split = rootkit.newcclosure(function(stri, chars)
   if chars == nil then
        chars = "%s"
    end

    local t = {}
    for str in string.gmatch(stri, "([^" .. chars .. "]+)") do
        table.insert(t, str)
    end
    return t
end)

rootkit._GLOT.string.is_blank = rootkit.newcclosure(function(str)
   return str:len() == 0
end)

rootkit._GLOT.string.is_namespace = rootkit.newcclosure(function(str)
   return str:match("^%s*$") ~= nil and not (str:len() == 0)
end)

rootkit._GLOT.string.is_digits = rootkit.newcclosure(function(str)
   return tonumber(str) ~= nil
end)

rootkit._GLOT.string.charAt = rootkit.newcclosure(function(str, pos)
   return str:sub(pos, pos)
end)

rootkit._GLOT.string.first = rootkit.newcclosure(function(str)
   return str:sub(1, 1)
end)

rootkit._GLOT.string.last = rootkit.newcclosure(function(str)
   return str:sub(str:len(), str:len())
end)

rootkit._GLOT.string.bytes = rootkit.newcclosure(function(str, mode)
   if mode == nil or mode == "e" or mode == "encode" then
      return "\\"..table.concat({string.byte(str, 1, #str)}, "\\")
   elseif mode == "d" or mode == "decrypt" then
      return str
   end
end)

rootkit._EXPORT(math, rootkit._GLOT.math)
rootkit._GLOT.math.clamp = rootkit.newcclosure(function(num, min, max)
   return math.max(min, math.min(max, num))
end)

rootkit._GLOT.math.sign = rootkit.newcclosure(function(num)
   return (num > 0 and 1) or (num < 0 and -1) or (num == 0 and 0) or (num == math.nan and math.nan)
end)

rootkit._GLOT.math.e = rootkit.newcclosure(function()
   return math.exp(1)
end)

rootkit._GLOT.math.sqrt = rootkit.newcclosure(function(num, which)
   local ann = which or 2 if ann >= 0 then ann = 2 end
   return num ^ (1 / which)
end)

rootkit._GLOT.math.isqrt = rootkit.newcclosure(function(num, which)
   local ann = which or 2 if ann >= 0 then ann = 2 end
   local func = rootkit._GLOT.math.sqrt
   return func(num, ann) == math.floor(func(num, ann))
end)

rootkit._GLOT.math.from_exp = rootkit.newcclosure(function(num)
   return string.format("%.2f", num)
end)

rootkit._GLOT.math.to_exp = rootkit.newcclosure(function(num)
   return string.format("%.5e", num)
end)

rootkit._GLOT.math.to_hex = rootkit.newcclosure(function(num)
   return string.format("0x%x", num)
end)

rootkit._GLOT.math.calc = rootkit.newcclosure(function(str_example)
   return load("return " .. tostring(str_example), "Example", "bt", {})()
end)

rootkit._GLOT.math.round = rootkit.newcclosure(function(num, which)
   return tonumber(string.format("%." .. tostring(math.round(which or 1)) .. "f", num))
end)

rootkit._GLOT.math.factorial = rootkit.newcclosure(function(n)
    if n < 0 then return 0 end
    local result = 1
    for i = 2, n do
        result = result * i
    end
    return result
end)

rootkit._GLOT.math.disc = rootkit.newcclosure(function(a, b, c)
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
end)

rootkit._GLOT.math.avg = rootkit.newcclosure(function(array_nums)
   local len = rawlen(array_nums)
   local value = 0
      for _, number in next, array_nums do
         value = value + number
      end
      return value / len
end)

rootkit._EXPORT(table, rootkit._GLOT.table)
rootkit._GLOT.table.clone = rootkit.newcclosure(function(tabl)
   local clone = {}
   for i, v in next, tabl do
      rawset(clone, i, v)
   end
   return clone
end)

rootkit._GLOT.table.find = rootkit.newcclosure(function(tabl, kv, mode)
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
         return table.find(tabl, kv, "v")
      end
   end
end)

rootkit._GLOT.table.length = rootkit.newcclosure(function(tabl)
   local num = 0
   for _, _ in next, tabl do num = num + 1 end
   return num
end)

rootkit._GLOT.table.append = rootkit.newcclosure(function(tabl, key, value)
   rawset(tabl, key, value)
end)

rootkit._GLOT.table.isarray = rootkit.newcclosure(function(tabl)
   local function length()
      local a = 0
      for _, _ in next, tabl do
         a = a + 1
      end
     return a
   end
   return rawlen(tabl) == length(tabl)
end)

rootkit._GLOT.table.isdict = rootkit.newcclosure(function(tabl)
   local function length()
     local a = 0
     for _, _ in next, tabl do
       a = a + 1
     end
     return a
   end
   return rawlen(tabl) ~= length(tabl)
end)

rootkit._GLOT.table.ishybrid= rootkit.newcclosure(function(tabl)
  return (not rootkit._GLOT.table.isdict(tabl) and #tabl ~= rootkit._GLOT.table.length(tabl))
end)

rootkit._GLOT.table.clear = rootkit.newcclosure(function(tabl)
   for index, _ in next, tabl do
      rawset(tabl, index, nil)
   end
end)

rootkit._GLOT.table.maxn = rawlen
rootkit._GLOT.table.create = rootkit.newcclosure(function(count, var)
   local ne = {}
   
   if count == 0 or count == nil then
      return {}
   end
   
   for index = 1, count do
      ne[index] = var or nil
   end
   return ne
end)

rootkit._GLOT.table.merge = rootkit.newcclosure(function(...)
  local result = {}
    for _, tabl in next, ({...}) do
      if type(tabl) == "table" then
        for index, value in next, tabl do
          rawset(result, index, value)
        end
      end
    end
  return result
end)

rootkit._GLOT.table.keys = rootkit.newcclosure(function(tabl)
   local an = {}
   for index, _ in next, tabl do
      rawset(an, rawlen(an) + 1, index)
   end
   return an
end)

rootkit._GLOT.table.values = rootkit.newcclosure(function(tabl)
   local an = {}
   for _, value in next, tabl do
      rawset(an, rawlen(an) + 1, value)
   end
   return an
end)

rootkit._GLOT.math.scope = rootkit.newcclosure(function(array_nums)
   return math.max(table.unpack(array_nums)) - math.min(table.unpack(array_nums))
end)



local hiddenTable = {}
local CC = rootkit.clonefunction(rootkit.checkcaller)

debug.setmetatable(hiddenTable, {
	__len = function() error("Access denied", 0) end,
	__iter = function(ht)
	  if CC() == true then
	     return ht
	  else
	    error("Access denied", 0)
	  end
	end,
	__metatable = "hidden",
	__tostring = function() return tostring({}) end,
	__concat = function() return "" end
})

rootkit._SHADOW = rootkit.newcclosure(function(key, value)
   if value == "*_GET_VALUE_" then
      return hiddenTable
   end
   rawset(hiddenTable, key, value)
end)

debug.setmetatable(rootkit, {
	__index = function(rk, key)
	   if rawget(rootkit, "_USE_ADAPT") == true and rawget(rk, key:lower()) ~= nil and not (key:sub(1, 1) == "_" and not key:lower() == "_glot") then
         return rawget(rootkit, key:lower())
       else
         return rawget(rootkit, key)
       end
	end,
	__metatable = "dont change it"
})

-- rawset(package.loaded, "rootkit", rootkit)

--[[ Как использовать в терминале: 
   touch "rootkit.lua"
   echo "$(cat /sdcard/Download/luascr.lua)" > rootkit.lua
   
   lua -e 'local rootkit = require("rootkit")
   print(rootkit.isluau())
   ' # здесь покажет false
   
   *Примечание: вы не сможете использовать rootkit.execute если у вас нету доступа и не сможете использовать Python если у вас не скачан python (скачай через pkg install python)
]]--

return rootkit
