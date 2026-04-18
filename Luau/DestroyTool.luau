local tool = Instance.new("Tool", game.Players.LocalPlayer:WaitForChild("Backpack", 10))
tool.Name = "Destroy tool"
tool.ToolTip = "Destroying part which you clicked"

local handle = Instance.new("Part", tool)
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Material = Enum.Material.SmoothPlastic
handle.Color = Color3.new(1, 1, 1)

tool.Activated:Connect(function()
  local part = game.Players.LocalPlayer:GetMouse().Target
  if part then
    part:Destroy()
  end
end)
