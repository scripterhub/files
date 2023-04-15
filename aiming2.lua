                            local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/scripterhub/files/main/aiming.lua"))()
                            Aiming.TeamCheck(false)
                             
                            
                            local Workspace = game:GetService("Workspace")
                            local Players = game:GetService("Players")
                            local RunService = game:GetService("RunService")
                            local UserInputService = game:GetService("UserInputService")
                            
                            
                            local LocalPlayer = Players.LocalPlayer
                            local Mouse = LocalPlayer:GetMouse()
                            local CurrentCamera = Workspace.CurrentCamera
                            
                            local DaHoodSettings = {
                                SilentAim = true,
                                Prediction = 0.131,
                            }
                            getgenv().DaHoodSettings = DaHoodSettings
                            
                             local Workspace = game:GetService("Workspace")

                             local Players = game:GetService("Players")

                             local RunService = game:GetService("RunService")

                             local UserInputService = game:GetService("UserInputService")



                             local LocalPlayer = Players.LocalPlayer

                             local Mouse = LocalPlayer:GetMouse()

                             local CurrentCamera = Workspace.CurrentCamera

                            
                            function Aiming.Check()
                            -------------
                                if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
                                    return false
                                end
                            
                                -- // Check if downed
                                local Character = Aiming.Character(Aiming.Selected)
                                local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
                                local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                            
                                -- // Check B
                                if (KOd or Grabbed) then
                                    return false
                                end
                            
                                -- //
                                return true
                            end
                         
