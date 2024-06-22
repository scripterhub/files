-- SimpleUILibrary ModuleScript
local SimpleUILibrary = {}

-- Function to create a new UI window
function SimpleUILibrary:CreateWindow(config)
    -- Configuration defaults
    local config = config or {}
    local shadowEnabled = config.Shadow or true
    local backgroundColor = config.BackgroundColor or Color3.new(1, 1, 1)
    local blurredBackground = config.BlurredBackground or false
    local size = config.Size or UDim2.new(0, 300, 0, 200)
    local topbarText = config.TopbarText or "Window"
    local topbarFont = config.TopbarFont or Enum.Font.SourceSans
    local topbarTextSize = config.TopbarTextSize or 14

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomWindow"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size
    mainFrame.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    mainFrame.BackgroundColor3 = backgroundColor
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = screenGui

    -- Create shadow
    if shadowEnabled then
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Image = "rbxassetid://1316045217" -- Example shadow image
        shadow.BackgroundTransparency = 1
        shadow.ImageTransparency = 0.5
        shadow.ZIndex = 0
        shadow.Parent = mainFrame
    end

    -- Create topbar
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 30)
    topbar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    topbar.BorderSizePixel = 0
    topbar.Parent = mainFrame

    local topbarLabel = Instance.new("TextLabel")
    topbarLabel.Size = UDim2.new(1, 0, 1, 0)
    topbarLabel.BackgroundTransparency = 1
    topbarLabel.Text = topbarText
    topbarLabel.Font = topbarFont
    topbarLabel.TextSize = topbarTextSize
    topbarLabel.TextColor3 = Color3.new(1, 1, 1)
    topbarLabel.Parent = topbar

    -- Enable dragging of the window
    local UIS = game:GetService("UserInputService")
    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Apply blurred background if needed
    if blurredBackground then
        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Size = 10
        blurEffect.Parent = game.Lighting
    end

    return screenGui, mainFrame
end

-- Function to add a script button
function SimpleUILibrary:AddScriptButton(window, config)
    -- Configuration defaults
    local config = config or {}
    local buttonImage = config.ButtonImage or "rbxassetid://3570695787"
    local onClick = config.OnClick or function() end

    -- Create button
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Image = buttonImage
    button.BackgroundTransparency = 1
    button.Parent = window

    button.MouseButton1Click:Connect(function()
        onClick()
        window:Destroy()
    end)
end

return SimpleUILibrary
