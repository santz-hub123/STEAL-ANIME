-- 🎯 ACAVO BOOST GUI PREMIUM
-- Combinação dos melhores recursos dos dois scripts
-- Interface otimizada para mobile e PC

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cores do tema Acavo melhorado
local colors = {
    background = Color3.fromRGB(15, 15, 20),
    primary = Color3.fromRGB(88, 101, 242),
    secondary = Color3.fromRGB(114, 137, 218),
    accent = Color3.fromRGB(255, 73, 97),
    success = Color3.fromRGB(67, 181, 129),
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(185, 187, 190),
    border = Color3.fromRGB(40, 43, 48),
    orangeAccent = Color3.fromRGB(255, 140, 0)
}

-- Variáveis do boost
local currentSpeed = 16
local currentJump = 50
local isActive = false
local isNoclipActive = false
local noclipConnection = nil
local originalWalkSpeed = 16
local originalJumpPower = 50
local spawnPosition = nil

-- Criar notificação
local function createNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Função NoClip melhorada
local function toggleNoclip()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
        createNotification("ACAVO BOOST", "NoClip ativado!", 2)
        
        noclipConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.CanTouch = false
                        end
                    end
                    
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        humanoidRootPart.CanCollide = false
                        humanoidRootPart.CanTouch = false
                        
                        for _, bodyMover in pairs(humanoidRootPart:GetChildren()) do
                            if bodyMover:IsA("BodyVelocity") or bodyMover:IsA("BodyPosition") or bodyMover:IsA("BodyAngularVelocity") then
                                bodyMover:Destroy()
                            end
                        end
                    end
                end
            end)
        end)
    else
        createNotification("ACAVO BOOST", "NoClip desativado!", 2)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        pcall(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                        part.CanCollide = true
                        part.CanTouch = true
                    end
                end
            end
        end)
    end
end

-- Função para teleportar para a base
local function teleportToMyBase()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        
        if spawnPosition then
            humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 5, 0))
            createNotification("ACAVO BOOST", "Teleportado para sua base!", 2)
        else
            local spawnLocation = nil
            
            if player.Team then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("SpawnLocation") and obj.TeamColor == player.TeamColor then
                        spawnLocation = obj
                        break
                    end
                end
            end
            
            if not spawnLocation then
                spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
            end
            
            if spawnLocation then
                local spawnCFrame = spawnLocation.CFrame
                local frontPosition = spawnCFrame + (spawnCFrame.LookVector * 5)
                humanoidRootPart.CFrame = CFrame.new(frontPosition.Position + Vector3.new(0, 5, 0))
                spawnPosition = frontPosition.Position
                createNotification("ACAVO BOOST", "Base definida e teleport realizado!", 2)
            else
                humanoidRootPart.CFrame = CFrame.new(0, 10, 0)
                spawnPosition = Vector3.new(0, 5, 0)
                createNotification("ACAVO BOOST", "Base padrão definida!", 3)
            end
        end
    else
        createNotification("ACAVO BOOST", "Personagem não encontrado!", 2)
    end
end

-- Criar GUI principal (50% menor)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcavoBoostGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Frame principal (tamanho reduzido)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 350) -- 50% menor
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Efeito de sombra
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Bordas arredondadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Header com gradiente
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40) -- Menor
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = colors.primary
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Gradiente do header
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, colors.primary),
    ColorSequenceKeypoint.new(1, colors.secondary)
}
gradient.Rotation = 45
gradient.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ACAVO BOOST"
title.TextColor3 = colors.text
title.TextSize = 18 -- Menor
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30) -- Menor
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = colors.accent
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = colors.text
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Container principal
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Status do boost
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 30) -- Menor
statusFrame.Position = UDim2.new(0, 0, 0, 0)
statusFrame.BackgroundColor3 = colors.border
statusFrame.BorderSizePixel = 0
statusFrame.Parent = container

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔴 BOOST INATIVO"
statusLabel.TextColor3 = colors.textSecondary
statusLabel.TextSize = 12 -- Menor
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = statusFrame

-- Função para criar slider otimizado para mobile/PC
local function createSlider(name, displayName, minVal, maxVal, defaultVal, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Frame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 60) -- Menor
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20) -- Menor
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = displayName
    label.TextColor3 = colors.text
    label.TextSize = 12 -- Menor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 40, 0, 20) -- Menor
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = colors.primary
    valueLabel.TextSize = 12 -- Menor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    -- Controles para aumentar/diminuir (ótimo para mobile)
    local decreaseBtn = Instance.new("TextButton")
    decreaseBtn.Name = "DecreaseBtn"
    decreaseBtn.Size = UDim2.new(0, 25, 0, 25) -- Menor
    decreaseBtn.Position = UDim2.new(0, 0, 0, 25)
    decreaseBtn.BackgroundColor3 = colors.accent
    decreaseBtn.BorderSizePixel = 0
    decreaseBtn.Text = "-"
    decreaseBtn.TextColor3 = colors.text
    decreaseBtn.TextSize = 14
    decreaseBtn.Font = Enum.Font.GothamBold
    decreaseBtn.Parent = sliderFrame
    
    local decreaseCorner = Instance.new("UICorner")
    decreaseCorner.CornerRadius = UDim.new(0, 6)
    decreaseCorner.Parent = decreaseBtn
    
    local increaseBtn = Instance.new("TextButton")
    increaseBtn.Name = "IncreaseBtn"
    increaseBtn.Size = UDim2.new(0, 25, 0, 25) -- Menor
    increaseBtn.Position = UDim2.new(1, -25, 0, 25)
    increaseBtn.BackgroundColor3 = colors.success
    increaseBtn.BorderSizePixel = 0
    increaseBtn.Text = "+"
    increaseBtn.TextColor3 = colors.text
    increaseBtn.TextSize = 14
    increaseBtn.Font = Enum.Font.GothamBold
    increaseBtn.Parent = sliderFrame
    
    local increaseCorner = Instance.new("UICorner")
    increaseCorner.CornerRadius = UDim.new(0, 6)
    increaseCorner.Parent = increaseBtn
    
    -- Slider tradicional para PC
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, -60, 0, 6) -- Ajustado para os botões
    sliderBg.Position = UDim2.new(0, 30, 0, 35)
    sliderBg.BackgroundColor3 = colors.border
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 3)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = colors.primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 3)
    sliderFillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Size = UDim2.new(0, 16, 0, 16) -- Menor
    sliderHandle.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0, -5)
    sliderHandle.BackgroundColor3 = colors.text
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderBg
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = sliderHandle
    
    local currentValue = defaultVal
    local dragging = false
    
    local function updateSlider(value)
        currentValue = math.clamp(value, minVal, maxVal)
        local percentage = (currentValue - minVal) / (maxVal - minVal)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -8, 0, -5)
        valueLabel.Text = tostring(math.floor(currentValue))
        
        if name == "Speed" then
            currentSpeed = currentValue
        elseif name == "Jump" then
            currentJump = currentValue
        end
        
        if isActive then
            applyBoost()
        end
    end
    
    -- Controles para mobile
    decreaseBtn.MouseButton1Click:Connect(function()
        updateSlider(currentValue - 5)
    end)
    
    increaseBtn.MouseButton1Click:Connect(function()
        updateSlider(currentValue + 5)
    end)
    
    -- Slider para PC
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percentage
            
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                percentage = math.clamp((input.Position.X - sliderPos) / sliderSize, 0, 1)
            else -- Touch
                local touchPos = input.Position.X
                percentage = math.clamp((touchPos - sliderPos) / sliderSize, 0, 1)
            end
            
            local value = math.floor(minVal + percentage * (maxVal - minVal))
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return updateSlider
end

-- Criar sliders com controles para mobile
local updateSpeed = createSlider("Speed", "🏃 Velocidade", 1, 200, 50, 40)
local updateJump = createSlider("Jump", "🦘 Força do Pulo", 1, 300, 100, 110)

-- Botões de funcionalidades extras
local function createFeatureButton(name, text, yPos, color, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 30) -- Menor
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = colors.text
    button.TextSize = 12 -- Menor
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Efeitos de hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 5, 0, 32)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
    end)
    
    return button
end

-- Botão principal toggle
local toggleBtn = createFeatureButton("ToggleButton", "🚀 ATIVAR BOOST", 180, colors.success, container)

-- Botão NoClip
local noclipBtn = createFeatureButton("NoclipButton", "🚪 NOCLIP: OFF", 220, colors.orangeAccent, container)

-- Botão TP Base
local tpBaseBtn = createFeatureButton("TpBaseButton", "🏠 TELEPORTAR PARA BASE", 260, colors.secondary, container)

-- Funções do boost
function applyBoost()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
    end
end

function toggleBoost()
    isActive = not isActive
    
    if isActive then
        toggleBtn.Text = "🛑 PARAR BOOST"
        toggleBtn.BackgroundColor3 = colors.accent
        statusLabel.Text = "🟢 BOOST ATIVO - Speed: " .. currentSpeed .. " | Jump: " .. currentJump
        statusLabel.TextColor3 = colors.success
        applyBoost()
    else
        toggleBtn.Text = "🚀 ATIVAR BOOST"
        toggleBtn.BackgroundColor3 = colors.success
        statusLabel.Text = "🔴 BOOST INATIVO"
        statusLabel.TextColor3 = colors.textSecondary
        
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character.Humanoid
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.JumpPower = originalJumpPower
        end
    end
end

-- Atualizar botão NoClip
local function updateNoclipButton()
    noclipBtn.Text = isNoclipActive and "🚪 NOCLIP: ON" or "🚪 NOCLIP: OFF"
    noclipBtn.BackgroundColor3 = isNoclipActive and colors.success or colors.orangeAccent
end

-- Eventos
toggleBtn.MouseButton1Click:Connect(toggleBoost)
noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
    updateNoclipButton()
end)
tpBaseBtn.MouseButton1Click:Connect(teleportToMyBase)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Auto-aplicar após respawn
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    -- Salvar valores originais
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
    end
    
    wait(1)
    if isActive then
        applyBoost()
    end
    if isNoclipActive then
        toggleNoclip()
    end
end)

-- Salvar posição de spawn inicial
spawn(function()
    wait(5)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = player.Character.HumanoidRootPart.Position
    end
end)

-- Arrastar GUI
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

-- Animação de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 250, 0, 350)})
openTween:Play()

createNotification("ACAVO BOOST", "Interface premium carregada!", 3)

print("🎯 ACAVO BOOST GUI carregada com sucesso!")
print("📱 Interface otimizada para mobile e PC")
print("⚡ Controles de velocidade e pulo aprimorados")
print("🚪 NoClip e Teleporte para base adicionados")
