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

-- Dropdown เลือกรถ
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.9,0,0,40)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Parent = frame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0,12)
dropdownCorner.Parent = dropdownFrame

local dropdownLabel = Instance.new("TextLabel")
dropdownLabel.Size = UDim2.new(1,0,1,0)
dropdownLabel.BackgroundTransparency = 1
dropdownLabel.Text = "Select Cart"
dropdownLabel.Font = Enum.Font.Gotham
dropdownLabel.TextSize = 14
dropdownLabel.TextColor3 = Color3.fromRGB(0,0,0)
dropdownLabel.Parent = dropdownFrame

local options = {"VIP","Mini","Race","Default","DefalutV2","BigWheel","Rope","LongLarry","Mine","Nyan"}
local selectedItem = nil

local optionContainer = Instance.new("ScrollingFrame")
optionContainer.Size = UDim2.new(1,0,0,0)
optionContainer.Position = UDim2.new(0,0,1,0)
optionContainer.BackgroundColor3 = Color3.fromRGB(230,230,230)
optionContainer.Visible = false
optionContainer.ScrollBarThickness = 5
optionContainer.Parent = dropdownFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = optionContainer
uiList.Padding = UDim.new(0,2)

for i,opt in ipairs(options) do
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1,0,0,30)
    optBtn.Text = opt
    optBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    optBtn.Font = Enum.Font.Gotham
    optBtn.TextSize = 14
    optBtn.Parent = optionContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = optBtn

    optBtn.MouseButton1Click:Connect(function()
        selectedItem = opt
        dropdownLabel.Text = "Cart: "..opt
        optionContainer.Visible = false
    end)
end

-- ปรับ CanvasSize
optionContainer.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    optionContainer.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y)
end)

-- คลิกเปิด/ปิด Dropdown
dropdownFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        optionContainer.Visible = not optionContainer.Visible
    end
end)

-- Equip Cart
createButton("Equip Cart", function()
    if selectedItem then
        if not LocalPlayer:FindFirstChild("EquippedCart") then
            local strVal = Instance.new("StringValue")
            strVal.Name = "EquippedCart"
            strVal.Value = ""
            strVal.Parent = LocalPlayer
        end
        LocalPlayer.EquippedCart.Value = selectedItem
        print("EquippedCart set to:", selectedItem)
    else
        warn("Please select a cart!")
    end
end)

-- Spawn Cart
createButton("Spawn Cart", function()
    if selectedItem then
        local success, result = pcall(function()
            return GetEquipped:InvokeServer(selectedItem)
        end)
        if success then
            print("Spawned:", result)
        else
            warn("Error calling GetEquipped:", result)
        end
    else
        warn("Please select a cart!")
    end
end)

-- Flip Loop Toggle
createToggle("Flip Loop", false, function(value)
    flipLoopRunning = value
end)

-- Flip Once
createButton("Flip Once", function()
    local success, err = pcall(function()
        Flip:FireServer()
    end)
    if not success then
        warn("Error firing Flip:", err)
    else
        print("Flip fired once!")
    end
end)

-- Turn 90°
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
        if not gp and input.KeyCode == Enum.KeyCode.F1 then
            frame.Visible = not frame.Visible
        end
    end)
end
