-- SANTZ HUB - Script Roblox Profissional RGB
-- VERSÃO COMPACTA E OTIMIZADA PARA STEAL ANIME
-- Interface moderna com efeitos RGB e fundo transparente

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Aguardar character com verificação robusta
local function waitForCharacter()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character
    end
    return player.CharacterAdded:Wait()
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
pcall(function()
    if CoreGui:FindFirstChild("SantzHubGUI") then
        CoreGui:FindFirstChild("SantzHubGUI"):Destroy()
    end
end)

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantzHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Frame de loading compacto
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.3
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

-- Logo do loading com efeito RGB
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(0, 400, 0, 60)
logoText.Position = UDim2.new(0.5, -200, 0.5, -60)
logoText.BackgroundTransparency = 1
logoText.Text = "⚡ SANTZ HUB ⚡"
logoText.TextColor3 = Color3.fromRGB(255, 0, 128)
logoText.TextSize = 42
logoText.TextStrokeTransparency = 0
logoText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
logoText.Font = Enum.Font.GothamBold
logoText.TextTransparency = 1
logoText.ZIndex = 11
logoText.Parent = loadingFrame

-- Subtítulo compacto
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 300, 0, 30)
subtitle.Position = UDim2.new(0.5, -150, 0.5, 10)
subtitle.BackgroundTransparency = 1
subtitle.Text = "LOADING..."
subtitle.TextColor3 = Color3.fromRGB(0, 255, 255)
subtitle.TextSize = 16
subtitle.Font = Enum.Font.Gotham
subtitle.TextTransparency = 1
subtitle.ZIndex = 11
subtitle.Parent = loadingFrame

-- Animação RGB para o logo
spawn(function()
    while logoText and logoText.Parent do
        for i = 0, 1, 0.02 do
            if logoText and logoText.Parent then
                logoText.TextColor3 = Color3.fromHSV(i, 1, 1)
                wait(0.03)
            else
                break
            end
        end
    end
end)

-- Animação de loading rápida
local function playLoadingAnimation()
    local logoTween = TweenService:Create(logoText, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0})
    logoTween:Play()
    
    wait(0.3)
    
    local subtitleTween = TweenService:Create(subtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 0})
    subtitleTween:Play()
    
    wait(1.5)
    subtitle.Text = "READY!"
    subtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    wait(0.8)
    
    local fadeOut = TweenService:Create(loadingFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    fadeOut:Play()
    
    TweenService:Create(logoText, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    
    fadeOut.Completed:Connect(function()
        loadingFrame:Destroy()
    end)
end

-- Frame principal COMPACTO e TRANSPARENTE
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 380) -- Muito menor
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.4 -- Mais transparente
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Cantos arredondados
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Sombra suave
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 15, 1, 15)
shadow.Position = UDim2.new(0, -7.5, 0, -7.5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

-- Header compacto
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50) -- Menor
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.6
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- Título principal com RGB
local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, -80, 1, 0)
mainTitle.Position = UDim2.new(0, 15, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ SANTZ HUB ⚡"
mainTitle.TextColor3 = Color3.fromRGB(255, 0, 128)
mainTitle.TextSize = 18
mainTitle.TextStrokeTransparency = 0
mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left
mainTitle.Parent = header

-- Versão
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 80, 0, 15)
version.Position = UDim2.new(1, -85, 0, 30)
version.BackgroundTransparency = 1
version.Text = "v2.0 RGB"
version.TextColor3 = Color3.fromRGB(255, 215, 0)
version.TextSize = 10
version.Font = Enum.Font.Gotham
version.Parent = header

-- Botão fechar compacto
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 12.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Container de scroll compacto
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -15, 1, -65)
scrollFrame.Position = UDim2.new(0, 7.5, 0, 55)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
scrollFrame.Parent = mainFrame

-- Layout compacto
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = scrollFrame

-- Função para criar botões compactos e estilizados
local function createCompactButton(text, icon, color, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 45) -- Botões menores
    buttonFrame.BackgroundColor3 = color
    buttonFrame.BackgroundTransparency = 0.3
    buttonFrame.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = buttonFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonFrame
    
    -- Efeito RGB no texto
    spawn(function()
        while textLabel and textLabel.Parent do
            for i = 0, 1, 0.01 do
                if textLabel and textLabel.Parent then
                    textLabel.TextColor3 = Color3.fromHSV(i, 0.8, 1)
                    wait(0.05)
                else
                    break
                end
            end
        end
    end)
    
    -- Efeitos visuais
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, Size = UDim2.new(1, 3, 0, 48)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 45)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -2, 0, 42)}):Play()
        wait(0.1)
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 45)}):Play()
        
        if callback then
            pcall(callback)
        end
    end)
    
    return button
end

-- Funções principais OTIMIZADAS
local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        connections.noclip = RunService.Stepped:Connect(function()
            pcall(function()
                local char = player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part ~= char.PrimaryPart then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
        print("✅ NoClip ATIVADO")
        statusText.Text = "👻 NO CLIP ATIVO"
        statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        pcall(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
        print("❌ NoClip DESATIVADO")
        statusText.Text = "🟢 SISTEMA ONLINE"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

-- Função melhorada para encontrar bases
local function findBase()
    local bases = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:find("base") or name:find("flag") or name:find("spawn") or 
               name:find("capture") or name:find("team") then
                if obj:IsA("Model") and obj.PrimaryPart then
                    table.insert(bases, obj.PrimaryPart)
                elseif obj:IsA("Part") then
                    table.insert(bases, obj)
                end
            end
        end
    end
    
    -- Retorna a primeira base encontrada ou nil
    return bases[1]
end

local function roofTeleport()
    local base = findBase()
    if base then
        local pos = base.Position
        rootPart.CFrame = CFrame.new(pos.X, pos.Y + 50, pos.Z)
        print("🚀 ROOF TP - Sucesso!")
        statusText.Text = "🚀 ROOF TP ATIVO"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 50, 0)
        print("🚀 TP para cima - Executado!")
        statusText.Text = "🚀 TP CIMA - OK"
    end
end

local function teleportToBase()
    rootPart.CFrame = originalPosition
    print("🏠 MY BASE TP - Sucesso!")
    statusText.Text = "🏠 MY BASE TP - OK"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function santzHallTP()
    local base = findBase()
    if base then
        local pos = base.Position
        rootPart.CFrame = CFrame.new(pos.X + math.random(-10, 10), pos.Y + 5, pos.Z + math.random(-10, 10))
        print("⚡ SANTZ HALL - Ativado!")
        statusText.Text = "⚡ SANTZ HALL ATIVO"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 255)
        
        -- NoClip temporário
        if not noclipEnabled then
            toggleNoClip()
            wait(3)
            toggleNoClip()
        end
    else
        print("❌ Base não encontrada")
        statusText.Text = "❌ Base não encontrada"
    end
end

local function mouseTP()
    if mouse.Hit then
        local target = mouse.Hit.Position
        rootPart.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
        print("🎯 MOUSE TP - Sucesso!")
        statusText.Text = "🎯 MOUSE TP - OK"
    end
end

-- Criar botões compactos
createCompactButton("ROOF TP", "🚀", Color3.fromRGB(231, 76, 60), roofTeleport)
createCompactButton("MY BASE", "🏠", Color3.fromRGB(46, 204, 113), teleportToBase)
createCompactButton("NO CLIP", "👻", Color3.fromRGB(241, 196, 15), toggleNoClip)
createCompactButton("SANTZ HALL", "⚡", Color3.fromRGB(155, 89, 182), santzHallTP)
createCompactButton("MOUSE TP", "🎯", Color3.fromRGB(52, 152, 219), mouseTP)

-- Status bar compacto
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, -25)
statusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusBar.BackgroundTransparency = 0.6
statusBar.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 SISTEMA ONLINE"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.TextSize = 10
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- RGB para título e status
spawn(function()
    while mainTitle and mainTitle.Parent do
        for i = 0, 1, 0.01 do
            if mainTitle and mainTitle.Parent then
                mainTitle.TextColor3 = Color3.fromHSV(i, 1, 1)
                wait(0.08)
            else
                break
            end
        end
    end
end)

-- Controle de fechar
closeBtn.MouseButton1Click:Connect(function()
    -- Desconectar todas as conexões
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    TweenService:Create(mainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    wait(0.4)
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Hotkeys otimizadas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.N then
        toggleNoClip()
    elseif key == Enum.KeyCode.R then
        roofTeleport()
    elseif key == Enum.KeyCode.B then
        teleportToBase()
    elseif key == Enum.KeyCode.H then
        santzHallTP()
    elseif key == Enum.KeyCode.T then
        mouseTP()
    elseif key == Enum.KeyCode.X then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Atualizar character automaticamente
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    originalPosition = rootPart.CFrame
    
    -- Reativar NoClip se estava ativo
    if noclipEnabled then
        noclipEnabled = false
        toggleNoClip()
    end
end)

-- Inicialização final
spawn(function()
    playLoadingAnimation()
    wait(3)
    
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 320, 0, 380)}):Play()
end)

-- Output final
print("⚡ SANTZ HUB RGB - CARREGADO! ⚡")
print("🎮 VERSÃO: Compacta e Otimizada")
print("📋 HOTKEYS: N=NoClip | R=RoofTP | B=BaseTP | H=SantzHall | T=MouseTP | X=Toggle")
print("🌈 EFEITOS: Full RGB ativado!")
print("✨ STATUS: 100% Funcional!")
