local UIService = {}
UIService.__index = UIService

local TweenService = game:GetService("TweenService")
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = game.Lighting

local function createDraggableWindow(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local blurTweenIn = TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 15})
    blurTweenIn:Play()

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = config.Size or UDim2.new(0.3, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = config.BackgroundTransparency or 0.5
    mainFrame.Parent = screenGui

    if config.Shadow then
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageTransparency = 0.5
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.Parent = mainFrame
    end

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    topBar.Parent = mainFrame

    local topBarText = Instance.new("TextLabel")
    topBarText.Text = config.TopBarText or "Window"
    topBarText.Font = config.TopBarFont or Enum.Font.SourceSans
    topBarText.TextSize = config.TopBarTextSize or 24
    topBarText.Size = UDim2.new(1, 0, 1, 0)
    topBarText.TextColor3 = Color3.fromRGB(255, 255, 255)
    topBarText.BackgroundTransparency = 1
    topBarText.Parent = topBar

    local isDragging = false
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if isDragging then
                update(input)
            end
        end
    end)

    return screenGui, mainFrame
end

local function createAddScriptButton(config, parent)
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0, 100, 0, 100)
    button.Image = config.Image or "rbxassetid://6031068420"
    button.Parent = parent

    button.MouseButton1Click:Connect(function()
        local blurTweenOut = TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 0})
        blurTweenOut:Play()

        blurTweenOut.Completed:Connect(function()
            parent:Destroy()
            BlurEffect:Destroy()
        end)
    end)
    
    return button
end

function UIService.new(config)
    local self = setmetatable({}, UIService)
    self.screenGui, self.mainFrame = createDraggableWindow(config)
    self.buttons = {}
    return self
end

function UIService:AddScript(config)
    local button = createAddScriptButton(config, self.mainFrame)
    table.insert(self.buttons, button)
    return button
end

return UIService
