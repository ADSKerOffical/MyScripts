local getInfoAboutUser = newcclosure(function()
  local hiddenRequest = clonefunction(game.HttpService.RequestAsync)
  local decode = clonefunction(game.HttpService.JSONDecode)
  
  return {
    IP = rawget(decode(game.HttpService, hiddenRequest(game.HttpService, {Url = "https://httpbin.org/get", Method = "GET"}).Body), "origin"),
    Platform = tostring(game:GetService("UserInputService").GetPlatform(game.UserInputService)),
    DeviceType = tostring(game:GetService("UserInputService").GetDeviceType(game.UserInputService)),
    Exploit = (identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname()) or "UNKNOWN",
    HWID = (gethwid and gethwid()) or "UNKNOWN",
    CliendId = game.RbxAnalyticsService.GetClientId(game.RbxAnalyticsService),
    DeviceId = game:GetService("DeviceIdService"):GetDeviceId(),
    ID = tonumber(string.match(game.Players.LocalPlayer.CharacterAppearance, "&userId=(%d+)")) or "UNKNOWN",
    UserAgent = game.HttpService.GetUserAgent(game.HttpService),
    ClientGitHash = (gethiddenproperty and gethiddenproperty(game:GetService("RunService"), "ClientGitHash")) or "UNKNOWN"
  }
end)

for i, v in next, getInfoAboutUser() do
  print(i, v)
end
