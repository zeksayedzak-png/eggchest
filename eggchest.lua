--[[
    💰 TREASURE HUNTER HUB (MOBILE OPTIMIZED)
    ✅ الانتقال العشوائي للصناديق (SilverChest)
    ✅ منع التكرار (ينقلك لصندوق مختلف كل مرة)
    ✅ شريط تحكم بالسرعة (0-100)
    ✅ متوافق مع Delta & Mobile
]]--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local lastChest = nil -- لتخزين آخر صندوق تم الذهاب إليه

-- متغيرات التحكم
local playerSpeed = 16

-- ==================== دالة السحب (Draggable GUI) للهواتف ====================
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

-- ==================== بناء الواجهة (GUI) ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TreasureSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 240)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "💎 TREASURE HUB"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- زر الانتقال للصندوق (Next Chest)
local tpButton = Instance.new("TextButton")
tpButton.Text = "NEXT CHEST 💰"
tpButton.Size = UDim2.new(0.85, 0, 0, 50)
tpButton.Position = UDim2.new(0.075, 0, 0.25, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.AutoButtonColor = true
tpButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = tpButton

-- نظام السرعة (Slider)
local speedTitle = Instance.new("TextLabel")
speedTitle.Text = "Speed: 16"
speedTitle.Size = UDim2.new(1, 0, 0, 20)
speedTitle.Position = UDim2.new(0, 0, 0.55, 0)
speedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
speedTitle.BackgroundTransparency = 1
speedTitle.Font = Enum.Font.Gotham
speedTitle.Parent = mainFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.8, 0, 0, 6)
sliderBack.Position = UDim2.new(0.1, 0, 0.75, 0)
sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBack.Parent = mainFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 20, 0, 20)
sliderBtn.Position = UDim2.new(0.16, -10, 0.5, -10)
sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
sliderBtn.Text = ""
sliderBtn.Parent = sliderBack

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBtn

makeDraggable(mainFrame)

-- ==================== منطق البرمجة (Logic) ====================

-- دالة البحث عن الصناديق والانتقال لعشوائي منها
local function teleportToRandomChest()
    local treasuresFolder = workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("Nodes") and workspace.Interactions.Nodes:FindFirstChild("Treasure")
    
    if not treasuresFolder then
        warn("لم يتم العثور على مجلد الصناديق!")
        return
    end

    local allChests = {}
    
    -- جمع كل الصناديق المتاحة (SilverChest)
    for _, folder in pairs(treasuresFolder:GetChildren()) do
        local lid = folder:FindFirstChild("SilverChest") and folder.SilverChest:FindFirstChild("Lid")
        if lid then
            -- التأكد أنه ليس نفس الصندوق الأخير
            if lid ~= lastChest then
                table.insert(allChests, lid)
            end
        end
    end

    -- إذا وجدنا صناديق
    if #allChests > 0 then
        local randomChest = allChests[math.random(1, #allChests)]
        lastChest = randomChest -- تحديث الصندوق الأخير لمنع التكرار
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- الانتقال فوق الصندوق بمسافة بسيطة (3 ستود)
            player.Character.HumanoidRootPart.CFrame = randomChest.CFrame * CFrame.new(0, 3, 0)
            print("تم الانتقال إلى صندوق جديد: " .. randomChest.Parent.Parent.Name)
        end
    else
        -- في حال كان هناك صندوق واحد فقط في الخريطة كلها
        lastChest = nil
        print("جاري إعادة البحث عن صناديق...")
    end
end

-- تفعيل زر التنقل
tpButton.MouseButton1Click:Connect(function()
    teleportToRandomChest()
    -- تأثير بصري بسيط عند الضغط
    tpButton.Text = "TELEPORTING..."
    task.wait(0.3)
    tpButton.Text = "NEXT CHEST 💰"
end)

-- منطق شريط السرعة
local isSliding = false

local function updateSpeed(input)
    local rect = sliderBack.AbsolutePosition
    local width = sliderBack.AbsoluteSize.X
    local x = math.clamp(input.Position.X - rect.X, 0, width)
    local percentage = x / width
    sliderBtn.Position = UDim2.new(percentage, -10, 0.5, -10)
    
    playerSpeed = math.floor(percentage * 100)
    speedTitle.Text = "Speed: " .. playerSpeed
    
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = playerSpeed
    end
end

sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input)
    end
end)

-- الحفاظ على السرعة عند الرسبون
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.5)
    hum.WalkSpeed = playerSpeed
end)

print("✅ Treasure Script Loaded! Use the button to TP.")
