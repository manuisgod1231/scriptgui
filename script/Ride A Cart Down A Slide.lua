-- โหลด Linoria Library.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

-- Window หลัก
local Window = Library:CreateWindow({
    Title = 'CMe HUB (Linoria)',
    Center = true,
    AutoShow = true,
})

-- Tabs
local MainTab = Window:AddTab('Main')
local CartTab = Window:AddTab('Cart')
local BulletTab = Window:AddTab('Bullet')

-- Main Section
local MainSection = MainTab:AddLeftGroupbox('Main Controls')

MainSection:AddButton('Flip Once', function()
    local success, err = pcall(function()
        game:GetService('ReplicatedStorage').Flip:FireServer()
    end)
    if not success then warn('Flip error:', err) end
end)

local flipLoopRunning = false
MainSection:AddToggle('FlipLoop', {
    Text = 'Flip Loop',
    Default = false,
    Callback = function(state)
        flipLoopRunning = state
    end
})

MainSection:AddButton('Turn 90°', function()
    game:GetService('ReplicatedStorage').Turn:FireServer()
end)

-- Flip Loop task
task.spawn(function()
    while true do
        if flipLoopRunning then
            local success, err = pcall(function()
                game:GetService('ReplicatedStorage').Flip:FireServer()
            end)
            if not success then warn('Flip error:', err) end
        end
        task.wait(0.2)
    end
end)

-- Cart Section
local CartSection = CartTab:AddLeftGroupbox('Cart Manager')

CartSection:AddDropdown('CartSelect', {
    Values = {'VIP','Mini','Race','Default','DefalutV2','BigWheel','Rope','LongLarry','Mine','Nyan'},
    Default = 1,
    Multi = false,
    Text = 'Select Cart',
    Callback = function(selected)
        local player = game:GetService('Players').LocalPlayer
        if not player:FindFirstChild('EquippedCart') then
            local strVal = Instance.new('StringValue')
            strVal.Name = 'EquippedCart'
            strVal.Parent = player
        end
        player.EquippedCart.Value = selected
        print('EquippedCart set to:', selected)
    end
})

CartSection:AddButton('Equip Cart', function()
    local player = game:GetService('Players').LocalPlayer
    if player:FindFirstChild('EquippedCart') then
        print('EquippedCart equipped:', player.EquippedCart.Value)
    else
        warn('ยังไม่ได้เลือก Cart')
    end
end)

CartSection:AddButton('Spawn Cart', function()
    local player = game:GetService('Players').LocalPlayer
    if player:FindFirstChild('EquippedCart') then
        local cart = player.EquippedCart.Value
        local success, result = pcall(function()
            return game:GetService('ReplicatedStorage').GetEquipped:InvokeServer(cart)
        end)
        if success then
            print('Spawned:', result)
        else
            warn('Error spawn cart:', result)
        end
    else
        warn('ยังไม่ได้เลือก Cart')
    end
end)

-- Bullet Section
local BulletSection = BulletTab:AddLeftGroupbox('Bullet Manager')

BulletSection:AddDropdown('BulletSelect', {
    Values = {'Default','Big'},
    Default = 1,
    Multi = false,
    Text = 'Select Bullet',
    Callback = function(selected)
        local player = game:GetService('Players').LocalPlayer
        if not player:FindFirstChild('EquippedBullet') then
            local strVal = Instance.new('StringValue')
            strVal.Name = 'EquippedBullet'
            strVal.Parent = player
        end
        player.EquippedBullet.Value = selected
        print('EquippedBullet set to:', selected)
    end
})

-- Theme + Save Manager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('CMeHub')
SaveManager:SetFolder('CMeHub')

ThemeManager:ApplyToTab(Window)
SaveManager:BuildConfigSection(Window)
