-- =========================
-- LINOX HUB - XENO SAFE UI
-- =========================

print("LINOX: CARGANDO UI...")

repeat task.wait() until game:IsLoaded()
task.wait(5)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- limpiar si existe
pcall(function()
    CoreGui:FindFirstChild("LINOX_UI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LINOX_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- 🔥 CLAVE PARA XENO
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 360, 0, 260)
main.Position = UDim2.new(0.5, -180, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)
main.BorderSizePixel = 0
main.Visible = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "LINOX Pet Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(230,230,230)

local info = Instance.new("TextLabel")
info.Parent = main
info.Position = UDim2.new(0,20,0,60)
info.Size = UDim2.new(1,-40,0,40)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.Text = "RightCtrl = Mostrar / Ocultar"
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(180,180,180)

local box = Instance.new("TextBox")
box.Parent = main
box.Position = UDim2.new(0,20,0,110)
box.Size = UDim2.new(1,-40,0,40)
box.PlaceholderText = "Ej: 10 = 10M | 5000 = 5B"
box.BackgroundColor3 = Color3.fromRGB(60,60,60)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextSize = 16
Instance.new("UICorner", box)

local btn = Instance.new("TextButton")
btn.Parent = main
btn.Position = UDim2.new(0,20,0,170)
btn.Size = UDim2.new(1,-40,0,50)
btn.Text = "AUTO JOIN / PET FINDER"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
Instance.new("UICorner", btn)

-- Keybind
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

print("LINOX: UI MOSTRADA CORRECTAMENTE")
