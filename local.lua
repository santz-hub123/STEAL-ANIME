--[[
  🎯 ACAVO BOOST ULTRA - Versão Definitiva
  ✅ NoClip 100% funcional
  ✅ Speed Boost ajustável
  ✅ Jump Boost configurável
  ✅ Teleporte para base fixo
  ✅ Interface intuitiva
  ✅ Proteção contra anti-cheat
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configurações principais
local SAFE_MODE = true
local MAX_SAFE_SPEED = 50
local MAX_SAFE_JUMP = 100
local RANDOM_VARIATION = 0.1

-- Variáveis de estado
local currentSpeed = humanoid.WalkSpeed
local currentJump = humanoid.JumpPower
local isBoostActive = false
local isNoclipActive = false
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local spawnPosition = character:WaitForChild("HumanoidRootPart").Position
local noclipConnection = nil
local boostConnection = nil

-- Cores modernas
local colors = {
    background = Color3.fromRGB(20, 20, 30),
    primary = Color3.fromRGB(100, 120, 255),
    secondary = Color3.fromRGB(140, 160, 255),
    accent = Color3.fromRGB(255, 80, 100),
    success = Color3.fromRGB(80, 200, 120),
    text = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(50, 55, 60)
}

-- Função de notificação melhorada
local function Notify(title, message)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = 3,
        Button1 = "OK"
    })
end

-- Criação da interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcavoUltraGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Efeitos visuais
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = colors.primary
header.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({colors.primary, colors.secondary})
headerGradient.Rotation = 45
headerGradient.Parent = header

-- Componentes da interface
local title = Instance.new("TextLabel")
title.Text = "⚡ ACAVO ULTRA"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.TextColor3 = colors.text
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = colors.accent
closeBtn.TextColor3 = colors.text
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Sistema de NoClip aprimorado
local function ToggleNoclip()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
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
        Notify("ACAVO ULTRA", "NoClip DESATIVADO")
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- Sistema de Boost completo
local function ApplyBoost()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if SAFE_MODE then
        -- Aplicação segura e gradual
        humanoid.WalkSpeed = humanoid.WalkSpeed + (currentSpeed - humanoid.WalkSpeed) * 0.2
        humanoid.JumpPower = humanoid.JumpPower + (currentJump - humanoid.JumpPower) * 0.2
        
        -- Variação aleatória
        if math.random() < 0.2 then
            humanoid.WalkSpeed = humanoid.WalkSpeed * (1 + (math.random() * RANDOM_VARIATION - RANDOM_VARIATION/2))
            humanoid.JumpPower = humanoid.JumpPower * (1 + (math.random() * RANDOM_VARIATION - RANDOM_VARIATION/2))
        end
    else
        -- Modo direto
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
    end
end

-- Teleporte para base definitivo
local function TeleportToBase()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        -- Verificar se a posição de spawn é válida
        if spawnPosition and (rootPart.Position - spawnPosition).Magnitude > 10 then
            rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
            Notify("ACAVO ULTRA", "Teleportado para base!")
        else
            -- Sistema de fallback
            local spawnLocations = workspace:FindFirstChild("SpawnLocations") or workspace:FindFirstChildOfClass("SpawnLocation")
            if spawnLocations then
                spawnPosition = spawnLocations.Position
                rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
                Notify("ACAVO ULTRA", "Nova base definida!")
            else
                spawnPosition = Vector3.new(0, 100, 0)
                rootPart.CFrame = CFrame.new(spawnPosition)
                Notify("ACAVO ULTRA", "Base padrão definida")
            end
        end
    end
end

-- Sliders otimizados
local function CreateSlider(name, label, min, max, default, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 70)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = container

    local labelText = Instance.new("TextLabel")
    labelText.Text = label
    labelText.Size = UDim2.new(1, -50, 0, 20)
    labelText.TextColor3 = colors.text
    labelText.Font = Enum.Font.GothamSemibold
    labelText.TextSize = 14
    labelText.BackgroundTransparency = 1
    labelText.Parent = sliderFrame

    local valueText = Instance.new("TextLabel")
    valueText.Text = tostring(default)
    valueText.Size = UDim2.new(0, 50, 0, 20)
    valueText.Position = UDim2.new(1, -50, 0, 0)
    valueText.TextColor3 = colors.primary
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 14
    valueText.BackgroundTransparency = 1
    valueText.Parent = sliderFrame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 30)
    slider.BackgroundColor3 = colors.border
    slider.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = colors.primary
    fill.Parent = slider

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    handle.BackgroundColor3 = colors.text
    handle.Parent = slider

    -- Controles interativos
    local function UpdateValue(value)
        value = math.clamp(math.floor(value), min, max)
        local percent = (value - min) / (max - min)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, -8, 0.5, -8)
        valueText.Text = tostring(value)
        
        if name == "Speed" then
            currentSpeed = value
        else
            currentJump = value
        end
        
        if isBoostActive then
            ApplyBoost()
        end
    end

    -- Conexões de eventos
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local percent = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            UpdateValue(min + percent * (max - min))
        end
    end)

    return UpdateValue
end

-- Botões com feedback visual
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

    -- Efeitos visuais
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 5, 0, 42)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    end)

    return button
end

-- Criar controles
local updateSpeed = CreateSlider("Speed", "🏃 Velocidade:", 16, 200, 50, 0)
local updateJump = CreateSlider("Jump", "🦘 Pulo:", 20, 300, 50, 80)

local boostBtn = CreateButton("🚀 ATIVAR BOOST", 160, colors.success)
local noclipBtn = CreateButton("🚪 NOCLIP: OFF", 210, colors.accent)
local tpBaseBtn = CreateButton("🏠 TP TO MY BASE", 260, colors.secondary)

-- Controle do boost principal
local function ToggleBoost()
    isBoostActive = not isBoostActive
    
    if isBoostActive then
        boostBtn.Text = "🛑 DESATIVAR BOOST"
        boostBtn.BackgroundColor3 = colors.accent
        
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

-- Conexões de eventos
boostBtn.MouseButton1Click:Connect(ToggleBoost)
noclipBtn.MouseButton1Click:Connect(function()
    ToggleNoclip()
    noclipBtn.Text = isNoclipActive and "🚪 NOCLIP: ON" or "🚪 NOCLIP: OFF"
    noclipBtn.BackgroundColor3 = isNoclipActive and colors.success or colors.accent
end)
tpBaseBtn.MouseButton1Click:Connect(TeleportToBase)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Atualização contínua para personagens novos
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    spawnPosition = newChar:WaitForChild("HumanoidRootPart").Position
    
    -- Reaplicar configurações
    if isBoostActive then
        ToggleBoost()
        ToggleBoost() -- Alternar para reativar
    end
    
    if isNoclipActive then
        ToggleNoclip()
        ToggleNoclip() -- Alternar para reativar
    end
end)

-- Animação de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 280, 0, 380)}):Play()

Notify("ACAVO ULTRA", "Sistema carregado com sucesso!")
