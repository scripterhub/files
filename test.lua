local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local BlurEffect = Instance.new("BlurEffect", game.Lighting)
BlurEffect.Size = 0 -- Initial blur size

local UILibrary = {}

function UILibrary:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    local BaseFrame = Instance.new("Frame", ScreenGui)
    local TopBar = Instance.new("Frame", BaseFrame)
    local Title = Instance.new("TextLabel", TopBar)
    local UIShadow = Instance.new("ImageLabel", BaseFrame)

    -- Configure BaseFrame
    BaseFrame.Size = config.Size or UDim2.new(0, 400, 0, 300)
    BaseFrame.Position = UDim2.new(0.5, -BaseFrame.Size.X.Offset / 2, 0.5, -BaseFrame.Size.Y.Offset / 2)
    BaseFrame.BackgroundTransparency = 0.1
    BaseFrame.BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(255, 255, 255)
    BaseFrame.ClipsDescendants = true

    -- Add Shadow
    UIShadow.Size = UDim2.new(1, 10, 1, 10)
    UIShadow.Position = UDim2.new(0, -5, 0, -5)
    UIShadow.Image = "rbxassetid://1316045217"
    UIShadow.ImageColor3 = Color3.new(0, 0, 0)
    UIShadow.ImageTransparency = 0.5
    UIShadow.ScaleType = Enum.ScaleType.Slice
    UIShadow.SliceCenter = Rect.new(10, 10, 118, 118)

    -- Configure TopBar
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0

    -- Configure Title
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.TopBarText or "Title"
    Title.Font = config.TopBarFont or Enum.Font.SourceSans
    Title.TextSize = config.TopBarTextSize or 20
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Enable Draggable Top Bar
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = BaseFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            BaseFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Configure Blurred Background
    if config.BlurredBackground then
        BlurEffect.Size = 10
    end

    -- Add AddScript Button Function
    function UILibrary:AddScriptButton(imageId, callback)
        local Button = Instance.new("ImageButton", BaseFrame)
        Button.Size = UDim2.new(0, 50, 0, 50)
        Button.Image = imageId
        Button.Position = UDim2.new(0, #BaseFrame:GetChildren() * 60, 0, 50)

        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
            ScreenGui:Destroy() -- Destroy UI after selecting button
        end)
    end

    return UILibrary
end

return UILibrary
