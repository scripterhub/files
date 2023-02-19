hookfunction(game.Players.LocalPlayer.IsInGroup, function() return true end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nosssa/NossLock/main/AntiAimViewer"))()
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/scripterhub/files/main/1.lua"))()
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/scripterhub/files/main/1.lua"))()

Aiming.TeamCheck(false)



local Workspace = game:GetService("Workspace")

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")



local LocalPlayer = Players.LocalPlayer

local Mouse = LocalPlayer:GetMouse()

local CurrentCamera = Workspace.CurrentCamera


---------------------------------------------------------------
local DaHoodSettings = {
    
    SilentAim = true,

    AimLock = false,

    Prediction = 0.1,

    AimLockKeybind = Enum.KeyCode.E,

    Resolver = true,
    
}
--------------------------------------------------
getgenv().DaHoodSettings = DaHoodSettings                           
--------------------------------------------------- -fov 5.5-6.6 is legit
