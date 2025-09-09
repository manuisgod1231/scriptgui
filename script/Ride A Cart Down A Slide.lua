-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local GetEquipped = ReplicatedStorage:WaitForChild("GetEquipped")
local Flip = ReplicatedStorage:WaitForChild("Flip")
local Turn = ReplicatedStorage:WaitForChild("Turn")

-- Remove old GUI
if LocalPlayer:FindFirstChild("ChatGPT_HUB") then
    LocalPlayer["ChatGPT_HUB"]:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatGPT_HUB"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0.5, -150, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(242,242,247)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
frame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0,12)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ChatGPT HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Parent = frame

-- Flip loop state
local flipLoopRunning = false
local toggleStates = {}

-- Button creator
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = frame
    btn.AutoButtonColor = true

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,12)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle creator
local function createToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9,0,0,40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(0,0,0)
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.3,0,1,0)
    toggleBtn.Position = UDim2.new(0.7,0,0,0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(52,199,89) or Color3.fromRGB(142,142,147)
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = toggleBtn

    local state = default
    toggleStates[toggleBtn] = state
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleStates[toggleBtn] = state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(52,199,89) or Color3.fromRGB(142,142,147)
        callback(state)
    end)
end

-- Equip TextBox
local equipBox = Instance.new("TextBox")
equipBox.Size = UDim2.new(0.9,0,0,35)
equipBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
equipBox.TextColor3 = Color3.fromRGB(0,0,0)
equipBox.Text = ""
equipBox.PlaceholderText = "Type - VIP, Mini, Race, Default, DefalutV2, BigWheel, Rope, LongLarry, Mine, Nyan"
equipBox.Font = Enum.Font.Gotham
equipBox.TextScaled = true
equipBox.TextSize = 10
equipBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0,12)
boxCorner.Parent = equipBox

-- Equip Cart Button
createButton("Equip Cart", function()
    local itemName = equipBox.Text
    if itemName ~= "" then
        if not LocalPlayer:FindFirstChild("EquippedCart") then
            local strVal = Instance.new("StringValue")
            strVal.Name = "EquippedCart"
            strVal.Value = ""
            strVal.Parent = LocalPlayer
        end
        LocalPlayer.EquippedCart.Value = itemName
        print("EquippedCart set to:", itemName)
    else
        warn("Please type a cart name!")
    end
end)

-- Spawn Cart Button
createButton("Spawn Cart", function()
    local itemName = equipBox.Text
    if itemName ~= "" then
        local success, result = pcall(function()
            return GetEquipped:InvokeServer(itemName)
        end)
        if success then
            print("Spawned:", result)
        else
            warn("Error calling GetEquipped:", result)
        end
    else
        warn("Please type a cart name!")
    end
end)

-- Flip Loop Toggle
createToggle("Flip Loop", false, function(value)
    flipLoopRunning = value
end)

-- Flip Once Button
createButton("Flip Once", function()
    local success, err = pcall(function()
        Flip:FireServer()
    end)
    if not success then warn("Flip error:",err) end
end)

-- Turn 90° Button
createButton("Turn 90°", function()
    Turn:FireServer()
end)

-- Background Flip Loop
task.spawn(function()
    while true do
        if flipLoopRunning then
            local success, err = pcall(function()
                Flip:FireServer()
            end)
            if not success then warn("Flip error:",err) end
        end
        task.wait(0.2)
    end
end)

-- GUI Toggle
if UserInputService.TouchEnabled then
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(1, -60, 1, -60)
    toggleButton.BackgroundColor3 = Color3.fromRGB(52,199,89)
    toggleButton.Text = "≡"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 25
    toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0,12)
    toggleCorner.Parent = toggleButton

    toggleButton.Active = true
    toggleButton.Draggable = true

    local guiVisible = true
    toggleButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end)
else
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.E then
            frame.Visible = not frame.Visible
        end
    end)
end
