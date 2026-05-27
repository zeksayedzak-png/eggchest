--[[
    🚀 MOB STICKER & SPEED HUB (V2 - MOBILE OPTIMIZED)
    ✅ تم الإصلاح: واجهة في المنتصف + قابلة للسحب + حماية من الحذف
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- متغيرات التحكم
local stickEnabled = false
local isSelecting = false
local selectedMob = nil
local playerSpeed = 16

-- وظيفة تحديد مكان الواجهة لضمان الظهور في Delta
local function getParent()
    if gethui then return gethui() end
    return CoreGui
end

-- حذف النسخ القديمة لتجنب التكرار
if getParent():FindFirstChild("MobStickHub") then
    getParent():FindFirstChild("MobStickHub"):Destroy()
end

-- ==================== بناء الواجهة (GUI) ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobStickHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = getParent()

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 260)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- في منتصف الشاشة تماماً
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- نقطة الارتكاز في المنتصف
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- وظيفة السحب المتطورة للموبايل
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
end
makeDraggable(mainFrame)

local title = Instance.new("TextLabel")
title.Text = "🎯 MOB STICKER V2"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local mobDisplay = Instance.new("TextLabel")
mobDisplay.Text = "Target: None"
mobDisplay.Size = UDim2.new(0.9, 0, 0, 25)
mobDisplay.Position = UDim2.new(0.05, 0, 0.15, 0)
mobDisplay.TextColor3 = Color3.fromRGB(255, 200, 0)
mobDisplay.BackgroundTransparency = 1
mobDisplay.Font = Enum.Font.GothamMedium
mobDisplay.TextSize = 12
mobDisplay.Parent = mainFrame

-- زر الاختيار
local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(0.85, 0, 0, 35)
selectBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
selectBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
selectBtn.Text = "SELECT MOB"
selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.Parent = selectBtn

-- زر الالتصاق
local stickBtn = Instance.new("TextButton")
stickBtn.Size = UDim2.new(0.85, 0, 0, 35)
stickBtn.Position = UDim2.new(0.075, 0, 0.47, 0)
stickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stickBtn.Text = "STICK: OFF"
stickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stickBtn.Font = Enum.Font.GothamBold
stickBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.Parent = stickBtn

-- السلايدر (السرعة)
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Speed: 16"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.75, 0)
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = mainFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.8, 0, 0, 5)
sliderBack.Position = UDim2.new(0.1, 0, 0.9, 0)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.Parent = mainFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 16, 0, 16)
sliderBtn.Position = UDim2.new(0, 0, 0.5, -8)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.Text = ""
sliderBtn.Parent = sliderBack
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

-- زر التصغير (Toggle Button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "Menu"
toggleBtn.TextColor3 = Color3.white
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ==================== الوظائف المنطقية ====================

-- اختيار الموب باللمس
selectBtn.MouseButton1Click:Connect(function()
    isSelecting = true
    selectBtn.Text = "TAP A MOB..."
    selectBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
end)

UserInputService.InputBegan:Connect(function(input)
    if isSelecting and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local target = mouse.Target
        if target then
            local model = target:FindFirstAncestorOfClass("Model")
            if model then
                selectedMob = model
                mobDisplay.Text = "Target: " .. model.Name
                isSelecting = false
                selectBtn.Text = "SELECT MOB"
                selectBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
            end
        end
    end
end)

-- الالتصاق
stickBtn.MouseButton1Click:Connect(function()
    if not selectedMob then return end
    stickEnabled = not stickEnabled
    stickBtn.Text = stickEnabled and "STICK: ON" or "STICK: OFF"
    stickBtn.BackgroundColor3 = stickEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

RunService.Heartbeat:Connect(function()
    if stickEnabled and selectedMob and selectedMob:FindFirstChild("HumanoidRootPart") then
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            -- الالتصاق فوق رأس الموب بـ 5 بلاطات لضمان عدم حدوث Fling (طيران)
            myRoot.CFrame = selectedMob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

-- السرعة
local sliding = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        sliderBtn.Position = UDim2.new(pos, -8, 0.5, -8)
        playerSpeed = math.floor(pos * 200)
        speedLabel.Text = "Speed: " .. playerSpeed
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = playerSpeed
        end
    end
end)

print("✅ DONE! UI CENTERED AND READY.")
