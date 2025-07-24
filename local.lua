--[[
  🎯 ACAVO BOOST ULTRA - Versão Final
  ✅ Interface compacta (50% menor)
  ✅ Controles otimizados para mobile e PC
  ✅ Técnicas avançadas anti-detectação
  ✅ Sistema de NoClip integrado
  ✅ Teleporte para base
  ✅ Modo seguro configurável
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
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações de segurança
local SAFE_MODE = true -- Ativa proteções contra anti-cheat
local MAX_SAFE_SPEED = 35 -- Velocidade máxima "segura"
local MAX_SAFE_JUMP = 75 -- Pulo máximo "seguro"
local RANDOM_VARIATION = 0.15 -- Variação aleatória (0-1)

-- Cores do tema premium
local colors = {
    background = Color3.fromRGB(15, 15, 20),
    primary = Color3.fromRGB(88, 101, 242),
    secondary = Color3.fromRGB(114, 137, 218),
    accent = Color3.fromRGB(255, 73, 97),
    success = Color3.fromRGB(67, 181, 129),
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(185, 187, 190),
    border = Color3.fromRGB(40, 43, 48),
    orangeAccent = Color3.fromRGB(255, 140, 0),
    warning = Color3.fromRGB(255, 165, 0)
}

-- Estado do sistema
local currentSpeed = 16
local currentJump = 50
local isBoostActive = false
local isNoclipActive = false
local originalWalkSpeed = 16
local originalJumpPower = 50
local spawnPosition = nil
local noclipConnection = nil
local lastUpdate = 0

-- Função para notificações
local function notify(title, message, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 3
    })
end

-- Criação da interface otimizada
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcavoBoostUltra"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Frame principal (50% menor)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Efeitos visuais
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Header com gradiente
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = colors.primary
header.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, colors.primary),
    ColorSequenceKeypoint.new(1, colors.secondary)
})
headerGradient.Rotation = 45
headerGradient.Parent = header

-- Título e botão fechar
local title = Instance.new("TextLabel")
title.Text = "⚡ ACAVO ULTRA"
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = colors.text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = colors.accent
closeBtn.TextColor3 = colors.text
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

-- Container principal
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Status do sistema
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 30)
statusFrame.BackgroundColor3 = colors.border
statusFrame.Parent = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "🔍 Sistema Inicializado"
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.TextColor3 = colors.textSecondary
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

-- Função para criar sliders com controles mobile
local function createSlider(name, label, minVal, maxVal, defaultVal, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = container

    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Text = label
    labelText.Size = UDim2.new(1, -40, 0, 20)
    labelText.TextColor3 = colors.text
    labelText.Font = Enum.Font.GothamSemibold
    labelText.TextSize = 12
    labelText.BackgroundTransparency = 1
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = sliderFrame

    -- Valor atual
    local valueText = Instance.new("TextLabel")
    valueText.Text = tostring(defaultVal)
    valueText.Size = UDim2.new(0, 40, 0, 20)
    valueText.Position = UDim2.new(1, -40, 0, 0)
    valueText.TextColor3 = colors.primary
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 12
    valueText.BackgroundTransparency = 1
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = sliderFrame

    -- Controles mobile
    local decreaseBtn = Instance.new("TextButton")
    decreaseBtn.Text = "-"
    decreaseBtn.Size = UDim2.new(0, 25, 0, 25)
    decreaseBtn.Position = UDim2.new(0, 0, 0, 25)
    decreaseBtn.BackgroundColor3 = colors.accent
    decreaseBtn.TextColor3 = colors.text
    decreaseBtn.Font = Enum.Font.GothamBold
    decreaseBtn.Parent = sliderFrame

    local increaseBtn = Instance.new("TextButton")
    increaseBtn.Text = "+"
    increaseBtn.Size = UDim2.new(0, 25, 0, 25)
    increaseBtn.Position = UDim2.new(1, -25, 0, 25)
    increaseBtn.BackgroundColor3 = colors.success
    increaseBtn.TextColor3 = colors.text
    increaseBtn.Font = Enum.Font.GothamBold
    increaseBtn.Parent = sliderFrame

    -- Slider tradicional
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -60, 0, 6)
    sliderBg.Position = UDim2.new(0, 30, 0, 35)
    sliderBg.BackgroundColor3 = colors.border
    sliderBg.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = colors.primary
    sliderFill.Parent = sliderBg

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0, -5)
    sliderHandle.BackgroundColor3 = colors.text
    sliderHandle.Parent = sliderBg

    -- Arredondamentos
    for _, obj in pairs({sliderBg, sliderFill, sliderHandle, decreaseBtn, increaseBtn}) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, obj == sliderHandle and 8 or 4)
        corner.Parent = obj
    end

    -- Lógica do slider
    local currentValue = defaultVal
    local dragging = false

    local function updateValue(newValue)
        currentValue = math.clamp(math.floor(newValue), minVal, maxVal)
        local percent = (currentValue - minVal) / (maxVal - minVal)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percent, -8, 0, -5)
        valueText.Text = tostring(currentValue)
        
        if name == "Speed" then
            currentSpeed = currentValue
        else
            currentJump = currentValue
        end
        
        if isBoostActive then
            applyBoost()
        end
    end

    -- Conexões de eventos
    decreaseBtn.MouseButton1Click:Connect(function()
        updateValue(currentValue - 5)
    end)

    increaseBtn.MouseButton1Click:Connect(function()
        updateValue(currentValue + 5)
    end)

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((input.Position.X - sliderPos) / sliderSize, 0, 1)
            updateValue(minVal + percent * (maxVal - minVal))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return updateValue
end

-- Criar sliders
local updateSpeed = createSlider("Speed", "🏃 Velocidade", 16, 200, 50, 40)
local updateJump = createSlider("Jump", "🦘 Pulo", 50, 300, 100, 110)

-- Função para criar botões com efeitos
local function createButton(name, text, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.TextColor3 = colors.text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    -- Efeitos de hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 5, 0, 32)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
    end)

    return button
end

-- Botões principais
local toggleBtn = createButton("ToggleBoost", "🚀 ATIVAR BOOST", 180, colors.success)
local noclipBtn = createButton("Noclip", "🚪 NOCLIP: OFF", 220, colors.orangeAccent)
local tpBaseBtn = createButton("TeleportBase", "🏠 TELEPORTAR PARA BASE", 260, colors.secondary)

-- Sistema de NoClip avançado
local function toggleNoclip()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
        noclipBtn.Text = "🚪 NOCLIP: ON"
        noclipBtn.BackgroundColor3 = colors.success
        notify("ACAVO ULTRA", "NoClip ativado", 2)
        
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
        noclipBtn.BackgroundColor3 = colors.orangeAccent
        notify("ACAVO ULTRA", "NoClip desativado", 2)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- Teleporte para base
local function teleportToBase()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        if spawnPosition then
            rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
            notify("ACAVO ULTRA", "Teleportado para base!", 2)
        else
            -- Tentar encontrar spawn padrão
            local spawns = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
            if spawns then
                spawnPosition = spawns.Position
                rootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 3, 0))
                notify("ACAVO ULTRA", "Base definida e teleport realizado!", 2)
            else
                spawnPosition = Vector3.new(0, 50, 0)
                rootPart.CFrame = CFrame.new(spawnPosition)
                notify("ACAVO ULTRA", "Base padrão definida!", 3)
            end
        end
    end
end

-- Sistema de boost otimizado e seguro
local function applyBoost()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Proteção contra detecção
    local now = tick()
    if now - lastUpdate < 0.5 then return end -- Limitar atualizações
    lastUpdate = now
    
    if SAFE_MODE then
        -- Modificação gradual e aleatória
        local targetSpeed = math.min(currentSpeed, MAX_SAFE_SPEED)
        humanoid.WalkSpeed = humanoid.WalkSpeed + (targetSpeed - humanoid.WalkSpeed) * 0.3
        
        local targetJump = math.min(currentJump, MAX_SAFE_JUMP)
        humanoid.JumpPower = humanoid.JumpPower + (targetJump - humanoid.JumpPower) * 0.3
        
        -- Variação aleatória
        if math.random() < 0.3 then
            humanoid.WalkSpeed = humanoid.WalkSpeed * (1 + (math.random() * RANDOM_VARIATION * 2 - RANDOM_VARIATION))
            humanoid.JumpPower = humanoid.JumpPower * (1 + (math.random() * RANDOM_VARIATION * 2 - RANDOM_VARIATION))
        end
        
        -- Para velocidades acima do seguro, usar BodyVelocity complementar
        if currentSpeed > MAX_SAFE_SPEED then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local vel = rootPart:FindFirstChild("AV_BoostVelocity") or Instance.new("BodyVelocity")
                vel.Name = "AV_BoostVelocity"
                vel.MaxForce = Vector3.new(10000, 0, 10000)
                vel.Velocity = humanoid.MoveDirection * (currentSpeed - humanoid.WalkSpeed)
                vel.Parent = rootPart
            end
        end
    else
        -- Modo direto (menos seguro)
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
    end
end

-- Ativar/desativar boost
local function toggleBoost()
    isBoostActive = not isBoostActive
    
    if isBoostActive then
        toggleBtn.Text = "🛑 DESATIVAR BOOST"
        toggleBtn.BackgroundColor3 = colors.accent
        statusLabel.Text = "🟢 BOOST ATIVO | Vel: "..currentSpeed.." | Pulo: "..currentJump
        statusLabel.TextColor3 = colors.success
        
        -- Salvar valores originais
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                originalJumpPower = humanoid.JumpPower
            end
        end
        
        applyBoost()
        notify("ACAVO ULTRA", "Boost ativado (Modo "..(SAFE_MODE and "Seguro" or "Turbo")..")", 2)
    else
        toggleBtn.Text = "🚀 ATIVAR BOOST"
        toggleBtn.BackgroundColor3 = colors.success
        statusLabel.Text = "🔴 BOOST INATIVO"
        statusLabel.TextColor3 = colors.textSecondary
        
        -- Restaurar valores originais gradualmente
        coroutine.wrap(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Remover BodyVelocity se existir
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vel = rootPart:FindFirstChild("AV_BoostVelocity")
                        if vel then vel:Destroy() end
                    end
                    
                    -- Restauração suave
                    for i = 1, 10 do
                        if humanoid then
                            humanoid.WalkSpeed = originalWalkSpeed + (humanoid.WalkSpeed - originalWalkSpeed) * (1 - i/10)
                            humanoid.JumpPower = originalJumpPower + (humanoid.JumpPower - originalJumpPower) * (1 - i/10)
                            wait(0.1)
                        end
                    end
                end
            end
        end)()
        
        notify("ACAVO ULTRA", "Boost desativado", 2)
    end
end

-- Conexões de eventos
toggleBtn.MouseButton1Click:Connect(toggleBoost)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
tpBaseBtn.MouseButton1Click:Connect(teleportToBase)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Sistema de arrastar
local dragging = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Inicialização segura
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    -- Salvar spawn position
    if character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = character.HumanoidRootPart.Position
    end
    
    -- Reaplicar boost se estava ativo
    if isBoostActive then
        wait(math.random(1, 3)) -- Delay aleatório
        applyBoost()
    end
end)

-- Animação de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 250, 0, 350)}):Play()

notify("ACAVO ULTRA", "Sistema carregado com sucesso!", 3)

print("🎯 ACAVO BOOST ULTRA - Versão Final")
print("📱 Interface otimizada para mobile e PC")
print("🛡️ Sistema anti-detectação ativado")
print("⚡ Velocidade: "..currentSpeed.." | Pulo: "..currentJump)
print("🔒 Modo Seguro: "..tostring(SAFE_MODE))
