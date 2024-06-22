-- UI Library Module
local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Helper functions
local function create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Function to create the main window
function UILibrary:CreateWindow(config)
    local window = create("ScreenGui", {
        Name = "CustomWindow",
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })
    
    local blurEffect = create("BlurEffect", {
        Size = config.BlurSize or 24,
        Parent = game:GetService("Lighting")
    })

    local background = create("Frame", {
        Size = config.Size or UDim2.new(0, 400, 0, 300),
        BackgroundTransparency = config.BlurredBackground and 0.5 or 0,
        BackgroundColor3 = config.BackgroundColor or Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Parent = window
    })
    
    local shadow = create("ImageLabel", {
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.new(0, -12, 0, -12),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = background
    })

    local topBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        BorderSizePixel = 0,
        Parent = background
    })
    
    local title = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Window Title",
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Parent = topBar
    })
    
    local function makeDraggable(frame, handle)
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end
    
    makeDraggable(background, topBar)
    
    return window
end

-- Function to add a script button
function UILibrary:AddScriptButton(window, scriptToLoad)
    local scriptButton = create("ImageButton", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(1, -60, 1, -60),
        BackgroundTransparency = 1,
        Image = "rbxassetid://YOUR_IMAGE_ASSET_ID",
        Parent = window
    })
    
    scriptButton.MouseButton1Click:Connect(function()
        local newScript = Instance.new("Script")
        newScript.Source = scriptToLoad
        newScript.Parent = game.Workspace
        window:Destroy()
    end)
end

return UILibrary
