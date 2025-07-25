-- LocalScript - StarterPlayer > StarterPlayerScripts

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Coordenadas de teleport
local ROOF_POSITION = Vector3.new(100, 60, 100) -- <=== Altere para o teto da base inimiga
local MY_BASE_POSITION = Vector3.new(-50, 10, -50) -- <=== Altere para sua base

-- Criação da GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ProGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 240)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "💠 HACK MENU 💠"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.Parent = mainFrame

-- Minimizar botão
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.Text = "_"
minimize.TextColor3 = Color3.fromRGB(0, 170, 255)
minimize.Font = Enum.Font.FredokaOne
minimize.TextSize = 24
minimize.BackgroundTransparency = 1
minimize.Parent = mainFrame

-- Função utilitária para criar botões
local function createButton(name, position, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, position)
	btn.Text = name
	btn.Font = Enum.Font.FredokaOne
	btn.TextColor3 = Color3.fromRGB(0, 170, 255)
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.Parent = mainFrame

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Comandos
createButton("🚀 Roof TP", 50, function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(ROOF_POSITION + Vector3.new(0, 5, 0))
	end
end)

createButton("🏠 TP My Base", 95, function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(MY_BASE_POSITION + Vector3.new(0, 5, 0))
	end
end)

-- NoClip
local noClip = false
createButton("🚧 Toggle No Clip", 140, function()
	noClip = not noClip
end)

RunService.Stepped:Connect(function()
	if noClip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Minimizar lógica
local isMinimized = false
local allChildren = {}

for _, v in pairs(mainFrame:GetChildren()) do
	if v:IsA("TextButton") or v:IsA("TextLabel") then
		if v ~= minimize then
			table.insert(allChildren, v)
		end
	end
end

minimize.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	for _, element in pairs(allChildren) do
		element.Visible = not isMinimized
	end
end)
