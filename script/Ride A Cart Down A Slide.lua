-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Remove old GUI
if LocalPlayer:FindFirstChild("CMe_HUB") then
    LocalPlayer.CMe_HUB:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CMe_HUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,400,0,550)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,15)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "CMe HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- =======================
-- CONTENT SCROLLING AREA
-- =======================
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1,-10,1,-50)
contentScroll.Position = UDim2.new(0,5,0,45)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 6
contentScroll.CanvasSize = UDim2.new(0,0,0,0)
contentScroll.Parent = frame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0,8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentScroll
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y)
end)

-- =======================
-- Helper functions
-- =======================
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = contentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9,0,0,35)
    toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.Text = text.." : "..(default and "✅" or "❌")
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 16
    toggle.Parent = contentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = toggle

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text.." : "..(state and "✅" or "❌")
        callback(state)
    end)
end

-- Collapsible scrollable selection list
local function createScrollableSelection(titleText, options, callback)
    local header = Instance.new("TextButton")
    header.Size = UDim2.new(0.9,0,0,35)
    header.BackgroundColor3 = Color3.fromRGB(60,60,60)
    header.TextColor3 = Color3.fromRGB(255,255,255)
    header.Text = titleText.." ▼"
    header.Font = Enum.Font.Gotham
    header.TextSize = 16
    header.Parent = contentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = header

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.9,0,0,0) -- collapsed
    scrollFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    scrollFrame.BorderColor3 = Color3.fromRGB(100,100,100)
    scrollFrame.BorderSizePixel = 2
    scrollFrame.Visible = false
    scrollFrame.Parent = contentScroll
    scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollFrame.ScrollBarThickness = 6

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0,2)
    listLayout.Parent = scrollFrame

    local selected = nil

    for _, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,30)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = option
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = scrollFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,6)
        corner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            selected = option
            header.Text = "Selected: "..option.." ▼"
            scrollFrame.Visible = false
            scrollFrame.Size = UDim2.new(0.9,0,0,0)
            callback(option)
        end)
    end

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
    end)

    header.MouseButton1Click:Connect(function()
        scrollFrame.Visible = not scrollFrame.Visible
        if scrollFrame.Visible then
            scrollFrame.Size = UDim2.new(0.9,0,0,200)
        else
            scrollFrame.Size = UDim2.new(0.9,0,0,0)
        end
    end)
end

-- =======================
-- CART SELECTION
-- =======================
local carts = {"VIP","Mini","Race","Default","DefalutV2","BigWheel","Rope","LongLarry","Mine","Nyan"}
local selectedCart = nil

createScrollableSelection("Select Cart", carts, function(choice)
    selectedCart = choice
    if not LocalPlayer:FindFirstChild("EquippedCart") then
        local strVal = Instance.new("StringValue")
        strVal.Name = "EquippedCart"
        strVal.Parent = LocalPlayer
    end
    LocalPlayer.EquippedCart.Value = selectedCart
end)

createButton("Equip Cart", function()
    if selectedCart then
        LocalPlayer.EquippedCart.Value = selectedCart
        print("EquippedCart set to:", selectedCart)
    else
        warn("Select a cart first!")
    end
end)

createButton("Spawn Cart", function()
    if selectedCart then
        pcall(function() ReplicatedStorage.GetEquipped:InvokeServer(selectedCart) end)
    else
        warn("Select a cart first!")
    end
end)

-- =======================
-- BULLET SELECTION
-- =======================
local bullets = {"Default","Big"}
local selectedBullet = nil

createScrollableSelection("Select Bullet", bullets, function(choice)
    selectedBullet = choice
end)

createButton("Equip Bullet", function()
    if selectedBullet then
        if not LocalPlayer:FindFirstChild("EquippedBullet") then
            local strVal = Instance.new("StringValue")
            strVal.Name = "EquippedBullet"
            strVal.Parent = LocalPlayer
        end
        LocalPlayer.EquippedBullet.Value = selectedBullet
        print("EquippedBullet set to:", selectedBullet)
    else
        warn("Select a bullet first!")
    end
end)

-- =======================
-- ACTION BUTTONS (BOTTOM)
-- =======================
local flipLoopRunning = false

createButton("Flip Once", function()
    pcall(function() ReplicatedStorage.Flip:FireServer() end)
end)

createToggle("Toggle Flip Loop", false, function(state)
    flipLoopRunning = state
end)

createButton("Turn 90°", function()
    pcall(function() ReplicatedStorage.Turn:FireServer() end)
end)

task.spawn(function()
    while true do
        if flipLoopRunning then
            pcall(function() ReplicatedStorage.Flip:FireServer() end)
        end
        task.wait(0.2)
    end
end)

-- =======================
-- GUI TOGGLE (PC & Mobile)
-- =======================
local guiVisible = true

if UserInputService.TouchEnabled then
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0,50,0,50)
    toggleBtn.Position = UDim2.new(1,-60,1,-60)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(52,199,89)
    toggleBtn.Text = "≡"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 25
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = toggleBtn

    toggleBtn.Active = true
    toggleBtn.Draggable = true

    toggleBtn.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end)
else
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            guiVisible = not guiVisible
            frame.Visible = guiVisible
        end
    end)
end
