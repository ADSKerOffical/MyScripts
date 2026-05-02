game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
local tool = cloneref(Instance.new("Tool", game.Players.LocalPlayer.Backpack))
tool.Name = "Tool gun"
tool.RequiresHandle = false
tool.ToolTip = "Universal weapon for exploit makers"
tool.GripPos = Vector3.new(0, -0.45, 0.75)

local currentScript = getfenv(0).script
local toolmode = 1
local CanQueryBypass = false
local GuiMode = false

local hook; hook = hookmetamethod(workspace, "__newindex", newcclosure(function(self, index, value)
  if checkcaller() and CanQueryBypass == true and getfenv(0).script == currentScript and self:IsA("BasePart") and index == "CanQuery" then
    return true
  elseif not checkcaller() and self == tool then
    return nil
  end
  return hook(self, index, value)
end))

local STARTER_GUI = cloneref(game:GetService("StarterGui"))
local hook; hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
  if not checkcaller() and getfenv(0).script ~= currentScript and self == STARTER_GUI then
    local args = {...}
    if getnamecallmethod() == "SetCore" and #args > 0 and args[1] == "DevConsoleVisible" then
      return nil
    elseif getnamecallmethod() == "SetCoreGuiEnabled" and #args > 0 and args[1] == Enum.CoreGuiType.Backpack then
      return nil
    end
    elseif getfenv(0).script ~= currentScript and self.IsA(self, "Tool") and getnamecallmethod() == "Activate" then
    return nil
  end
  return hook(self, ...)
end))

local handle = cloneref(Instance.new("Part", tool))
handle.Name = "Handle"
handle.Massless = true
handle.Anchored = false

local mesh = cloneref(Instance.new("SpecialMesh", handle))
mesh.MeshId = "rbxassetid://4658783228"
mesh.TextureId = "rbxassetid://4658783257"
mesh.Scale = Vector3.new(0.15, 0.175, 0.2)

local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or cloneref(game.CoreGui))
ScreenGui.Enabled = false
ScreenGui.ResetOnSpawn = true

local Button = Instance.new("TextButton")
Button.Name = "Button"
Button.Size = UDim2.new(0.07, 0.07, 0.07, 7)
Button.Position = UDim2.new(0.86, 0, 0.4, 0)
Button.BackgroundColor3 = Color3.new(0.35, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.Text = "Switch mode"
Button.Parent = ScreenGui

local consob = Button:Clone()
consob.Parent = ScreenGui
consob.Position = UDim2.new(0.88, 0, 0.51, 0)
consob.Text = "Open console"
consob.Size = UDim2.new(0.05, 0.05, 0.05, 5)
consob.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

consob.MouseButton1Click:Connect(function()
  game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
end)

local extra = Instance.new("TextButton", ScreenGui)
extra.Text = "Print all"
extra.Position = UDim2.new(0.83, 0, 0.52, 0)
extra.Size = UDim2.new(0.04, 0.04, 0.04, 4)
extra.TextColor3 = Color3.new(1, 1, 1)
extra.TextScaled = true
extra.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

extra.MouseButton1Click:Connect(function()
  if toolmode == 1 then
for _, part in next, workspace:GetDescendants() do
  if part:IsA("BasePart") then
print(part.ClassName, part:GetFullName())
  end
end
  elseif toolmode == 2 then

  elseif toolmode == 3 then

  elseif toolmode == 4 then
for _, img in next, workspace:GetDescendants() do
  if img:IsA("Decal") or img:IsA("Texture") or img:IsA("ParticleEmitter") or img:IsA("Beam") then
print(img.ClassName, img.Texture)
  elseif img:IsA("ImageLabel") then
print(img.ClassName, img.Image)
  end
end
  elseif toolmode == 5 then
for _, mes in next, workspace:GetDescendants() do
  if mes:IsA("SpecialMesh") then
print(mes.ClassName, mes.TextureId)
 elseif mes:IsA("MeshPart") then
print(mes.ClassName, mes.TextureID)
  end
end
  elseif toolmode == 6 then
for _, part in next, workspace:GetDescendants() do
  if part:IsA("BasePart") and part:FindFirstChild("TouchInterest") then
print(part.ClassName, part:GetFullName())
  end
end
  elseif toolmode == 7 then
for _, sound in next, workspace:GetDescendants() do
  if sound:IsA("Sound") then
print(sound.ClassName, sound.SoundId, sound.Parent:GetFullName())
  end
end
  elseif toolmode == 8 then
for _, anim in next, workspace:GetDescendants() do
  if anim:IsA("Animation") then
print(anim.ClassName, anim.AnimationId, anim.Parent:GetFullName())
  end
end
  end
  
  extra.BackgroundColor3 = Color3.new(0, 1, 0)
  local partTweenn2 = game:GetService("TweenService"):Create(extra, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    })
    partTweenn2:Play()
end)

local CQBypass = extra:Clone()
CQBypass.Parent = ScreenGui
CQBypass.Position = UDim2.new(0.94, 0, 0.52, 0)
CQBypass.Text = "Enable CanQuery Bypass"
CQBypass.TextWrapped = true
CQBypass.TextColor3 = Color3.new(1, 0, 0)

CQBypass.MouseButton1Click:Connect(function()
 CanQueryBypass = not CanQueryBypass
 if CanQueryBypass == true then
   CQBypass.TextColor3 = Color3.new(0, 1, 0)
 else
   CQBypass.TextColor3 = Color3.new(1, 0, 0)
 end
end)

local getproperties = newcclosure(function(instance)
local properties = {}
    for _, property in next, game:GetService("ReflectionService"):GetPropertiesOfClass(instance.ClassName) do
      pcall(function()
        if gethiddenproperty(instance, property.Name) ~= nil then
            properties[property.Name] = gethiddenproperty(instance, property.Name)
        end
      end)
    end
  return properties
end)

Button.MouseButton1Click:Connect(function()
    toolmode += 1
     if toolmode > 11 then
toolmode = 1
     end
     if toolmode < 10 then
       pcall(function() Button:FindFirstChildOfClass("UIGradient"):Destroy() end)
     end
 if toolmode == 1 then
Button.BackgroundColor3 = Color3.new(0.35, 0, 0)
  elseif toolmode == 2 then
Button.BackgroundColor3 = Color3.new(0, 0.35, 0)
  elseif toolmode == 3 then
Button.BackgroundColor3 = Color3.new(0, 0, 0.35)
  elseif toolmode == 4 then
Button.BackgroundColor3 = Color3.new(0.35, 0.35, 0)
  elseif toolmode == 5 then
Button.BackgroundColor3 = Color3.new(0.35, 0, 0.35)
  elseif toolmode == 6 then
Button.BackgroundColor3 = Color3.new(0.5, 0.25, 0.1)
  elseif toolmode == 7 then
Button.BackgroundColor3 = Color3.new(0.1, 0.25, 0.5)
  elseif toolmode == 8 then
Button.BackgroundColor3 = Color3.new(0.5, 0.25, 0.5)
   elseif toolmode == 9 then
Button.BackgroundColor3 = Color3.new(0, 0.6, 0.6)
  elseif toolmode == 10 then
Instance.new("UIGradient", Button).Color = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 0, 1))
  elseif toolmode == 11 then
Button:ClearAllChildren()
Instance.new("UIGradient", Button).Color = ColorSequence.new(Color3.new(0, 0, 1), Color3.new(1, 0, 0))
 end
local sound = Instance.new("Sound", handle)
sound.SoundId = "rbxassetid://18755588842"
sound.Volume = 2
sound.PlaybackSpeed = 1
sound.Looped = false
sound:Play()
 game.Debris:AddItem(sound, 2)
end)

local function mode(mouset)
  if mouset then
 if toolmode == 1 then
 setclipboard(tostring(mouset:GetFullName()))
 elseif toolmode == 2 then
  for i, v in next, getproperties(mouset) do
   pcall(function() print(i, v) end)
  end
 elseif toolmode == 3 then
  for _, obj in ipairs(mouset:GetDescendants()) do
   print(obj:GetFullName())
  end
 elseif toolmode == 4 then
 for _, dec in next, mouset:GetDescendants() do
     if dec:IsA("Decal") or dec:IsA("Texture") or dec:IsA("ParticleEmitter") or dec:IsA("Beam") or dec:IsA("Trail") then
       print(dec.ClassName, dec:GetFullName(), dec.Texture)
     elseif dec:IsA("SurfaceGui") or dec:IsA("BillboardGui") then
       for _, v in dec:GetDescendants() do
         if v:IsA("ImageLabel") then
           print(v.ClassName, v:GetFullName(), v.Image)
         end
      end
    end
  end
 elseif toolmode == 5 then
 if mouset:IsA("MeshPart") then
   print(mouset.ClassName, mouset.MeshId, mouset.TextureID)
 end
    for _, mes in next, mouset:GetDescendants() do
      if mes:IsA("SpecialMesh") then
print(mes.ClassName, mes.MeshId, mes.TextureId)
      elseif mes:IsA("MeshPart") then
print(mes.ClassName, mes.MeshId, mes.TextureID)
      end
    end
 elseif toolmode == 6 then
 if mouset:FindFirstChildWhichIsA("TouchTransmitter") then
       print("Part " .. tostring(mouset.Name) .. " have TouchInterest")
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, mouset, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, mouset, 1)
      else
     print("Part " .. tostring(mouset.Name) .. " dont have TouchInterest")
   end
 elseif toolmode == 7 then
 for _, soun in next, mouset:GetDescendants() do
       if soun:IsA("Sound") then
print(soun.ClassName, soun.SoundId)
       elseif soun:IsA("SoundEffect") then
print(soun.ClassName, soun:GetFullName())
       end
    end
 elseif toolmode == 8 then
 if mouset and mouset.Parent:FindFirstChildOfClass("Humanoid") then
  for _, animation in ipairs(mouset.Parent:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
    print(mouset.Parent:FindFirstChildOfClass("Humanoid").RigType, animation.Animation.ClassName, animation.Animation.AnimationId)
  end
 end
 elseif toolmode == 9 then
 print("Values of " .. mouset:GetFullName() .. ":")
    local function prinAtrs(inst)
      for atmame, atval in next, inst:GetAttributes() do
        print(`{inst:GetFullName()}: ({atname}) {typeof(atval) == "table" and tostring("{" .. table.concat(atval, ", ") .. "}") or tostring(atval)}`)
      end
    end
    for _, v in next, mouset:GetDescendants() do
      if v:IsA("ValueBase") then
        print(v.ClassName, v:GetFullName(), v.Value)
      end
      prinAtrs(v)
    end
 elseif toolmode == 10 then
  for _, scr in next, mouset:GetDescendants() do
    if scr:IsA("LocalScript") then
      print("Environment of " .. scr:GetFullName() .. ":")
      for i, v in next, getsenv(scr) do
        print(scr:GetFullName() .. ": ", i, v)
      end
    end
  end
 elseif toolmode == 11 then
   for _, modul in next, mouset:GetDescendants() do
     if modul:IsA("ModuleScript") then
       print("Functions of " .. modul:GetFullName() .. ": ")
       for i, v in require(modul) do
         print(scr:GetFullName() .. ": ", i, v)
       end
     end
   end
 end
  
local Highlight = Instance.new("Highlight")
Highlight.Parent = mouset
Highlight.Adornee = mouset
Highlight.FillTransparency = 0
Highlight.FillColor = Color3.fromRGB(0, 255, 0)
Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
Highlight.OutlineTransparency = 0
game.Debris:AddItem(Highlight, 4)

local partTweenn2 = game:GetService("TweenService"):Create(Highlight, TweenInfo.new(1, Enum.EasingStyle.Sine), {
        FillTransparency = 1,
        OutlineTransparency = 1
    })
    partTweenn2:Play()
  end
end 

--[[local selectClass = Instance.new("TextBox", ScreenGui)
selectClass.Text = ""
selectClass.PlaceholderText = "Find by class"
selectClass.Position = UDim2.new(0.83, 0, 0.58, 0)
selectClass.Size = UDim2.new(0.04, 0.04, 0.04, 4)
selectClass.BackgroundColor3 = extra.BackgroundColor3
selectClass.TextColor3 = Color3.new(1, 1, 1)
selectClass.MultiLine = false
selectClass.PlaceholderColor3 = Color3.new(0.4, 0.4, 0.4)
selectClass.TextScaled = true

selectClass.FocusLost:Connect(function(enterPress)
  if not enterPress then return end
  if string.len(selectClass.Text) > 35 then
    warn("Does such a class exist?")
    selectClass.Text = selectClass.Text:sub(1, 35)
  end
  
  if not game:GetService("ReflectionService"):GetClass(selectClass.Text) then
    print(selectClass.Text)
    error("This class does not exist", 0)
  end
    if toolmode == 1 then
      for _, v in next, game:GetDescendants() do
        if v:IsA(selectClass.Text) then
          print(v:GetFullName())
        end
      end
   end
end)]]--

tool.Activated:Connect(function()
  local mouset = game.Players.LocalPlayer:GetMouse().Target
local sound = Instance.new("Sound", handle)
sound.SoundId = "rbxassetid://7496207231"
sound.Volume = 2
sound.PlaybackSpeed = 1
sound.Looped = false
sound:Play()
game.Debris:AddItem(sound, 4)
   mode(mouset)
end)

tool.Equipped:Connect(function()
  sethiddenproperty(ScreenGui, "Enabled", true)
end)

tool.Unequipped:Connect(function()
  sethiddenproperty(ScreenGui, "Enabled", false)
end)

tool.Destroying:Connect(function()
  restorefunction(getrawmetatable(game)["__namecall"])
  restorefunction(getrawmetatable(workspace)["__newindex"])
end)
