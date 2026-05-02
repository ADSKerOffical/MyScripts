getgenv().dir = newcclosure(function(obj)
  assert(obj ~= nil, "The object must not be equal to nil")
  if typeof(obj) == "Instance" then
    local infos = {
      ["full"] = obj:GetFullName(),
      ["attrs"] = obj:GetAttributes(),
      ["actor"] = obj:GetActor() or nil,
      ["properties"] = (function() local tabl = {}; for _, prop in next, game:GetService("ReflectionService"):GetPropertiesOfClass(obj.ClassName) do if pcall(function() return gethiddenproperty(obj, prop.Name) end) then tabl[prop.Name] = gethiddenproperty(obj, prop.Name) end end; return tabl end)(),
      ["methods"] = (function() local tabl = {}; for _, method in next, game:GetService("ReflectionService"):GetMethodsOfClass(obj.ClassName) do table.insert(tabl, method.Name) end; return tabl end)(),
      ["signals"] = (function() local tabl = {}; for _, method in next, game:GetService("ReflectionService"):GetEventsOfClass(obj.ClassName) do table.insert(tabl, method.Name) end; return tabl end)(),
      ["is_hooked"] = (function() for _, func in next, getrawmetatable(obj) do if typeof(func) == "function" and (ishooked(func) or isfunctionhooked(func)) then return true end end return false end)(),
      ["metatable"] = getrawmetatable(obj),
      ["have_copy"] =  (function() local copies = {}
      for _, inst in next, getgc(true) do
         if typeof(inst) == "Instance" and obj:GetDebugId() == inst:GetDebugId() and obj ~= inst then
           table.insert(copies, inst)
         end
       end

        for _, inst in next, game:GetDescendants() do
          if obj:GetDebugId() == inst:GetDebugId() and obj ~= inst then
             table.insert(copies, inst)
           end
         end

         return (#copies > 0), copies
      end)(),
      ["replicated_signals"] = (function() local tabl = {}; for i, v in next, game:GetService("ReflectionService"):GetEventsOfClass(class.ClassName) do if cansignalreplicate(class[v.Name]) then table.insert(tabl, class[v.Name]) end end; return tabl end)(),
      ["copy"] = function() setclipboard(obj:GetFullName()) end
    }
    
    if obj:IsA("LuaSourceContainer") then
      infos["source"] = decompile(obj)
      infos["bytecode"] = (getscriptbytecode or dumpstring)(obj)
      infos["from_exploit"] = (function() for _, scr in getreg() do if typeof(scr) == "Instance" and scr:IsA("LuaSourceContainer") and compareinstances(scr, obj) then return true end end; return false end)()
      infos["hash"] = getscripthash(obj)
      infos["guid"] = gethiddenproperty(obj, "ScriptGuid")
    elseif obj:IsA("BasePart") then
      infos["is_network_owner"] = isnetworkowner(obj)
      infos["has_model"] = (obj:GetRootPart() ~= nil and obj:GetRootPart() or nil)
      if obj:IsA("MeshPart") then
      
      end
    elseif obj:IsA("Model") then
      
    end
    
    return infos
  elseif typeof(obj) == "table" then
    return {
      ["table_type"]
      ["has_metatable"]
      ["readonly"] = table.isfrozen(obj),
      ["is_weak"]
      ["size"]
      ["full_size"]
    }
  elseif typeof(obj) == "function" then
    return {
      ["name"] = debug.info(obj, "n"),
      ["closure"] = (debug.info(obj, "s") == "[C]" and "C" or debug.info(obj, "s") ~= "[C]" and "Lua"),
      ["script"] = (rawget(getfenv(obj), "script") ~= nil and rawget(getfenv(obj), "script") or "UNKNOWN"),
      ["func"] = debug.info(obj, "f"),
      ["currentLine"] = debug.info(obj, "l"),
      ["is_vararg"] = select(2, debug.info(obj, "a")),
      ["numparams"] = select(1, debug.info(obj, "a")),
      ["upvals"] = (function() return getupvalues(obj), #getupvalues(obj) end)(),
      ["consts"] = (function() return getconstants(obj), #getconstants(obj) end)(),
      ["protos"] = (function() return getprotos(obj), #getprotos(obj) end)(),
      ["is_executorF"] = isexecutorclosure(obj)
    }
  elseif typeof(obj) == "string" then
    return {
      ["ascii"] = ("\\"..table.concat({string.byte(input, 1, #input)}, "\\")),
      ["hex"] = (function() local hex = "" for i = 1, string.len(obj) do hex = hex .. string.format("%02x", string.byte(obj:sub(i, i))) end return hex end)(),
      ["base64"] = base64.encode(obj),
      ["link_format"] = game:GetService("HttpService"):UrlEncode(obj),
      ["binary"]
      ["from_ascii"] = loadstring("return \"".. text .. "\"")(),
      ["from_hex"] = obj:gsub("(%x%x)", function(h) return string.char(tonumber(h, 16)) end),
      ["from_base64"] = base64.encode(obj)
      ["from_binary"]
    }
  elseif typeof(obj) == "RBXScriptSignal" then
    return {
      ["is_replicated"] = cansignalreplicate(obj),
      ["params"] = getsignalarguments(obj)
    }
  elseif typeof(obj) == "RBXScriptConnection" then
    return {
      ["is_lua"] = obj.LuaConnection,
      ["enabled"] = obj.Enabled,
      ["func"] = obj.Function,
      ["script"] = getfenv(obj.Function).script
    }
  end
end)
