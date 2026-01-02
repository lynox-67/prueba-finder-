-- =====================================
-- LYNOX HUB - AUTO JOIN MANUAL REAL
-- =====================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local autoJoin = false

-- =====================================
-- SERVER HOP (REAL)
-- =====================================
local function hopServer()
    local ok, servers = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?limit=100"
            )
        )
    end)

    if ok and servers and servers.data then
        for _, s in ipairs(servers.data) do
            if s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PLACE_ID, s.id, LP)
                return
            end
        end
    end
end

-- =====================================
-- PET FINDER (MANUAL / VISIBLE)
-- =====================================
local function findBrainrots()
    local found = {}

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = string.lower(v.Name)
            if string.find(n, "brain") or string.find(n, "rot") then
                table.insert(found, v.Name)
            end
        end
    end

    return found
end

-- =====================================
-- UI
-- =====================================
pcall(function()
    CoreGui:FindFirstChild("LYNOX_GUI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LYNOX_GUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 330, 0, 250)
main.Position = UDim2.new(0.5, -165, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(45,45,45)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- DRAG
do
    local drag, startPos, startFrame
    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            startPos = i.Position
            startFrame = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - startPos
            main.Position = UDim2.new(
                startFrame.X.Scale,
                startFrame.X.Offset + delta.X,
                startFrame.Y.Scale,
                startFrame.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
end

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "LYNOX HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- STATUS
local status = Instance.new("TextLabel", main)
status.Position = UDim2.new(0,10,0,40)
status.Size = UDim2.new(1,-20,0,20)
status.BackgroundTransparency = 1
status.Text = "Estado: Idle"
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200,200,200)

-- BUTTON MAKER
local function mkButton(txt, y)
    local b = Instance.new("TextButton", main)
    b.Position = UDim2.new(0,20,0,y)
    b.Size = UDim2.new(1,-40,0,38)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Instance.new("UICorner", b)
    return b
end

local petBtn = mkButton("PET FINDER (MANUAL)", 70)
local joinBtn = mkButton("AUTO JOIN", 115)
local stopBtn = mkButton("STOP", 160)

local output = Instance.new("TextLabel", main)
output.Position = UDim2.new(0,20,0,205)
output.Size = UDim2.new(1,-40,0,35)
output.BackgroundTransparency = 1
output.TextWrapped = true
output.TextXAlignment = Left
output.Text = ""
output.Font = Enum.Font.Gotham
output.TextSize = 12
output.TextColor3 = Color3.fromRGB(220,220,220)

-- =====================================
-- BUTTON LOGIC
-- =====================================
petBtn.MouseButton1Click:Connect(function()
    local pets = findBrainrots()
    if #pets == 0 then
        output.Text = "No se detectaron Brainrots visibles"
    else
        output.Text = table.concat(pets, ", ")
    end
end)

joinBtn.MouseButton1Click:Connect(function()
    if autoJoin then return end
    autoJoin = true
    status.Text = "Estado: Auto Join activo"

    task.spawn(function()
        while autoJoin do
            hopServer()
            task.wait(3)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoJoin = false
    status.Text = "Estado: Auto Join detenido"
end)

-- MINIMIZE (RightCtrl)
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

print("LYNOX HUB CARGADO (FUNCIONAL REAL)")
