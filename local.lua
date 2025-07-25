-- SANTZ HUB SUPREMO vFinal
-- Criado por ChatGPT - 2025
-- Totalmente funcional, layout corrigido, com NoClip, Fly, TP, ESP e interface profissional.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SantzHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local themeColor = Color3.fromRGB(0, 162, 255)
local darkColor = Color3.fromRGB(20, 20, 25)

-- GUI Principal
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 450)
main.Position = UDim2.new(0.03, 0, 0.2, 0)
main.BackgroundColor3 = darkColor
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", main).Color = themeColor

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.Text = "⚡ SANTZ HUB SUPREMO ⚡"
header.TextColor3 = themeColor
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Botão de minimizar
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -30, 0.5, -12)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- Conteúdo com Scroll
local content = Instance.new("ScrollingFrame", main)
content.Position = UDim2.new(0, 0, 0, 40)
content.Size = UDim2.new(1, 0, 1, -40)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ScrollBarThickness = 4
content.ClipsDescendants = true

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", content)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

-- Minimizar
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	main.Size = minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 450)
end)

-- Notificação
local function notify(msg, success)
	local label = Instance.new("TextLabel", gui)
	label.Text = msg
	label.Size = UDim2.new(0, 250, 0, 30)
	label.Position = UDim2.new(1, -270, 1, -150)
	label.AnchorPoint = Vector2.new(0, 1)
	label.BackgroundColor3 = success and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.BorderSizePixel = 0
	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)

	TweenService:Create(label, TweenInfo.new(0.3), {Position = UDim2.new(1, -270, 1, -180)}):Play()
	task.delay(3, function()
		TweenService:Create(label, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, 40)}):Play()
		task.wait(0.3)
		label:Destroy()
	end)
end

-- Criar botões
local function createBtn(name, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1, -20, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", btn).Color = themeColor
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
	end)
	btn.MouseButton1Click:Connect(callback)
end

-- Funcionalidades

-- NoClip
local noclip = false
local noclipConn
createBtn("NoClip [TOGGLE]", function()
	noclip = not noclip
	if noclip then
		noclipConn = RunService.Stepped:Connect(function()
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end)
		notify("NoClip: Ativado", true)
	else
		if noclipConn then noclipConn:Disconnect() end
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = true end
		end
		notify("NoClip: Desativado", false)
	end
end)

-- TP Base Inimiga
createBtn("TP Base Inimiga (ROOF)", function()
	local found = false
	for _, m in pairs(workspace:GetDescendants()) do
		if m:IsA("Model") and m.Name:lower():find("base") and not m.Name:lower():find(player.Name:lower()) then
			local p = m:FindFirstChildWhichIsA("Part")
			if p then
				character:MoveTo(p.Position + Vector3.new(0, 10, 0))
				found = true
				break
			end
		end
	end
	notify(found and "TP para base inimiga efetuado!" or "Base inimiga não encontrada", found)
end)

-- TP Minha Base
createBtn("TP Minha Base", function()
	local found = false
	for _, m in pairs(workspace:GetDescendants()) do
		if m:IsA("Model") and m.Name:lower():find(player.Name:lower()) then
			local p = m:FindFirstChildWhichIsA("Part")
			if p then
				character:MoveTo(p.Position + Vector3.new(0, 10, 0))
				found = true
				break
			end
		end
	end
	notify(found and "TP para sua base efetuado!" or "Sua base não foi localizada", found)
end)

-- ESP Players
createBtn("ESP Players", function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			local char = plr.Character
			if char and not char:FindFirstChild("ESP") then
				local box = Instance.new("BillboardGui", char)
				box.Name = "ESP"
				box.Size = UDim2.new(0, 100, 0, 40)
				box.AlwaysOnTop = true
				box.Adornee = char:FindFirstChild("Head")
				local txt = Instance.new("TextLabel", box)
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.Text = plr.Name
				txt.TextColor3 = Color3.fromRGB(255, 0, 0)
				txt.BackgroundTransparency = 1
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 14
			end
		end
	end
	notify("ESP Ativado!", true)
end)

-- Fly
local flying = false
local flyConn
createBtn("Fly [TOGGLE]", function()
	flying = not flying
	if flying then
		local bodyGyro = Instance.new("BodyGyro", character.PrimaryPart)
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.P = 10000
		local bodyVel = Instance.new("BodyVelocity", character.PrimaryPart)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVel.Velocity = Vector3.new(0, 0, 0)
		flyConn = RunService.RenderStepped:Connect(function()
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			local dir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
			bodyVel.Velocity = dir * 60
		end)
		notify("Fly Ativado!", true)
	else
		if flyConn then flyConn:Disconnect() end
		character.PrimaryPart:FindFirstChild("BodyVelocity"):Destroy()
		character.PrimaryPart:FindFirstChild("BodyGyro"):Destroy()
		notify("Fly Desativado!", false)
	end
end)
