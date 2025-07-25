-- Configurações iniciais
local player = game:GetService("Players").LocalPlayer
local guiEnabled = true

-- Cria a interface principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Adiciona efeito de borda
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Título da interface
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "TELEPORT MENU"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 18
title.Parent = mainFrame

-- Botão de minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Parent = mainFrame

-- Função para teleportar para o telhado da base inimiga
local function roofTeleport()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Aqui você precisaria definir a posição do telhado da base inimiga
            -- Substitua os valores pelos da sua base inimiga
            local enemyRoofPosition = Vector3.new(100, 50, 100) -- Exemplo
            humanoidRootPart.CFrame = CFrame.new(enemyRoofPosition)
        end
    end
end

-- Função para teleportar para sua base
local function myBaseTeleport()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Aqui você precisaria definir a posição da sua base
            -- Substitua os valores pelos da sua base
            local myBasePosition = Vector3.new(0, 5, 0) -- Exemplo
            humanoidRootPart.CFrame = CFrame.new(myBasePosition)
        end
    end
end

-- Variável de estado do NoClip
local noclipActive = false

-- Função para ativar/desativar NoClip
local function toggleNoClip()
    noclipActive = not noclipActive
    noClipButton.Text = noclipActive and "NO CLIP: ON" or "NO CLIP: OFF"
    noClipButton.TextColor3 = noclipActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if noclipActive then
        -- Conexão para manter o NoClip ativo
        local noclipConnection
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                noclipConnection:Disconnect()
            end
        end)
    end
end

-- Botão Roof TP
local roofButton = Instance.new("TextButton")
roofButton.Name = "RoofButton"
roofButton.Size = UDim2.new(0.9, 0, 0, 40)
roofButton.Position = UDim2.new(0.05, 0, 0.2, 0)
roofButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
roofButton.BackgroundTransparency = 0.3
roofButton.Text = "ROOF TP"
roofButton.Font = Enum.Font.GothamBold
roofButton.TextColor3 = Color3.fromRGB(255, 255, 255)
roofButton.TextSize = 16
roofButton.Parent = mainFrame

local roofCorner = Instance.new("UICorner")
roofCorner.CornerRadius = UDim.new(0, 6)
roofCorner.Parent = roofButton

roofButton.MouseButton1Click:Connect(roofTeleport)

-- Botão My Base TP
local baseButton = Instance.new("TextButton")
baseButton.Name = "BaseButton"
baseButton.Size = UDim2.new(0.9, 0, 0, 40)
baseButton.Position = UDim2.new(0.05, 0, 0.45, 0)
baseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
baseButton.BackgroundTransparency = 0.3
baseButton.Text = "TP MY BASE"
baseButton.Font = Enum.Font.GothamBold
baseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
baseButton.TextSize = 16
baseButton.Parent = mainFrame

local baseCorner = Instance.new("UICorner")
baseCorner.CornerRadius = UDim.new(0, 6)
baseCorner.Parent = baseButton

baseButton.MouseButton1Click:Connect(myBaseTeleport)

-- Botão No Clip
noClipButton = Instance.new("TextButton")
noClipButton.Name = "NoClipButton"
noClipButton.Size = UDim2.new(0.9, 0, 0, 40)
noClipButton.Position = UDim2.new(0.05, 0, 0.7, 0)
noClipButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
noClipButton.BackgroundTransparency = 0.3
noClipButton.Text = "NO CLIP: OFF"
noClipButton.Font = Enum.Font.GothamBold
noClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noClipButton.TextSize = 16
noClipButton.Parent = mainFrame

local noClipCorner = Instance.new("UICorner")
noClipCorner.CornerRadius = UDim.new(0, 6)
noClipCorner.Parent = noClipButton

noClipButton.MouseButton1Click:Connect(toggleNoClip)

-- Função para minimizar/maximizar a interface
minimizeButton.MouseButton1Click:Connect(function()
    if guiEnabled then
        mainFrame.Size = UDim2.new(0, 300, 0, 30)
        roofButton.Visible = false
        baseButton.Visible = false
        noClipButton.Visible = false
        minimizeButton.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 200)
        roofButton.Visible = true
        baseButton.Visible = true
        noClipButton.Visible = true
        minimizeButton.Text = "_"
    end
    guiEnabled = not guiEnabled
end)

-- Efeito de hover nos botões
local function setupButtonHover(button)
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.1
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0.3
    end)
end

setupButtonHover(roofButton)
setupButtonHover(baseButton)
setupButtonHover(noClipButton)
setupButtonHover(minimizeButton)
