local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()
local Window = Venyx.new("CMe HUB - Venyx", 5013109572)

local MainTab = Window:addPage("Main", 5012544693)
local CartTab = Window:addPage("Cart", 5012544693)
local BulletTab = Window:addPage("Bullet", 5012544693)

-- Main
MainTab:addButton("Flip Once", function()
    game:GetService("ReplicatedStorage").Flip:FireServer()
end)

local flipLoopRunning = false
MainTab:addToggle("Flip Loop", function(state)
    flipLoopRunning = state
end)

MainTab:addButton("Turn 90°", function()
    game:GetService("ReplicatedStorage").Turn:FireServer()
end)

task.spawn(function()
    while true do
        if flipLoopRunning then
            game:GetService("ReplicatedStorage").Flip:FireServer()
        end
        task.wait(0.2)
    end
end)

-- Cart
local carts = {"VIP","Mini","Race","Default","DefalutV2","BigWheel","Rope","LongLarry","Mine","Nyan"}
CartTab:addDropdown("Select Cart", carts, function(selected)
    local player = game:GetService("Players").LocalPlayer
    if not player:FindFirstChild("EquippedCart") then
        local strVal = Instance.new("StringValue")
        strVal.Name = "EquippedCart"
        strVal.Parent = player
    end
    player.EquippedCart.Value = selected
end)

CartTab:addButton("Equip Cart", function()
    local player = game:GetService("Players").LocalPlayer
    print("EquippedCart:", player.EquippedCart.Value)
end)

CartTab:addButton("Spawn Cart", function()
    local player = game:GetService("Players").LocalPlayer
    game:GetService("ReplicatedStorage").GetEquipped:InvokeServer(player.EquippedCart.Value)
end)

-- Bullet
BulletTab:addDropdown("Select Bullet", {"Default","Big"}, function(selected)
    local player = game:GetService("Players").LocalPlayer
    if not player:FindFirstChild("EquippedBullet") then
        local strVal = Instance.new("StringValue")
        strVal.Name = "EquippedBullet"
        strVal.Parent = player
    end
    player.EquippedBullet.Value = selected
end)
