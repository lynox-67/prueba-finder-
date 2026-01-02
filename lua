-- =====================================
-- LYNOX PET FINDER (MIKU STYLE)
-- AUTO JOIN + PET FINDER REAL
-- NO WEBHOOK
-- =====================================

repeat task.wait() until game:IsLoaded()
task.wait(3)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local running = false

-- =========================
-- UTILIDADES
-- =========================

local function formatMoney(v)
    if v >= 1_000_000_000 then
        return string.format("%.2fB", v/1_000_000_000)
    else
        return string.format("%.0fM", v/1_000_000)
    end
end

local function parseValue(txt)
    local n = tonumber(txt)
    if not n then return nil end
    if n < 10 then n = 10 end
    if n > 5000 then n = 5000 end
    return n * 1_000_000
end

-- =========================
-- DETECCIÓN REAL (MIKU)
-- =========================

local foundList = {}

local function scanServer(minValue, addToList)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "brain") then

            -- Values
            for _, v in ipairs(obj:GetDescendants()) do
                if (v:IsA("NumberValue") or v:IsA("IntValue")) and v.Value >= minValue then
                    if addToList then
                        table.insert(foundList, obj.Name.." | "..formatMoney(v.Value))
                    end
                    return true
                end
            end

            -- Attributes
            for _, val in pairs(obj:GetAttributes()) do
                if type(val) == "number" and val >= minValue then
                    if addToList then
                        table.insert(foundList, obj.Name.." | "..formatMoney(val))
                    end
                    return true
                end
            end
        end
    end
    return false
end

local function hopServer()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?limit=100")
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

-- =========================
-- LIMPIAR UI
-- =========================

pcall(function()
    CoreGui:FindFirstChild("LYNOX_UI"):Destroy()
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "LYNOX_UI"
gui.ResetOnSpawn = false

-- =========================
-- FRAME PRINCIPAL
-- =========================

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,380,0,360)
main.Position = UDim2.new(0.5,-190,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Drag
do
    local drag, ds, sp
    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true ds = i.Position sp = main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            main.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
end

-- =========================
-- HEADER
-- =========================

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "LYNOX Pet Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0,40,0,30)
minBtn.Position = UDim2.new(1,-45,0,8)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn)

-- =========================
-- CONTENIDO
-- =========================

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,45)
content.Size = UDim2.new(1,0,1,-45)
content.BackgroundTransparency = 1

local box = Instance.new("TextBox", content)
box.Position = UDim2.new(0,20,0,15)
box.Size = UDim2.new(1,-40,0,40)
box.PlaceholderText = "Ej: 10 = 10M | 5000 = 5B"
box.Font = Enum.Font.Gotham
box.TextSize = 16
box.BackgroundColor3 = Color3.fromRGB(60,60,60)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box)

local petBtn = Instance.new("TextButton", content)
petBtn.Position = UDim2.new(0,20,0,65)
petBtn.Size = UDim2.new(1,-40,0,40)
petBtn.Text = "PET FINDER"
petBtn.Font = Enum.Font.GothamBold
petBtn.TextSize = 16
petBtn.BackgroundColor3 = Color3.fromRGB(85,85,85)
petBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", petBtn)

local joinBtn = Instance.new("TextButton", content)
joinBtn.Position = UDim2.new(0,20,0,115)
joinBtn.Size = UDim2.new(1,-40,0,40)
joinBtn.Text = "AUTO JOIN"
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 16
joinBtn.BackgroundColor3 = Color3.fromRGB(105,105,105)
joinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", joinBtn)

local list = Instance.new("TextLabel", content)
list.Position = UDim2.new(0,20,0,165)
list.Size = UDim2.new(1,-40,0,120)
list.BackgroundColor3 = Color3.fromRGB(55,55,55)
list.TextXAlignment = Left
list.TextYAlignment = Top
list.TextWrapped = true
list.Text = "Brainrots encontrados:\n"
list.Font = Enum.Font.Gotham
list.TextSize = 14
list.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", list)

-- =========================
-- MINIMIZAR
-- =========================

local minimized = false
local fullSize = main.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0,380,0,45) or fullSize
    minBtn.Text = minimized and "+" or "-"
end)

-- =========================
-- BOTONES
-- =========================

petBtn.MouseButton1Click:Connect(function()
    foundList = {}
    local v = parseValue(box.Text)
    if not v then return end
    scanServer(v, true)
    list.Text = "Brainrots encontrados:\n" .. (#foundList > 0 and table.concat(foundList, "\n") or "Ninguno")
end)

joinBtn.MouseButton1Click:Connect(function()
    running = not running
    if not running then return end

    local v = parseValue(box.Text)
    if not v then running = false return end

    task.spawn(function()
        while running do
            if scanServer(v, false) then
                running = false
                break
            else
                hopServer()
            end
            task.wait(3)
        end
    end)
end)

-- =========================
-- KEYBIND
-- =========================

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

print("LYNOX PET FINDER CARGADO")
