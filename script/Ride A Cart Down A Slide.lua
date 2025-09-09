-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local GetEquipped = ReplicatedStorage:WaitForChild("GetEquipped")
local Flip = ReplicatedStorage:WaitForChild("Flip")
local Turn = ReplicatedStorage:WaitForChild("Turn")

-- Remove old GUI if exists
if LocalPlayer:FindFirstChild("ChatGPT_HUB") then
    LocalPlayer["ChatGPT_HUB"]:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatGPT_HUB"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
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

-- Button function
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

-- Toggle function
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

-- Cart selector
local selectorFrame = Instance.new("Frame")
selectorFrame.Size = UDim2.new(0.9,0,0,130)
selectorFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
selectorFrame.Parent = frame

local selectorCorner = Instance.new("UICorner")
selectorCorner.CornerRadius = UDim.new(0,12)
selectorCorner.Parent = selectorFrame

local selectedCartLabel = Instance.new("TextLabel")
selectedCartLabel.Size = UDim2.new(1,0,0,30)
selectedCartLabel.BackgroundTransparency = 1
selectedCartLabel.Text = "Select Cart..."
selectedCartLabel.Font = Enum.Font.Gotham
selectedCartLabel.TextSize = 14
selectedCartLabel.TextColor3 = Color3.fromRGB(0,0,0)
selectedCartLabel.Parent = selectorFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-30)
scroll.Position = UDim2.new(0,0,0,30)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.Parent = selectorFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scroll
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,4)

local carts = {"VIP","Mini","Race","Default","DefaultV2","BigWheel","Rope","LongLarry","Mine","Nyan"}
for _,cartName in ipairs(carts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(230,230,230)
    btn.Text = cartName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Parent = scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        selectedCartLabel.Text = cartName
    end)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
end)

-- Spawn Cart
createButton("Spawn Cart", function()
    local cart = selectedCartLabel.Text
    if cart ~= "Select Cart..." then
        local success, result = pcall(function()
            return GetEquipped:InvokeServer(cart)
        end)
        if success then
            print("Equipped:", result)
        else
            warn("Error calling GetEquipped:", result)
        end
    else
        warn("No cart selected!")
    end
end)

-- Flip Loop
createToggle("Flip Loop", false, function(value)
    flipLoopRunning = value
end)

-- Flip Once
createButton("Flip Once", function()
    local success, err = pcall(function()
        Flip:FireServer()
    end)
    if not success then warn("Error firing Flip:", err) end
end)

-- Turn
createButton("Turn", function()
    Turn:FireServer()
end)

-- Flip loop thread
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

-- GUI toggle handling
local guiVisible = true

if UserInputService.TouchEnabled then
    -- Mobile toggle button
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

    toggleButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end)
else
    -- PC: toggle with RightCtrl
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then
            guiVisible = not guiVisible
            frame.Visible = guiVisible
        end
    end)
end

-- Reset
for btn, state in pairs(toggleStates) do
    btn.BackgroundColor3 = Color3.fromRGB(142,142,147)
    toggleStates[btn] = false
end
flipLoopRunning = false
selectedCartLabel.Text = "Select Cart..."
