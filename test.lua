-- SimpleUILibrary ModuleScript

local SimpleUILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Function to create a new UI element
local function createUIElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    element.Parent = parent
    return element
end

-- Function to create the base window
function SimpleUILibrary:CreateBaseWindow(config)
    local screenGui = createUIElement("ScreenGui", {
        ResetOnSpawn = false,
    }, game.Players.LocalPlayer:WaitForChild("PlayerGui"))

    local blurEffect = createUIElement("BlurEffect", {
        Size = config.BlurSize or 24,
    }, game.Lighting)

    local baseFrame = createUIElement("Frame", {
        Size = config.Size or UDim2.new(0, 400, 0, 300),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 0.3,
    }, screenGui)

    local shadow = createUIElement("ImageLabel", {
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://1316045217", -- Shadow asset
        ImageTransparency = 0.5,
        BackgroundTransparency = 1,
    }, baseFrame)

    local topBar = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
    }, baseFrame)

    local topBarText = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.TopBarText or "Base Window",
        Font = config.TopBarFont or Enum.Font.SourceSans,
        TextSize = config.TopBarTextSize or 24,
        TextColor3 = Color3.fromRGB(255, 255, 255),
    }, topBar)

    -- Draggable functionality for topBar
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        baseFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = baseFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return screenGui, baseFrame
end

-- Function to create the AddScript button
function SimpleUILibrary:AddScriptButton(parent, config)
    local button = createUIElement("ImageButton", {
        Size = config.Size or UDim2.new(0, 50, 0, 50),
        Image = config.Image or "rbxassetid://0", -- Default image
        BackgroundTransparency = 1,
    }, parent)

    button.MouseButton1Click:Connect(function()
        parent:Destroy()
    end)

    return button
end

return SimpleUILibrary
