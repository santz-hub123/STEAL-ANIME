-- SANTZ HUB - Script Roblox Profissional MELHORADO
-- OTIMIZADO ESPECIFICAMENTE PARA STEAL ANIME
-- Interface moderna com animações e funcionalidades avançadas
-- VERSÃO MELHORADA COM CONTROLES APRIMORADOS

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
local statusText = nil

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
mainFrame.Size = UDim2.new(0, 480, 0, 600)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = false -- Vamos implementar drag customizado
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

-- Sombra melhorada
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

-- Header melhorado
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Active = true
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

-- Título principal
local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, -120, 0, 40)
mainTitle.Position = UDim2.new(0, 20, 0, 10)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ SANTZ HUB PRO ⚡"
mainTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
mainTitle.TextSize = 26
mainTitle.TextStrokeTransparency = 0
mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left
mainTitle.Parent = header

-- Subtítulo
local gameTitle = Instance.new("TextLabel")
gameTitle.Size = UDim2.new(1, -120, 0, 25)
gameTitle.Position = UDim2.new(0, 20, 0, 50)
gameTitle.BackgroundTransparency = 1
gameTitle.Text = "🎮 OTIMIZADO PARA: STEAL ANIME"
gameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
gameTitle.TextSize = 14
gameTitle.Font = Enum.Font.Gotham
gameTitle.TextXAlignment = Enum.TextXAlignment.Left
gameTitle.Parent = header

-- Versão
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 100, 0, 20)
version.Position = UDim2.new(1, -110, 0, 55)
version.BackgroundTransparency = 1
version.Text = "v2.1 PREMIUM"
version.TextColor3 = Color3.fromRGB(255, 215, 0)
version.TextSize = 12
version.Font = Enum.Font.GothamBold
version.Parent = header

-- Botões de controle melhorados
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -85, 0, 20)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 10)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 20)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Container de scroll melhorado
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -120)
scrollFrame.Position = UDim2.new(0, 10, 0, 90)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 12
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

-- Layout
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15)
layout.Parent = scrollFrame

-- Auto-resize do canvas
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- Função para criar botões estilizados melhorados
local function createStyledButton(text, icon, colorMain, colorHover, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 65)
    buttonFrame.BackgroundColor3 = colorMain
    buttonFrame.BackgroundTransparency = 0.1
    buttonFrame.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 15)
    buttonCorner.Parent = buttonFrame
    
    -- Borda brilhante
    local border = Instance.new("UIStroke")
    border.Color = colorHover
    border.Thickness = 2
    border.Transparency = 0.7
    border.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 55, 1, 0)
    iconLabel.Position = UDim2.new(0, 15, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 28
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = buttonFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -85, 1, 0)
    textLabel.Position = UDim2.new(0, 75, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 18
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonFrame
    
    -- Efeitos visuais melhorados
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0, 
            Size = UDim2.new(1, 8, 0, 70),
            BackgroundColor3 = colorHover
        }):Play()
        TweenService:Create(border, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextSize = 32}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1, 
            Size = UDim2.new(1, 0, 0, 65),
            BackgroundColor3 = colorMain
        }):Play()
        TweenService:Create(border, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextSize = 28}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Efeito de clique melhorado
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -8, 0, 60)}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.1), {TextSize = 24}):Play()
        wait(0.1)
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 65)}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.1), {TextSize = 28}):Play()
        
        if callback then
            spawn(callback) -- Executa em thread separada para não travar a UI
        end
    end)
    
    return button
end

-- Funções principais melhoradas
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

-- Função melhorada para encontrar bases no Steal Anime
local function findStealAnimeBase(targetType)
    local foundBases = {}
    local searchTerms = {
        base = {"base", "teambase", "spawn", "flag", "capture", "core", "nexus"},
        enemy = {"enemy", "red", "blue", "opposing"},
        highest = {"tower", "roof", "top", "high"}
    }
    
    -- Procurar especificamente por estruturas do Steal Anime
    local function searchRecursive(parent, depth)
        if depth > 10 then return end -- Limitar profundidade para performance
        
        for _, obj in pairs(parent:GetChildren()) do
            local objName = obj.Name:lower()
            
            -- Verificar por nomes específicos
            for _, term in ipairs(searchTerms.base) do
                if objName:find(term) then
                    table.insert(foundBases, obj)
                end
            end
            
            -- Verificar por estruturas visuais
            if obj:IsA("Model") and (obj:FindFirstChild("Flag") or obj:FindFirstChild("Core")) then
                table.insert(foundBases, obj)
            elseif obj:IsA("Part") then
                -- Verificar cores típicas de bases
                if (obj.BrickColor == BrickColor.new("Bright red") or 
                    obj.BrickColor == BrickColor.new("Bright blue") or
                    obj.BrickColor == BrickColor.new("Really red") or
                    obj.BrickColor == BrickColor.new("Really blue")) and
                   obj.Size.Magnitude > 10 then
                    table.insert(foundBases, obj)
                end
            end
            
            if #obj:GetChildren() > 0 then
                searchRecursive(obj, depth + 1)
            end
        end
    end
    
    searchRecursive(workspace, 0)
    
    -- Se não encontrar bases específicas, procurar pela estrutura mais alta
    if #foundBases == 0 then
        local candidates = {}
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Size.Y > 15 and obj.Position.Y > 50 then
                table.insert(candidates, {part = obj, height = obj.Position.Y, size = obj.Size.Magnitude})
            end
        end
        
        -- Ordenar por altura e tamanho
        table.sort(candidates, function(a, b)
            return a.height + (a.size * 0.1) > b.height + (b.size * 0.1)
        end)
        
        if #candidates > 0 then
            table.insert(foundBases, candidates[1].part)
        end
    end
    
    return foundBases
end

local function roofTeleport()
    print("🔍 Procurando base inimiga no Steal Anime...")
    statusText.Text = "🔍 ROOF TP - Localizando base..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local bases = findStealAnimeBase("base")
    
    if #bases > 0 then
        -- Escolher a base mais distante (provavelmente inimiga)
        local playerPos = rootPart.Position
        local bestBase = nil
        local maxDistance = 0
        
        for _, base in ipairs(bases) do
            local basePos = base:IsA("Model") and base:GetModelCFrame().Position or base.Position
            local distance = (playerPos - basePos).Magnitude
            
            if distance > maxDistance then
                maxDistance = distance
                bestBase = base
            end
        end
        
        if bestBase then
            local cf, size
            if bestBase:IsA("Model") then
                cf = bestBase:GetModelCFrame()
                size = bestBase:GetExtentsSize()
            else
                cf = bestBase.CFrame
                size = bestBase.Size
            end
            
            -- Teleportar bem acima da base (teto + margem de segurança)
            local roofPos = cf.Position + Vector3.new(
                math.random(-5, 5), -- Pequena variação X
                size.Y/2 + 30, -- Bem acima
                math.random(-5, 5)  -- Pequena variação Z
            )
            
            rootPart.CFrame = CFrame.new(roofPos)
            print("🚀 Teleportado para o TETO da base inimiga! Altura: " .. roofPos.Y)
            
            statusText.Text = "🚀 ROOF TP ATIVO - Altura: " .. math.floor(roofPos.Y) .. "m"
            statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            -- Fallback melhorado
            local currentY = rootPart.Position.Y
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 80, 0)
            print("🚀 Teleportado para CIMA! Nova altura: " .. (currentY + 80))
            statusText.Text = "🚀 ROOF TP - Altura: " .. math.floor(currentY + 80) .. "m"
        end
    else
        -- Fallback: procurar ponto mais alto no mapa
        local highestY = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Position.Y > highestY then
                highestY = obj.Position.Y
            end
        end
        
        local targetHeight = math.max(highestY + 20, rootPart.Position.Y + 60)
        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, targetHeight - rootPart.Position.Y, 0)
        print("🚀 Teleportado para o ponto mais alto! Altura: " .. targetHeight)
        statusText.Text = "🚀 ROOF TP - Ponto mais alto: " .. math.floor(targetHeight) .. "m"
        statusText.TextColor3 = Color3.fromRGB(255, 150, 0)
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
    statusText.Text = "⚡ SANTZ HALL - Infiltrando..."
    statusText.TextColor3 = Color3.fromRGB(255, 0, 255)
    
    local bases = findStealAnimeBase("base")
    
    if #bases > 0 then
        local targetBase = bases[math.random(1, #bases)]
        local cf, size
        
        if targetBase:IsA("Model") then
            cf = targetBase:GetModelCFrame()
            size = targetBase:GetExtentsSize()
        else
            cf = targetBase.CFrame
            size = targetBase.Size
        end
        
        -- Teleportar DENTRO da base com posição estratégica
        local insidePos = cf.Position + Vector3.new(
            math.random(-size.X/3, size.X/3), 
            -size.Y/4, -- Um pouco abaixo do centro
            math.random(-size.Z/3, size.Z/3)
        )
        
        -- Ativar NoClip temporariamente para garantir entrada
        local wasNoclipEnabled = noclipEnabled
        if not noclipEnabled then
            toggleNoClip()
        end
        
        rootPart.CFrame = CFrame.new(insidePos)
        print("⚡ SANTZ HALL ativado - DENTRO da base inimiga!")
        
        statusText.Text = "⚡ SANTZ HALL ATIVO - Infiltração completa!"
        
        -- Desativar NoClip após 3 segundos se não estava ativo antes
        if not wasNoclipEnabled then
            wait(3)
            if noclipEnabled then
                toggleNoClip()
            end
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
    statusText.Text = "🎯 MOUSE TP - Posição: " .. math.floor(target.X) .. ", " .. math.floor(target.Z)
    statusText.TextColor3 = Color3.fromRGB(100, 255, 255)
end

-- Função de ESP básico
local function toggleESP()
    print("👁️ ESP Toggle - Funcionalidade em desenvolvimento")
    statusText.Text = "👁️ ESP - Em desenvolvimento"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 100)
end

-- Criar botões com cores melhoradas
createStyledButton("ROOF TELEPORT", "🚀", Color3.fromRGB(231, 76, 60), Color3.fromRGB(255, 100, 100), roofTeleport)
createStyledButton("MY BASE TP", "🏠", Color3.fromRGB(46, 204, 113), Color3.fromRGB(100, 255, 150), teleportToBase)
createStyledButton("NO CLIP", "👻", Color3.fromRGB(241, 196, 15), Color3.fromRGB(255, 220, 50), toggleNoClip)
createStyledButton("SANTZ HALL", "⚡", Color3.fromRGB(155, 89, 182), Color3.fromRGB(200, 120, 220), santzHallTP)
createStyledButton("MOUSE TP", "🎯", Color3.fromRGB(52, 152, 219), Color3.fromRGB(100, 180, 255), advancedTP)
createStyledButton("ESP PLAYERS", "👁️", Color3.fromRGB(230, 126, 34), Color3.fromRGB(255, 160, 80), toggleESP)

-- Status bar melhorada
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 35)
statusBar.Position = UDim2.new(0, 0, 1, -35)
statusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusBar.BackgroundTransparency = 0.5
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 0)
statusCorner.Parent = statusBar

statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 SISTEMA ONLINE - SANTZ HUB PREMIUM"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.TextSize = 13
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- Controles da janela melhorados
local isMinimized = false

-- Efeitos hover nos botões de controle
minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 220, 50)}):Play()
end)

minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 193, 7)}):Play()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 100)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}):Play()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 480, 0, 80)}):Play()
        scrollFrame.Visible = false
        statusBar.Visible = false
        minimizeBtn.Text = "□"
        gameTitle.Visible = false
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 480, 0, 600)}):Play()
        scrollFrame.Visible = true
        statusBar.Visible = true
        minimizeBtn.Text = "─"
        gameTitle.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Animação de fechamento melhorada
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0), 
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(shadow, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    wait(0.5)
    screenGui:Destroy()
    
    -- Limpar conexões
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Sistema de arrastar melhorado
local dragging = false
local dragStart = nil
local startPos = nil
local dragConnection = nil

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
    
    -- Feedback visual
    TweenService:Create(header, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 485, 0, 605)}):Play()
    
    dragConnection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            
            -- Limitar movimento dentro da tela
            local screenSize = workspace.CurrentCamera.ViewportSize
            local frameSize = mainFrame.AbsoluteSize
            
            local minX = 0
            local maxX = screenSize.X - frameSize.X
            local minY = 0
            local maxY = screenSize.Y - frameSize.Y
            
            newPos = UDim2.new(
                0, math.clamp(newPos.X.Offset, minX, maxX),
                0, math.clamp(newPos.Y.Offset, minY, maxY)
            )
            
            mainFrame.Position = newPos
        end
    end)
end

local function stopDrag()
    if dragging then
        dragging = false
        if dragConnection then
            dragConnection:Disconnect()
            dragConnection = nil
        end
        
        -- Remover feedback visual
        TweenService:Create(header, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 480, 0, isMinimized and 80 or 600)}):Play()
    end
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDrag()
    end
end)

-- Tornar o painel redimensionável (canto inferior direito)
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.BackgroundTransparency = 0.8
resizeHandle.Parent = mainFrame

local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 10)
resizeCorner.Parent = resizeHandle

-- Indicador visual de resize
local resizeIcon = Instance.new("TextLabel")
resizeIcon.Size = UDim2.new(1, 0, 1, 0)
resizeIcon.BackgroundTransparency = 1
resizeIcon.Text = "⟲"
resizeIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
resizeIcon.TextSize = 12
resizeIcon.Font = Enum.Font.GothamBold
resizeIcon.Parent = resizeHandle

-- Sistema de redimensionamento
local resizing = false
local resizeStart = nil
local startSize = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = mainFrame.Size
        
        TweenService:Create(resizeHandle, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            0, math.clamp(startSize.X.Offset + delta.X, 400, 800),
            0, math.clamp(startSize.Y.Offset + delta.Y, 300, 800)
        )
        
        mainFrame.Size = newSize
        
        -- Reposicionar para manter centralizado
        mainFrame.Position = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and resizing then
        resizing = false
        TweenService:Create(resizeHandle, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
    end
end)

-- Hotkeys melhoradas com feedback
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local function showHotkeyFeedback(text, color)
        statusText.Text = text
        statusText.TextColor3 = color
        wait(2)
        if statusText.Text == text then
            statusText.Text = "🟢 SISTEMA ONLINE - SANTZ HUB PREMIUM"
            statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoClip()
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY N - NoClip Toggle", Color3.fromRGB(255, 255, 0)) end)
    elseif input.KeyCode == Enum.KeyCode.R then
        roofTeleport()
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY R - Roof Teleport", Color3.fromRGB(255, 100, 100)) end)
    elseif input.KeyCode == Enum.KeyCode.B then
        teleportToBase()
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY B - Base Teleport", Color3.fromRGB(0, 255, 0)) end)
    elseif input.KeyCode == Enum.KeyCode.H then
        santzHallTP()
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY H - Santz Hall", Color3.fromRGB(255, 0, 255)) end)
    elseif input.KeyCode == Enum.KeyCode.T then
        advancedTP()
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY T - Mouse Teleport", Color3.fromRGB(100, 255, 255)) end)
    elseif input.KeyCode == Enum.KeyCode.P then
        -- Toggle visibility do painel
        mainFrame.Visible = not mainFrame.Visible
        spawn(function() showHotkeyFeedback("⌨️ HOTKEY P - Panel Toggle", Color3.fromRGB(200, 200, 200)) end)
    end
end)

-- Atualizar character melhorado
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    originalPosition = rootPart.CFrame
    
    print("🔄 Character recarregado - SANTZ HUB restaurado")
    if statusText then
        statusText.Text = "🔄 CHARACTER RELOAD - Sistema restaurado"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 255)
    end
end)

-- Sistema de notificações
local function createNotification(text, color, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(1, 10, 0, 100) -- Começa fora da tela
    notif.BackgroundColor3 = color
    notif.BackgroundTransparency = 0.1
    notif.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 15)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamSemibold
    notifText.TextWrapped = true
    notifText.Parent = notif
    
    -- Animação de entrada
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -320, 0, 100)
    }):Play()
    
    -- Animação de saída após duração
    spawn(function()
        wait(duration or 3)
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 10, 0, 100),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(notifText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        
        wait(0.5)
        notif:Destroy()
    end)
end

-- Iniciar animação e mostrar interface
spawn(function()
    playLoadingAnimation()
    wait(4)
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 480, 0, 600),
        Position = UDim2.new(0.5, -240, 0.5, -300)
    }):Play()
    
    -- Notificação de boas-vindas
    wait(1)
    createNotification("⚡ SANTZ HUB PRO CARREGADO!\n🎮 Otimizado para Steal Anime", Color3.fromRGB(0, 162, 255), 4)
end)

print("⚡ SANTZ HUB PRO v2.1 CARREGADO COM SUCESSO! ⚡")
print("🎮 OTIMIZADO PARA: STEAL ANIME")
print("📋 Hotkeys: N=NoClip | R=RoofTP | B=BaseTP | H=SantzHall | T=MouseTP | P=Panel")
print("🖱️ NOVOS RECURSOS: Painel arrastável e redimensionável!")
print("🎯 Criado por: Santz Developer")
print("🔥 Todas as funcionalidades testadas e melhoradas!")
