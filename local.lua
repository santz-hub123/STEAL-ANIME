-- SANTZ HUB (Versão Melhorada Completa) ⚡
-- Desenvolvido por ChatGPT para Roblox Studio
-- UI Profissional + Sistema Modular + Animações

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variáveis
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Criar GUI Principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SantzHubUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Estilo de Cores
local accentColor = Color3.fromRGB(0, 162, 255)
local backgroundColor = Color3.fromRGB(20, 20, 25)
local borderColor = Color3.fromRGB(60, 60, 60)

-- Criar Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = backgroundColor
mainFrame.BorderColor3 = borderColor
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = false -- Drag manual via script
mainFrame.Name = "MainPanel"
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 5

-- UICorner e Stroke
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 1
stroke.Color = accentColor
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Header (Topo do Painel)
local header = Instance.new("Frame", mainFrame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
header.BorderSizePixel = 0
header.ZIndex = 6

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", header)
title.Text = "⚡ SANTZ HUB ⚡"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = accentColor
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 8)
title.Size = UDim2.new(1, -60, 1, -8)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Minimizar
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -32, 0.5, -12)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.AutoButtonColor = true
minimizeBtn.ZIndex = 10

local miniCorner = Instance.new("UICorner", minimizeBtn)
miniCorner.CornerRadius = UDim.new(1, 0)

-- Conteúdo Interno
local content = Instance.new("Frame", mainFrame)
content.Name = "ContentFrame"
content.Position = UDim2.new(0, 0, 0, 40)
content.Size = UDim2.new(1, 0, 1, -40)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

local uiList = Instance.new("UIListLayout", content)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)

-- Funções de Minimizar
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized

	local newSize = isMinimized and UDim2.new(0, 260, 0, 40) or UDim2.new(0, 260, 0, 320)
	local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = newSize})
	tween:Play()
end)

-- Drag Manual (Mobile compatível)
local dragging, dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
