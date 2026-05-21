--[[
    EGG & CHEST BRINGER V3 (MOBILE OPTIMIZED)
    ✅ دقة البحث: DragonEgg & Chests
    ✅ واجهة صغيرة وقابلة للسحب (Delta Friendly)
    ✅ جلب العناصر أمام اللاعب مباشرة
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemFetcherGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 130)
mainFrame.Position = UDim2.new(0.5, -80, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "📦 مجمع الأدوات"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- زر جلب البيض
local eggBtn = Instance.new("TextButton")
eggBtn.Name = "EggBtn"
eggBtn.Text = "🥚 جلب البيض"
eggBtn.Size = UDim2.new(0.9, 0, 0, 35)
eggBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
eggBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
eggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
eggBtn.Font = Enum.Font.GothamBold
eggBtn.TextSize = 13
eggBtn.Parent = mainFrame
Instance.new("UICorner", eggBtn).CornerRadius = UDim.new(0, 6)

-- زر جلب الصناديق
local chestBtn = Instance.new("TextButton")
chestBtn.Name = "ChestBtn"
chestBtn.Text = "🎁 جلب الصناديق"
chestBtn.Size = UDim2.new(0.9, 0, 0, 35)
chestBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
chestBtn.BackgroundColor3 = Color3.fromRGB(215, 120, 0)
chestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chestBtn.Font = Enum.Font.GothamBold
chestBtn.TextSize = 13
chestBtn.Parent = mainFrame
Instance.new("UICorner", chestBtn).CornerRadius = UDim.new(0, 6)

-- ==================== نظام السحب للجوال ====================
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    dragging = false
end)

-- ==================== وظيفة الجلب العامة ====================
local function bringItems(targetSize, targetName)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return 0 end
    
    local root = char.HumanoidRootPart
    local count = 0
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Root" then
            -- التحقق من الحجم (مع هامش خطأ بسيط جداً)
            local diff = (obj.Size - targetSize).Magnitude
            if diff < 0.1 then
                count = count + 1
                -- جلب الجزء أمام اللاعب وتكديسه للأعلى
                obj.CFrame = root.CFrame * CFrame.new(0, (count * 5) - 2, -7)
                obj.Anchored = true -- لضمان عدم سقوطها تحت الماب
            end
        end
    end
    return count
end

-- تشغيل الأزرار
eggBtn.MouseButton1Click:Connect(function()
    local eggSize = Vector3.new(4, 6, 4)
    local found = bringItems(eggSize, "Root")
    
    if found > 0 then
        eggBtn.Text = "✅ تم جلب: " .. found
    else
        eggBtn.Text = "❌ لم يتم العثور"
    end
    task.wait(1.5)
    eggBtn.Text = "🥚 جلب البيض"
end)

chestBtn.MouseButton1Click:Connect(function()
    local chestSize = Vector3.new(7.5, 4.5, 6)
    local found = bringItems(chestSize, "Root")
    
    if found > 0 then
        chestBtn.Text = "✅ تم جلب: " .. found
    else
        chestBtn.Text = "❌ لم يتم العثور"
    end
    task.wait(1.5)
    chestBtn.Text = "🎁 جلب الصناديق"
end)

print("✅ Egg & Chest Bringer Loaded Successfully!")
