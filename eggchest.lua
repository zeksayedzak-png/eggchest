--[[
    EGG & CHEST TELEPORTER V5 (MOBILE)
    ✅ المهام: انتقال للبيضة + صندوق 2 + صندوق 3
    ✅ الأهداف: تخصيص بناءً على الحجم والاسم
    ✅ واجهة قابلة للسحب للجوال
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggChestTPGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي (تم زيادة الطول ليناسب 3 أزرار)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 170)
mainFrame.Position = UDim2.new(0.5, -75, 0.5, -85)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "🥚 مجمع الهدايا"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- وظيفة عامة لإنشاء الأزرار بسهولة
local function createButton(name, text, color, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- الأزرار
local eggBtn = createButton("EggBtn", "انتقال للبيضة", Color3.fromRGB(85, 0, 255), UDim2.new(0.05, 0, 0.22, 0))
local chest2Btn = createButton("Chest2Btn", "انتقال صندوق 2", Color3.fromRGB(255, 140, 0), UDim2.new(0.05, 0, 0.48, 0))
local chest3Btn = createButton("Chest3Btn", "انتقال صندوق 3", Color3.fromRGB(255, 85, 0), UDim2.new(0.05, 0, 0.74, 0))

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

-- ==================== وظائف الانتقال ====================

local function teleportTo(targetType)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local found = false
    
    if targetType == "Egg" then
        -- البحث عن البيضة (Size: 4, 6, 4)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Root" and (obj.Size - Vector3.new(4, 6, 4)).Magnitude < 0.1 then
                hrp.CFrame = obj.CFrame * CFrame.new(0, 0, 3)
                found = true; break
            end
        end
    elseif targetType == "Chest2" then
        -- البحث عن صندوق 2 (Workspace.Chest2.Root)
        local chest2 = workspace:FindFirstChild("Chest2")
        if chest2 and chest2:FindFirstChild("Root") then
            hrp.CFrame = chest2.Root.CFrame * CFrame.new(0, 0, 4)
            found = true
        end
    elseif targetType == "Chest3" then
        -- البحث عن صندوق 3 (Workspace.Chest3.Root)
        local chest3 = workspace:FindFirstChild("Chest3")
        if chest3 and chest3:FindFirstChild("Root") then
            hrp.CFrame = chest3.Root.CFrame * CFrame.new(0, 0, 4)
            found = true
        end
    end
    return found
end

-- برمجة ضغط الأزرار
eggBtn.MouseButton1Click:Connect(function()
    if teleportTo("Egg") then
        eggBtn.Text = "✅ تم"
        task.wait(1)
        eggBtn.Text = "انتقال للبيضة"
    else
        eggBtn.Text = "❌ غير موجود"
        task.wait(1)
        eggBtn.Text = "انتقال للبيضة"
    end
end)

chest2Btn.MouseButton1Click:Connect(function()
    if teleportTo("Chest2") then
        chest2Btn.Text = "✅ تم الصندوق 2"
        task.wait(1)
        chest2Btn.Text = "انتقال صندوق 2"
    else
        chest2Btn.Text = "❌ غير موجود"
        task.wait(1)
        chest2Btn.Text = "انتقال صندوق 2"
    end
end)

chest3Btn.MouseButton1Click:Connect(function()
    if teleportTo("Chest3") then
        chest3Btn.Text = "✅ تم الصندوق 3"
        task.wait(1)
        chest3Btn.Text = "انتقال صندوق 3"
    else
        chest3Btn.Text = "❌ غير موجود"
        task.wait(1)
        chest3Btn.Text = "انتقال صندوق 3"
    end
end)

print("✅ Egg & Chest Teleporter Loaded!")
