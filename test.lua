local Library = {}

-- Utility function to create UI elements
local function createUIElement(parent, elementType, properties)
    local element = Instance.new(elementType)
    for propName, propValue in pairs(properties) do
        element[propName] = propValue
    end
    element.Parent = parent
    return element
end

-- Create a new window
function Library:CreateWindow(name, size, position)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name
    ScreenGui.Parent = game.CoreGui
    
    local Window = createUIElement(ScreenGui, "Frame", {
        Name = name,
        Size = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset),
        Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    
    local WindowTitle = createUIElement(Window, "TextLabel", {
        Text = name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(0, 0, 0)
    })
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Window
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return Window
end

-- Create a TextBox
function Library:CreateTextBox(parent, name, type, callback)
    local TextBoxFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local TextBox = createUIElement(TextBoxFrame, "TextBox", {
        PlaceholderText = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if type == "int" then
                callback(tonumber(TextBox.Text))
            elseif type == "string" then
                callback(TextBox.Text)
            else
                callback(TextBox.Text)
            end
        end
    end)
end

-- Create a Toggle
function Library:CreateToggle(parent, name, callback)
    local ToggleFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local ToggleButton = createUIElement(ToggleFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local ToggleState = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        callback(ToggleState)
        ToggleButton.Text = name .. " : " .. (ToggleState and "On" or "Off")
    end)
end

-- Create a Keybind
function Library:CreateKeybind(parent, name, defaultKey, callback)
    local KeybindFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local KeybindButton = createUIElement(KeybindFrame, "TextButton", {
        Text = name .. ": " .. defaultKey.Name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local keybind = defaultKey
    
    KeybindButton.MouseButton1Click:Connect(function()
        KeybindButton.Text = name .. ": Press a key"
        local connection
        connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybind = input.KeyCode
                KeybindButton.Text = name .. ": " .. keybind.Name
                connection:Disconnect()
            end
        end)
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            callback()
        end
    end)
end

-- Create a Dropdown
function Library:CreateDropdown(parent, name, options, callback)
    local DropdownFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local DropdownButton = createUIElement(DropdownFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local OptionsFrame = createUIElement(DropdownFrame, "Frame", {
        Size = UDim2.new(0.8, 0, #options * 50, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0.5,
        Visible = false
    })
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = OptionsFrame
    
    DropdownButton.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)
    
    for _, option in ipairs(options) do
        local OptionButton = createUIElement(OptionsFrame, "TextButton", {
            Text = option,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 0.5,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextScaled = true
        })
        
        OptionButton.MouseButton1Click:Connect(function()
            callback(option)
            DropdownButton.Text = name .. ": " .. option
            OptionsFrame.Visible = false
        end)
    end
end

-- Create a MultiDropdown
function Library:CreateMultiDropdown(parent, name, options, callback)
    local MultiDropdownFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local MultiDropdownButton = createUIElement(MultiDropdownFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local OptionsFrame = createUIElement(MultiDropdownFrame, "Frame", {
        Size = UDim2.new(0.8, 0, #options * 50, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0.5,
        Visible = false
    })
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = OptionsFrame
    
    local selectedOptions = {}
    
    MultiDropdownButton.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)
    
    for _, option in ipairs(options) do
        local OptionButton = createUIElement(OptionsFrame, "TextButton", {
            Text = option,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 0.5,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextScaled = true
        })
        
        OptionButton.MouseButton1Click:Connect(function()
            if table.find(selectedOptions, option) then
                table.remove(selectedOptions, table.find(selectedOptions, option))
                OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                table.insert(selectedOptions, option)
                OptionButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
            callback(selectedOptions)
            MultiDropdownButton.Text = name .. ": " .. table.concat(selectedOptions, ", ")
        end)
    end
end

-- Create a Slider
function Library:CreateSlider(parent, name, min, max, step, callback)
    local SliderFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local Slider = createUIElement(SliderFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local SliderValue = createUIElement(SliderFrame, "TextLabel", {
        Text = tostring(min),
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0.8, 0, 0, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local dragging = false
    local function updateValue(input)
        local scale = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
        local value = min + scale * (max - min)
        value = math.floor(value / step + 0.5) * step
        SliderValue.Text = tostring(value)
        callback(value)
    end
    
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input)
        end
    end)
    
    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input)
        end
    end)
end

-- Create a Button
function Library:CreateButton(parent, name, callback)
    local ButtonFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local Button = createUIElement(ButtonFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- Create an RGB Color Picker
function Library:CreateColorPicker(parent, name, callback)
    local ColorPickerFrame = createUIElement(parent, "Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local ColorPickerButton = createUIElement(ColorPickerFrame, "TextButton", {
        Text = name,
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true
    })
    
    local ColorPicker = Instance.new("Color3Value")
    
    ColorPickerButton.MouseButton1Click:Connect(function()
        local colorPickerGui = Instance.new("Frame")
        colorPickerGui.Size = UDim2.new(0.5, 0, 0.5, 0)
        colorPickerGui.Position = UDim2.new(0.25, 0, 0.25, 0)
        colorPickerGui.BackgroundTransparency = 0.5
        colorPickerGui.Parent = game.CoreGui
        
        local colorPicker = Instance.new("ImageButton")
        colorPicker.Size = UDim2.new(1, 0, 1, 0)
        colorPicker.Image = "rbxassetid://6523286723" -- An example color picker image
        colorPicker.Parent = colorPickerGui
        
        colorPicker.MouseButton1Click:Connect(function()
            local pixelColor = colorPicker:GetColorAtMousePosition()
            ColorPicker.Value = pixelColor
            ColorPickerButton.Text = name .. ": " .. tostring(pixelColor)
            callback(pixelColor)
            colorPickerGui:Destroy()
        end)
    end)
end

return Library
