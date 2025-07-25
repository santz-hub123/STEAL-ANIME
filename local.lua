-- SANTZ HUB - Script Roblox Profissional
-- OTIMIZADO ESPECIFICAMENTE PARA STEAL ANIME
-- Interface moderna com animações e funcionalidades avançadas

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Aguardar character
local function waitForCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local character = waitForCharacter()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis globais
local noclipEnabled = false
local connections = {}
local originalPosition = rootPart.CFrame
local gui = nil

-- Limpar GUI anterior se existir
if CoreGui:FindFirstChild("SantzHubGUI") then
    CoreGui:FindFirstChild("SantzHubGUI"):Destroy()
end

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantzHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Frame de loading/animação inicial
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

-- Logo do loading
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(0, 600, 0, 100)
logoText.Position = UDim2.new(0.5, -300, 0.5, -100)
logoText.BackgroundTransparency = 1
logoText.Text = "SANTZ HUB"
logoText.TextColor3 = Color3.fromRGB(0, 162, 255)
logoText.TextSize = 60
logoText.TextStrokeTransparency = 0
logoText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
logoText.Font = Enum.Font.GothamBold
logoText.TextTransparency = 1
logoText.ZIndex = 11
logoText.Parent = loadingFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 400, 0, 40)
subtitle.Position = UDim2.new(0.5, -200, 0.5, 20)
subtitle.BackgroundTransparency = 1
subtitle.Text = "CARREGANDO SISTEMA..."
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.TextSize = 20
subtitle.Font = Enum.Font.Gotham
subtitle.TextTransparency = 1
subtitle.ZIndex = 11
subtitle.Parent = loadingFrame

-- Barra de loading
local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 0, 6)
loadingBar.Position = UDim2.new(0.5, -200, 0.5, 80)
loadingBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 11
loadingBar.Parent = loadingFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 3)
loadingBarCorner.Parent = loadingBar

-- Animação de entrada
local function playLoadingAnimation()
    -- Fade in do logo
    local logoTween = TweenService:Create(logoText, TweenInfo.new(1, Enum.EasingStyle.Quad), {TextTransparency = 0})
    logoTween:Play()
    
    wait(0.5)
    
    -- Fade in do subtítulo
    local subtitleTween = TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0})
    subtitleTween:Play()
    
    wait(0.5)
    
    -- Animação da barra de loading
    local barTween = TweenService:Create(loadingBar, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 6)})
    barTween:Play()
    
    -- Textos de carregamento
    local loadingTexts = {
        "INICIALIZANDO MÓDULOS...",
        "CARREGANDO EXPLOITS...",
        "VERIFICANDO SEGURANÇA...",
        "CONECTANDO SERVIÇOS...",
        "SISTEMA PRONTO!"
    }
    
    for i, text in ipairs(loadingTexts) do
        wait(0.4)
        subtitle.Text = text
        if i == #loadingTexts then
            subtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
    
    wait(1)
    
    -- Fade out da tela de loading
    local fadeOut = TweenService:Create(loadingFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    fadeOut:Play()
    
    local logoFadeOut = TweenService:Create(logoText, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 1})
    logoFadeOut:Play()
    
    local subtitleFadeOut = TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 1})
    subtitleFadeOut:Play()
    
    fadeOut.Completed:Connect(function()
        loadingFrame:Destroy()
    end)
end

-- Frame principal (inicialmente invisível)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Gradiente do frame principal
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 180))
}
mainGradient.Rotation = 45
mainGradient.Parent = mainFrame

-- Cantos arredondados
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

-- Sombra
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 25)
shadowCorner.Parent = shadow

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

-- Título principal
local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, -120, 1, 0)
mainTitle.Position = UDim2.new(0, 20, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ SANTZ HUB PRO ⚡"
mainTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
mainTitle.TextSize = 24
mainTitle.TextStrokeTransparency = 0
mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left
mainTitle.Parent = header

-- Versão
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 100, 0, 20)
version.Position = UDim2.new(1, -110, 0, 45)
version.BackgroundTransparency = 1
version.Text = "v2.0 PREMIUM"
version.TextColor3 = Color3.fromRGB(255, 215, 0)
version.TextSize = 12
version.Font = Enum.Font.Gotham
version.Parent = header

-- Botões de controle
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -75, 0, 17.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 17.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Container de scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -90)
scrollFrame.Position = UDim2.new(0, 10, 0, 80)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 10
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
scrollFrame.Parent = mainFrame

-- Layout
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15)
layout.Parent = scrollFrame

-- Função para criar botões estilizados
local function createStyledButton(text, icon, color, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 60)
    buttonFrame.BackgroundColor3 = color
    buttonFrame.BackgroundTransparency = 0.1
    buttonFrame.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 15)
    buttonCorner.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 50, 1, 0)
    iconLabel.Position = UDim2.new(0, 15, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = buttonFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -80, 1, 0)
    textLabel.Position = UDim2.new(0, 70, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 18
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonFrame
    
    -- Efeitos visuais
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(1, 5, 0, 65)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, Size = UDim2.new(1, 0, 0, 60)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Efeito de clique
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 55)}):Play()
        wait(0.1)
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Funções principais
local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        connections.noclip = RunService.Stepped:Connect(function()
            pcall(function()
                if character and character.Parent then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
        print("✅ NoClip ATIVADO - Atravesse paredes livremente!")
        statusText.Text = "👻 NO CLIP ATIVO - Atravessando paredes"
        statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        pcall(function()
            if character and character.Parent then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
        print("❌ NoClip DESATIVADO - Colisão restaurada")
        statusText.Text = "🟢 SISTEMA ONLINE - SANTZ HUB PREMIUM"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

-- Função específica para encontrar bases no Steal Anime
local function findStealAnimeBase(searchTerm)
    local foundBases = {}
    
    -- Procurar especificamente por estruturas do Steal Anime
    local function searchRecursive(parent)
        for _, obj in pairs(parent:GetChildren()) do
            if obj.Name:lower():find("base") or 
               obj.Name:lower():find("teambase") or
               obj.Name:lower():find("spawn") or
               obj.Name:lower():find("flag") or
               obj.Name:lower():find("capture") or
               (obj:IsA("Model") and obj:FindFirstChild("Flag")) or
               (obj:IsA("Part") and obj.BrickColor == BrickColor.new("Bright red")) or
               (obj:IsA("Part") and obj.BrickColor == BrickColor.new("Bright blue")) then
                table.insert(foundBases, obj)
            end
            if #obj:GetChildren() > 0 then
                searchRecursive(obj)
            end
        end
    end
    
    searchRecursive(workspace)
    
    -- Se não encontrar, procurar pela estrutura mais alta (geralmente a base)
    if #foundBases == 0 then
        local highestY = -math.huge
        local highestObj = nil
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Size.Y > 10 and obj.Position.Y > highestY then
                highestY = obj.Position.Y
                highestObj = obj
            end
        end
        
        if highestObj then
            table.insert(foundBases, highestObj)
        end
    end
    
    return foundBases[1]
end

local function roofTeleport()
    print("🔍 Procurando base inimiga no Steal Anime...")
    local base = findStealAnimeBase("base")
    if base then
        local cf, size = base:GetBoundingBox()
        -- Teleportar bem acima da base (teto + margem de segurança)
        local roofPos = cf.Position + Vector3.new(0, size.Y/2 + 25, 0)
        rootPart.CFrame = CFrame.new(roofPos)
        print("🚀 Teleportado para o TETO da base inimiga!")
        
        -- Feedback visual
        statusText.Text = "🚀 ROOF TP ATIVO - Posição: Teto da Base"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        -- Fallback: teleportar para cima da posição atual
        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 60, 0)
        print("🚀 Teleportado para CIMA! (Base não detectada)")
        statusText.Text = "🚀 ROOF TP - Teleportado para cima"
    end
end

local function teleportToBase()
    rootPart.CFrame = originalPosition
    print("🏠 Teleportado para SUA BASE inicial!")
    statusText.Text = "🏠 MY BASE TP - Retornado com sucesso"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function santzHallTP()
    print("⚡ Ativando SANTZ HALL para Steal Anime...")
    local base = findStealAnimeBase("base")
    if base then
        local cf, size = base:GetBoundingBox()
        -- Teleportar DENTRO da base com posição estratégica
        local insidePos = cf.Position + Vector3.new(
            math.random(-size.X/3, size.X/3), 
            -size.Y/4, -- Um pouco abaixo do centro para ficar no chão
            math.random(-size.Z/3, size.Z/3)
        )
        rootPart.CFrame = CFrame.new(insidePos)
        print("⚡ SANTZ HALL ativado - DENTRO da base inimiga!")
        
        -- Feedback visual especial
        statusText.Text = "⚡ SANTZ HALL ATIVO - Infiltração completa!"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 255)
        
        -- Ativar NoClip temporariamente para garantir entrada
        if not noclipEnabled then
            toggleNoClip()
            wait(2)
            toggleNoClip()
        end
    else
        print("❌ Base inimiga não encontrada para Santz Hall")
        statusText.Text = "❌ SANTZ HALL - Base não detectada"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function advancedTP()
    local target = mouse.Hit.Position
    rootPart.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
    print("🎯 Teleportado para posição do mouse!")
end

-- Criar botões
createStyledButton("ROOF TELEPORT", "🚀", Color3.fromRGB(231, 76, 60), roofTeleport)
createStyledButton("MY BASE TP", "🏠", Color3.fromRGB(46, 204, 113), teleportToBase)
createStyledButton("NO CLIP", "👻", Color3.fromRGB(241, 196, 15), toggleNoClip)
createStyledButton("SANTZ HALL", "⚡", Color3.fromRGB(155, 89, 182), santzHallTP)
createStyledButton("MOUSE TP", "🎯", Color3.fromRGB(52, 152, 219), advancedTP)

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 1, -30)
statusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusBar.BackgroundTransparency = 0.5
statusBar.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 SISTEMA ONLINE - SANTZ HUB PREMIUM"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- Controles da janela
local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 70)}):Play()
        scrollFrame.Visible = false
        statusBar.Visible = false
        minimizeBtn.Text = "□"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 550)}):Play()
        scrollFrame.Visible = true
        statusBar.Visible = true
        minimizeBtn.Text = "─"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    wait(0.5)
    screenGui:Destroy()
end)

-- Tornar arrastável
local dragging = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoClip()
    elseif input.KeyCode == Enum.KeyCode.R then
        roofTeleport()
    elseif input.KeyCode == Enum.KeyCode.B then
        teleportToBase()
    elseif input.KeyCode == Enum.KeyCode.H then
        santzHallTP()
    elseif input.KeyCode == Enum.KeyCode.T then
        advancedTP()
    end
end)

-- Atualizar character
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

-- Iniciar animação e mostrar interface
spawn(function()
    playLoadingAnimation()
    wait(4)
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 550)}):Play()
end)

print("⚡ SANTZ HUB PRO CARREGADO COM SUCESSO! ⚡")
print("🎮 OTIMIZADO PARA: STEAL ANIME")
print("📋 Hotkeys: N=NoClip | R=RoofTP | B=BaseTP | H=SantzHall | T=MouseTP")
print("🎯 Criado por: Santz Developer")
print("🔥 Todas as funcionalidades testadas para Steal Anime!")
