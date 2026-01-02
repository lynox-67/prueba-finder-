-- =========================
-- LINOX PET FINDER - XENO
-- =========================

print("LINOX SCRIPT CARGADO")
warn("LINOX INICIANDO...")

-- Esperar a que cargue el juego
repeat task.wait() until game:IsLoaded()
task.wait(2)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PLACE_ID = game.PlaceId

-- CONFIG DEL USUARIO
local MIN_PRICE = 10_000_000      -- 10M
local MAX_PRICE = 5_000_000_000   -- 5B

-- Brainrots permitidos
local ALLOWED_BRAINROTS = {
    "Dragon Cannelloni",
    "Capitano Moby",
    "Tictac Sahur",
    "La Casa Boo",
    "Burguru And Fryuru"
}

-- =========================
-- FUNCIONES
-- =========================

local function isAllowed(name)
    for _, v in ipairs(ALLOWED_BRAINROTS) do
        if v == name then
            return true
        end
    end
    return false
end

-- SIMULACIÓN DE LECTURA (XENO SAFE)
local function scanServer()
    warn("LINOX: Escaneando server...")

    -- ⚠️ Roblox no expone el valor real,
    -- esto es un placeholder funcional
    -- para comprobar ejecución
    return false
end

local function hopServer()
    warn("LINOX: Cambiando de server...")
    task.wait(1)

    local servers = {}
    local success, result = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    end)

    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(
            PLACE_ID,
            servers[math.random(1, #servers)],
            LocalPlayer
        )
    else
        warn("LINOX: No hay servers disponibles")
    end
end

-- =========================
-- LOOP PRINCIPAL
-- =========================

task.spawn(function()
    while task.wait(3) do
        local found = scanServer()

        if not found then
            hopServer()
        else
            warn("LINOX: Brainrot encontrado, detenido")
            break
        end
    end
end)
