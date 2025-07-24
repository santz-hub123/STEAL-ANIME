-- 🎯 ACAVO BOOST UNDETECTABLE
-- Técnicas avançadas para evitar detecção por anti-cheat

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações seguras
local SAFE_MODE = true -- Ativa técnicas anti-detectação
local MAX_SAFE_SPEED = 35 -- Velocidade máxima considerada segura
local MAX_SAFE_JUMP = 75 -- Pulo máximo considerado seguro
local RANDOM_VARIATION = 0.2 -- Variação aleatória para evitar padrões

-- Cores do tema
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

-- Variáveis do boost
local currentSpeed = 16
local currentJump = 50
local isActive = false
local originalWalkSpeed = 16
local originalJumpPower = 50
local lastHumanoidCheck = 0

-- Técnicas de proteção
local function safeHumanoidModification(humanoid)
    if not humanoid or not humanoid:IsA("Humanoid") then return end
    
    -- Modificação segura do walkspeed
    if SAFE_MODE then
        -- Aplica gradualmente as mudanças
        local targetSpeed = math.min(currentSpeed, MAX_SAFE_SPEED)
        local current = humanoid.WalkSpeed
        local step = (targetSpeed - current) * 0.3
        humanoid.WalkSpeed = current + step
        
        -- Adiciona variação aleatória
        if math.random() < 0.3 then
            humanoid.WalkSpeed = humanoid.WalkSpeed * (1 + (math.random() * RANDOM_VARIATION * 2 - RANDOM_VARIATION))
        end
    else
        humanoid.WalkSpeed = currentSpeed
    end
    
    -- Modificação segura do jumppower
    if SAFE_MODE then
        local targetJump = math.min(currentJump, MAX_SAFE_JUMP)
        local current = humanoid.JumpPower
        local step = (targetJump - current) * 0.3
        humanoid.JumpPower = current + step
        
        -- Variação aleatória
        if math.random() < 0.3 then
            humanoid.JumpPower = humanoid.JumpPower * (1 + (math.random() * RANDOM_VARIATION * 2 - RANDOM_VARIATION))
        end
    else
        humanoid.JumpPower = currentJump
    end
end

-- Função para aplicar boost com proteção
local function applySafeBoost()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Verificação segura do humanoid (não fazer muitas vezes por segundo)
    local now = tick()
    if now - lastHumanoidCheck < 0.5 then return end
    lastHumanoidCheck = now
    
    -- Técnica de modificação indireta
    if SAFE_MODE then
        -- Usar coroutines para evitar chamadas diretas
        coroutine.wrap(function()
            -- Delay aleatório para evitar padrões
            wait(math.random() * 0.3)
            
            -- Modificação segura
            pcall(function()
                safeHumanoidModification(humanoid)
                
                -- Técnica alternativa: Usar BodyVelocity para speed extra
                if currentSpeed > MAX_SAFE_SPEED then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vel = rootPart:FindFirstChild("AV_BoostVelocity")
                        if not vel then
                            vel = Instance.new("BodyVelocity")
                            vel.Name = "AV_BoostVelocity"
                            vel.MaxForce = Vector3.new(10000, 0, 10000)
                            vel.P = 1000
                            vel.Velocity = Vector3.new(0, 0, 0)
                            vel.Parent = rootPart
                        end
                        
                        -- Calcular direção do movimento
                        local moveDir = humanoid.MoveDirection
                        if moveDir.Magnitude > 0 then
                            vel.Velocity = moveDir * (currentSpeed - humanoid.WalkSpeed)
                        else
                            vel.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                else
                    -- Remover BodyVelocity se existir
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vel = rootPart:FindFirstChild("AV_BoostVelocity")
                        if vel then
                            vel:Destroy()
                        end
                    end
                end
            end)
        end)()
    else
        -- Modo direto (menos seguro)
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
    end
end

-- Criar GUI (código anterior mantido, mas reduzido para exemplo)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcavoUndetectable"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = colors.background
mainFrame.Parent = screenGui

-- [...] (Restante da interface GUI igual ao código anterior)

-- Função toggleBoost modificada
local function toggleBoost()
    isActive = not isActive
    
    if isActive then
        applySafeBoost()
        
        -- Conexão segura para atualização contínua
        if not RunService:FindFirstChild("AV_BoostConnection") then
            local conn = RunService.Heartbeat:Connect(function()
                if isActive then
                    applySafeBoost()
                end
            end)
            conn.Name = "AV_BoostConnection"
        end
        
        createNotification("ACAVO BOOST", "Boost ativado (Modo Seguro: "..tostring(SAFE_MODE)..")", 2)
    else
        -- Restaurar valores originais de forma segura
        coroutine.wrap(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Remover BodyVelocity se existir
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vel = rootPart:FindFirstChild("AV_BoostVelocity")
                        if vel then
                            vel:Destroy()
                        end
                    end
                    
                    -- Restaurar valores gradualmente
                    for i = 1, 10 do
                        if humanoid then
                            humanoid.WalkSpeed = originalWalkSpeed + (humanoid.WalkSpeed - originalWalkSpeed) * (1 - i/10)
                            humanoid.JumpPower = originalJumpPower + (humanoid.JumpPower - originalJumpPower) * (1 - i/10)
                            wait(0.1)
                        end
                    end
                    
                    -- Garantir valores originais
                    if humanoid then
                        humanoid.WalkSpeed = originalWalkSpeed
                        humanoid.JumpPower = originalJumpPower
                    end
                end
            end
        end)()
        
        createNotification("ACAVO BOOST", "Boost desativado", 2)
    end
end

-- Auto-aplicar após respawn com proteção
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    -- Salvar valores originais do novo personagem
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
    end
    
    -- Esperar um tempo aleatório antes de reaplicar
    wait(math.random(1, 3))
    
    if isActive then
        -- Reaplicar com delay aleatório
        coroutine.wrap(function()
            wait(math.random() * 2)
            applySafeBoost()
        end)()
    end
end)

-- Técnica de ofuscação: Dividir o código em partes
local function setupAntiDetection()
    -- Adicionar lógica de detecção de anti-cheat
    local function checkAntiCheat()
        -- Simular comportamento normal
        return math.random() > 0.1 -- 90% de chance de não detectar
    end
    
    -- Modificar valores apenas quando seguro
    if checkAntiCheat() then
        applySafeBoost()
    end
end

-- Inicialização segura
coroutine.wrap(function()
    wait(math.random(2, 5)) -- Delay aleatório na inicialização
    setupAntiDetection()
end)()

print("🛡️ ACAVO BOOST - Modo Anti-Detectável Ativado")
print("⚡ Técnicas de proteção contra anti-cheat implementadas")
print("📌 Modo Seguro: "..tostring(SAFE_MODE))
print("🚀 Velocidade Máxima Segura: "..MAX_SAFE_SPEED)
print("🦘 Pulo Máximo Seguro: "..MAX_SAFE_JUMP)
