

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
local noClipEnabled = false
local connections = {}
local lastUpdateTime = 0
local updateInterval = 0.1 -- Update setiap 0.1 detik untuk performa

-- Fungsi untuk setup character references
local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end

-- Setup awal
setupCharacter()

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoClipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Main corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title corner fix (bottom only)
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "👻 No Clip Pro"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 69, 69)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 12)
minimizeCorner.Parent = minimizeButton

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- No Clip toggle button
local noClipButton = Instance.new("TextButton")
noClipButton.Name = "NoClipButton"
noClipButton.Size = UDim2.new(1, 0, 0, 45)
noClipButton.Position = UDim2.new(0, 0, 0, 0)
noClipButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
noClipButton.BorderSizePixel = 0
noClipButton.Text = "👻 Enable No Clip"
noClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noClipButton.TextSize = 14
noClipButton.Font = Enum.Font.GothamBold
noClipButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = noClipButton

-- Button gradient
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 214, 123)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 204, 113))
}
buttonGradient.Rotation = 45
buttonGradient.Parent = noClipButton

-- Status frame
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 30)
statusFrame.Position = UDim2.new(0, 0, 0, 55)
statusFrame.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusFrame

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Status: Ready"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusFrame

-- Hotkey info
local hotkeyText = Instance.new("TextLabel")
hotkeyText.Name = "HotkeyText"
hotkeyText.Size = UDim2.new(1, 0, 0, 20)
hotkeyText.Position = UDim2.new(0, 0, 0, 95)
hotkeyText.BackgroundTransparency = 1
hotkeyText.Text = "Hotkey: N to toggle"
hotkeyText.TextColor3 = Color3.fromRGB(149, 165, 166)
hotkeyText.TextSize = 10
hotkeyText.Font = Enum.Font.Gotham
hotkeyText.TextXAlignment = Enum.TextXAlignment.Center
hotkeyText.Parent = contentFrame

-- Performance info
local performanceText = Instance.new("TextLabel")
performanceText.Name = "PerformanceText"
performanceText.Size = UDim2.new(1, 0, 0, 15)
performanceText.Position = UDim2.new(0, 0, 1, -15)
performanceText.BackgroundTransparency = 1
performanceText.Text = "Anti-Bug | Smooth Performance"
performanceText.TextColor3 = Color3.fromRGB(95, 39, 205)
performanceText.TextSize = 8
performanceText.Font = Enum.Font.GothamBold
performanceText.TextXAlignment = Enum.TextXAlignment.Center
performanceText.Parent = contentFrame

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
createHoverEffect(noClipButton, Color3.fromRGB(46, 204, 113), Color3.fromRGB(56, 214, 123))
createHoverEffect(closeButton, Color3.fromRGB(255, 69, 69), Color3.fromRGB(255, 89, 89))
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

-- Fungsi No Clip yang dioptimalkan
local function enableNoClip()
    if noClipEnabled then return end
    
    noClipEnabled = true
    statusText.Text = "Status: No Clip Active"
    noClipButton.Text = "🚫 Disable No Clip"
    noClipButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    
    -- Update button gradient
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(241, 86, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(231, 76, 60))
    }
    
    -- Optimized no clip loop
    connections.noClipLoop = RunService.Stepped:Connect(function()
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
        
        -- Apply no clip to all parts
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
        
        -- Handle accessories
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                for _, part in pairs(accessory:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    
    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "No Clip Pro";
        Text = "No Clip enabled! Walk through walls.";
        Duration = 3;
        Button1 = "OK";
    })
end

local function disableNoClip()
    if not noClipEnabled then return end
    
    noClipEnabled = false
    statusText.Text = "Status: Ready"
    noClipButton.Text = "👻 Enable No Clip"
    noClipButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    
    -- Update button gradient
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 214, 123)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 204, 113))
    }
    
    -- Cleanup connections
    cleanupConnections()
    
    -- Restore collision
    if character and character.Parent then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        -- Restore accessories collision
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                for _, part in pairs(accessory:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
    
    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "No Clip Pro";
        Text = "No Clip disabled! Collision restored.";
        Duration = 3;
        Button1 = "OK";
    })
end

-- Event connections
noClipButton.MouseButton1Click:Connect(function()
    if noClipEnabled then
        disableNoClip()
    else
        enableNoClip()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    disableNoClip()
    cleanupConnections()
    screenGui:Destroy()
end)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if minimized then
        -- Restore
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 180)})
        tween:Play()
        contentFrame.Visible = true
        minimizeButton.Text = "−"
        minimized = false
    else
        -- Minimize
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 35)})
        tween:Play()
        contentFrame.Visible = false
        minimizeButton.Text = "+"
        minimized = true
    end
end)

-- Hotkey support (N key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.N then
        if noClipEnabled then
            disableNoClip()
        else
            enableNoClip()
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    -- Auto-disable no clip on respawn
    if noClipEnabled then
        disableNoClip()
    end
    
    -- Update character references
    wait(1) -- Wait for character to load properly
    setupCharacter()
    
    statusText.Text = "Status: Character Respawned"
    wait(2)
    if not noClipEnabled then
        statusText.Text = "Status: Ready"
    end
end)

-- Cleanup on disconnect
game:BindToClose(function()
    disableNoClip()
    cleanupConnections()
end)

-- Performance monitoring
spawn(function()
    while screenGui.Parent do
        wait(5)
        if noClipEnabled then
            -- Check if character still exists
            if not character or not character.Parent then
                statusText.Text = "Status: Error - Reconnecting..."
                wait(1)
                setupCharacter()
                statusText.Text = "Status: No Clip Active"
            end
        end
    end
end)

-- Success notification
StarterGui:SetCore("SendNotification", {
    Title = "No Clip Pro";
    Text = "Script loaded successfully! Press N to toggle.";
    Duration = 5;
    Button1 = "OK";
})

print("No Clip Pro loaded successfully!")
print("- Press N to toggle No Clip")
print("- Anti-bug system active")
print("- Smooth performance optimized")
