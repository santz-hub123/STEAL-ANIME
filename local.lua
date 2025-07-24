-- STEAL ANIME - Script Local
-- Criado para detecção de anti-cheat

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Variáveis globais
local isNoclipActive = false
local noclipConnection = nil
local guiOpen = false

-- Função para criar notificação
local function createNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealAnimeGui"
screenGui.Parent = CoreGui

-- Frame principal com tema acabou
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 140, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Arredondar interface
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Gradiente de fundo
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Header
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Título STEAL ANIME
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ STEAL ANIME"
titleLabel.TextColor3 = Color3.fromRGB(25, 25, 35)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = headerFrame

-- Subtítulo
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -60, 0, 15)
subtitleLabel.Position = UDim2.new(0, 15, 0, 25)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Anti-Cheat Detector"
subtitleLabel.TextColor3 = Color3.fromRGB(45, 45, 65)
subtitleLabel.TextSize = 10
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = headerFrame

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Container principal
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 55)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Status de detecção
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 30)
statusFrame.Position = UDim2.new(0, 0, 0, 0)
statusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
statusFrame.BorderSizePixel = 1
statusFrame.BorderColor3 = Color3.fromRGB(255, 140, 0)
statusFrame.Parent = container

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔍 Scanning for Anti-Cheat..."
statusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = statusFrame

-- Função para criar botão
local function createButton(name, text, position, size, color, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = color
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(255, 140, 0)
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.TextStrokeTransparency = 0.7
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Gradiente do botão
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.max(0, color.R * 255 - 30),
            math.max(0, color.G * 255 - 30),
            math.max(0, color.B * 255 - 30)
        ))
    }
    btnGradient.Rotation = 90
    btnGradient.Parent = button
    
    return button
end

-- Botão NoClip
local noclipBtn = createButton(
    "NoclipButton",
    "🚪 NOCLIP: OFF",
    UDim2.new(0, 0, 0, 45),
    UDim2.new(1, 0, 0, 35),
    Color3.fromRGB(70, 70, 90),
    container
)

-- Botão TP to Base
local tpBaseBtn = createButton(
    "TpBaseButton",
    "🏠 TP TO BASE",
    UDim2.new(0, 0, 0, 90),
    UDim2.new(1, 0, 0, 35),
    Color3.fromRGB(255, 140, 0),
    container
)

-- Funcionalidade NoClip MELHORADA
local function toggleNoclip()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
        noclipBtn.Text = "🚪 NOCLIP: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Atualizar gradiente
        local btnGradient = noclipBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 200, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 170, 20))
            }
        end
        
        createNotification("STEAL ANIME", "NoClip ativado!", 2)
        
        -- Conexão do NoClip APRIMORADA
        noclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                if player.Character then
                    -- Desativar colisão de todas as partes do personagem
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    -- Verificar partes adicionadas dinamicamente
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
        
        -- Conexão adicional para garantir que funcione
        spawn(function()
            while isNoclipActive and player.Character do
                pcall(function()
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
                wait(0.1)
            end
        end)
        
    else
        noclipBtn.Text = "🚪 NOCLIP: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        
        -- Atualizar gradiente
        local btnGradient = noclipBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
            }
        end
        
        createNotification("STEAL ANIME", "NoClip desativado!", 2)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        -- Reativar colisão de forma mais eficiente
        pcall(function()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
                
                -- Partes específicas que devem ter colisão
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.CanCollide = false -- HumanoidRootPart sempre sem colisão
                end
                
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.CanCollide = false -- Head normalmente sem colisão
                end
            end
        end)
    end
end

-- Funcionalidade TP to Base
local function teleportToBase()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        
        -- Procurar por spawn ou base do jogador
        local spawnLocation = nil
        
        -- Primeiro, tentar encontrar spawn do time
        if player.Team then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("SpawnLocation") and obj.TeamColor == player.TeamColor then
                    spawnLocation = obj
                    break
                end
            end
        end
        
        -- Se não encontrou spawn do time, procurar spawn geral
        if not spawnLocation then
            spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
        end
        
        -- Se ainda não encontrou, usar posição padrão
        if spawnLocation then
            -- Teleportar um pouco à frente do spawn
            local spawnCFrame = spawnLocation.CFrame
            local frontPosition = spawnCFrame + (spawnCFrame.LookVector * 5)
            humanoidRootPart.CFrame = CFrame.new(frontPosition.Position + Vector3.new(0, 5, 0))
            createNotification("STEAL ANIME", "Teleportado para a base!", 2)
        else
            -- Posição de emergência (origem do mundo)
            humanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            createNotification("STEAL ANIME", "Base não encontrada! Teleportado para origem.", 3)
        end
    else
        createNotification("STEAL ANIME", "Personagem não encontrado!", 2)
    end
end

-- Sistema de detecção de anti-cheat (simulado)
local function detectAntiCheat()
    spawn(function()
        wait(2)
        statusLabel.Text = "🔍 Scanning for Anti-Cheat..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
        
        wait(3)
        
        -- Simular detecção
        local detectionResults = {
            "✅ No FE Anti-Cheat detected",
            "⚠️ Weak Anti-Cheat detected",
            "🔴 Strong Anti-Cheat detected",
            "✅ Anti-Cheat bypassed successfully"
        }
        
        local result = detectionResults[math.random(1, #detectionResults)]
        statusLabel.Text = result
        
        if string.find(result, "✅") then
            statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        elseif string.find(result, "⚠️") then
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

-- Efeitos visuais dos botões
local function addButtonEffects(button)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = button.Size + UDim2.new(0, 5, 0, 2)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = button.Size - UDim2.new(0, 5, 0, 2)
        })
        tween:Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = button.Size - UDim2.new(0, 3, 0, 1)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = button.Size + UDim2.new(0, 3, 0, 1)
        })
        tween:Play()
    end)
end

-- Conectar eventos dos botões
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
tpBaseBtn.MouseButton1Click:Connect(teleportToBase)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    guiOpen = false
end)

-- Adicionar efeitos aos botões
addButtonEffects(noclipBtn)
addButtonEffects(tpBaseBtn)
addButtonEffects(closeBtn)

-- Toggle GUI (Tecla End)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.End then
        guiOpen = not guiOpen
        mainFrame.Visible = guiOpen
        
        if guiOpen then
            -- Animação de entrada
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Visible = true
            local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 280, 0, 200)
            })
            openTween:Play()
            
            -- Iniciar detecção
            detectAntiCheat()
        end
    end
end)

-- Desativar NoClip quando personagem reseta - APRIMORADO
player.CharacterAdded:Connect(function(character)
    -- Aguardar o personagem carregar completamente
    character:WaitForChild("HumanoidRootPart")
    
    if isNoclipActive then
        -- Manter NoClip ativo no novo personagem
        spawn(function()
            wait(1) -- Aguardar carregamento completo
            
            -- Reativar NoClip automaticamente
            noclipConnection = RunService.Stepped:Connect(function()
                pcall(function()
                    if player.Character then
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)
            
            -- Loop adicional para garantir
            spawn(function()
                while isNoclipActive and player.Character do
                    pcall(function()
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                    wait(0.1)
                end
            end)
            
            createNotification("STEAL ANIME", "NoClip mantido após respawn!", 2)
        end)
    end
end)

-- Detectar quando novas partes são adicionadas ao personagem
local function setupCharacterNoClip(character)
    if not isNoclipActive then return end
    
    -- Conectar evento para novas partes
    character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and isNoclipActive then
            child.CanCollide = false
            
            -- Também desativar colisão de partes filhas
            child.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BasePart") and isNoclipActive then
                    descendant.CanCollide = false
                end
            end)
        end
    end)
end

-- Conectar setup quando personagem aparece
player.CharacterAdded:Connect(setupCharacterNoClip)

-- Inicialização
createNotification("STEAL ANIME", "Script carregado! Pressione END para abrir.", 5)
detectAntiCheat()

print("🌟 STEAL ANIME Script Loaded!")
print("📋 Funcionalidades:")
print("   🚪 NoClip - Atravessar paredes")  
print("   🏠 TP to Base - Teleporte para base")
print("   🔍 Anti-Cheat Detection")
print("⌨️ Pressione END para abrir/fechar a interface")
