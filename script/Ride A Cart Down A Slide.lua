-- โหลด Material UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

-- สร้าง Window หลัก
local UI = Library.Load({
    Title = "CMe HUB (Material UI)",
    Style = 1,  -- 1 = Dark, 2 = Light
    SizeX = 400,
    SizeY = 300,
    Theme = "Dark" -- หรือ "Light"
})

-- =======================
-- MAIN TAB
-- =======================
local MainTab = UI.New({Title = "Main"})

-- ปุ่ม Flip Once
MainTab.Button({
    Text = "Flip Once",
    Callback = function()
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").Flip:FireServer()
        end)
        if not success then warn("Flip error:", err) end
    end
})

-- Toggle Flip Loop
local flipLoopRunning = false
MainTab.Toggle({
    Text = "Flip Loop",
    Callback = function(state)
        flipLoopRunning = state
    end,
    Enabled = false
})

-- Run flip loop
task.spawn(function()
    while true do
        if flipLoopRunning then
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage").Flip:FireServer()
            end)
            if not success then warn("Flip error:", err) end
        end
        task.wait(0.2)
    end
end)

-- ปุ่ม Turn 90
MainTab.Button({
    Text = "Turn 90°",
    Callback = function()
        game:GetService("ReplicatedStorage").Turn:FireServer()
    end
})

-- =======================
-- CART TAB
-- =======================
local CartTab = UI.New({Title = "Cart"})

CartTab.Dropdown({
    Text = "Select Cart",
    Options = {"VIP","Mini","Race","Default","DefalutV2","BigWheel","Rope","LongLarry","Mine","Nyan"},
    Callback = function(selected)
        local player = game:GetService("Players").LocalPlayer
        if not player:FindFirstChild("EquippedCart") then
            local strVal = Instance.new("StringValue")
            strVal.Name = "EquippedCart"
            strVal.Parent = player
        end
        player.EquippedCart.Value = selected
        print("EquippedCart set to:", selected)
    end
})

CartTab.Button({
    Text = "Equip Cart",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player:FindFirstChild("EquippedCart") then
            print("EquippedCart equipped:", player.EquippedCart.Value)
        else
            warn("ยังไม่ได้เลือก Cart")
        end
    end
})

CartTab.Button({
    Text = "Spawn Cart",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player:FindFirstChild("EquippedCart") then
            local cart = player.EquippedCart.Value
            local success, result = pcall(function()
                return game:GetService("ReplicatedStorage").GetEquipped:InvokeServer(cart)
            end)
            if success then
                print("Spawned:", result)
            else
                warn("Error spawn cart:", result)
            end
        else
            warn("ยังไม่ได้เลือก Cart")
        end
    end
})

-- =======================
-- BULLET TAB
-- =======================
local BulletTab = UI.New({Title = "Bullet"})

BulletTab.Dropdown({
    Text = "Select Bullet",
    Options = {"Default","Big"},
    Callback = function(selected)
        local player = game:GetService("Players").LocalPlayer
        if not player:FindFirstChild("EquippedBullet") then
            local strVal = Instance.new("StringValue")
            strVal.Name = "EquippedBullet"
            strVal.Parent = player
        end
        player.EquippedBullet.Value = selected
        print("EquippedBullet set to:", selected)
    end
})
