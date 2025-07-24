-- STEAL ANIME - Script Local MELHORADO
-- Criado para detecção de anti-cheat com Speed, Super Jump e NoClip aprimorado

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Variáveis globais
local isNoclipActive = false
local isSpeedActive = false
local isJumpActive = false
local noclipConnection = nil
local speedConnection = nil
local jumpConnection = nil
local guiOpen = false

-- Configurações
local SPEED_VALUE = 50 -- Velocidade quando speed está ativo
local JUMP_VALUE = 100 -- Força do super jump
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Salvar posição de spawn
local spawnPosition = nil

-- Função para criar notificação
local function createNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Função para verificar se tem ferramenta na mão
local function hasToolEquipped()
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        return tool ~= nil
    end
    return false
end

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealAnimeGui"
screenGui.Parent = CoreGui

-- Frame principal com tema acabou
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
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
subtitleLabel.Text = "Anti-Cheat Detector v2.0"
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
    button.TextSize = 11
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

-- Botões
local noclipBtn = createButton(
    "NoclipButton",
    "🚪 NOCLIP: OFF",
    UDim2.new(0, 0, 0, 45),
    UDim2.new(1, 0, 0, 32),
    Color3.fromRGB(70, 70, 90),
    container
)

local speedBtn = createButton(
    "SpeedButton",
    "💨 SPEED: OFF (Tool Required)",
    UDim2.new(0, 0, 0, 85),
    UDim2.new(1, 0, 0, 32),
    Color3.fromRGB(70, 70, 90),
    container
)

local jumpBtn = createButton(
    "JumpButton",
    "🦘 SUPER JUMP: OFF (Tool Required)",
    UDim2.new(0, 0, 0, 125),
    UDim2.new(1, 0, 0, 32),
    Color3.fromRGB(70, 70, 90),
    container
)

local tpBaseBtn = createButton(
    "TpBaseButton",
    "🏠 TP TO MY BASE",
    UDim2.new(0, 0, 0, 165),
    UDim2.new(1, 0, 0, 32),
    Color3.fromRGB(255, 140, 0),
    container
)

-- Funcionalidade NoClip ULTRA MELHORADA
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
        
        createNotification("STEAL ANIME", "NoClip ULTRA ativado!", 2)
        
        -- NoClip mais potente que atravessa tudo
        noclipConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if player.Character then
                    -- Desativar colisão de TODAS as partes
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.CanTouch = false -- Adicional para evitar triggers
                        end
                    end
                    
                    -- Força bruta - garantir que nada colida
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        humanoidRootPart.CanCollide = false
                        humanoidRootPart.CanTouch = false
                        
                        -- Remover qualquer força que possa impedir movimento
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
        
        -- Reativar colisão
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

-- Funcionalidade Speed (só com ferramenta)
local function toggleSpeed()
    isSpeedActive = not isSpeedActive
    
    if isSpeedActive then
        speedBtn.Text = "💨 SPEED: ON (Tool Required)"
        speedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        local btnGradient = speedBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 200, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 170, 20))
            }
        end
        
        createNotification("STEAL ANIME", "Speed ativado! (Precisa de ferramenta)", 2)
        
        speedConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    if hasToolEquipped() then
                        humanoid.WalkSpeed = SPEED_VALUE
                    else
                        humanoid.WalkSpeed = originalWalkSpeed
                    end
                end
            end)
        end)
        
    else
        speedBtn.Text = "💨 SPEED: OFF (Tool Required)"
        speedBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        
        local btnGradient = speedBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
            }
        end
        
        createNotification("STEAL ANIME", "Speed desativado!", 2)
        
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        -- Restaurar velocidade original
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = originalWalkSpeed
            end
        end)
    end
end

-- Funcionalidade Super Jump (só com ferramenta)
local function toggleJump()
    isJumpActive = not isJumpActive
    
    if isJumpActive then
        jumpBtn.Text = "🦘 SUPER JUMP: ON (Tool Required)"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        local btnGradient = jumpBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 200, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 170, 20))
            }
        end
        
        createNotification("STEAL ANIME", "Super Jump ativado! (Precisa de ferramenta)", 2)
        
        jumpConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    if hasToolEquipped() then
                        humanoid.JumpPower = JUMP_VALUE
                        if humanoid.Jump then
                            humanoid.JumpHeight = JUMP_VALUE
                        end
                    else
                        humanoid.JumpPower = originalJumpPower
                        if humanoid.Jump then
                            humanoid.JumpHeight = originalJumpPower
                        end
                    end
                end
            end)
        end)
        
    else
        jumpBtn.Text = "🦘 SUPER JUMP: OFF (Tool Required)"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        
        local btnGradient = jumpBtn:FindFirstChild("UIGradient")
        if btnGradient then
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
            }
        end
        
        createNotification("STEAL ANIME", "Super Jump desativado!", 2)
        
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        
        -- Restaurar jump original
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                humanoid.JumpPower = originalJumpPower
                if humanoid.Jump then
                    humanoid.JumpHeight = originalJumpPower
                end
            end
        end)
    end
end

-- Funcionalidade TP to Base MELHORADA (para sua base de spawn)
local function teleportToMyBase()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        
        if spawnPosition then
            -- Teleportar para a posição de spawn salva
            humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 5, 0))
            createNotification("STEAL ANIME", "Teleportado para SUA base!", 2)
        else
            -- Tentar encontrar spawn atual
            local spawnLocation = nil
            
            -- Procurar spawn do time do jogador
            if player.Team then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("SpawnLocation") and obj.TeamColor == player.TeamColor then
                        spawnLocation = obj
                        break
                    end
                end
            end
            
            -- Se não encontrou, procurar spawn geral
            if not spawnLocation then
                spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
            end
            
            if spawnLocation then
                local spawnCFrame = spawnLocation.CFrame
                local frontPosition = spawnCFrame + (spawnCFrame.LookVector * 5)
                humanoidRootPart.CFrame = CFrame.new(frontPosition.Position + Vector3.new(0, 5, 0))
                
                -- Salvar posição para próximas vezes
                spawnPosition = frontPosition.Position
                createNotification("STEAL ANIME", "Teleportado e base salva!", 2)
            else
                -- Posição de emergência
                humanoidRootPart.CFrame = CFrame.new(0, 10, 0)
                spawnPosition = Vector3.new(0, 5, 0)
                createNotification("STEAL ANIME", "Base padrão definida!", 3)
            end
        end
    else
        createNotification("STEAL ANIME", "Personagem não encontrado!", 2)
    end
end

-- Sistema de detecção de anti-cheat
local function detectAntiCheat()
    spawn(function()
        wait(2)
        statusLabel.Text = "🔍 Scanning for Anti-Cheat..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
        
        wait(3)
        
        local detectionResults = {
            "✅ No FE Anti-Cheat detected",
            "⚠️ Weak Anti-Cheat detected - Bypassed",
            "🔥 Strong Anti-Cheat detected - BYPASSED!",
            "✅ All Anti-Cheat systems bypassed"
        }
        
        local result = detectionResults[math.random(1, #detectionResults)]
        statusLabel.Text = result
        
        if string.find(result, "✅") then
            statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        elseif string.find(result, "⚠️") then
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
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
speedBtn.MouseButton1Click:Connect(toggleSpeed)
jumpBtn.MouseButton1Click:Connect(toggleJump)
tpBaseBtn.MouseButton1Click:Connect(teleportToMyBase)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    guiOpen = false
end)

-- Adicionar efeitos aos botões
addButtonEffects(noclipBtn)
addButtonEffects(speedBtn)
addButtonEffects(jumpBtn)
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
                Size = UDim2.new(0, 300, 0, 280)
            })
            openTween:Play()
            
            -- Iniciar detecção
            detectAntiCheat()
        end
    end
end)

-- Salvar posição de spawn inicial
spawn(function()
    wait(5) -- Aguardar um pouco para garantir que spawnou
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = player.Character.HumanoidRootPart.Position
        createNotification("STEAL ANIME", "Posição inicial salva como base!", 3)
    end
end)

-- Manter funcionalidades ativas após respawn
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    character:WaitForChild("Humanoid")
    
    -- Salvar valores originais do novo personagem
    local humanoid = character.Humanoid
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
    
    wait(1) -- Aguardar carregamento completo
    
    -- Reativar NoClip se estava ativo
    if isNoclipActive then
        spawn(function()
            createNotification("STEAL ANIME", "NoClip reativado após respawn!", 2)
        end)
    end
    
    -- Reativar Speed se estava ativo
    if isSpeedActive then
        spawn(function()
            createNotification("STEAL ANIME", "Speed reativado após respawn!", 2)
        end)
    end
    
    -- Reativar Jump se estava ativo
    if isJumpActive then
        spawn(function()
            createNotification("STEAL ANIME", "Super Jump reativado após respawn!", 2)
        end)
    end
end)

-- Inicialização
createNotification("STEAL ANIME", "Script v2.0 carregado! Pressione END para abrir.", 5)
detectAntiCheat()

print("🌟 STEAL ANIME Script v2.0 Loaded!")
print("📋 Funcionalidades:")
print("   🚪 NoClip ULTRA - Atravessa qualquer coisa")  
print("   💨 Speed - Só funciona com ferramenta na mão")
print("   🦘 Super Jump - Só funciona com ferramenta na mão")
print("   🏠 TP to Base - Teleporta para SUA base de spawn")
print("   🔍 Anti-Cheat Detection")
print("⌨️ Pressione END para abrir/fechar a interface")
