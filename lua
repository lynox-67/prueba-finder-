-- TEST LYNOX HUB - BOTONES FUNCIONANDO

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

pcall(function()
    CoreGui:FindFirstChild("LYNOX_TEST"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LYNOX_TEST"
gui.Parent = gethui and gethui() or CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-40,0,50)
btn.Position = UDim2.new(0,20,0,30)
btn.Text = "CLICK AQUÍ"
btn.TextSize = 20
btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
btn.TextColor3 = Color3.new(1,1,1)

btn.Activated:Connect(function()
    btn.Text = "FUNCIONA ✅"
    print("BOTÓN FUNCIONANDO")
end)

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

