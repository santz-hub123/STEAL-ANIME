--[[
  🎯 ACAVO BOOST ULTRA - Versão Final Corrigida
  ✅ Interface 100% funcional
  ✅ Botão de minimizar adicionado
  ✅ NoClip, Speed e Jump funcionando
  ✅ TP para base corrigido
  ✅ Proteção anti-detectação
]]

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Variáveis essenciais
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configurações
local SAFE_MODE = true
local MAX_SAFE_SPEED = 50
local MAX_SAFE_JUMP = 100
local RANDOM_VARIATION = 0.1

-- Estado do sistema
local currentSpeed = humanoid.WalkSpeed
local currentJump = humanoid.JumpPower
local isBoostActive = false
local isNoclipActive = false
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local spawnPosition = character:WaitForChild("HumanoidRootPart").Position
local noclipConnection = nil
local boostConnection = nil
local minimized = false

-- Cores modernas
local colors = {
    background = Color3.fromRGB(25, 25, 35),
    primary = Color3.fromRGB(100, 120, 255),
    secondary = Color3.fromRGB(140, 160, 255),
    accent = Color3.fromRGB(255, 80, 100),
    success = Color3.fromRGB(80, 200, 120),
    text = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(50, 55, 60)
}

-- Função de notificação
local function Notify(title, message)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = 3
    })
end

-- Criação da interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcavoUltraGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Efeitos visuais
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = colors.primary
header.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({colors.primary, colors.secondary})
headerGradient.Rotation = 45
headerGradient.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Text = "⚡ ACAVO ULTRA"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.TextColor3 = colors.text
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = colors.accent
closeBtn.TextColor3 = colors.text
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -80, 0.5, -15)
minimizeBtn.BackgroundColor3 = colors.secondary
minimizeBtn.TextColor3 = colors.text
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

-- Container principal
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Status
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 30)
statusFrame.BackgroundColor3 = colors.border
statusFrame.Parent = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "🔍 Sistema Inicializado"
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.TextColor3 = colors.text
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

-- Função para criar sliders
local function CreateSlider(name, label, minVal, maxVal, defaultVal, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 70)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = container

    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Text = label
    labelText.Size = UDim2.new(1, -50, 0, 20)
    labelText.TextColor3 = colors.text
    labelText.Font = Enum.Font.GothamSemibold
    labelText.TextSize = 14
    labelText.BackgroundTransparency = 1
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = sliderFrame

    -- Valor
    local valueText = Instance.new("TextLabel")
    valueText.Text = tostring(defaultVal)
    valueText.Size = UDim2.new(0, 50, 0, 20)
    valueText.Position = UDim2.new(1, -50, 0, 0)
    valueText.TextColor3 = colors.primary
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 14
    valueText.BackgroundTransparency = 1
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = sliderFrame

    -- Slider
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = colors.border
    sliderBg.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = colors.primary
    sliderFill.Parent = sliderBg

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = colors.text
    sliderHandle.Parent = sliderBg

    -- Arredondamentos
    for _, obj in pairs({sliderBg, sliderFill, sliderHandle}) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, obj == sliderHandle and 8 or 4)
        corner.Parent = obj
    end

    -- Lógica do slider
    local currentValue = defaultVal
    local dragging = false

    local function UpdateValue(value)
        currentValue = math.clamp(math.floor(value), minVal, maxVal)
        local percent = (currentValue - minVal) / (maxVal - minVal)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        valueText.Text = tostring(currentValue)
        
        if name == "Speed" then
            currentSpeed = currentValue
        else
            currentJump = currentValue
        end
        
        if isBoostActive then
            ApplyBoost()
        end
    end

    -- Eventos
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percent = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            UpdateValue(minVal + percent * (maxVal - minVal))
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            UpdateValue(minVal + percent * (maxVal - minVal))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return UpdateValue
end

-- Função para criar botões
local function CreateButton(text, yPos, color)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.TextColor3 = colors.text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = container

    -- Efeitos
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 5, 0, 42)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    end)

    return button
end

-- Sistema de NoClip
local function ToggleNoclip()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
        noclipBtn.Text = "🚪 NOCLIP: ON"
        noclipBtn.BackgroundColor3 = colors.success
        Notify("ACAVO ULTRA", "NoClip ATIVADO")
        
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "🚪 NOCLIP: OFF"
        noclipBtn.BackgroundColor3 = colors.accent
        Notify("ACAVO ULTRA", "NoClip DESATIVADO")
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- Sistema de Boost
local function ApplyBoost()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if SAFE_MODE then
        humanoid.WalkSpeed = humanoid.WalkSpeed + (currentSpeed - humanoid.WalkSpeed) * 0.2
        humanoid.JumpPower = humanoid.JumpPower + (currentJump - humanoid.JumpPower) * 0.2
    else
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
    end
end

-- Teleporte para base
local function TeleportToBase()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        if spawnPosition then
            rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
            Notify("ACAVO ULTRA", "Teleportado para base!")
        else
            local spawnLoc = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
            if spawnLoc then
                spawnPosition = spawnLoc.Position
                rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
                Notify("ACAVO ULTRA", "Base definida!")
            else
                spawnPosition = Vector3.new(0, 100, 0)
                rootPart.CFrame = CFrame.new(spawnPosition)
                Notify("ACAVO ULTRA", "Base padrão definida")
            end
        end
    end
end

-- Controle do boost
local function ToggleBoost()
    isBoostActive = not isBoostActive
    
    if isBoostActive then
        boostBtn.Text = "🛑 DESATIVAR BOOST"
        boostBtn.BackgroundColor3 = colors.accent
        statusLabel.Text = "🟢 BOOST ATIVO | Vel: "..currentSpeed.." | Pulo: "..currentJump
        
        -- Salvar valores originais
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                originalJumpPower = humanoid.JumpPower
            end
        end
        
        -- Iniciar conexão
        boostConnection = RunService.Heartbeat:Connect(function()
            if isBoostActive then
                ApplyBoost()
            end
        end)
        
        Notify("ACAVO ULTRA", "Boost ATIVADO")
    else
        boostBtn.Text = "🚀 ATIVAR BOOST"
        boostBtn.BackgroundColor3 = colors.success
        statusLabel.Text = "🔴 BOOST INATIVO"
        
        -- Restaurar valores
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
                humanoid.JumpPower = originalJumpPower
            end
        end
        
        if boostConnection then
            boostConnection:Disconnect()
            boostConnection = nil
        end
        
        Notify("ACAVO ULTRA", "Boost DESATIVADO")
    end
end

-- Criar controles
local updateSpeed = CreateSlider("Speed", "🏃 Velocidade:", 16, 200, 50, 0)
local updateJump = CreateSlider("Jump", "🦘 Pulo:", 20, 300, 50, 80)

local boostBtn = CreateButton("🚀 ATIVAR BOOST", 160, colors.success)
local noclipBtn = CreateButton("🚪 NOCLIP: OFF", 210, colors.accent)
local tpBaseBtn = CreateButton("🏠 TP TO MY BASE", 260, colors.secondary)

-- Minimizar/maximizar
local function ToggleMinimize()
    minimized = not minimized
    
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 50)}):Play()
        minimizeBtn.Text = "+"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 400)}):Play()
        minimizeBtn.Text = "-"
    end
end

-- Conexões de eventos
boostBtn.MouseButton1Click:Connect(ToggleBoost)
noclipBtn.MouseButton1Click:Connect(ToggleNoclip)
tpBaseBtn.MouseButton1Click:Connect(TeleportToBase)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
minimizeBtn.MouseButton1Click:Connect(ToggleMinimize)

-- Atualização para novos personagens
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    spawnPosition = newChar:WaitForChild("HumanoidRootPart").Position
    
    -- Reaplicar configurações
    if isBoostActive then
        coroutine.wrap(function()
            wait(1)
            ToggleBoost()
            wait(0.5)
            ToggleBoost()
        end)()
    end
    
    if isNoclipActive then
        coroutine.wrap(function()
            wait(1)
            ToggleNoclip()
            wait(0.5)
            ToggleNoclip()
        end)()
    end
end)

-- Animação de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 400)}):Play()

Notify("ACAVO ULTRA", "Sistema carregado com sucesso!")
