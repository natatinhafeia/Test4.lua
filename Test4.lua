-- Aimbot, ESP e FOV com GUI Personalizada

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AimbotEnabled = true
local ESPEnabled = true
local FOVEnabled = false
local TargetPlayer = nil

-- Função para desenhar o ESP (caixa e nome ao redor do alvo)
local function DrawESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local screenPosition, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
        if onScreen then
            -- Criar uma box para o ESP
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 50, 0, 50)
            box.Position = UDim2.new(0, screenPosition.X - 25, 0, screenPosition.Y - 25)
            box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Vermelho
            box.BackgroundTransparency = 0.7
            box.BorderSizePixel = 2
            box.Parent = game.CoreGui

            -- Nome do jogador no ESP
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0, 50, 0, 20)
            nameLabel.Position = UDim2.new(0, screenPosition.X - 25, 0, screenPosition.Y - 60)
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextSize = 14
            nameLabel.Parent = game.CoreGui

            -- Remover o ESP após um tempo
            game:GetService("Debris"):AddItem(box, 0.1)
            game:GetService("Debris"):AddItem(nameLabel, 0.1)
        end
    end
end

-- Função para encontrar o melhor alvo (puxando a mira para a cabeça)
local function FindTarget()
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character:FindFirstChild("Head")
            if target then
                local distance = (Camera.CFrame.Position - target.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    TargetPlayer = player
                end
            end
        end
    end
end

-- Função de Aimbot para puxar a mira
local function Aimbot()
    if AimbotEnabled and TargetPlayer and TargetPlayer.Character then
        local target = TargetPlayer.Character:FindFirstChild("Head")
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end

-- Função para desenhar o FOV (círculo)
local function DrawFOV()
    if FOVEnabled then
        local fovRadius = 100  -- Tamanho do círculo de FOV
        local fovCircle = Instance.new("Frame")
        fovCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
        fovCircle.Position = UDim2.new(0.5, -fovRadius, 0.5, -fovRadius)
        fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fovCircle.BackgroundTransparency = 0.6
        fovCircle.BorderSizePixel = 0
        fovCircle.Parent = game.CoreGui
        game:GetService("Debris"):AddItem(fovCircle, 0.1)
    end
end

-- Função para criar a GUI do Aimbot, ESP e FOV
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainFrame.BackgroundTransparency = 0.5
    mainFrame.Parent = ScreenGui

    -- Botão Aimbot
    local aimbotButton = Instance.new("TextButton")
    aimbotButton.Size = UDim2.new(0, 180, 0, 50)
    aimbotButton.Position = UDim2.new(0, 10, 0, 10)
    aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    aimbotButton.Text = "Toggle Aimbot"
    aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotButton.TextSize = 18
    aimbotButton.Parent = mainFrame
    aimbotButton.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        aimbotButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    -- Botão ESP
    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(0, 180, 0, 50)
    espButton.Position = UDim2.new(0, 10, 0, 70)
    espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    espButton.Text = "Toggle ESP"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.TextSize = 18
    espButton.Parent = mainFrame
    espButton.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        espButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    -- Botão FOV
    local fovButton = Instance.new("TextButton")
    fovButton.Size = UDim2.new(0, 180, 0, 50)
    fovButton.Position = UDim2.new(0, 10, 0, 130)
    fovButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fovButton.Text = "Toggle FOV"
    fovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovButton.TextSize = 18
    fovButton.Parent = mainFrame
    fovButton.MouseButton1Click:Connect(function()
        FOVEnabled = not FOVEnabled
        fovButton.BackgroundColor3 = FOVEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    -- Função de mover a GUI
    local dragging = false
    local dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Chama a função para criar a GUI
CreateGUI()

-- Loop para encontrar o alvo, ativar Aimbot, ESP e FOV
while true do
    wait(0.1)
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawESP(player)
            end
        end
    end
    FindTarget()
    Aimbot()
    DrawFOV()
end
