--// LINOX | ROBA UN BRAINROT
--// Guardado + Prioridad editable
--// Auto Join Real

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PLACE_ID = game.PlaceId

-------------------------------------------------
-- 📁 CONFIG FILE
-------------------------------------------------

local CONFIG_FILE = "linox_brainrot_config.json"

local DEFAULT_CONFIG = {
    minPrice = 10e6,
    maxPrice = 5e9,
    priority = {
        "Admin Lucky Block",
        "La Supreme Combinasion",
        "La Secret Combinasion",
        "La Extinct Grande",
        "Dragon Cannelloni",
        "Capitano Moby",
        "Tictac Sahur",
    }
}

local CONFIG

if isfile and isfile(CONFIG_FILE) then
    CONFIG = HttpService:JSONDecode(readfile(CONFIG_FILE))
else
    CONFIG = DEFAULT_CONFIG
    if writefile then
        writefile(CONFIG_FILE, HttpService:JSONEncode(CONFIG))
    end
end

-------------------------------------------------
-- 💰 VALORES FALLBACK (ROBA UN BRAINROT)
-------------------------------------------------

local VALUE_FALLBACK = {
    ["Admin Lucky Block"] = 5e9,
    ["La Supreme Combinasion"] = 4e9,
    ["La Secret Combinasion"] = 3e9,
    ["La Extinct Grande"] = 2e9,
    ["Dragon Cannelloni"] = 250e6,
    ["Capitano Moby"] = 1e9,
    ["Tictac Sahur"] = 40e6,
}

-------------------------------------------------
-- 🔝 PRIORIDAD MAP
-------------------------------------------------

local PRIORITY_INDEX = {}
local function rebuildPriority()
    PRIORITY_INDEX = {}
    for i,name in ipairs(CONFIG.priority) do
        PRIORITY_INDEX[name] = i
    end
end
rebuildPriority()

-------------------------------------------------
-- 🧠 UTILIDADES
-------------------------------------------------

local function isBrainrot(name)
    return PRIORITY_INDEX[name] ~= nil
end

local function getValue(model)
    local v = model:FindFirstChild("Value")
    if v and v:IsA("NumberValue") then
        return v.Value
    end
    return VALUE_FALLBACK[model.Name]
end

-------------------------------------------------
-- 🔍 SCAN DEL SERVER (REAL)
-------------------------------------------------

local function scanServer()
    local found = {}

    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and isBrainrot(obj.Name) then
            local value = getValue(obj)
            if value and value >= CONFIG.minPrice and value <= CONFIG.maxPrice then
                table.insert(found, {
                    name = obj.Name,
                    value = value,
                    priority = PRIORITY_INDEX[obj.Name]
                })
            end
        end
    end

    table.sort(found, function(a,b)
        return a.priority < b.priority
    end)

    return found[1]
end

-------------------------------------------------
-- 🚀 SERVER HOP (ANTI REPETIDOS)
-------------------------------------------------

local visited = {}

local function hopServer()
    local data = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _,s in ipairs(data.data) do
        if s.playing < s.maxPlayers and not visited[s.id] then
            visited[s.id] = true
            TeleportService:TeleportToPlaceInstance(PLACE_ID, s.id, LP)
            return
        end
    end

    visited = {} -- reset si se acabaron
end

-------------------------------------------------
-- 🔁 LOOP PRINCIPAL
-------------------------------------------------

task.spawn(function()
    while task.wait(4) do
        local best = scanServer()
        if best then
            warn("[LINOX] ENCONTRADO:", best.name, math.floor(best.value/1e6).."M")
            break
        else
            warn("[LINOX] No hay Brainrot válido, cambiando server...")
            hopServer()
        end
    end
end)

-------------------------------------------------
-- 🛠️ COMANDOS RÁPIDOS (EDITABLES)
-------------------------------------------------
-- Cambiar prioridad (ejemplo):
-- table.insert(CONFIG.priority, 1, "Dragon Cannelloni")
-- rebuildPriority()
-- writefile(CONFIG_FILE, HttpService:JSONEncode(CONFIG))
