--[[
    Acavo UI Script - Roblox LocalScript
    Autor: ChatGPT | Estilo profissional inspirado no tema Acavo
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Workspace referências (ajuste os nomes conforme seu jogo)
local enemyRoofPart = workspace:WaitForChild("EnemyBase"):WaitForChild("Roof")
local myBasePart = workspace:WaitForChild("MyBase")
local objetoName = "ObjetoRoubado" -- nome do item que o jogador precisa ter

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AcavoUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0, 20, 0.35, 0)
frame.BackgroundTransparency = 0.35
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BorderSizePixel = 0

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", frame)
title.Text = "⚙️ Acavo Panel"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Função para criar botões
local function createButton(text, positionY)
	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Position = UDim2.new(0.05, 0, 0, positionY)
	button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBlack
	button.TextSize = 18
	button.Text = text
	button.AutoButtonColor = true

	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 10)

	return button
end

-- Botões
local roofTpBtn = createButton("🚀 Roof TP", 40)
local tpBaseBtn = createButton("🏠 TP MY BASE (OFF)", 90)
local noclipBtn = createButton("👻 NO CLIP (OFF)", 140)
local minimizeBtn = createButton("🔽 Minimizar", 190)

-- Estados
local autoTP = false
local noclip = false
local minimized = false

-- Funções
roofTpBtn.MouseButton1Click:Connect(function()
	local backpack = player:WaitForChild("Backpack")
	local hasItem = backpack:FindFirstChild(objetoName) or character:FindFirstChild(objetoName)

	if hasItem then
		character:MoveTo(enemyRoofPart.Position + Vector3.new(0, 5, 0))
	else
		warn("Você precisa do item roubado para usar o Roof TP.")
	end
end)

tpBaseBtn.MouseButton1Click:Connect(function()
	autoTP = not autoTP
	tpBaseBtn.Text = autoTP and "✅ TP MY BASE (ON)" or "🏠 TP MY BASE (OFF)"
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "✅ NO CLIP (ON)" or "👻 NO CLIP (OFF)"
end)

-- Loop para NoClip e Auto TP
runService.Stepped:Connect(function()
	if noclip and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end

	if autoTP and character then
		character:MoveTo(myBasePart.Position + Vector3.new(0, 3, 0))
	end
end)

-- Minimizar UI
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextButton") and child ~= minimizeBtn then
			child.Visible = not minimized
		end
	end
	minimizeBtn.Text = minimized and "🔼 Restaurar" or "🔽 Minimizar"
end)
