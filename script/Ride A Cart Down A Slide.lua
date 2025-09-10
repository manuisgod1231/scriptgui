local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
 
local UI = Material.Load({
    Title = "CMe HUB - Material",
    Style = 1,
    SizeX = 400,
    SizeY = 300,
    Theme = "Dark"
})

-- Tabs
local MainTab = UI.New({Title = "Main"})
local CartTab = UI.New({Title = "Cart"})
local BulletTab = UI.New({Title = "Bullet"})

-- Main
MainTab.Button({Text = "Flip Once", Callback = function() game:GetService("ReplicatedStorage").Flip:FireServer() end})
local flipLoopRunning = false
MainTab.Toggle({Text = "Flip Loop", Callback = function(state) flipLoopRunning = state end})
MainTab.Button({Text = "Turn 90°", Callback = function() game:GetService("ReplicatedStorage").Turn:FireServer() end})

task.spawn(function()
    while true do
        if flipLoopRunning then
            game:GetService("ReplicatedStorage").Flip:FireServer()
        end
        task.wait(0.2)
    end
end)

-- Cart
CartTab.Dropdown({Text = "Select Cart", Options = {"VIP","Mini","Race","Default","DefalutV2","BigWheel","Rope","LongLarry","Mine","Nyan"}, Callback = function(selected)
    local player = game:GetService("Players").LocalPlayer
    if not player:FindFirstChild("EquippedCart") then
        local strVal = Instance.new("StringValue")
        strVal.Name = "EquippedCart"
        strVal.Parent = player
    end
    player.EquippedCart.Value = selected
end})
CartTab.Button({Text = "Equip Cart", Callback = function() print("EquippedCart:", game:GetService("Players").LocalPlayer.EquippedCart.Value) end})
CartTab.Button({Text = "Spawn Cart", Callback = function() game:GetService("ReplicatedStorage").GetEquipped:InvokeServer(game:GetService("Players").LocalPlayer.EquippedCart.Value) end})

-- Bullet
BulletTab.Dropdown({Text = "Select Bullet", Options = {"Default","Big"}, Callback = function(selected)
    local player = game:GetService("Players").LocalPlayer
    if not player:FindFirstChild("EquippedBullet") then
        local strVal = Instance.new("StringValue")
        strVal.Name = "EquippedBullet"
        strVal.Parent = player
    end
    player.EquippedBullet.Value = selected
end})
