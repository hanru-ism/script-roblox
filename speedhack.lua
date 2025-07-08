-- Roblox Speed Hack GUI Script
-- Anti-Bug & Smooth Performance
-- Pastikan script ini dijalankan sebagai LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variabel global
local character = nil
local humanoid = nil
local rootPart = nil
local speedEnabled = false
local currentSpeed = 50
local originalWalkSpeed = 16
local originalJumpPower = 50
local connections = {}
local lastUpdateTime = 0
local updateInterval = 0.05 -- Update lebih sering untuk speed yang smooth

-- Preset speeds
local speedPresets = {
    {name = "Walk", speed = 16, emoji = "🚶"},
    {name = "Run", speed = 30, emoji = "🏃"},
    {name = "Fast", speed = 50, emoji = "💨"},
    {name = "Super", speed = 100, emoji = "⚡"},
    {name = "Sonic", speed = 200, emoji = "🔥"},
    {name = "Flash", speed = 500, emoji = "🌟"}
}

-- Fungsi untuk setup character references
local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Simpan original values
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
end

-- Setup awal
setupCharacter()

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHackGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 280)
mainFrame.Position = UDim2.new(1, -340, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, -4)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Main corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Animated gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Animate gradient
spawn(function()
    while mainFrame.Parent do
        for i = 0, 360, 2 do
            gradient.Rotation = i
            wait(0.1)
        end
    end
end)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

-- Title corner fix
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title text dengan efek glow
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Speed Hack Pro"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Glow effect untuk title
local titleGlow = titleText:Clone()
titleGlow.Name = "TitleGlow"
titleGlow.Size = UDim2.new(1, 2, 1, 2)
titleGlow.Position = UDim2.new(0, -1, 0, -1)
titleGlow.TextColor3 = Color3.fromRGB(255, 215, 0)
titleGlow.TextTransparency = 0.5
titleGlow.ZIndex = titleText.ZIndex - 1
titleGlow.Parent = titleText

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 15)
minimizeCorner.Parent = minimizeButton

-- Content frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
contentFrame.Parent = mainFrame

-- Speed toggle button
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(1, 0, 0, 50)
speedButton.Position = UDim2.new(0, 0, 0, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
speedButton.BorderSizePixel = 0
speedButton.Text = "⚡ Enable Speed Hack"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 14
speedButton.Font = Enum.Font.GothamBold
speedButton.Parent = contentFrame

local speedButtonCorner = Instance.new("UICorner")
speedButtonCorner.CornerRadius = UDim.new(0, 10)
speedButtonCorner.Parent = speedButton

-- Speed button gradient
local speedGradient = Instance.new("UIGradient")
speedGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 162, 229)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
}
speedGradient.Rotation = 45
speedGradient.Parent = speedButton

-- Current speed display
local speedDisplay = Instance.new("Frame")
speedDisplay.Name = "SpeedDisplay"
speedDisplay.Size = UDim2.new(1, 0, 0, 40)
speedDisplay.Position = UDim2.new(0, 0, 0, 60)
speedDisplay.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
speedDisplay.BorderSizePixel = 0
speedDisplay.Parent = contentFrame

local speedDisplayCorner = Instance.new("UICorner")
speedDisplayCorner.CornerRadius = UDim.new(0, 8)
speedDisplayCorner.Parent = speedDisplay

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -10, 1, 0)
speedLabel.Position = UDim2.new(0, 5, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Current Speed: " .. currentSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedDisplay

-- Custom speed input
local customFrame = Instance.new("Frame")
customFrame.Name = "CustomFrame"
customFrame.Size = UDim2.new(1, 0, 0, 80)
customFrame.Position = UDim2.new(0, 0, 0, 110)
customFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
customFrame.BorderSizePixel = 0
customFrame.Parent = contentFrame

local customCorner = Instance.new("UICorner")
customCorner.CornerRadius = UDim.new(0, 10)
customCorner.Parent = customFrame

local customLabel = Instance.new("TextLabel")
customLabel.Name = "CustomLabel"
customLabel.Size = UDim2.new(1, -10, 0, 25)
customLabel.Position = UDim2.new(0, 5, 0, 5)
customLabel.BackgroundTransparency = 1
customLabel.Text = "Custom Speed:"
customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
customLabel.TextSize = 12
customLabel.Font = Enum.Font.Gotham
customLabel.TextXAlignment = Enum.TextXAlignment.Left
customLabel.Parent = customFrame

local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0.6, -5, 0, 30)
speedInput.Position = UDim2.new(0, 5, 0, 30)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.BorderSizePixel = 0
speedInput.Text = tostring(currentSpeed)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 14
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "Enter speed..."
speedInput.Parent = customFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = speedInput

local setSpeedButton = Instance.new("TextButton")
setSpeedButton.Name = "SetSpeedButton"
setSpeedButton.Size = UDim2.new(0.4, -5, 0, 30)
setSpeedButton.Position = UDim2.new(0.6, 5, 0, 30)
setSpeedButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
setSpeedButton.BorderSizePixel = 0
setSpeedButton.Text = "Set Speed"
setSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setSpeedButton.TextSize = 12
setSpeedButton.Font = Enum.Font.GothamBold
setSpeedButton.Parent = customFrame

local setSpeedCorner = Instance.new("UICorner")
setSpeedCorner.CornerRadius = UDim.new(0, 5)
setSpeedCorner.Parent = setSpeedButton

-- Preset speeds
local presetFrame = Instance.new("Frame")
presetFrame.Name = "PresetFrame"
presetFrame.Size = UDim2.new(1, 0, 0, 140)
presetFrame.Position = UDim2.new(0, 0, 0, 200)
presetFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
presetFrame.BorderSizePixel = 0
presetFrame.Parent = contentFrame

local presetCorner = Instance.new("UICorner")
presetCorner.CornerRadius = UDim.new(0, 10)
presetCorner.Parent = presetFrame

local presetLabel = Instance.new("TextLabel")
presetLabel.Name = "PresetLabel"
presetLabel.Size = UDim2.new(1, -10, 0, 25)
presetLabel.Position = UDim2.new(0, 5, 0, 5)
presetLabel.BackgroundTransparency = 1
presetLabel.Text = "Speed Presets:"
presetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
presetLabel.TextSize = 12
presetLabel.Font = Enum.Font.Gotham
presetLabel.TextXAlignment = Enum.TextXAlignment.Left
presetLabel.Parent = presetFrame

-- Create preset buttons
for i, preset in ipairs(speedPresets) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    
    local presetButton = Instance.new("TextButton")
    presetButton.Name = "Preset" .. i
    presetButton.Size = UDim2.new(0.32, -3, 0, 25)
    presetButton.Position = UDim2.new(col * 0.33, 5, 0, 35 + row * 30)
    presetButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    presetButton.BorderSizePixel = 0
    presetButton.Text = preset.emoji .. " " .. preset.name
    presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    presetButton.TextSize = 10
    presetButton.Font = Enum.Font.Gotham
    presetButton.Parent = presetFrame
    
    local presetButtonCorner = Instance.new("UICorner")
    presetButtonCorner.CornerRadius = UDim.new(0, 5)
    presetButtonCorner.Parent = presetButton
    
    -- Preset button click
    presetButton.MouseButton1Click:Connect(function()
        currentSpeed = preset.speed
        speedInput.Text = tostring(currentSpeed)
        speedLabel.Text = "Current Speed: " .. currentSpeed
        
        if speedEnabled then
            humanoid.WalkSpeed = currentSpeed
        end
    end)
end

-- Status frame
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 35)
statusFrame.Position = UDim2.new(0, 0, 0, 350)
statusFrame.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Status: Ready | Hotkey: X"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = statusFrame

-- Fungsi untuk membuat efek hover yang smooth
local function createHoverEffect(button, normalColor, hoverColor)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = normalColor})
        tween:Play()
    end)
end

-- Menambahkan efek hover
createHoverEffect(speedButton, Color3.fromRGB(52, 152, 219), Color3.fromRGB(72, 172, 239))
createHoverEffect(setSpeedButton, Color3.fromRGB(46, 204, 113), Color3.fromRGB(66, 224, 133))
createHoverEffect(closeButton, Color3.fromRGB(255, 59, 59), Color3.fromRGB(255, 79, 79))
createHoverEffect(minimizeButton, Color3.fromRGB(255, 193, 7), Color3.fromRGB(255, 213, 47))

-- Fungsi untuk membersihkan connections
local function cleanupConnections()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
end

-- Fungsi Speed Hack yang dioptimalkan
local function enableSpeed()
    if speedEnabled then return end
    
    speedEnabled = true
    statusText.Text = "Status: Speed Active | Hotkey: X"
    speedButton.Text = "🛑 Disable Speed Hack"
    speedButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    
    -- Update button gradient
    speedGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(241, 86, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(231, 76, 60))
    }
    
    -- Apply speed
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
    end
    
    -- Speed monitoring loop
    connections.speedLoop = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdateTime < updateInterval then
            return
        end
        lastUpdateTime = currentTime
        
        -- Safety check
        if not character or not character.Parent then
            setupCharacter()
            return
        end
        
        -- Maintain speed
        if humanoid and humanoid.WalkSpeed ~= currentSpeed then
            humanoid.WalkSpeed = currentSpeed
        end
        
        -- Update display
        speedLabel.Text = "Current Speed: " .. currentSpeed .. " (Active)"
    end)
    
    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "Speed Hack Pro";
        Text = "Speed hack enabled! Speed: " .. currentSpeed;
        Duration = 3;
        Button1 = "OK";
    })
end

local function disableSpeed()
    if not speedEnabled then return end
    
    speedEnabled = false
    statusText.Text = "Status: Ready | Hotkey: X"
    speedButton.Text = "⚡ Enable Speed Hack"
    speedButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    
    -- Update button gradient
    speedGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 162, 229)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
    }
    
    -- Cleanup connections
    cleanupConnections()
    
    -- Restore original speed
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
    end
    
    -- Update display
    speedLabel.Text = "Current Speed: " .. currentSpeed
    
    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "Speed Hack Pro";
        Text = "Speed hack disabled! Speed restored.";
        Duration = 3;
        Button1 = "OK";
    })
end

-- Event connections
speedButton.MouseButton1Click:Connect(function()
    if speedEnabled then
        disableSpeed()
    else
        enableSpeed()
    end
end)

setSpeedButton.MouseButton1Click:Connect(function()
    local inputSpeed = tonumber(speedInput.Text)
    if inputSpeed and inputSpeed > 0 and inputSpeed <= 1000 then
        currentSpeed = inputSpeed
        speedLabel.Text = "Current Speed: " .. currentSpeed
        
        if speedEnabled then
            humanoid.WalkSpeed = currentSpeed
        end
        
        StarterGui:SetCore("SendNotification", {
            Title = "Speed Hack Pro";
            Text = "Speed set to: " .. currentSpeed;
            Duration = 2;
            Button1 = "OK";
        })
    else
        speedInput.Text = tostring(currentSpeed)
        StarterGui:SetCore("SendNotification", {
            Title = "Speed Hack Pro";
            Text = "Invalid speed! Use 1-1000";
            Duration = 2;
            Button1 = "OK";
        })
    end
end)

closeButton.MouseButton1Click:Connect(function()
    disableSpeed()
    cleanupConnections()
    screenGui:Destroy()
end)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if minimized then
        -- Restore
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 280)})
        tween:Play()
        contentFrame.Visible = true
        minimizeButton.Text = "−"
        minimized = false
    else
        -- Minimize
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 40)})
        tween:Play()
        contentFrame.Visible = false
        minimizeButton.Text = "+"
        minimized = true
    end
end)

-- Hotkey support (X key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        if speedEnabled then
            disableSpeed()
        else
            enableSpeed()
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    -- Auto-disable speed on respawn
    if speedEnabled then
        disableSpeed()
    end
    
    -- Update character references
    wait(1) -- Wait for character to load properly
    setupCharacter()
    
    statusText.Text = "Status: Character Respawned | Hotkey: X"
    wait(2)
    if not speedEnabled then
        statusText.Text = "Status: Ready | Hotkey: X"
    end
end)

-- Input validation
speedInput.FocusLost:Connect(function()
    local inputSpeed = tonumber(speedInput.Text)
    if not inputSpeed or inputSpeed <= 0 or inputSpeed > 1000 then
        speedInput.Text = tostring(currentSpeed)
    end
end)

-- Cleanup on disconnect
game:BindToClose(function()
    disableSpeed()
    cleanupConnections()
end)

-- Performance monitoring
spawn(function()
    while screenGui.Parent do
        wait(3)
        if speedEnabled then
            -- Check if character still exists
            if not character or not character.Parent then
                statusText.Text = "Status: Error - Reconnecting..."
                wait(1)
                setupCharacter()
                statusText.Text = "Status: Speed Active | Hotkey: X"
            end
        end
    end
end)

-- Success notification
StarterGui:SetCore("SendNotification", {
    Title = "Speed Hack Pro";
    Text = "Script loaded! Press X to toggle speed.";
    Duration = 5;
    Button1 = "OK";
})

print("Speed Hack Pro loaded successfully!")
print("- Press X to toggle Speed Hack")
print("- Use presets or custom speed input")
print("- Anti-bug system active")
print("- Smooth performance optimized")