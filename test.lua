-- UI Library Module
local UILibrary = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Function to create the main window
function UILibrary:CreateWindow(config)
    local screenGui = Instance.new("ScreenGui", playerGui)
    screenGui.Name = "CustomUI"
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Parent = game.Lighting
    blurEffect.Size = 0
    
    local window = Instance.new("Frame", screenGui)
    window.Name = "MainWindow"
    window.Size = config.Size or UDim2.new(0, 400, 0, 300)
    window.BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local shadow = Instance.new("ImageLabel", window)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    local topBar = Instance.new("Frame", window)
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    topBar.BorderSizePixel = 0
    
    local topBarLabel = Instance.new("TextLabel", topBar)
    topBarLabel.Name = "Title"
    topBarLabel.Size = UDim2.new(1, -10, 1, -10)
    topBarLabel.Position = UDim2.new(0, 5, 0, 5)
    topBarLabel.BackgroundTransparency = 1
    topBarLabel.Text = config.Title or "Title"
    topBarLabel.Font = config.TitleFont or Enum.Font.SourceSans
    topBarLabel.TextSize = config.TitleSize or 24
    topBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    topBarLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Function to make the window draggable
    local function makeDraggable(frame, handle)
        local dragging = false
        local dragInput, mousePos, framePos

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = input.Position
                framePos = frame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        RunService.Heartbeat:Connect(function()
            if dragging then
                local delta = game:GetService("UserInputService"):GetMouseLocation() - mousePos
                frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            end
        end)
    end

    makeDraggable(window, topBar)

    -- Blur in animation
    local blurTween = TweenService:Create(blurEffect, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 10})
    blurTween:Play()

    return window
end

-- Function to add an AddScript button
function UILibrary:AddScript(parent, config)
    local button = Instance.new("ImageButton", parent)
    button.Name = "AddScriptButton"
    button.Size = UDim2.new(0, 100, 0, 100)
    button.BackgroundTransparency = 1
    button.Image = config.Image or "rbxassetid://1234567890"
    button.Position = config.Position or UDim2.new(0, 0, 0, 0)

    button.MouseButton1Click:Connect(function()
        -- Destroy UI and unblur the screen
        local blurEffect = game.Lighting:FindFirstChildOfClass("BlurEffect")
        if blurEffect then
            local blurOutTween = TweenService:Create(blurEffect, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0})
            blurOutTween:Play()
            blurOutTween.Completed:Connect(function()
                blurEffect:Destroy()
            end)
        end
        parent.Parent:Destroy()
    end)
    
    return button
end

return UILibrary
