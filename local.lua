-- Script Roblox Profissional - Interface Acabo
-- Criado para funcionalidades avançadas de teleporte e exploits

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis do script
local noclipEnabled = false
local connections = {}
local originalBasePosition = rootPart.Position
local isMinimized = false

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcaboInterface"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Adicionar gradiente ao fundo
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 144, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Adicionar cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Adicionar sombra
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ACABO INTERFACE PRO ⚡"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 18
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -45, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeBtn

-- Container para botões
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -20, 1, -70)
buttonContainer.Position = UDim2.new(0, 10, 0, 60)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 8
buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
buttonContainer.Parent = mainFrame

-- Layout dos botões
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = buttonContainer

-- Função para criar botões
local function createButton(text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.TextStrokeTransparency = 0
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Parent = buttonContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Efeito de hover
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2})
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Função para encontrar a base inimiga
local function findEnemyBase()
    local bases = workspace:FindFirstChild("Bases") or workspace
    for _, obj in pairs(bases:GetChildren()) do
        if obj.Name:lower():find("base") and obj:FindFirstChild("Part") then
            return obj
        end
    end
    return nil
end

-- Função para encontrar o teto da base
local function findBaseCeiling(base)
    local highestY = -math.huge
    local ceilingPart = nil
    
    for _, part in pairs(base:GetDescendants()) do
        if part:IsA("BasePart") and part.Position.Y > highestY then
            highestY = part.Position.Y
            ceilingPart = part
        end
    end
    
    return ceilingPart
end

-- Função NoClip
local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        connections.noclip = RunService.Stepped:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Função Roof TP
local function roofTeleport()
    local enemyBase = findEnemyBase()
    if enemyBase then
        local ceiling = findBaseCeiling(enemyBase)
        if ceiling then
            rootPart.CFrame = CFrame.new(ceiling.Position + Vector3.new(0, 20, 0))
            print("Teleportado para o teto da base inimiga!")
        else
            print("Teto da base não encontrado!")
        end
    else
        print("Base inimiga não encontrada!")
    end
end

-- Função TP My Base
local function teleportToMyBase()
    rootPart.CFrame = CFrame.new(originalBasePosition)
    print("Teleportado para sua base!")
end

-- Função Santz Hall (TP para dentro da base fechada)
local function santzHall()
    local enemyBase = findEnemyBase()
    if enemyBase then
        -- Encontrar o centro da base
        local cf, size = enemyBase:GetBoundingBox()
        local centerPosition = cf.Position
        
        -- Teleportar para dentro da base (10 studs acima do chão)
        rootPart.CFrame = CFrame.new(centerPosition + Vector3.new(0, 10, 0))
        print("Santz Hall ativado - Teleportado para dentro da base!")
    else
        print("Base inimiga não encontrada!")
    end
end

-- Função de teleporte de base avançado
local function advancedBaseTeleport()
    local targetBase = nil
    
    -- Procurar por diferentes tipos de bases
    local possibleBases = {"Base", "TeamBase", "SpawnLocation", "Flag"}
    
    for _, baseName in pairs(possibleBases) do
        targetBase = workspace:FindFirstChild(baseName)
        if targetBase then break end
    end
    
    if not targetBase then
        -- Procurar recursivamente
        local function searchForBase(parent)
            for _, obj in pairs(parent:GetChildren()) do
                if obj.Name:lower():find("base") or obj.Name:lower():find("spawn") then
                    return obj
                end
                local found = searchForBase(obj)
                if found then return found end
            end
            return nil
        end
        targetBase = searchForBase(workspace)
    end
    
    if targetBase and targetBase:IsA("BasePart") then
        rootPart.CFrame = targetBase.CFrame + Vector3.new(0, 5, 0)
        print("Teleportado para a base!")
    elseif targetBase then
        local part = targetBase:FindFirstChildOfClass("BasePart")
        if part then
            rootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            print("Teleportado para a base!")
        end
    else
        print("Nenhuma base encontrada!")
    end
end

-- Função para minimizar/maximizar
local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 50)})
        tween:Play()
        buttonContainer.Visible = false
        minimizeBtn.Text = "□"
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 500)})
        tween:Play()
        buttonContainer.Visible = true
        minimizeBtn.Text = "─"
    end
end

-- Criar botões
createButton("🚀 ROOF TP", Color3.fromRGB(255, 100, 100), roofTeleport)
createButton("🏠 TP MY BASE", Color3.fromRGB(100, 255, 100), teleportToMyBase)
createButton("👻 NO CLIP", Color3.fromRGB(255, 255, 100), toggleNoClip)
createButton("⚡ SANTZ HALL", Color3.fromRGB(255, 100, 255), santzHall)
createButton("🎯 BASE TELEPORT", Color3.fromRGB(100, 255, 255), advancedBaseTeleport)

-- Status indicator
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 1, -30)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.5
statusLabel.Text = "STAT
