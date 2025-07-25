-- Interface Roblox Local Script (StarterPlayerScripts)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Configurações de posições (ajuste conforme seu jogo)
local enemyBaseRoof = workspace:WaitForChild("EnemyBase"):WaitForChild("Roof").Position
local myBase = workspace:WaitForChild("MyBase").Position

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AcavoUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 220)
mainFrame.Position = UDim2.new(0, 20, 0.3, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.BorderSizePixel = 0

-- UI Stroke & Corner
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Fonte estilo Acavo
local function createButton(text, yPos)
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(0, 90, 200)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBlack
	button.TextSize = 18
	button.AutoButtonColor = true

	local uiCorner = Instance.new("UICorner", button)
	uiCorner.CornerRadius = UDim.new(0, 10)

	return button
end

-- Botões
local roofTpBtn = createButton("🚀 Roof TP", 10)
local myBaseBtn = createButton("🏠 TP MY BASE", 60)
local noclipBtn = createButton("🚧 NO CLIP (OFF)", 110)
local minimizeBtn = createButton("🔽 Minimizar", 160)

-- Noclip logic
local noclipActive = false

local function toggleNoclip()
	noclipActive = not noclipActive
	noclipBtn.Text = noclipActive and "✅ NO CLIP (ON)" or "🚧 NO CLIP (OFF)"
end

runService.Stepped:Connect(function()
	if noclipActive and char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Roof TP
roofTpBtn.MouseButton1Click:Connect(function()
	local backpack = player:WaitForChild("Backpack")
	local hasItem = backpack:FindFirstChild("ObjetoRoubado") or char:FindFirstChild("ObjetoRoubado")
	if hasItem then
		char:MoveTo(enemyBaseRoof + Vector3.new(0, 5, 0))
	else
		warn("Você precisa roubar o objeto primeiro.")
	end
end)

-- TP MY BASE
myBaseBtn.MouseButton1Click:Connect(function()
	if char and myBase then
		char:MoveTo(myBase + Vector3.new(0, 3, 0))
	end
end)

-- Toggle NO CLIP
noclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- Minimizar
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(mainFrame:GetChildren()) do
		if child:IsA("TextButton") and child ~= minimizeBtn then
			child.Visible = not minimized
		end
	end
	minimizeBtn.Text = minimized and "🔼 Restaurar" or "🔽 Minimizar"
end)
