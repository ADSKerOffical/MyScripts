--[[

 ____            _       _        _   _       _     
| __ ) _   _  __| | __ _(_) ___  | | | |_   _| |__  
|  _ \| | | |/ _` |/ _` | |/ _ \ | |_| | | | | '_ \ 
| |_) | |_| | (_| | (_| | |  __/ |  _  | |_| | |_) |
|____/ \__,_|\__,_|\__, |_|\___| |_| |_|\__,_|_.__/ 
                   |___/                            

]]--

local BudgieHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Resources/FluentCopy.lua"))()

local BHUTitle = "Budgie Hub Universal 2 Alpha"
local currentScript = getfenv(0).script

  local month, day = os.date("%B"), os.date("%d")
  if month == "February" and day == "14" then
   BHUTitle = BHUTitle .. "♥️"
  elseif month == "October" and day == "31" then
    BHUTitle = BHUTitle .. "🎃"
  elseif month == "January" and day == "1" then
    BHUTitle = BHUTitle .. "🎄"
  elseif month == "July" and day == "25" then
    BHUTitle = BHUTitle .. "🎉"
  elseif month == "April" and (day == "12" or day == "5") then
    BHUTitle = BHUTitle .. "🥚"
  elseif month == "March" and day == "21" then
    BHUTitle = BHUTitle .. "🦜"
  end

local Window = BudgieHub:CreateWindow({
    Title = BHUTitle,
    SubTitle = "by ADSKer",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

for i, v in next, getgc(true) do
   if typeof(v) == "table" and rawget(v, "Detected") and typeof(rawget(v, "Detected")) == "function" then
   setthreadidentity(2)
     local Detected, Kill = rawget(v, "Detected"), rawget(v, "Kill")

     local hook1; hook1 = hookfunction(Detected, function(Action, Info, NoCrash)
       return true
     end)

     if rawget(v, "Variables") and rawget(v, "Process") and typeof(Kill) == "function" then
       local hook2; hook2 = hookfunction(Kill, function(info) end)
   end 

  local hook3; hook3 = hookfunction(getrenv().debug.info, newcclosure(function(...)
      local lineorf = ...
      if Detected and lineorf == Detected then
        return coroutine.yield(coroutine.running())
      end
      return hook3(...)
    end))
   setthreadidentity(8)
  end 
end

task.spawn(function()
  getgenv().BHU2 = {}
  BHU2.Window = {}
  BHU2.Settings = {}
  BHU2.Exploit = {}
  
  function BHU2.Window:ToCenter()
    Window.Root.AnchorPoint = Vector2.new(0.5, 0.5)
    game:GetService("TweenService"):Create(Window.Root, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {
       Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
  end
  
  function BHU2.Window:Align()
    Window.Root.Size = UDim2.new(0.7, 0, 1, 0)
  end
end)
  
local BHU2 = Instance.new("ScreenGui", cloneref(gethui and gethui() or game:GetService("CoreGui")))
BHU2.DisplayOrder = math.huge
BHU2.Name = "Budgie Hub 2"
BHU2.ClipToDeviceSafeArea = false
-- BHU2.ScreenInsets = Enum.ScreenInsets.None
BHU2.ResetOnSpawn = false

BHU2.Destroying:Connect(function()
  if restorefunction or restorefunc then
    (restorefunction or restorefunc)(rawget(getrawmetatable(game), "__namecall"))
  end
  pcall(function() getgenv().BHU2 = nil end)
end)

local BHU2_Icon = Instance.new("ImageButton", BHU2)
BHU2_Icon.Size = UDim2.new(0, math.floor(math.max(32, math.min(game.Players.LocalPlayer:GetMouse().ViewSizeX, game.Players.LocalPlayer:GetMouse().ViewSizeY) * 0.15)), 0, math.floor(math.max(32, math.min(game.Players.LocalPlayer:GetMouse().ViewSizeX, game.Players.LocalPlayer:GetMouse().ViewSizeY) * 0.15)))
BHU2_Icon.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
BHU2_Icon.Image = "rbxassetid://126371842393375"
BHU2_Icon.BorderSizePixel = 0
BHU2_Icon.Draggable = true

BHU2_Icon_Corner = Instance.new("UICorner", BHU2_Icon)
BHU2_Icon_Corner.CornerRadius = UDim.new(0.2, 0)

local conne = game:GetService("RunService").PreRender:Connect(function()
  local SSx, SSy = game.Players.LocalPlayer:GetMouse().ViewSizeX, game.Players.LocalPlayer:GetMouse().ViewSizeY * 1.1
  local xval, yval = BHU2_Icon.AbsolutePosition.X, BHU2_Icon.AbsolutePosition.Y
  if (xval + BHU2_Icon.AbsoluteSize.X) >= SSx then
    xval = SSx - BHU2_Icon.AbsoluteSize.X
  elseif (yval + BHU2_Icon.AbsoluteSize.Y) >= SSy then
    yval = SSy - BHU2_Icon.AbsoluteSize.Y
  end
  
  xval = (xval < 0 and 0) or xval
  yval = (yval < 0 and 0) or yval
  
  BHU2_Icon.Position = UDim2.new(0, math.floor(xval), 0, math.floor(yval))
end)

BHU2_Icon.MouseButton1Click:Connect(function()
  Window.Root.Visible = not Window.Root.Visible
end)

Window.Root.Parent.Destroying:Connect(function()
  BHU2:Destroy()
  conne:Disconnect()
end)

do
  task.spawn(function()
    -- 
    local isnetworkowner = newcclosure(function(part)
      return (part.ReceiveAge == 0 and gethiddenproperty(part, "NetworkIsSleeping") == false)
    end)
    
    local getfflag = getfflag or newcclosure(function(flagName)
      return settings():GetFVariable(flagName)
    end)
    
    local request = request or newcclosure(function(options)
      game:GetService("HttpService").RequestAsync(game.HttpService, options)
    end)
    
    local hookmetamethod = hookmetamethod or newcclosure(function(tabl, metamethod, newFunc)
      return hookfunction(rawget(getrawmetatable(tabl), metamethod), newFunc)
    end)
    
    local setclipboard = setclipboard or set_clipboard or toclipboard or setrbxclipboard
  end)
end

coroutine.wrap(function()
  if not isfolder("BHU2") then
    makefolder("BHU2")
  end
  
  writefile("BHU2/Version", "1.0")
  writefile("BHU2/Icon.jpg", game:HttpGetAsync("https://i.ibb.co/jPbnps2Q/IMG-20260310-143205-890.jpg"))
  writefile("BHU2/Icon_AssetId", "rbxassetid://126371842393375")
  if not isfile("BHU2/FeedbackCooldown") then
    writefile("BHU2/FeedbackCooldown")
  end
  if not isfile("BHU2/Birthday") or not (isfile("BHU2/Birthday") and readfile("BHU2/Birthday") == "true") then
    writefile("BHU2/Birthday", "false")
  end
  
  if month == "July" and day == "25" then
    writefile("BHU2/Birthday", "true")
  end
end)()

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://6523858394" }),
    Finders = Window:AddTab({Title = "Dev Tools", Icon = "rbxassetid://12392897830"}),
    Extra = Window:AddTab({Title = "Extra", Icon = "rbxassetid://71023809654860"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Creator = Window:AddTab({Title = "Creator", Icon = "https://www.roblox.com/headshot-thumbnail/image?userId=4636825706&width=420&height=420&format=png"})
}

local ToolControl = Tabs.Main:AddSection("Tool Control")

--[[
ToolControl.Container.Parent.Parent – scroll frame
ToolControl.Container.Parent – section with signature
ToolControl.Container – all buttons in section
]]

--[[local function addSectionToggle(inst, algnpos)
  local icon = Instance.new("TextButton", inst.Parent)
  icon.Size = UDim2.new(0.06, 0, 0.06, 0)
  icon.Name = "BHU2SectionToggle"
  icon.Text = "Hide"
  icon.TextColor3 = Color3.new(1, 1, 1)
  icon.Position = UDim2.new(0.1 + algnpos, 0, 0, 0)
  icon.BackgroundTransparency = 0.3
  icon.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
  icon.BorderSizePixel = 0
  icon:SetAttribute("Toggled", false)
  
  icon.MouseButton1Click:Connect(function()
    icon:SetAttribute("Toggled", not icon:GetAttribute("Toggled"))
    for _, l in next, inst:GetChildren() do
      if l:IsA("GuiObject") then
        l.Visible = not icon:GetAttribute("Toggled")
      end
    end
    if icon:GetAttribute("Toggled") == false then 
      icon.Text = "Hide"
      icon.Size = UDim2.new(0.06, 0, 0.06, 0)
      icon.Position = UDim2.new(0.1 + algnpos, 0, 0, 0)
    else 
      icon.Text = "Show"
      icon.Size = UDim2.new(0.06, 0, 0.6, 0)
      icon.Position = UDim2.new(0.1 + algnpos, 0, 0.15, 0)
    end
    
    icon.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
      if icon:GetAttribute("Toggled") == false then
        icon.Size = UDim2.new(0.06, 0, 0.06, 0)
        icon.Position = UDim2.new(0.1 + algnpos, 0, 0, 0)
      else
        icon.Size = UDim2.new(0.06, 0, 0.6, 0)
        icon.Position = UDim2.new(0.1 + algnpos, 0, 0.15, 0)
      end
    end)
  end)
end]]--
     local search = Instance.new("TextBox", ToolControl.Container.Parent.Parent)
     search.Name = "Search"
     search.Size = UDim2.new(1, 0, 0, 50)
     search.Position = UDim2.new(0.4, 0, 0.2, 0)
     search.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
     search.Text = ""
     search.TextSize *= 1.35
     search.TextWrapped = true
     search.BackgroundTransparency = 0.2
     search.TextColor3 = Color3.new(1, 1, 1)
     search.PlaceholderColor3 = Color3.new(0.75, 0.75, 0.75)
     search.ClearTextOnFocus = false
     search.PlaceholderText = "Search section or functions"
     
     search.FocusLost:Connect(function(enterPress)
       if string.len(search.Text) > 75 then 
         search.Text = search.Text:sub(75)
       end
       if enterPress then
         search.Text = search.Text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
         for _, ke in search.Parent:GetDescendants() do
           if ke:IsA("TextLabel") then
             ke.Parent.Parent.Visible = true
           end
         end
         
         for _, textl in next, search.Parent:GetDescendants() do
           if textl:IsA("TextLabel") and not textl.Text:lower():find(search.Text:lower()) then -- and textl.Parent:IsA("Frame")
             textl.Parent.Parent.Visible = false
          end
        end
         
         if search.Text == "" then
           for _, ke in next, search.Parent:GetDescendants() do
             if ke:IsA("TextLabel") then
               ke.Parent.Parent.Visible = true
             end
           end
         end
        Window:SelectTab(1)
       end
     end)
     
     local buttons_config = Instance.new("Folder", ToolControl.Container.Parent.Parent.Parent.Parent)
     
     local ontop = Instance.new("TextButton", buttons_config)
     ontop.Size = UDim2.new(0.075 / 2, 0, 0.1 / 2, 0)
     ontop.Position = UDim2.new(0.425, 0, 0.125, 0)
     ontop.Visible = false
     ontop.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
     ontop.BackgroundTransparency = 0.2
     ontop.Text = "↑"
     ontop.TextColor3 = Color3.new(1, 1, 1)
     ontop.Name = "ScrollToTop"
     
     local ondown = ontop:Clone()
     ondown.Position = UDim2.new(0.485, 0, 0.125, 0)
     ondown.Text = "↓"
     ondown.Name = "ScrollToDown"
     ondown.Parent = buttons_config
     
    local conta = ToolControl.Container.Parent.Parent
     conta.Changed:Connect(function()
       ontop.Visible = conta.Visible
       ondown.Visible = conta.Visible
     end)
     
     ontop.MouseButton1Click:Connect(function()
       conta:ScrollToTop()
     end)
     
     ondown.MouseButton1Click:Connect(function()
       local target = Vector2.new(conta.CanvasPosition.X, math.max(0, conta.AbsoluteCanvasSize.Y - conta.AbsoluteSize.Y))

game:GetService("TweenService"):Create(conta, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
     CanvasPosition = target
}):Play()
     end)

local Toggle = ToolControl:AddToggle("ToolControl", {
    Title = "Tool: Damage all players", 
    Description = "This function using method with TouchTransmitter. This doesn\'t work in all places. Tool, Players",
    Default = false,
    Callback = function(state)
	  aaa = state 
	  while aaa and game:GetService("RunService").RenderStepped:Wait() do
    pcall(function()
        local p = game.Players:GetPlayers()
        for i = 2, #p do local v = p[i].Character
            local LP = game.Players.LocalPlayer
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                for i, v in next, v:GetChildren() do
                    if v:IsA("BasePart") then
                        for _, part in next, tool:GetDescendants() do
                            if part:IsA("BasePart") and part:FindFirstChild("TouchInterest") then
                                firetouchinterest(part, v, 0)
                                firetouchinterest(part, v, 1)
                            end
                        end
                    end
                end
            end
        end
    end)
end
    end 
})

local Toggle = ToolControl:AddToggle("ToolControl", {
    Title = "Tool: Damage all NPC\'s", 
    Description = "This function uses the same method with TouchTransmitter. Doesn\'t work in all places. Tool, NPC",
    Default = false,
    Callback = function(state)
	ooj = state
while ooj and game:GetService("RunService").RenderStepped:Wait() do
    local LP = game:GetService("Players").LocalPlayer
local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                for i, v in next, workspace:GetDescendants() do
                    if v:IsA("Humanoid") and not game:GetService("Players"):GetPlayerFromCharacter(v.Parent) then
                       for i, d in next, v.Parent:GetDescendants() do
                         if d:IsA("BasePart") then
                           for _, part in next, tool:GetDescendants() do
                             if part:IsA("BasePart") then
                              firetouchinterest(part, d, 0)
                              firetouchinterest(part, d, 1)
                            end
                          end
                       end
                    end
                 end
             end
         end
     end
    end 
})

local Toggle = ToolControl:AddToggle("ToolControl", {
    Title = "Tool: Grab tools", 
    Description = "This feature allows you grab all dropped tools in the workspace. Tool",
    Default = false,
    Callback = function(state)
      aac = state
	  while aac and task.wait() do
       for _, tool in next, game.Workspace:GetDescendants() do
  if tool:IsA("Tool") and tool:FindFirstChildWhichIsA("BasePart") and not game.Players:GetPlayerFromCharacter(tool.Parent) then
    firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), tool:FindFirstChildWhichIsA("BasePart"), 0)
  end
end
     end
    end 
})

ToolControl:AddToggle("Grip", {
    Title = "Tool: Random grip poses",
    Description = "If you have a lot of tools, you can cover yourself with them. Tool, Grip",
    Callback = function(state)
      aje = state
      while aje and task.wait() do
        for _, tool in game.Players.LocalPlayer.Backpack:GetChildren() do
  if tool:IsA("Tool") then
    coroutine.wrap(function()
    tool.GripPos = Vector3.new(math.random(-math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50), math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50)), math.random(-math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50), math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50)), math.random(-math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50), math.clamp(#game.Players.LocalPlayer.Backpack:GetChildren(), 1, 50)))
    tool.Parent = game.Players.LocalPlayer.Character
      task.wait()
    tool.Parent = game.Players.LocalPlayer.Backpack
    end)()
  end
end
  end
    end
})

ToolControl:AddToggle("MyToggle", {
  Title = "Tool: Massles grip",
  Description = "All parts in the tool become phantom, thus not moving you",
  Default = false,
  Callback = function(Value)
     nsj = Value
while nsj and task.wait() do
  for _, tool in next, game.Players.LocalPlayer.Character:GetChildren() do
    if tool:IsA("Tool") then
      for _, part in tool:GetDescendants() do
        if part:IsA("BasePart") then
          part.Massless = not nsj
          part.CanCollide = not nsj
          part.Anchored = false
        end
      end
    end
  end
end
  end
})

local TouchControl = Tabs.Main:AddSection("TouchTransmitter/TouchInterest control")

local Toggle = TouchControl:AddToggle("TTIn", {
    Title = "Touch: Touch unanchored part to all players", 
    Description = "With this feature you can easily kill all players if there is an unattached unit with TouchTransmitter next to you. But only if there are no players nearby or you are the closest player to this part. Touch, Kill, Players",
    Default = false,
    Callback = function(state)
    aad = state
 while aad and task.wait() do
 if game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name) and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
  game.Players.LocalPlayer.SimulationRadius = math.huge
  for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 50) do
    if part.Anchored == false and part:FindFirstChildWhichIsA("TouchTransmitter") then
      for _, player in next, game.Players:GetPlayers() do
         if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChildWhichIsA("BasePart") then
         pcall(function()
           firetouchinterest(part, player.Character:FindFirstChildWhichIsA("BasePart"), 0)
           firetouchinterest(part, player.Character:FindFirstChildWhichIsA("BasePart"), 1)
         end)
        end
      end
    end
  end
 end
end
    end 
})

local Toggle = TouchControl:AddToggle("Toggle", {
   Title = "Touch: Touch unanchored parts to all NPC\'s",
   Description = "Similar to the previous function, but it only works on NPCs. Touch",
   Default = false,
   Callback = function(Value)
   
   end
})

local PlayerControl = Tabs.Main:AddSection("Local Player Control")

local Toggle = PlayerControl:AddToggle("MyToggle", {
    Title = "LocalPlayer: Fling", 
    Description = "You can fling nearby players and objects if collisions are enabled. Anti cheats can detect it. LocalPlayer, Fling",
    Default = false,
    Callback = function(state)
     ajei = state
     if ajei == false then return end
while ajei do
  game:GetService("RunService").Heartbeat:Wait()
 local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel * 100000 + Vector3.new(0, 100000, 0)
  game:GetService("RunService").RenderStepped:Wait()
   game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel
  game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel + Vector3.new(0, 0, 0) 
end
    end 
})

PlayerControl:AddToggle("MyToggle", {
  Title = "LocalPlayer: Fling v2",
  Description = "This feature makes all your body parts incredibly fast when you walking, but you don\'t fly away due to BodyVelocity. To stop the fling, just jump or switch humanoid states. LocalPlayer, Fling",
  Default = false,
  Callback = function(Value)
   uue = Value
   if uue == false then return end
   local coje = game.Players.LocalPlayer.Character.Humanoid.Running:Connect(function(speed)
  if speed > 0 and game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
   local bv = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
bv.P = math.huge

   repeat task.wait()
  bv.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
  game.Players.LocalPlayer.SimulationRadius = math.huge
  if game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown or game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding or game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Seated then
    game.Players.LocalPlayer.Character.Humanoid:ChangeState("GettingUp")
  end
  for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
    if part:IsA("BasePart") then
      part.CanCollide = false
      part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
      part.AssemblyLinearVelocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 125000
      part.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 125000
    end
  end
until bv.Parent == nil or game.Players.LocalPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Running
   pcall(function() bv:Destroy() end)
     for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
       if part:IsA("BasePart") then
         part.CanCollide = true
         part.AssemblyLinearVelocity = Vector3.zero
         part.AssemblyAngularVelocity = Vector3.zero
         part:ResetPropertyToDefault("CustomPhysicalProperties")
       end
    end
  end
end)

     task.spawn(function()
       repeat task.wait() until uue == false coje:Disconnect()
     end)
  end
})

PlayerControl:AddToggle("Defense", {
  Title = "LocalPlayer: Infinity jumps",
  Description = "Jump as much as you want. LocalPlayer",
  Default = false,
  Callback = function(Value)
     gigigi = Value
     local con = game:GetService("UserInputService").JumpRequest:Connect(function()
     if not game.Players.LocalPlayer.Character.Humanoid:GetStateEnabled("Jumping") then
       game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled("Jumping", true)
     end
       game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
     end)
     task.spawn(function() repeat task.wait() until gigigi == false con:Disconnect() end)
  end
})

local Toggle = PlayerControl:AddToggle("MyToggle", {
    Title = "LocalPlayer: Anti fling", 
    Description = "This feature prevents you from touching players. LocalPlayer, Anti fling",
    Default = false,
    Callback = function(state)
      aaf = state
     while aaf and task.wait() do
       for _, plr in next, game:GetService("Players"):GetPlayers() do
         if plr ~= game:GetService("Players").LocalPlayer and plr.Character then
for _, part in next, plr.Character:GetDescendants() do
  if part:IsA("BasePart") then
 part.CanCollide = not aaf
 part.CanTouch = not aaf
 part.AssemblyLinearVelocity = Vector3.zero
 part.AssemblyAngularVelocity = Vector3.zero
 part.RotVelocity = Vector3.zero
 part.Velocity = Vector3.zero
 part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
  end
end
         end
       end
     end
    end 
})

local Toggle = PlayerControl:AddToggle("MyToggle", {
    Title = "LocalPlayer: Anti sit", 
    Description = "You cant sit. LocalPlayer, Anti",
    Default = false,
    Callback = function(state)
      aal = state
while aal and task.wait() do pcall(function() game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled("Seated", not aal) end) end
    end 
})

local Toggle = PlayerControl:AddToggle("MyToggle", {
    Title = "LocalPlayer: Anti void", 
    Description = "This feature prevents you from falling off the map by teleporting you to random spawn location. LocalPlayer, Anti",
    Default = false,
    Callback = function(state)
      local function getrespawn(): Instance
  for _, part in next, workspace:GetDescendants() do
    if part:IsA("SpawnLocation") then
      return part
   end
  end
end

aaj = state
local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

local con = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
  if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.CFrame.Y <= workspace.FallenPartsDestroyHeight + 10 then
    if getrespawn() then
 char.HumanoidRootPart.CFrame = getrespawn().CFrame
 char.HumanoidRootPart.Velocity = Vector3.zero
     else
 char.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)
 char.HumanoidRootPart.Velocity = Vector3.zero
    end
  end
end)
task.spawn(function() repeat task.wait() until aaj == false con:Disconnect() end)
    end 
})

PlayerControl:AddToggle("Defense", {
  Title = "LocalPlayer: Noclip",
  Description = "You can pass through walls and parts. Noclip, LocalPlayer",
  Default = false,
  Callback = function(Value)
     toejh = Value
     if toejh == false then return end
while toejh and task.wait() do
  for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
    if part:IsA("BasePart") then
      part.CanCollide = not toejh
    end
  end
end
  end
})

PlayerControl:AddToggle("MyToggle", {
  Title = "LocalPlayer: Anti ragdoll",
  Description = "You turn off ragdoll at least you can walk in ragdoll mode. LocalPlayer, Anti",
  Default = false,
  Callback = function(Value)
     hgg = Value 
  while hgg and task.wait() do
    local humanoid = (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded()) and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if (humanoid:GetState() == Enum.HumanoidStateType.FallingDown or humanoid:GetState() == Enum.HumanoidStateType.Physics or humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding) then
      humanoid:ChangeState("GettingUp")
      humanoid.PlatformStand = false
      humanoid.Parent:MakeJoints()
      if humanoid:GetStateEnabled("FallingDown") then
        humanoid:SetStateEnabled("FallingDown", false)
      end
    end
  end
  end
})

PlayerControl:AddToggle("MyToggle", {
  Title = "LocalPlayer: Anti bang",
  Description = "Teleports you to the void if there is a player nearby with bang animation. LocalPlayer, Anti bang",
  Default = false,
  Callback = function(Value)
    kiudi = Value
     while kiudi and task.wait() do
       for _, player in next, game.Players:GetPlayers() do
         if player ~= game.Players.LocalPlayer and game.Workspace:FindFirstChild(player.Name) and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
           for _, anim in next, player.Character.Humanoid:GetPlayingAnimationTracks() do
              if anim.Animation.AnimationId == "rbxassetid://148840371" or anim.Animation.AnimationId == "rbxassetid://5918726674" then
    game:GetService("RunService").Heartbeat:Wait()
    last_pick_sin_mrazy = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9e8, workspace.FallenPartsDestroyHeight + 1, 9e8) 
    game:GetService("RunService").Heartbeat:Wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = last_pick_sin_mrazy
              end
           end
         end
       end
     end
  end
})

PlayerControl:AddToggle("MyToggle", {
  Title = "LocalPlayer: Anti bang mode",
  Description = "If the anti bang couldn\'t detect the player\'s animation, but he is attached to you, then you activate this function. LocalPlayer, Anti bang",
  Default = false,
  Callback = function(Value)
     ueuif = Value
while ueuif do
game:GetService("RunService").Heartbeat:Wait()
    last_pick_sin_mrazy = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9e8, workspace.FallenPartsDestroyHeight + 1, 9e8) 
    game:GetService("RunService").Heartbeat:Wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = last_pick_sin_mrazy
              end
  end
})

PlayerControl:AddToggle("Defense", {
  Title = "LocalPlayer: Desync",
  Description = "To the client, you\'ll still be able to move freely, but to the server, you'll feel like you\'re you lag a lot. LocalPlayer, desync",
  Default = false,
  Callback = function(Value)
    nejb = Value
   while nejb and task.wait() do
  for _, joi in next, game.Players.LocalPlayer.Character:GetDescendants() do
    if joi:IsA("JointInstance") then
      joi.Enabled = false
      joi.Enabled = true
    end
  end
end
  end
})

local PlayersControl = Tabs.Main:AddSection("Players Control")

local function getplrbyname(name)
  for _, plr in next, game.Players:GetPlayers() do
    if string.find(plr.Name, name, 1, false) or string.find(plr.DisplayName, name, 1, false) then
      return plr
    end
  end
end

local Input = PlayersControl:AddInput("Input", {
    Title = "Players: Fling player",
    Description = "You trying fling the player. Players",
    Default = "",
    Placeholder = "name",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        local player = getplrbyname(Value)
if player and player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
  local cooldown, currentPos = os.clock(), game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
  repeat task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
      if part:IsA("BasePart") then
        part.AssemblyLinearVelocity = Vector3.new(10000, 10000, 10000)
        part.AssemblyAngularVelocity = Vector3.new(10000, 10000, 10000)
      end
    end
  until (os.clock() - cooldown) >= 5 or player.Character.HumanoidRootPart.Velocity.Magnitude >= 200 or not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart")
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
  for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
    if part:IsA("BasePart") then
      part.AssemblyLinearVelocity = Vector3.zero
      part.AssemblyAngularVelocity = Vector3.zero
    end
  end
end
    end
})

local PartControl = Tabs.Main:AddSection("Parts Control")

local Toggle = PartControl:AddToggle("Test", {
    Title = "Part: Pusher", 
    Description = "Pushes all nearby parts away from you. Part, Fling",
    Default = false,
    Callback = function(state)
      oppja = state
while oppja and task.wait() do
  if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
  game.Players.LocalPlayer.SimulationRadius = math.huge
local parts = workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 35)
  for _, part in ipairs(parts) do
    if part and part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:FindFirstChild(part.Parent.Name) then
part.Velocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Unit * -800
part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0) 
  if part:FindFirstChild("PrimaryPart") ~= nil and not part.PrimaryPart:IsDescendantOf(game.Players.LocalPlayer.Character) and not part.PrimaryPart.Anchored and not game.Players:FindFirstChild(part.PrimaryPart.Parent.Name) then
     part.PrimaryPart.Velocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.PrimaryPart.Position).Unit * -800
  end
  if part:GetRootPart() and not part:GetRootPart():IsDescendantOf(game.Players.LocalPlayer.Character) and not part:GetRootPart().Anchored and not game.Players:FindFirstChild(part:GetRootPart().Parent.Name) then
     part:GetRootPart().Velocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part:GetRootPart().Position).Unit * -800
  end
      end
    end
  end
end   
    end 
})

local Toggle = PartControl:AddToggle("MyToggle", {
    Title = "Part: Anti part fling", 
    Description = "Prevents collision with all parts that do not belong to the local player. Part, Anti",
    Default = false,
    Callback = function(state)
 hueey = state
     while hueey and game:GetService("RunService").PreSimulation:Wait() do
       if game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name) and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         game.Players.LocalPlayer.SimulationRadius = math.huge
         sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", math.huge)
         sethiddenproperty(game.Players.LocalPlayer, "MaximumSimulationRadius", math.huge)
         
         for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 50) do
           if part.Anchored == false and not isnetworkowner(part) and part.Velocity.Magnitude >= 5 and not game.Players:GetPlayerFromCharacter(part.Parent) then
              part.Velocity = Vector3.zero
              part.RotVelocity = Vector3.zero
              part.AssemblyLinearVelocity = Vector3.zero
              part.AssemblyAngularVelocity = Vector3.zero
              part.CanCollide = isnetworkowner(part)
              part.CanTouch = isnetworkowner(part)
              part.CanQuery = isnetworkowner(part)
              part.Massless = not isnetworkowner(part)
              part:ResetPropertyToDefault("CustomPhysicalProperties")
           end
         end
       end
     end
    end 
})

local Toggle = PartControl:AddToggle("MyToggle", {
    Title = "Part: Untouchable", 
    Description = "When touching a part signal part.Touched and part.TouchEnded doesn\'t firing. Part",
    Default = false,
    Callback = function(state)
    euh = state
 while euh and task.wait() do
 local LP = game.Players.LocalPlayer
     for _, part in ipairs(LP.Character:GetDescendants()) do
       if part:IsA("BasePart") then
         part.CanTouch = not euh
         part.CanQuery = not euh
       end
     end
   end
    end 
})

PartControl:AddToggle("MyToggle", {
  Title = "Part: X-ray",
  Description = "All parts become transparent. Part, Xray, X-ray",
  Default = false,
  Callback = function(Value)
      xrayen = Value
for _, part in ipairs(workspace:GetDescendants()) do
  if part:IsA("BasePart") and not part.Parent:FindFirstChildOfClass("Humanoid") and part.Parent ~= game.Players.LocalPlayer.Character then
 part.LocalTransparencyModifier = xrayen and 0.6 or 0
  end
end
  end
})

PartControl:AddButton({
  Title = "Part: Get parts control tools",
  Description = "Gives you tools to manipulate parts",
  Callback = function()
     local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
tool.Name = "Black hole tool"
tool.ToolTip = "Vacuuming all nearby parts to a given point"
tool.RequiresHandle = false
tool:SetAttribute("Pulling", false)

tool.Activated:Connect(function()
  game.Players.LocalPlayer.SimulationRadius = math.huge
  tool:SetAttribute("Pulling", not tool:GetAttribute("Pulling"))
  for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 250) do
    if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
      coroutine.wrap(function()
      part.CanCollide = false
      local bv = Instance.new("BodyPosition", part)
      bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
      bv.D = 5
      bv.Position = game.Players.LocalPlayer:GetMouse().Hit.Position
      repeat task.wait() until tool:GetAttribute("Pulling") == false bv:Destroy()
      part.CanCollide = true
      part.Velocity = Vector3.zero
      end)()
    end
  end
end)

local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
tool.Name = "Reset parts tool"
tool.ToolTip = "Resets all nearby parts"
tool.RequiresHandle = false

tool.Activated:Connect(function()
  game.Players.LocalPlayer.SimulationRadius = math.huge
  for _, part in next, game.Workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 100) do
    if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) and isnetworkowner(part) then
      for _, prop in next, game:GetService("ReflectionService"):GetPropertiesOfClass(part.ClassName) do
        if not table.find({"CFrame", "Position", "Size", "Color", "ReceiveAge", "Anchored", "NetworkIsSleeping", "MeshId", "TextureID", "Parent"}, prop) then
          pcall(function() part:ResetPropertyToDefault(prop.Name) end)
        end
      end
      
      for _, bv in next, part:GetDescendants() do
        if bv:IsA("BodyMover") or bv:IsA("Constraint") then
          bv:Destroy()
         elseif bv:IsA("BaseScript") then
          bv.Enabled = false
        end
      end
    end
  end
end)

local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
tool.Name = "Void parts tool"
tool.ToolTip = "Sends all nearby objects to the void"
tool.RequiresHandle = false

tool.Activated:Connect(function()
  game.Players.LocalPlayer.SimulationRadius = math.huge
  for _, part in next, game.Workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 150) do
    if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) and isnetworkowner(part) then
      part.CanCollide = false
      local bodyg = Instance.new("BodyVelocity", part)
      bodyg.Velocity = Vector3.new(0, workspace.FallenPartsDestroyHeight, 0) * 10
      bodyg.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
      bodyg.P = math.huge
    end
  end
end)

local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
tool.Name = "Parts freezer"
tool.RequiresHandle = false
tool.ToolTip = "Immobilizes all parts in the radius"
tool.GripPos = Vector3.new(0, 0, 0)
tool:SetAttribute("Activated", false)

game.Players.LocalPlayer.SimulationRadius = math.huge
tool.Activated:Connect(function()
    tool:SetAttribute("Activated", not tool:GetAttribute("Activated"))
    game.Players.LocalPlayer.SimulationRadius = math.huge
    sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", math.huge)
    settings().Physics.AllowSleep = false
    game:GetService("TestService").IsSleepAllowed = false
    
    for _, part in next, game.Workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 300) do
      if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and isnetworkowner(part) then
        coroutine.wrap(function()
          local bv = Instance.new("BodyVelocity", part)
          bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          bv.Velocity = Vector3.zero
          bv.P = math.huge
            repeat task.wait() until tool:GetAttribute("Activated") == false
          bv:Destroy()
        end)()
      end
   end
end)
  end
})

PartControl:AddToggle("MyToggle", {
  Title = "Part: Pull nearby parts towards nearby players",
  Description = "This function attracts nearby unattached objects to nearby players. Part, Players, Attract",
  Default = false,
  Callback = function(Value)
yen = Value
    while yen and task.wait() do
  local humanoids = {}
for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 50) do
    if part.Parent:IsA("Model") and part.Parent:FindFirstChildOfClass("Humanoid") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and game.Players:GetPlayerFromCharacter(part.Parent) then
      if not table.find(humanoids, part.Parent:FindFirstChildOfClass("Humanoid")) then
        table.insert(humanoids, part.Parent:FindFirstChildOfClass("Humanoid"))
      end
    end
  end

  for _, humanoid in next, humanoids do
    for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 75) do
      if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) and not part:IsDescendantOf(humanoid.Parent) then
        game.Players.LocalPlayer.SimulationRadius = math.huge
        if part.Anchored == true then continue end
        part.CustomPhysicalProperties = PhysicalProperties.new(100, 1, 1, 1, 0)
        part.CanCollide = false
        part.Velocity = (humanoid.RootPart.Position - part.Position).Unit * 600
        part.RotVelocity = Vector3.new(900, 900, 900)
        
        for _, bv in next, part:GetDescendants() do
          if bv:IsA("BodyMover") or bv:IsA("Constraint") then
            bv:Destroy()
          end
        end
        elseif part.Anchored == true and not part:IsDescendantOf(game.Players.LocalPlayer.Character) then
         part.Velocity = Vector3.zero
         part.AssemblyAngularVelocity = Vector3.zero
         part.AssemblyLinearVelocity = Vector3.zero
      end
    end
  end
end
  end
})

PartControl:AddToggle("Defense", {
  Title = "Part: Pull nearby parts towards nearby NPC\'s",
  Description = "The function attracts all nearby parts to the nearest humanoid. Part, NPC, Attract",
  Default = false,
  Callback = function(Value)
    yeen = Value
    while yeen and task.wait() do
  local humanoids = {}
for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 50) do
    if part.Parent:IsA("Model") and part.Parent:FindFirstChildOfClass("Humanoid") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
      if not table.find(humanoids, part.Parent:FindFirstChildOfClass("Humanoid")) then
        table.insert(humanoids, part.Parent:FindFirstChildOfClass("Humanoid"))
      end
    end
  end

  for _, humanoid in next, humanoids do
    for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 75) do
      if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) and not part:IsDescendantOf(humanoid.Parent) then
        game.Players.LocalPlayer.SimulationRadius = math.huge
        if part.Anchored == true then continue end
        part.CustomPhysicalProperties = PhysicalProperties.new(100, 1, 1, 1, 0)
        part.CanCollide = false
        part.Velocity = (humanoid.RootPart.Position - part.Position).Unit * 600
        part.RotVelocity = Vector3.new(900, 900, 900)
        
        for _, bv in next, part:GetDescendants() do
          if bv:IsA("BodyMover") or bv:IsA("Constraint") then
            bv:Destroy()
          end
        end
        elseif part.Anchored == true and not part:IsDescendantOf(game.Players.LocalPlayer.Character) then
         part.Velocity = Vector3.zero
         part.AssemblyAngularVelocity = Vector3.zero
         part.AssemblyLinearVelocity = Vector3.zero
      end
    end
  end
end
  end
})

PartControl:AddToggle("Defense", {
  Title = "Part: Spin parts around",
  Description = "All nearby parts will spining around you",
  Default = false,
  Callback = function(Value)
    djhn = Value
while djhn and game:GetService("RunService").RenderStepped:Wait() do
  for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position, 200) do
    if part.Anchored == false and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
       game.Players.LocalPlayer.SimulationRadius = math.huge
       settings().Physics.AllowSleep = false

       local angle = tick() * 15
       part.Velocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(150 * math.cos(angle), 0, 150 * math.sin(angle)) - part.Position).Unit * 1000
       part.CanCollide = false
       part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
    end
  end
end
  end
})

local NPCControl = Tabs.Main:AddSection("NPC\'s control")

NPCControl:AddToggle("MyToggle", {
  Title = "NPC: Kill nearest",
  Description = "Kills nearby entities (does not guarantee). NPC, Kill",
  Default = false,
  Callback = function(Value)
    yoo = Value
while yoo and task.wait() do
 if workspace:FindFirstChild(game.Players.LocalPlayer.Name) and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
   local parts = workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 50)
    for _, part in next, parts do
      if part.Anchored == false and not game.Players:GetPlayerFromCharacter(part.Parent) and part.Parent:FindFirstChildOfClass("Humanoid") then
       local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        game.Players.LocalPlayer.SimulationRadius = math.huge
        
        if isnetworkowner(humanoid.Parent.HumanoidRootPart) then
        humanoid.Health = 0
        humanoid:TakeDamage(math.huge)
        humanoid:ChangeState("Dead") 
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.JumpHeight = 0
        humanoid.Sit = true
        humanoid.PlatformStand = true
        humanoid.EvaluateStateMachine = false
        humanoid:UnequipTools()
        end
        
        replicatesignal(humanoid.ServerBreakJoints)
        
        for _, part in next, humanoid.Parent:GetDescendants() do
           if part:IsA("BasePart") then
   part.CanCollide = false
   part.CanTouch = false
   sethiddenproperty(part, "LocalSimulationValidation", 0)
   part.Velocity = Vector3.new(0, -1000, 0)
   part.AssemblyAngularVelocity = Vector3.new(0, -1000, 0)
   part.AssemblyLinearVelocity = Vector3.new(0, -1000, 0)
           end
        end
      end
    end
  end
 end
  end
})

NPCControl:AddToggle("MyToggle", {
  Title = "NPC: Push nearest",
  Description = "You push away all nearby NPC from yourself. NPC",
  Default = false,
  Callback = function(Value)
     myyy = Value
while myyy and task.wait() do
 if workspace:FindFirstChild(game.Players.LocalPlayer.Name) and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
   local parts = workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 45)
    for _, part in next, parts do
      if part.Anchored == false and not game.Players:GetPlayerFromCharacter(part.Parent) and part.Parent:FindFirstChildOfClass("Humanoid") then
       local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        game.Players.LocalPlayer.SimulationRadius = math.huge
        humanoid.RootPart.AssemblyLinearVelocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - humanoid.RootPart.Position).Unit * -800
      end
    end
  end
 end
  end
})

NPCControl:AddToggle("Defense", {
  Title = "NPC: Rotate nearest",
  Description = "All nearby entities will revolve around you. NPC",
  Default = false,
  Callback = function(Value)
    oiyj = Value
while oiyj and task.wait() do
 if workspace:FindFirstChild(game.Players.LocalPlayer.Name) and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
   local parts = workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 45)
    for _, part in next, parts do
      if part.Anchored == false and not game.Players:GetPlayerFromCharacter(part.Parent) and part.Parent:FindFirstChildOfClass("Humanoid") then
       local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        game.Players.LocalPlayer.SimulationRadius = math.huge
        humanoid:ChangeState("FallingDown")
        local angle = tick() * 2
        humanoid.RootPart.AssemblyLinearVelocity = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(20 * math.cos(angle), 0, 20 * math.sin(angle)) - humanoid.RootPart.Position).Unit * 500
      end
    end
  end
 end
  end
})

NPCControl:AddToggle("MyToggle", {
  Title = "NPC: Bug nearest",
  Description = "This function distorts the positions of nearby entities, making them uncontrollable. NPC",
  Default = false,
  Callback = function(Value)
jush = Value
    while jush and task.wait(wait()) do
local humanoids = {}
for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart", 10).Position, 75) do
    if part.Parent:IsA("Model") and part.Parent:FindFirstChildOfClass("Humanoid") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
      if not table.find(humanoids, part.Parent:FindFirstChildOfClass("Humanoid")) then
        table.insert(humanoids, part.Parent:FindFirstChildOfClass("Humanoid"))
      end
    end
  end

  for _, humanoid in next, humanoids do
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
    if isnetworkowner(humanoid.Parent.HumanoidRootPart) then
      humanoid.RootPart.Position = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
    end
  end
end
  end
})

NPCControl:AddToggle("Defense", {
  Title = "NPC: NPC fling",
  Description = "You flinging nearby players using NPCs",
  Default = false,
  Callback = function(Value)
   jdj = Value
    while jdj and task.wait() do
local Chumanoid, Cdistance = nil, math.huge
for _, part in next, game.Workspace:GetPartBoundsInRadius((game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").Position, 80) do
    if not part:IsDescendantOf(game.Players.LocalPlayer.Character) and part.Parent:FindFirstChildOfClass("Humanoid") and game.Players:GetPlayerFromCharacter(part.Parent) then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        local distance = (part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
        if distance < Cdistance then
            Cdistance = distance
            Chumanoid = humanoid 
        end
    end
end

if Chumanoid then
    game.Players.LocalPlayer.SimulationRadius = math.huge

  local humanoids = {}
for _, part in next, workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 80) do
    if part.Parent:IsA("Model") and part.Parent:FindFirstChildOfClass("Humanoid") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
      if not table.find(humanoids, part.Parent:FindFirstChildOfClass("Humanoid")) then
        table.insert(humanoids, part.Parent:FindFirstChildOfClass("Humanoid"))
      end
    end
  end

   for _, humanoid in next, humanoids do
     if isnetworkowner(humanoid.RootPart) then
     for _, part in next, humanoid.Parent:GetDescendants() do
       if part:IsA("BasePart") then
          part.CanCollide = false
          part.AssemblyLinearVelocity = (Chumanoid.RootPart.Position - humanoid.RootPart.Position).Unit * 200
          part.AssemblyAngularVelocity = Vector3.new(2000, 2000, 2000)
        end
      end
     end
   end
 end
end
  end
})

local AnimationControl = Tabs.Main:AddSection("Animation Control")

-- Dropdown: Animation: Play animation R6

local Dropdown = AnimationControl:AddDropdown("Dropdown", {
    Title = "Animation: Play animation R15",
    Description = "Play animations which I found. Animation",
    Values = {"Sinister dance", "Take L", "Rampage", "Gangam style", "Billy bounce", "Cat sinister dance", "Orange justice", "Shake that thang"},
    Multi = false,
    Default = "...",
})

Dropdown:OnChanged(function(Value)
  local as, res = pcall(function()
    if Value == "..." then return end
    local tabl = {
      ["Sinister dance"] = "rbxassetid://137581268977122",
      ["Take L"] = "rbxassetid://95656304023751",
      ["Rampage"] = "rbxassetid://113913115257328",
      ["Gangam style"] = "rbxassetid://129764254213842",
      ["Billy bounce"] = "rbxassetid://119280135350752",
      ["Cat sinister dance"] = "rbxassetid://119554409715043",
      ["Orange justice"] = "rbxassetid://95127716920692",
      ["Shake that thang"] = "rbxassetid://118364690209655"
    }
    for _, anim in next, game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks() do
      anim:Stop()
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = tabl[Value]
    anim.Name = tabl[Value]
    local realanim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
    realanim:Play()
    realanim:AdjustWeight(math.huge)
  end)
end)

AnimationControl:AddButton({
  Title = "Animation: Stop all animations",
  Description = "Stop all animations. Animation",
  Callback = function()
     for i, animation in ipairs(game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
    animation:Stop()
end
  end
})

local Input = AnimationControl:AddInput("Input", {
    Title = "Animation: Load animation",
    Description = "Launch your animation by Content ID",
    Default = "",
    Placeholder = "Id",
    Numeric = true, 
    Finished = true,
    Callback = function(Value)
        local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. tostring(Value)
local realanim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
realanim:Play()
realanim:AdjustWeight(math.huge)
    end
})

local Input = AnimationControl:AddInput("Input", {
    Title = "Animation: Search animation by name",
    Description = "Enter the name of the animation you want to find here, and the program searches the catalog for animations with that name. If a search is successful, a window will appear with five animations you can load. This feature is under development and may have some bugs",
    Default = "",
    Placeholder = "Name",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Search result"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local Frame = Instance.new("Frame", gui)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 250, 0, 250)
Frame.BackgroundTransparency = 0.1
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Position = UDim2.new(0.35, 0, 0.2, 0)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Position = UDim2.new(0, 50, 0, -5)
Title.Text = "Search result"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local List = Instance.new("ScrollingFrame", Frame)
List.Size = UDim2.new(0, 200, 0, 200)
List.ScrollBarThickness = 5
List.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
List.Position = UDim2.new(0, 23, 0, 21)
List.BorderSizePixel = 0
List.BackgroundTransparency = 0.1

local Layout = Instance.new("UIGridLayout", List)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.CellSize = UDim2.new(0, 200, 0, 20)
Layout.CellPadding = UDim2.new(0, 5, 0, 5)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
  List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Text = "X"
Close.Position = UDim2.new(1, 0, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundTransparency = 1

Close.MouseButton1Click:Connect(function()
  gui:Destroy()
end)

local assets = game.HttpService:JSONDecode(game:HttpGet("https://catalog.roblox.com/v1/search/items/details?Category=Animation&Subcategory=Emote&Keyword=" .. game.HttpService:UrlEncode(Value) .. "&Limit=20")).data
for i, v in next, assets do
  if v.assetType == 61 or v.assetType == 50 then
  local Button = Instance.new("TextButton", List)
  Button.Text = v.name .. ": " .. tostring(v.id)
  Button.BackgroundColor3 = List.BackgroundColor3
  Button.TextColor3 = Color3.new(1, 1, 1)
  Button.TextScaled = true
  Button.Position = UDim2.new(0.5, 0, 0.5, 0)
  Button.AnchorPoint = Vector2.new(0.5, 0.5)
  Button.TextXAlignment = Enum.TextXAlignment.Center
  Button.Size = UDim2.new(0, 10, 0, 10)
  Button.BorderSizePixel = 0
  
  Button.MouseButton1Click:Connect(function()
    for _, class in next, game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks() do
      class:Stop()
    end
   
    local anim = game:GetObjects("rbxassetid://" .. tostring(v.id))[1]
    local loa = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
    loa:Play()
    loa:AdjustWeight(math.huge)
  end)
 end
end
    end
})

local CameraControl = Tabs.Main:AddSection("Camera Control")

CameraControl:AddButton({
  Title = "Camera: Infinity zoom",
  Description = "You can zoom out the camera as much as you want",
  Callback = function()
     game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
  end
})

CameraControl:AddButton({
  Title = "Camera: Refresh camera",
  Description = "You resume your camera",
  Callback = function()
    workspace.CurrentCamera:Remove() task.wait(wait())
    workspace.CurrentCamera.CameraType = "Custom"
    game.Players.LocalPlayer.CameraMode = "Classic"
    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
  end
})

CameraControl:AddToggle("MyToggle", {
  Title = "Camera: Noclip camera",
  Description = "Your camera can pass through objects",
  Default = false,
  Callback = function(Value)
    CNE = Value
for i, v in next, getgc() do
    if getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper and typeof(v) == "function" then
        for i2, v2 in next, debug.getconstants(v) do
            if tonumber(v2) == 0.25 and CNE == true then
                debug.setconstant(v, i2, 0)
            elseif tonumber(v2) == 0 and CNE == false then
                debug.setconstant(v, i2, 0.25)
            end
        end
    end
end
  end
})

local LightControl = Tabs.Main:AddSection("Light Control")

local Dropdown = LightControl:AddDropdown("Dropdown", {
    Title = "Light: Set time",
    Description = "Day or night. Light",
    Values = {"Day", "Night"},
    Multi = false,
    Default = "...",
})

Dropdown:OnChanged(function(Value)
  pcall(function()
    if Value == "..." then return end
    
    if Value == "Day" then
      game:GetService("Lighting").TimeOfDay = "12:00:00"
    elseif Value == "Night" then
      game:GetService("Lighting").TimeOfDay = "23:00:00"
    end
  end)
end)

LightControl:AddButton({
  Title = "Light: Remove all lighting effects",
  Description = "Removes all lighting effects including the sky. You won\'t be able to return it",
  Callback = function()
     game.Lighting:ClearAllChildren()
  end
})

LightControl:AddToggle("Toggle", {
  Title = "Light: Fullbright",
  Default = false,
  Description = "Illuminates everything forever, but does not remove the lighting effects. Fullbright",
  Callback = function(Value)
   eihe = Value
   if eihe == false then return end
   local con = game.Lighting.Changed:Connect(function()
     game.Lighting.Ambient = Color3.new(1, 1, 1)
     game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
     game.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
     game.Lighting.GlobalShadows = false
     game.Lighting.FogEnd = math.huge
     game.Lighting.FogStart = math.huge
     game.Lighting.TimeOfDay = "12:34:43"
     
     for _, ligh in next, game.Lighting:GetDescendants() do
       if ligh:IsA("PostEffect") then
         ligh:Destroy()
       end
     end
    end)
  game.Lighting.TimeOfDay = "12:34:43"
  task.spawn(function() repeat task.wait() until eihe == false con:Disconnect() end)
  end
})

local ProximityControl = Tabs.Main:AddSection("ProximityPrompt Control")

ProximityControl:AddToggle("Defense", {
  Title = "ProximityPrompt: Instant activation",
  Description = "You instantly activate ProximityPrompt",
  Default = false,
  Callback = function(Value)
    uueme = Value
local con = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(promp)
  fireproximityprompt(promp, 0)
end)
task.spawn(function() repeat task.wait() until uueme == false con:Disconnect() end)
  end
})

local CoreControl = Tabs.Main:AddSection("Core Gui Control")

CoreControl:AddButton({
  Title = "CoreGui: Enable Backpack",
  Description = "Enables CoreGui Backpack",
  Callback = function(Value)
     game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
  end
})

CoreControl:AddButton({
  Title = "CoreGui: Enable PlayerList",
  Description = "Enables CoreGui PlayerList",
  Callback = function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, true) 
  end
})

CoreControl:AddButton({
  Title = "CoreGui: Enable Health",
  Description = "Enables CoreGui Health",
  Callback = function()
     game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
  end
})

CoreControl:AddButton({
  Title = "CoreGui: Enable Chat",
  Description = "Enables CoreGui Chat",
  Callback = function()
     game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
  end
})

CoreControl:AddButton({
  Title = "CoreGui: Enable AvatarSwitcher",
  Description = "Enables CoreGui AvatarSwitcher",
  Callback = function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.AvatarSwitcher, true)
  end
})

CoreControl:AddButton({
  Title = "CoreGui: Enable all",
  Description = "Enables all CoreGui",
  Callback = function()
     game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
  end
})

CoreControl:AddToggle("Toggle", {
  Title = "CoreGui: Disable console",
  Description = "This function disables dev console",
  Default = false,
  Callback = function(Value)
    if game.CoreGui:FindFirstChild("DevConsoleMaster") then
      game.CoreGui.DevConsoleMaster.Enabled = not Value
    end
  end
})

local SoundControl = Tabs.Main:AddSection("Sound Control")

SoundControl:AddButton({
    Title = "Sound: Reset ambient reverb",
    Description = "Reset Ambient Reverb (Removes global echo or something like that if it exists). Sound",
    Callback = function()
        game:GetService("SoundService"):ResetPropertyToDefault("AmbientReverb")
    end
})

SoundControl:AddToggle("MyToggle", {
  Title = "Sound: Mute sounds",
  Description = "All sounds in the game will be turned off",
  Default = false,
  Callback = function(Value)
     UserSettings():GetService("UserGameSettings").MasterVolume = (Value == true and 0 or 1)
  end
})

local TeleportControl = Tabs.Main:AddSection("Place Teleport Control")

local function makedialogue(callback)
  local calb = Instance.new("BindableFunction")
  calb.OnInvoke = function(action: string)
    if action == "Yes" then
      callback()
    elseif action == "No" then
      return 
    end
  end
  
  game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Budgie Hub",
    Text = "Confirm teleportation?",
    Duration = math.huge,
    Button1 = "Yes",
    Button2 = "No",
    Callback = calb
  })
end

TeleportControl:AddButton({
  Title = "Teleport: Rejoin",
  Description = "Teleports you to the server you are currently on",
  Callback = function()
    makedialogue(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer) end)
  end
})

TeleportControl:AddButton({
  Title = "Teleport: Server hop",
  Description = "Teleports you to a random server",
  Callback = function()
    makedialogue(function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
  end
})

TeleportControl:AddButton({
  Title = "Teleport: Smallest server",
  Description = "Teleports you to the server with the smallest population",
  Callback = function()
   makedialogue(function()
local servers = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
  if #servers > 0 then
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[1].id, game.Players.LocalPlayer)
  end
  end)
  end
})

TeleportControl:AddButton({
  Title = "Teleport: Biggest server",
  Description = "Teleports you to the server with the largest population",
  Callback = function()
    makedialogue(function()
   local servers = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data
  if #servers > 0 then
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[1].id, game.Players.LocalPlayer)
  end
  end)
  end
})

local CarControl = Tabs.Main:AddSection("Vehicle Control")

local Dropdown = CarControl:AddDropdown("Dropdown", {
    Title = "Vehicle: Send vehicle into the void",
    Description = "Current vehicle or all vehicles",
    Values = {"Current", "All"},
    Multi = false,
    Default = "...",
})

Dropdown:OnChanged(function(Value)
  pcall(function()
   if Value == "..." then return end
    local function FindCar(instance)
  local current = instance.Parent
  
  local function FindPart(inst: Instance, partname: string)
    for _, part in next, inst:GetChildren() do
      if part:IsA("BasePart") and string.find(string.lower(part.Name), partname) then
        return part
      end
    end
    return nil
  end

  while current ~= nil and current ~= workspace and current ~= game do
    if current:IsA("Model") and (current.Name:lower():find("car") or current.Name:lower():find("vehicle") or FindPart(current, "wheel")) then
      return current
    end
    current = current.Parent
  end

  return nil
end

    if Value == "Current" then
     local posit = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
FindCar(game.Players.LocalPlayer.Character.Humanoid.SeatPart):PivotTo(CFrame.new(0, workspace.FallenPartsDestroyHeight + 10, 0))
game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
  task.wait(wait())
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = posit
    else
   local posit = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
for _, seat in next, game.Workspace:GetDescendants() do
  if seat:IsA("VehicleSeat") and seat.Occupant == nil and FindCar(seat) and seat.Disabled == false then
    game.Players.LocalPlayer.SimulationRadius = math.huge
    repeat task.wait() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame until seat.Occupant == game.Players.LocalPlayer.Character.Humanoid
    repeat task.wait() FindCar(game.Players.LocalPlayer.Character.Humanoid.SeatPart):PivotTo(CFrame.new(0, workspace.FallenPartsDestroyHeight + 10, 0)) until FindCar(game.Players.LocalPlayer.Character.Humanoid.SeatPart):GetPivot() == CFrame.new(0, workspace.FallenPartsDestroyHeight + 10, 0)
      task.wait(wait())
    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    repeat task.wait() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = posit until game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame == posit
  end
end
    end
  end)
end)

CarControl:AddButton({
    Title = "Vehicle: Grab all vehicles",
    Description = "Grabs all vehicles to you. May contain bugs",
    Callback = function()
        local function FindCar(instance)
  local current = instance.Parent
  
  local function FindPart(inst: Instance, partname: string)
    for _, part in next, inst:GetChildren() do
      if part:IsA("BasePart") and string.find(string.lower(part.Name), partname) then
        return part
      end
    end
    return nil
  end

  while current ~= nil and current ~= workspace and current ~= game do
    if current:IsA("Model") and (current.Name:lower():find("car") or current.Name:lower():find("vehicle") or FindPart(current, "wheel")) then
      return current
    end
    current = current.Parent
  end

  return nil
end

local posit = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
for _, seat in next, game.Workspace:GetDescendants() do
  if seat:IsA("VehicleSeat") and seat.Occupant == nil and FindCar(seat) and seat.Disabled == false then
    game.Players.LocalPlayer.SimulationRadius = math.huge
    repeat task.wait() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame until seat.Occupant == game.Players.LocalPlayer.Character.Humanoid
    repeat task.wait() FindCar(game.Players.LocalPlayer.Character.Humanoid.SeatPart):PivotTo(posit) until FindCar(game.Players.LocalPlayer.Character.Humanoid.SeatPart):GetPivot() == posit
      task.wait(wait())
    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
  end
end
    end
})

CarControl:AddButton({
  Title = "Vehicle: Annoying car",
  Description = "Very quickly teleports your vehicle to all players until you stop sitting on her",
  Callback = function()
  local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    repeat task.wait()
for _, seat in next, game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent:GetDescendants() do
  if seat:IsA("Seat") and seat.Occupant == nil then
    for _, plr in next, game.Players:GetPlayers() do
      if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChildWhichIsA("BasePart") then
        game.Players.LocalPlayer.SimulationRadius = math.huge
        settings().Physics.AllowSleep = false
        seat.CFrame = plr.Character:FindFirstChildWhichIsA("BasePart").CFrame
        if seat:FindFirstChildWhichIsA("TouchTransmitter") then
         firetouchinterest(seat, plr.Character:FindFirstChildWhichIsA("BasePart"), 0)
         firetouchinterest(seat, plr.Character:FindFirstChildWhichIsA("BasePart"), 1)
       end
       task.wait()
      end
    end
  end
end
until not game.Players.LocalPlayer.Character.Humanoid.SeatPart
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos

    for _, part in next, game.Players.LocalPlayer.Character:GetDescendants() do
      if part:IsA("BasePart") then
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
      end
    end
  end
})

local HapticControl = Tabs.Main:AddSection("Haptic Control")

HapticControl:AddButton({
  Title = "Haptic: Vibrate",
  Description = "A clear example of how haptic works. It only work if you have vibration motor",
  Callback = function()
     if game:GetService("HapticService"):IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
      game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.2)
        task.wait(0.3)
      game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
     else
       error("Your device don\'t have motor", 0)
    end
  end
})

HapticControl:AddToggle("MyToggle", {
  Title = "Haptic: Disable haptic",
  Description = "Your device is not haptic (vibrates). This can be disabled in the normal settings",
  Default = false,
  Callback = function(Value)
     sethiddenproperty(UserSettings():GetService("UserGameSettings"), "HapticStrength", Value == true and 0 or 1)
  end
})

local ClientControl = Tabs.Main:AddSection("Client Control")

local Dropdown = ClientControl:AddDropdown("Dropdown", {
    Title = "Client: Set device orientation",
    Description = "Sets the screen orientation of your device. Client",
    Values = {"LandscapeLeft", "LandscapeRight", "LandscapeSensor", "Portrait", "Sensor"},
    Multi = false,
    Default = "",
})

Dropdown:OnChanged(function(Value)
   if pcall(function() return Enum.ScreenOrientation[Value] end) then
     game.Players.LocalPlayer.PlayerGui.ScreenOrientation = Enum.ScreenOrientation[Value]
   end
end)

ClientControl:AddToggle("Defense", {
  Title = "Client: Set premium",
  Description = "Makes you look with premium, but visually. Client",
  Default = false,
  Callback = function(Value)
     if Value == true then
       sethiddenproperty(game.Players.LocalPlayer, "MembershipTypeReplicate", Enum.MembershipType.Premium)
     else
       sethiddenproperty(game.Players.LocalPlayer, "MembershipTypeReplicate", Enum.MembershipType.None)
     end
  end
})

local ClientAntiKickEnabled = false
local GamepassBypassEnabled = false
pcall(function()
   local hook; hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if ClientAntiKickEnabled then
      if self == game.Players.LocalPlayer and table.find({"Kick", "Destroy", "Remove", "ClearAllChildren"}, getnamecallmethod()) then
        return nil
      elseif self == game.Players and table.find({"Destroy", "Remove", "ClearAllChildren", "ResetLocalPlayer"}, getnamecallmethod()) then
        return nil
      elseif self == game and table.find({"Shutdown"}, getnamecallmethod()) then
        return nil
      end
    elseif GamepassBypassEnabled then
      if not checkcaller() and (self == game.GetService(game, "MarketplaceService") and table.find({"UserOwnsGamePassAsync", "PlayerOwnsAssetAsync", "PlayerOwnsBundleAsync"}, getnamecallmethod())) or (self == game.GetService(game, "BadgeService") and table.find({"UserHasBadge"}, getnamecallmethod())) then
        return true 
      end
    end
    return hook(self, ...)
  end))
end)

ClientControl:AddToggle("Defense", {
  Title = "Client: Client anti kick",
  Description = "Protects you from client-side kicks. It may not work if you don\'t have a hookmetamethod, getnamecallmethod and newcclosure",
  Default = false,
  Callback = function(Value)
     ClientAntiKickEnabled = Value
  end
})

ClientControl:AddToggle("Defense", {
  Title = "Client: Gamepass bypass",
  Description = "Makes you think client scripts that you own this gameplay, but the keyword is only for the client side, for server side you don't still own it",
  Default = false,
  Callback = function(togle)
    GamepassBypassEnabled = togle
  end
})

ClientControl:AddButton({
  Title = "Client: Server-side reset",
  Description = "You\'re doing a reset as if the server killed you. Client",
  Callback = function()
    if replicatesignal == nil then
      error("Where is replicatesignal?", 0)
    end
    replicatesignal(game.Players.LocalPlayer.Kill)
  end
})

ClientControl:AddToggle("Defense", {
  Title = "Client: Disable controls",
  Description = "All module scripts that control your character will be disabled. Client",
  Default = false,
  Callback = function(Value)
     if Value == true then
       require(game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule):GetControls():Disable()
       sethiddenproperty(game:GetService("GuiService"), "TouchControlsEnabled", false)
       if game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui") then
         game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui").Enabled = false
       end
     else
       require(game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule):GetControls():Enable()
       sethiddenproperty(game:GetService("GuiService"), "TouchControlsEnabled", true)
       if game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui") then
         game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui").Enabled = true
       end
     end
  end
})

local SettingsControl = Tabs.Main:AddSection("Experimental Control")

SettingsControl:AddToggle("Defense", {
  Title = "Experimental: Show controlled parts",
  Description = "Shows the parts that you can control – white: you don\'t have control, red: in the process of controlling, the color of your parts: you have control over the part. Experimental",
  Default = false,
  Callback = function(Value)
     settings().Physics.AreOwnersShown = Value
  end
})

SettingsControl:AddToggle("Defense", {
  Title = "Experimental: Enable physics throttling",
  Description = "Always includes Throttle to the parts (physics lags so as not to reduce FPS). This feature can break the physics of the parts and your character. Experimental",
  Default = false,
  Callback = function(Value)
    if Value == true then
      settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
      settings().Physics.ThrottleAdjustTime = 50
    else
      settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
      settings().Physics.ThrottleAdjustTime = 1
    end
  end
})

SettingsControl:AddToggle("Defense", {
  Title = "Experimental: Visualize clients simulation",
  Description = "Shows what the distribution of your simulation looks like for network ownership and other players. Experimental",
  Default = false,
  Callback = function(Value)
    settings().Physics.AreRegionsShown = Value
  end
})

SettingsControl:AddToggle("Defense", {
  Title = "Experimental: Collision debugging",
  Description = "Shows detailed information about which parts you are currently in contact with. Experimental",
  Default = false,
  Callback = function(Value)
     settings().Physics.AreCollisionCostsShown = Value
  end
})

local FFlagControl = Tabs.Main:AddSection("FFlags Control")
FFlagControl:AddParagraph({
    Title = "",
    Content = "For security reasons, all these FFlags are reset when you exit the game"
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: FontSizePadding",
    Description = "Changes the text size in the ENTIRE app and in the entire game. FFlag",
    Default = "1",
    Placeholder = "int",
    Numeric = true, 
    Finished = true, 
    Callback = function(Value)
       if Value == "" then
         setfflag("FontSizePadding", "1")
       else
        setfflag("FontSizePadding", tostring(Value))
      end
    end
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: TouchSenderMaxBandwidthBps",
    Description = "Determines how quickly the event is fired part.Touched on your character. FFlag",
    Default = "12940",
    Placeholder = "int",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
      if Value == "" then
        setfflag("TouchSenderMaxBandwidthBps", "12940")
      else
        setfflag("TouchSenderMaxBandwidthBps", tostring(Value))
      end
    end
})

local Input = FFlagControl:AddToggle("Input", {
    Title = "FFlag: SkyUseRGBEEncoding",
    Description = "Makes the sky black. FFlag",
    Default = false,
    Callback = function(Value)
        setfflag("SkyUseRGBEEncoding", tostring(Value))
    end
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: RaycastMaxDistance",
    Description = "Sets a limit size for Ray.new including HipHeight of humanoids. FFlag",
    Default = "15000",
    Placeholder = "int",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
      if Value == "" then
        setfflag("RaycastMaxDistance", "15000")
      else
        setfflag("RaycastMaxDistance", tostring(Value))
      end
    end
})

FFlagControl:AddToggle("Defense", {
  Title = "FFlag: DebugDrawBroadPhaseAABBs",
  Description = "Highlights hitboxes of humanoids and parts. FFlag",
  Default = false,
  Callback = function(Value)
     setfflag("DebugDrawBroadPhaseAABBs", tostring(Value))
  end
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: TaskSchedulerTargetFps",
    Description = "Sets a limit on FPS. 0 is the device\'s default. FFlag",
    Default = "0",
    Placeholder = "int",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
      if Value == "" then
        setfflag("TaskSchedulerTargetFps", "0")
      else
        setfflag("TaskSchedulerTargetFps", tostring(Value))
      ene
    end
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: DebugShowFlagState",
    Description = "Shows the status of FFlag",
    Default = "",
    Placeholder = "fflagName: string",
    Numeric = false,
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
        setfflag("DebugShowFlagState", tostring(Value))
    end
})

FFlagControl:AddToggle("Defense", {
  Title = "FFlag: DebugLightGridShowChunks",
  Description = "This FFlag draws chunks like in Minecraft",
  Default = false,
  Callback = function(Value)
     setfflag("DebugLightGridShowChunks", tostring(Value))
  end
})

local Input = FFlagControl:AddInput("Input", {
    Title = "FFlag: PhysicsSenderMaxBandwidthBps",
    Description = "This FFlag controls the speed at which physics is sent. If you set it to 0, the player will be frozen for the server side",
    Default = "38760",
    Placeholder = "int",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
      if Value == "" then
        setfflag("PhysicsSenderMaxBandwidthBps", "38760")
      else
        setfflag("PhysicsSenderMaxBandwidthBps", tostring(Value))
      end
    end
})

game:GetService("Players").PlayerRemoving:Connect(function(plr)
  if plr == game.Players.LocalPlayer then
    setfflag("FontSizePadding", "1")
    setfflag("TouchSenderMaxBandwidthBps", "12940")
    setfflag("SkyUseRGBEEncoding", "false")
    setfflag("RaycastMaxDistance", "15000")
    setfflag("DebugDrawBroadPhaseAABBs", "false")
    setfflag("TaskSchedulerTargetFps", "0")
    setfflag("DebugShowFlagState", "")
    setfflag("DebugLightGridShowChunks", "False")
    setfflag("PhysicsSenderMaxBandwidthBps", "38760")
  end
end)



Tabs.Finders:AddButton({
  Title = "Dex explorer",
  Description = "A handy tool that imitates a roblox studio explorer",
  Callback = function()
     loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
  end
})

Tabs.Finders:AddButton({
  Title = "Tool gun",
  Description = "My special tool with special modes. 1 mod copies the full name of the object you clicked on, 2 displays in the console the value of all parameters of the object you clicked on, 3 mod gets all the descendants of the object you clicked on and there are other modes",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/Tool_gun.luau"))()
  end
})

Tabs.Finders:AddButton({
  Title = "Remote spy",
  Description = "Shows all RemoteEvent and RemoteFunction in a special menu which you run",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
  end
})

Tabs.Finders:AddButton({
  Title = "Animation logger",
  Description = "Receives ContentId animations that you play",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/Animation-Logger/main/Gui"))()
  end
})

Tabs.Finders:AddButton({
  Title = "Audio logger",
  Description = "Get information about sounds",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHUOriginal/refs/heads/main/Guis/AudioLoggerV2"))()
  end
})

Tabs.Finders:AddButton({
   Title = "Texture Provider",
   Description = "Finding all textures in the game. This is my old script",
   Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU/refs/heads/main/Special/TextureProvider"))()
   end
})

Tabs.Finders:AddButton({
  Title = "Subplace finder",
  Description = "Gets all places (even hidden ones) from the creator of the current place. If you have a delta and the \"Verified teleports\" feature is enabled then you won\'t be able to teleport",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHUOriginal/refs/heads/main/Guis/SubplaceFinder"))()
  end
})

Tabs.Finders:AddButton({
  Title = "Http spy",
  Description = "Get all links that are launched on your client",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/Scripts/refs/heads/master/HttpsSpy.lua"))()
  end
})

local Input = Tabs.Finders:AddInput("Input", {
    Title = "Search scripts on scriptblox",
    Description = "Shows you the scripts that were found in scriptblox by the given name",
    Default = "",
    Placeholder = "name",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Search result"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local Frame = Instance.new("Frame", gui)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 250, 0, 250)
Frame.BackgroundTransparency = 0.1
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Position = UDim2.new(0.35, 0, 0.2, 0)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Position = UDim2.new(0, 50, 0, -5)
Title.Text = "Search result"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local List = Instance.new("ScrollingFrame", Frame)
List.Size = UDim2.new(0, 200, 0, 200)
List.ScrollBarThickness = 5
List.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
List.Position = UDim2.new(0, 23, 0, 21)
List.BorderSizePixel = 0
List.BackgroundTransparency = 0.1

local Layout = Instance.new("UIGridLayout", List)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.CellSize = UDim2.new(0, 200, 0, 20)
Layout.CellPadding = UDim2.new(0, 5, 0, 5)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
  List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Text = "X"
Close.Position = UDim2.new(1, 0, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundTransparency = 1

Close.MouseButton1Click:Connect(function()
  gui:Destroy()
end)

local namescr = game:GetService("HttpService"):UrlEncode(Value)
local scripts = game.HttpService:JSONDecode(game:HttpGet("https://scriptblox.com/api/script/search?q=" .. namescr)).result.scripts
for i, scrip in next, scripts do
  local Button = Instance.new("TextButton", List)
  Button.Text = scrip.slug
  Button.BackgroundColor3 = List.BackgroundColor3
  Button.TextColor3 = Color3.new(1, 1, 1)
  Button.TextScaled = true
  Button.Position = UDim2.new(0.5, 0, 0.5, 0)
  Button.AnchorPoint = Vector2.new(0.5, 0.5)
  Button.TextXAlignment = Enum.TextXAlignment.Center
  Button.Size = UDim2.new(0, 10, 0, 10)
  Button.BorderSizePixel = 0
  
  Button.MouseButton1Click:Connect(function()
    loadstring(scrip.script)()
  end)
end
    end
})

local Section = Tabs.Finders:AddSection("Finders")

Tabs.Finders:AddButton({
   Title = "Open console",
   Description = "Opening the console window. Anti console scripts can be detect this",
   Callback = function()
     game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
   end
})

Tabs.Finders:AddButton({
  Title = "Copy self position",
  Description = "Gets your HumanoidRootPart position",
  Callback = function()
    setclipboard(tostring(Vector3.new(math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X), math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y), math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z))))
  end
})

Tabs.Finders:AddButton({
  Title = "Copy place info",
  Description = "Gets information about this place",
  Callback = function()
    setclipboard(`Place Id: {game.PlaceId}\nGame Id: {game.GameId}\nCreator Id: {game.CreatorId}`)
  end
})

Tabs.Finders:AddButton({
  Title = "Copy self information",
  Description = "Copies your information, such as client ID, HWID and more",
  Callback = function()
    local deviceId = game:GetService("DeviceIdService"):GetDeviceId()
    local gitHash = gethiddenproperty(game:GetService("RunService"), "ClientGitHash")
    local Useragent = game:GetService("HttpService"):GetUserAgent()
    local IP = game:GetService("HttpService"):JSONDecode(request({Url = "https://httpbin.org/get", Method = "GET"}).Body).origin
    setclipboard("Client ID: " .. tostring(game:GetService("RbxAnalyticsService"):GetClientId()) .. "\nHardware ID: " .. gethwid() .. "\nExploit name: " .. identifyexecutor() .. "\nDevice ID: " .. deviceId .. "\nClient git hash: " .. gitHash .. "\nUser Agent: " .. Useragent .. "\nYour IP: " .. tostring(IP))
  end
})

local AntiConsoleBypass = false
local suc, res = pcall(function()
  local hook; hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not checkcaller() and self == game.StarterGui and (getnamecallmethod() == "SetCore" or getnamecallmethod() == "GetCore") then
      if AntiConsoleBypass == false then return hook(self, ...) end
      local args = {...}
      if #args > 0 and args[1] == "DevConsoleVisible" then
        return nil
      end
    end
    return hook(self, ...)
  end))
end)

if not suc then
  BudgieHub:Notify({
        Title = "Budgie Hub Notification",
        Content = "Error",
        SubContent = "Functions for console\'s anti-detection is missing or something went wrong. Anti console bypass won\'t work\nError: ".. res,
        Duration = 10
  })
end

Tabs.Finders:AddToggle("MyToggle", {
  Title = "Anti console bypass",
  Description = "Anti-detect scripts don\'t see that you\'ve opened the console. This script uses hookmetamethod, checkcaller, getnamecallmethod and newcclosure so you must have these exploit functions so that you can use this",
  Default = false,
  Callback = function(Value)
    AntiConsoleBypass = Value
  end
})

Tabs.Finders:AddButton({
   Title = "Print all local scripts",
   Description = "Outputs all local scripts to the console. There\'s no point in outputting server-side scripts",
   Callback = function()
     for _, lc in next, game:GetDescendants() do
       if lc:IsA("LocalScript") then
         print(lc:GetFullName())
       end
     end
   end
})

Tabs.Finders:AddButton({
   Title = "Print all module scripts",
   Description = "Outputs all module scripts from the game and function getloadedmodules to the console",
   Callback = function()
      local as = {}
      for _, modul in next, game:GetDescendants() do
         if modul:IsA("ModuleScript") and not table.find(as, modul) then
           table.insert(as, modul)
           print(modul:GetFullName())
         end
      end
      
      for _, modul in next, getloadedmodules() do
        if modul:IsA("ModuleScript") and not table.find(as, modul) then
          table.insert(as, modul)
          print(modul:GetFullName())
        end
      end
   end
})

Tabs.Finders:AddButton({
   Title = "Print all local player value bases",
   Description = "Print all local player, character and humanoid value bases",
   Callback = function()
     for _, val in next, game.Players.LocalPlayer:GetDescendants() do
       if val:IsA("ValueBase") then
         print(val.ClassName, val:GetFullName(), val.Value)
       end
     end
     
     for _, val in next, game.Players.LocalPlayer.Character:GetDescendants() do
       if val:IsA("ValueBase") then
         print(val.ClassName, val:GetFullName(), val.Value)
       end
     end
   end
})

Tabs.Finders:AddButton({
   Title = "Print all local player attributes",
   Description = "Print all local player, character, humanoid attributes",
   Callback = function()
     for atname, atval in next, game.Players.LocalPlayer:GetAttributes() do
       print(game.Players.LocalPlayer:GetFullName(), atname, atval)
     end
     
     for _, desc in next, game.Players.LocalPlayer:GetDescendants() do
       for atname, atval in next, desc:GetAttributes() do
         print(desc:GetFullName(), atname, atval)
       end
     end
     
     for atname, atval in next, game.Players.LocalPlayer.Character:GetAttributes() do
       print(game.Players.LocalPlayer:GetFullName(), atname, atval)
     end
     
     for _, desc in next, game.Players.LocalPlayer.Character:GetDescendants() do
       for atname, atval in next, desc:GetAttributes() do
         print(desc:GetFullName(), atname, atval)
       end
     end
   end
})

Tabs.Finders:AddSection("Encrypt string")

Tabs.Finders:AddInput("jd", {
  Title = "To ASCII",
  Description = "This is ascii bytes. They are automatically decrypted in the compiler at startup and it is enough to do \"return asciiText\"",
  Default = "",
  Placeholder = "Any text",
  Numberic = false,
  Finished = true,
  Callback = function(text)
    
  end
})

Tabs.Finders:AddInput("Ue", {
  Title = "To HEX",
  Description = "This is Hex format (the hexadecimal system)",
  Default = "",
  Placeholder = "Any text",
  Numberic = false,
  Finished = true,
  Callback = function(text)
    
  end 
})

Tabs.Finders:AddInput("ue", {
  Title = "To Base64",
  Description = "This is base64 format",
  Default = "",
  Placeholder = "Any text",
  Numberic = false,
  Finished = true,
  Callback = function(text)
    local encode = (base64 and rawget(base64, "encode")) or base64_encode
    setclipboard(encode(text))
  end
})



local Section = Tabs.Extra:AddSection("Tools")

local Dropdown = Tabs.Extra:AddDropdown("Dropdown", {
    Title = "Custom tools",
    Description = "My custom tools created by me",
    Values = {"Rainbow Coil", "Jump Boots", "Particle Evaporator", "Energy Sphere", "Brazil Samba", "Part Morph", "Atomic Bomb"},
    Multi = false,
    Default = "",
})

Dropdown:OnChanged(function(Value)
    if Value == "Rainbow Coil" then
      loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/NewTool/refs/heads/main/Auxiliary/Rainbow%20coil"))()
     elseif Value == "Jump Boots" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/NewTool/refs/heads/main/Auxiliary/Jump%20Boots"))()
     elseif Value == "Particle Evaporator" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/NewTool/refs/heads/main/Range/Mythic/Particle%20Evaporator"))()
     elseif Value == "Energy Sphere" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/Tool_Energy_Sphere.luau"))()
     elseif Value == "Brazil Samba" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/Brazil_Samba.luau"))()
     elseif Value == "Part Morph" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/Part_Morph.luau"))()
     elseif Value == "Atomic Bomb" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/Atomic_Bomb.luau"))()
    end
end)

local Section = Tabs.Extra:AddSection("Special scripts")

Tabs.Extra:AddButton({
  Title = "Neko arc exe",
  Description = "By Tomato2007",
  Callback = function()
     loadstring(game:HttpGet("https://pastebin.com/raw/KW0NTUp6"))()
  end
})

Tabs.Extra:AddButton({
  Title = "Endless road",
  Description = "...",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/1PB/refs/heads/main/Endless%20Road%202"))()
  end
})

Tabs.Extra:AddButton({
  Title = "Morph in A60",
  Description = "You become A60. Made by me",
  Callback = function()
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Scripts/A60.luau"))()
  end
})



local Input = Tabs.Settings:AddInput("Input", {
    Title = "Set icon size",
    Description = "Sets the size of the icon (Multiplies the number by the original size) that turns the menu on or off",
    Default = "",
    Placeholder = "Default 1",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
        BHU2_Icon.Size = UDim2.new(0, math.floor(math.max(32, math.min(game.Players.LocalPlayer:GetMouse().ViewSizeX, game.Players.LocalPlayer:GetMouse().ViewSizeY) * 0.15)) * math.clamp(Value, 0.3, 3), 0, math.floor(math.max(32, math.min(game.Players.LocalPlayer:GetMouse().ViewSizeX, game.Players.LocalPlayer:GetMouse().ViewSizeY) * 0.15)) * math.clamp(Value, 0.3, 3))
        if tonumber(Value) < 0.3 then Input:SetValue(0.3)
        elseif tonumber(Value) > 3 then Input:SetValue(3) end
    end
})

local Toggle = Tabs.Settings:AddToggle("MyToggle", {
    Title = "Hide icon", 
    Description = "Hides or shows the icon",
    Default = false,
    Callback = function(state)
       BHU2_Icon.Visible = not state
    end 
})

Tabs.Settings:AddToggle("MyToggle", {
  Title = "Align window",
  Description = "Aligns the menu to the size of your screen",
  Default = false,
  Callback = function(Value)
    udhdb = Value
     if udhdb == true then
       Window.Root.Size = UDim2.new(0.7, 0, 1, 0) 
     else
       Window.Root.Size = UDim2.fromOffset(580, 460)
     end
  end
})

Tabs.Settings:AddToggle("Defense", {
  Title = "Disable list configuration in main tab",
  Description = "Disables all control buttons in the main tab (like \"↑\")",
  Default = true,
  Callback = function(Value)
     buttons_config.Parent = (Value == true and game or Value == false and conta.Parent.Parent)
  end
})

Tabs.Settings:AddToggle("Anti afk", {
  Title = "Anti afk",
  Description = "You won\'t get kicked if you\'re AFK for more than 20 minutes",
  Default = false,
  Callback = function(Value)
    for _, con in next, getconnections(game.Players.LocalPlayer.Idled) do
      if Value == true then con:Disable() else con:Enable() end
    end
  end
})

Tabs.Settings:AddToggle("Defense", {
  Title = "Disable gameplay paused",
  Description = "Removes the menu that stops gameplay",
  Default = false,
  Callback = function(Value)
    game:GetService("GuiService"):SetGameplayPausedNotificationEnabled(not Value)
  end
})

local queueonteleport = queueonteleport or queue_on_teleport
writefile("BHU2/ExecuteAgainAfterRejoining", "false")
Tabs.Settings:AddToggle("MyToggle", {
  Title = "Execute after rejoining",
  Description = "When you rejoining or teleport to another place, the script executing again",
  Default = false,
  Callback = function(Value)
     writefile("BHU2/ExecuteAgainAfterRejoining", tostring(Value))
  end
})

pcall(function()
queueonteleport([[
  if isfolder("BHU2") and isfile("BHU2/ExecuteAgainAfterRejoining") and readfile("BHU2/ExecuteAgainAfterRejoining") == "true" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/BudgieHubUniversal2.lua"))()
  end
]])
end)

Tabs.Settings:AddInput("Input", {
  Title = "Restore exploit function",
  Description = "Restores the exploit function by name. To see the entire list of functions, then enter !list in textbox",
  Default = "",
  Placeholder = "isnetworkowner and etc",
  Numeric = false,
  Finished = true,
  Callback = function(value)
    if value ~= "!list" then
    local str = (value:gsub(" ", ""):gsub("%c", "") .. ".luau"):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
    
    local suc, res = pcall(function()
      return game:HttpGetAsync("https://raw.githubusercontent.com/ADSKerOffical/Budgify/refs/heads/main/Exploit/Functions/Source/" .. str)
    end)
    
    if suc then
      loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ADSKerOffical/Budgify/refs/heads/main/Exploit/Functions/Source/" .. str))()
      BudgieHub:Notify({
         Title = "Budgie Hub",
         Content = "Function " .. str:gsub(".luau", "") .. " has been restored",
         SubContent = "",
         Duration = 5
       })
    else
      BudgieHub:Notify({
        Title = "Budgie Hub",
        Content = "Function " .. str:gsub(".luau", "") .. " do not exist or I did not make the source code",
        SubContent = "",
        Duration = 5
      })
    end
    elseif value == "!list" then
      local tabl = {}
      for i, v in game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/ADSKerOffical/Budgify/contents/Exploit/Functions/Source?ref=main")) do
        local a = v.name:gsub(".luau", "")
        table.insert(tabl, a)
      end
      
      BudgieHub:Notify({
        Title = "Budgie Hub",
        Content = "List of all functions:",
        SubContent = table.concat(tabl, ", "),
        Duration = nil
      })
    end
  end
})

Tabs.Settings:AddInput("Input", {
  Title = "Load custom library",
  Description = "You can load my custom libraries and using it for your works. You can write !list if you want know all libraries and !loadall if you want using all libraries at once",
  Default = "",
  Placeholder = "Library name",
  Numberic = false,
  Finished = true,
  Callback = function(Value)
  
  end
}) 



Tabs.Creator:AddButton({
  Title = "Copy account link",
  Description = "Wow, it\'s me",
  Callback = function()
     (setclipboard or toclipboard or setrbxclipboard or (syn and syn.write_clipboard))("https://www.roblox.com/users/4636825706/profile")
  end
})

Tabs.Creator:AddButton({
  Title = "Copy telegram link",
  Description = "Holy shit, that\'s me too. If you want to write me something, write here. I\'m there 24/7",
  Callback = function()
    (setclipboard or toclipboard or setrbxclipboard or (syn and syn.write_clipboard))("https://t.me/Budgify")
  end
})

Tabs.Creator:AddButton({
  Title = "Copy discord link",
  Description = "This is me too. You can write about anything here, but I\'m rarely there",
  Callback = function()
     (setclipboard or toclipboard or setrbxclipboard or (syn and syn.write_clipboard))("https://discordapp.com/users/1096878275583803492")
  end
})

Tabs.Creator:AddButton({
  Title = "Copy scriptblox link",
  Description = "I\'m on scriptblox. You probably found the script there",
  Callback = function()
    (setclipboard or toclipboard or setrbxclipboard or (syn and syn.write_clipboard))("https://scriptblox.com/u/ADSKer")
  end
})

Tabs.Creator:AddButton({
  Title = "Copy tiktok link",
  Description = "My tiktok account. Maybe I\'ll share my knowledge and tutorials",
  Callback = function()
    (setclipboard or toclipboard or setrbxclipboard or (syn and syn.write_clipboard))("https://www.tiktok.com/@denis_grusin")
  end
})

local anonymousMess = false
Tabs.Creator:AddInput("jsj", {
  Title = "Feedback",
  Description = "You can send a message to my to offer me to make the functions for Budgie Hub Universal 2. I will write that idea suggested precisely you. But you can send a message once an 10 minutes and not too long",
  Default = "",
  Placeholder = "text",
  Numberic = false,
  Finished= true,
  Callback = function(text)
     if #readfile("BHU2/FeedbackCooldown") == 0 or (pcall(function() return tonumber(readfile("BHU2/FeedbackCooldown")) end) and tick() - tonumber(readfile("BHU2/FeedbackCooldown")) > 600) then
     local message = tostring(text:gsub("%c", ""):gsub("%p", ""):gsub("\\", "/"))
     local req = clonefunction(game:GetService("HttpService").RequestAsync)
     local name = game:HttpGet("https://users.roproxy.com/v1/users/" .. string.match(game.Players.LocalPlayer.CharacterAppearance, "&userId=(%d+)")):match('"name":"([^"]+)"')
     if anonymousMess == true then
       name = name .. " (Anonymous)" -- •⁠‿⁠•
       -- Не ну а вдруг мне кто-то херню будет отправлять
     end
     
     assert(string.len(message) > 3, "Message is too small")
     assert(string.len(message) <= 500, "Message is too big")
     
     local response = req(game:GetService("HttpService"), {
       Url = loadstring(game.HttpGetAsync(game, "https://raw.githubusercontent.com/ADSKerOffical/BHU2Project/refs/heads/main/Resources/Weebhook_link"))(),
       Method = "POST",
       Headers = {["Content-Type"] = "application/json", ["User-Agent"] = "Budgie Hub request"},
       Body =  [[{"content":"]] .. message .. [[","username":"]] .. name .. [["}]]
     })
     
     if response.Success == false then
       BudgieHub:Notify({
         Title = "Budgie Hub",
         Content = "Something went wrong and feedback doesn\'t sended. Body: " .. rawget(response, "Body"),
         SubContent = "",
         Duration = nil
       })
       return 
     end
     writefile("BHU2/FeedbackCooldown", tostring(tick()))
     BudgieHub:Notify({
       Title = "Budgie Hub",
       Content = "Feedback was been sended",
       SubContent = "",
       Duration = 5
     })
     elseif #readfile("BHU2/FeedbackCooldown") ~= 0 and tick() - tonumber(readfile("BHU2/FeedbackCooldown")) < 600 then
       error(`Don't forget that you can only send requests once an 10 minutes. You have {math.floor(600 - (tick() - tonumber(readfile("BHU2/FeedbackCooldown"))))} seconds left to wait`)
    end
  end
})

--[[pcall(function()
  local hook; hook = hookfunction(writefile, newcclosure(function(fileName, value)
    if getfenv(0).script ~= currentScript and fileName == "BHU2/FeedbackCooldown" then
      return 
    end
    return hook(fileName, value)
  end))
end)]]--

Tabs.Creator:AddToggle("Toggle", {
  Title = "Anonymous message",
  Description = "You can use this feature so I can't see who sent me the idea",
  Default = false,
  Callback = function(togle)
    anonymousMess = togle
  end
})

-- Meeting with me
pcall(function()
  BHU2:SetAttribute("MeetedWithOwner", false)
  
  game.Players.PlayerAdded:Connect(function(player)
    if player.UserId == 4636825706 and BHU2:GetAttribute("MeetedWithOwner") == false then
      BudgieHub:Notify({
         Title = "Budgie Hub",
         Content = `Who do I see? Wait, it\'s an ADSKer ({player.DisplayName})!! Creator of Budgie Hub!!!!!!!! You\'re lucky to have met me. I hope we will become friends`,
         SubContent = "",
         Duration = 15
       })
       BHU2:SetAttribute("MeetedWithOwner", true)
    end
  end)
  
  for _, player in next, game.Players:GetPlayers() do
    if player.UserId == 4636825706 and game.Players.LocalPlayer.UserId ~= 4636825706 and BHU2:GetAttribute("MeetedWithOwner") == false then
      BudgieHub:Notify({
        Title = "Budgie Hub",
        Content = `Who do I see? Wait, it\'s an ADSKer ({player.DisplayName})!! Create of Budgie Hub!!!!!!!! You\'re lucky to have met me. I hope we will become friends`,
        SubContent = "",
        Duration = 15
      })
      BHU2:SetAttribute("MeetedWithOwner", true)
    end
  end
end)

-- protect BHU2
pcall(function()
  local hook; hook = hookmetamethod(BHU2, "__namecall", newcclosure(function(self, ...)
    if getfenv(0).script ~= currentScript and (self == BHU2 or self.IsDescendantOf(self, BHU2)) then
      return nil
    end
    return hook(self, ...)
  end))
  
  local hook; hook = hookmetamethod(BHU2, "__newindex", newcclosure(function(self, index, value)
    if getfenv(0).script ~= currentScript and (self == BHU2 or self:IsDescendantOf(BHU2)) then
      return nil
    end
    return hook(self, index, value)
  end))
end)

--[[
  Ого, а ты довольно умён. Ты смог обойти мои защиты. Я горжусь тобой
  Wow, you're smart. You were able to bypass all my defenses. I'm proud of you
]]
