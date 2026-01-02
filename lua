-- ===================================
-- LYNOX PET FINDER + AUTO JOIN MANUAL
-- XENO COMPATIBLE - TODO FUNCIONAL
-- ===================================

repeat task.wait() until game:IsLoaded()
task.wait(2)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local autoJoin = false

-- ===================================
-- SERVER HOP
-- ===================================

local function hopServer()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?limit=100"
            )
        )
    end)

    if ok and data and data.data then
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PLACE_ID, s.id, LP)
                return
            end
        end
    end
end

-- ===================================
-- PET FINDER MANUAL
-- ===================================

local function findBrainrot()
    local found = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if string.find(string.lower(obj.Name), "brain") then
                table.insert(found, obj.Name)
            end
        end
    end

    return found
end

-- ===================================
-- UI
-- ===================================

pcall(function()
    CoreGui:FindFirstChild("LYNOX_HUB"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LYNOX_HUB"
gui.Parent = gethui and gethui() or CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,360,0,300)
frame.Position = UDim2.new(0.5,-180,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Drag
do
    local d,ds,sp
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d=true ds=i.Position sp=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then d=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position-ds
            frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y)
        end
    end)
end

-- Header
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "LYNOX Pet Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,40,0,30)
minBtn.Position = UDim2.new(1,-45,0,5)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0,0,0,40)
content.Size = UDim2.new(1,0,1,-40)
content.BackgroundTransparency = 1

-- Status
local status = Instance.new("TextLabel", content)
status.Position = UDim2.new(0,20,0,10)
status.Size = UDim2.new(1,-40,0,30)
status.BackgroundTransparency = 1
status.Text = "Estado: Idle"
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(220,220,220)

-- Pet Finder Button
local petBtn = Instance.new("TextButton", content)
petBtn.Position = UDim2.new(0,20,0,50)
petBtn.Size = UDim2.new(1,-40,0,40)
petBtn.Text = "PET FINDER"
petBtn.Font = Enum.Font.GothamBold
petBtn.TextSize = 16
petBtn.BackgroundColor3 = Color3.fromRGB(85,85,85)
petBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", petBtn)

-- Auto Join Button
local joinBtn = Instance.new("TextButton", content)
joinBtn.Position = UDim2.new(0,20,0,100)
joinBtn.Size = UDim2.new(1,-40,0,40)
joinBtn.Text = "AUTO JOIN"
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 16
joinBtn.BackgroundColor3 = Color3.fromRGB(105,105,105)
joinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", joinBtn)

-- Stop Button
local stopBtn = Instance.new("TextButton", content)
stopBtn.Position = UDim2.new(0,20,0,150)
stopBtn.Size = UDim2.new(1,-40,0,35)
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
stopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", stopBtn)

-- Result box
local result = Instance.new("TextLabel", content)
result.Position = UDim2.new(0,20,0,195)
result.Size = UDim2.new(1,-40,0,60)
result.BackgroundColor3 = Color3.fromRGB(55,55,55)
result.TextWrapped = true
result.TextYAlignment = Top
result.TextXAlignment = Left
result.Text = "Resultado:\n"
result.Font = Enum.Font.Gotham
result.TextSize = 13
result.TextColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", result)

-- ===================================
-- BUTTON LOGIC
-- ===================================

local minimized = false
local fullSize = frame.Size

minBtn.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    frame.Size = minimized and UDim2.new(0,360,0,40) or fullSize
    minBtn.Text = minimized and "+" or "-"
end)

petBtn.Activated:Connect(function()
    local list = findBrainrot()
    if #list == 0 then
        result.Text = "Resultado:\nNo hay Brainrot en este server"
    else
        result.Text = "Resultado:\n" .. table.concat(list, "\n")
    end
end)

joinBtn.Activated:Connect(function()
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

stopBtn.Activated:Connect(function()
    autoJoin = false
    status.Text = "Estado: Auto Join detenido"
end)

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

print("LYNOX PET FINDER + AUTO JOIN LISTO")
