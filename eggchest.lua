--[[
    🐝 MOB STICKER & AUTO-ATTACH UI
    ✅ واجهة متطورة للهواتف (Delta Support)
    ✅ نظام اختيار الموبات باللمس (Select Mob)
    ✅ الالتصاق بمركز الموب (Sticky Mode)
    ✅ التحكم بالسرعة وزر إعادة التعيين
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- متغيرات التحكم
local selectedMob = nil
local isAttaching = false
local playerSpeed = 16
local selectingMode = false

-- ==================== دالة السحب (Draggable) ====================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==================== بناء الواجهة ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobStickerHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "🐝 MOB STICKER"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- عرض اسم الموب المختار
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Target: None"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.15, 0)
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

-- زر الاختيار (Select)
local selectBtn = Instance.new("TextButton")
selectBtn.Text = "SELECT MOB"
selectBtn.Size = UDim2.new(0.8, 0, 0, 35)
selectBtn.Position = UDim2.new(0.1, 0, 0.28, 0)
selectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
selectBtn.TextColor3 = Color3.white
selectBtn.Font = Enum.Font.GothamBold
selectBtn.Parent = mainFrame
Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 8)

-- زر التشغيل (Toggle On/Off)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "STICK: OFF"
toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.1, 0, 0.43, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.TextColor3 = Color3.white
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- زر الريسيرش (Reset)
local resetBtn = Instance.new("TextButton")
resetBtn.Text = "RESET TARGET"
resetBtn.Size = UDim2.new(0.8, 0, 0, 35)
resetBtn.Position = UDim2.new(0.1, 0, 0.58, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resetBtn.TextColor3 = Color3.white
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = mainFrame
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 8)

-- نظام السرعة
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "WalkSpeed: 16"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.75, 0)
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.8, 0, 0, 5)
sliderBack.Position = UDim2.new(0.1, 0, 0.88, 0)
sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBack.Parent = mainFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.Position = UDim2.new(0.16, -7, 0.5, -7)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
sliderBtn.Text = ""
sliderBtn.Parent = sliderBack
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

makeDraggable(mainFrame)

-- ==================== المنطق البرمجي (Logic) ====================

-- 1. وظيفة اختيار الموب باللمس
selectBtn.MouseButton1Click:Connect(function()
    selectingMode = true
    selectBtn.Text = "TAP ON A MOB..."
    selectBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end -- يمنع الاختيار إذا ضغطت على زر الواجهة
    
    if selectingMode and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local target = mouse.Target
        if target then
            -- البحث عن المودل (الموب)
            local model = target:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildWhichIsA("Humanoid") then
                selectedMob = model
                statusLabel.Text = "Target: " .. model.Name
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                selectingMode = false
                selectBtn.Text = "MOB SELECTED!"
                selectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                task.wait(1)
                selectBtn.Text = "SELECT MOB"
            end
        end
    end
end)

-- 2. زر التشغيل والايقاف
toggleBtn.MouseButton1Click:Connect(function()
    if not selectedMob then 
        statusLabel.Text = "SELECT A MOB FIRST!"
        task.wait(1)
        statusLabel.Text = "Target: None"
        return 
    end
    
    isAttaching = not isAttaching
    if isAttaching then
        toggleBtn.Text = "STICK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleBtn.Text = "STICK: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- 3. زر الريسيت
resetBtn.MouseButton1Click:Connect(function()
    selectedMob = nil
    isAttaching = false
    statusLabel.Text = "Target: None"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleBtn.Text = "STICK: OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- 4. حلقة الالتصاق (التحديث المستمر)
RunService.Heartbeat:Connect(function()
    if isAttaching and selectedMob and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local mobRoot = selectedMob:FindFirstChild("HumanoidRootPart") or selectedMob:FindFirstChild("PrimaryPart") or selectedMob:FindFirstChildWhichIsA("BasePart")
        
        if mobRoot then
            -- الالتصاق بمركز الموب بظبط
            player.Character.HumanoidRootPart.CFrame = mobRoot.CFrame
        else
            -- إذا اختفى الموب
            isAttaching = false
            statusLabel.Text = "Mob Lost! Resetting..."
            toggleBtn.Text = "STICK: OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end)

-- 5. منطق السلايدر (السرعة)
local isSliding = false
local function updateSpeed(input)
    local rect = sliderBack.AbsolutePosition
    local width = sliderBack.AbsoluteSize.X
    local x = math.clamp(input.Position.X - rect.X, 0, width)
    local percentage = x / width
    sliderBtn.Position = UDim2.new(percentage, -7, 0.5, -7)
    playerSpeed = math.floor(percentage * 100)
    speedLabel.Text = "WalkSpeed: " .. playerSpeed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = playerSpeed
    end
end

sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input)
    end
end)

-- الحفاظ على السرعة عند الموت
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.5)
    hum.WalkSpeed = playerSpeed
end)

print("✅ Mob Sticker Hub Loaded!")
