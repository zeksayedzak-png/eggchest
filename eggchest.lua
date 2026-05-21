--[[
    EGG BRINGER V2 (SPECIAL SIZE)
    ✅ البحث عن البيض بحجم 99,5,5
    ✅ جلب أمام اللاعب مباشرة
    ✅ واجهة صغيرة وقابلة للتحريك للمس
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إنشاء الواجهة (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggMoverGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي (صغير)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0.5, -75, 0.5, -40)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true -- يعمل في بعض النسخ
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- عنوان صغير
local title = Instance.new("TextLabel")
title.Text = "🥚 مجمع البيض"
title.Size = UDim2.new(1, 0, 0, 25)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = mainFrame

-- زر الجلب
local bringBtn = Instance.new("TextButton")
bringBtn.Text = "جلب البيض الآن"
bringBtn.Size = UDim2.new(0.9, 0, 0, 40)
bringBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
bringBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
bringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bringBtn.Font = Enum.Font.GothamBold
bringBtn.TextSize = 14
bringBtn.Parent = mainFrame
Instance.new("UICorner", bringBtn).CornerRadius = UDim.new(0, 6)

-- ==================== نظام السحب للجوال (دلتا) ====================
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

-- ==================== وظيفة جلب البيضة ====================
bringBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local eggSize = Vector3.new(99, 5, 5) -- الحجم الذي حددته أنت
    local count = 0
    
    -- البحث في الماب
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size == eggSize then
            count = count + 1
            
            -- نقل البيضة أمام اللاعب مع إزاحة بسيطة لكل واحدة جديدة
            -- الترتيب: كل بيضة تبعد عن الأخرى 6 أمتار للأعلى لكي لا تتداخل
            obj.CFrame = root.CFrame * CFrame.new(0, (count * 6) - 5, -15)
            
            -- إلغاء التثبيت لكي تتحرك (أو اجعلها true إذا أردتها ثابتة في الهواء)
            obj.Anchored = true 
            obj.CanCollide = true
        end
    end
    
    if count > 0 then
        bringBtn.Text = "تم جلب: " .. count
        task.wait(1)
        bringBtn.Text = "جلب البيض الآن"
    else
        bringBtn.Text = "لم يتم العثور عليها"
        task.wait(1)
        bringBtn.Text = "جلب البيض الآن"
    end
end)

print("✅ Egg Bringer Loaded!")
