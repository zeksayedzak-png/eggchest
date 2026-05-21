--[[
    EGG TELEPORTER V4 (MOBILE)
    ✅ المهمة: نقل اللاعب إلى مكان البيضة
    ✅ الهدف: Root (Size: 4, 6, 4)
    ✅ واجهة صغيرة وقابلة للسحب
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggTPGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي (صغير جداً)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 90)
mainFrame.Position = UDim2.new(0.5, -70, 0.5, -45)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "🥚 مجمع البيض"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = mainFrame

-- زر الانتقال
local tpBtn = Instance.new("TextButton")
tpBtn.Text = "انتقال للبيضة"
tpBtn.Size = UDim2.new(0.85, 0, 0, 40)
tpBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
tpBtn.Parent = mainFrame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

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

-- ==================== وظيفة الانتقال للبيضة ====================
tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local eggSize = Vector3.new(4, 6, 4)
    local found = false
    
    -- البحث في الماب عن البيضة
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Root" then
            -- التأكد من الحجم بدقة
            local diff = (obj.Size - eggSize).Magnitude
            if diff < 0.1 then
                -- الانتقال أمام البيضة بمسافة 3 أمتار
                hrp.CFrame = obj.CFrame * CFrame.new(0, 0, 3) 
                found = true
                break -- التوقف عند أول بيضة يجدها
            end
        end
    end
    
    if found then
        tpBtn.Text = "✅ تم الانتقال"
        tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        tpBtn.Text = "❌ لم يتم العثور"
        tpBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
    
    task.wait(1)
    tpBtn.Text = "انتقال للبيضة"
    tpBtn.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
end)

print("✅ Egg Teleporter Loaded!")
