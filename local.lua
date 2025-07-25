-- LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")

-- COORDENADAS
local enemyBaseRoof = Vector3.new(100, 50, 100) -- Altere conforme o mapa
local myBase = Vector3.new(-50, 10, -50)        -- Altere conforme o mapa

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "CustomGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Active = true
mainFrame.Draggable = true

local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚡ HACK MENU ⚡"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.Arcade
title.TextSize = 24

-- Função de botão
local function createButton(text, posY, callback)
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.Position = UDim2.new(0.05, 0, 0, posY)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(0, 170, 255)
	button.Font = Enum.Font.Arcade
	button.TextSize = 18
	button.Text = text
	button.MouseButton1Click:Connect(callback)
	
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 6)
	
	return button
end

-- Botões
createButton("Roof TP", 40, function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(enemyBaseRoof + Vector3.new(0, 5, 0))
	end
end)

createButton("TP My Base", 80, function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(myBase + Vector3.new(0, 5, 0))
	end
end)

local noClipActive = false
createButton("No Clip [Toggle]", 120, function()
	noClipActive = not noClipActive
end)

-- NOCLIP LOOP
game:GetService("RunService").Stepped:Connect(function()
	if noClipActive and player.Character and player.Character:FindFirstChild("Humanoid") then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide == true then
				part.CanCollide = false
			end
		end
	end
end)

-- Botão de minimizar
local minimized = false
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
minimizeBtn.Font = Enum.Font.Arcade
minimizeBtn.TextSize = 20
minimizeBtn.BackgroundTransparency = 1

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(mainFrame:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("TextLabel") then
			child.Visible = not minimized
		end
	end
	minimizeBtn.Visible = true
end)
