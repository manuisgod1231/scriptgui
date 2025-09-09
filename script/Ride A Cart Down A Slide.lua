-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local GetEquipped = ReplicatedStorage:WaitForChild("GetEquipped")
local Flip = ReplicatedStorage:WaitForChild("Flip")
local Turn = ReplicatedStorage:WaitForChild("Turn")
local PurchaseBullet = ReplicatedStorage:WaitForChild("PurchaseBullet")

-- Remove old GUI if exists
if LocalPlayer:FindFirstChild("CMe_HUB") then
    LocalPlayer["CMe_HUB"]:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CMe_HUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 500)
frame.Position = UDim2.new(0.5, -160, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(242,242,247)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = screenGui

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
title.Text = "CMe HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Parent = frame

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
local toggleStates = {}
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

-- Flip Loop
local flipLoopRunning = false
createToggle("Flip Loop", false, function(value)
    flipLoopRunning = value
end)

task.spawn(function()
    while true do
        if flipLoopRunning then
            pcall(function() Flip:FireServer() end)
        end
        task.wait(0.2)
    end
end)

-- Turn 90°
createButton("Turn 90 (สันยรักองศา)", function()
    Turn:FireServer()
end)

-- Equip Cart TextBox
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

-- Spawn Cart Button
local spawnCartBtn = createButton("Spawn Cart", function()
    local name = equipBox.Text
    if name ~= "" then
        pcall(function()
            GetEquipped:InvokeServer(name)
        end)
    end
end)

-- Equip Bullet Button
local equipBulletBtn = createButton("Equip Bullet", function()
    local args = { "Default", 0 }
    pcall(function() PurchaseBullet:FireServer(unpack(args)) end)
end)

-- Bullet Selection
if not LocalPlayer:FindFirstChild("EquippedBullet") then
    local strVal = Instance.new("StringValue")
    strVal.Name = "EquippedBullet"
    strVal.Value = "Default"
    strVal.Parent = LocalPlayer
end

local bulletHeader = Instance.new("TextButton")
bulletHeader.Size = UDim2.new(0.9,0,0,35)
bulletHeader.BackgroundColor3 = Color3.fromRGB(200,200,200)
bulletHeader.TextColor3 = Color3.fromRGB(0,0,0)
bulletHeader.Font = Enum.Font.Gotham
bulletHeader.TextSize = 16
bulletHeader.Text = "Select Bullet ▼"
bulletHeader.Parent = frame
local bulletCorner = Instance.new("UICorner")
bulletCorner.CornerRadius = UDim.new(0,12)
bulletCorner.Parent = bulletHeader

local bulletFrame = Instance.new("Frame")
bulletFrame.Size = UDim2.new(0.95,0,0,80)
bulletFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
bulletFrame.Visible = false
bulletFrame.Parent = frame
local bulletLayout = Instance.new("UIListLayout")
bulletLayout.Parent = bulletFrame
bulletLayout.Padding = UDim.new(0,2)
bulletLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local bullets = {"Default","Big"}
local isBulletExpanded = false
local otherButtons = {spawnCartBtn, equipBulletBtn, bulletHeader}

for _, bulletName in ipairs(bullets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(230,230,230)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Text = bulletName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = bulletFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        LocalPlayer.EquippedBullet.Value = bulletName
        bulletHeader.Text = "Selected Bullet: "..bulletName.." ▼"
        bulletFrame.Visible = false
        isBulletExpanded = false
        for _, b in ipairs(otherButtons) do
            b.Visible = true
        end
    end)
end

bulletHeader.MouseButton1Click:Connect(function()
    isBulletExpanded = not isBulletExpanded
    bulletFrame.Visible = isBulletExpanded
    for _, b in ipairs(otherButtons) do
        b.Visible = not isBulletExpanded
    end
end)

-- GUI Toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -60, 1, -60)
toggleButton.BackgroundColor3 = Color3.fromRGB(52,199,89)
toggleButton.Text = "CMe"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 25
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,12)
toggleButton.Active = true
toggleButton.Draggable = true

local guiVisible = true
toggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
end)

-- PC toggle E key
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.E and not processed then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)
