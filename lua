-- =========================
-- UI LINOX PET FINDER
-- =========================

local UIS = game:GetService("UserInputService")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "LINOX_UI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.25, 0.35)
main.Position = UDim2.fromScale(0.37, 0.3)
main.BackgroundColor3 = Color3.fromRGB(35,35,35)
main.BorderSizePixel = 0
main.Visible = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,16)

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.15,0)
title.BackgroundTransparency = 1
title.Text = "LINOX Pet Finder"
title.TextColor3 = Color3.fromRGB(220,220,220)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Input
local box = Instance.new("TextBox", main)
box.PlaceholderText = "Ej: 10 = 10M | 5000 = 5B"
box.Size = UDim2.new(0.9,0,0.18,0)
box.Position = UDim2.new(0.05,0,0.2,0)
box.BackgroundColor3 = Color3.fromRGB(50,50,50)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextScaled = true

Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

-- Botón Pet Finder
local petBtn = Instance.new("TextButton", main)
petBtn.Text = "PET FINDER"
petBtn.Size = UDim2.new(0.9,0,0.18,0)
petBtn.Position = UDim2.new(0.05,0,0.45,0)
petBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
petBtn.TextColor3 = Color3.new(1,1,1)
petBtn.Font = Enum.Font.GothamBold
petBtn.TextScaled = true
Instance.new("UICorner", petBtn)

-- Botón Auto Join
local joinBtn = Instance.new("TextButton", main)
joinBtn.Text = "AUTO JOIN"
joinBtn.Size = UDim2.new(0.9,0,0.18,0)
joinBtn.Position = UDim2.new(0.05,0,0.68,0)
joinBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
joinBtn.TextColor3 = Color3.new(1,1,1)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextScaled = true
Instance.new("UICorner", joinBtn)

-- Keybind RightCtrl
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

print("LINOX UI CARGADA")
