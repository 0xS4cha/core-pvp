isDead = false
local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

AddEventHandler('core:onPlayerDeath', function(data)
    isDead = true
    SetPedToRagdollWithFall(p:ped(), 0, 0, 0, -GetEntityForwardVector(p:ped()), .0, 0.0, .0, .0, .0, .0, .0)
    PlayerInComa(data)
end)

local DetailsScalform = {
    respawn = {
        control = 38,
        label = GetPhrase('respawn')
    },
    respawnearby = {
        control = 45,
        label = GetPhrase('respawn_nearby')
    },
}

local function ActiveScalform(bool)
    local dataSlots = {
        {
            name = "CLEAR_ALL",
            param = {}
        },
        {
            name = "TOGGLE_MOUSE_BUTTONS",
            param = { 0 }
        },
        {
            name = "CREATE_CONTAINER",
            param = {}
        }
    }
    local dataId = 0
    for k, v in pairs(bool and DetailsScalform) do
        dataSlots[#dataSlots + 1] = {
            name = "SET_DATA_SLOT",
            param = { dataId, GetControlInstructionalButton(2, v.control, 0), v.label }
        }
        dataId = dataId + 1
    end
    dataSlots[#dataSlots + 1] = {
        name = "DRAW_INSTRUCTIONAL_BUTTONS",
        param = { -1 }
    }
    return dataSlots
end

local Scalform = nil

local function RespawnPlayer(nearby)
    DoScreenFadeOut(1000)
    Wait(1000) -- Wait for fade out to complete
    
    local pos = GetEntityCoords(p:ped())
    if nearby then
        -- Get random position nearby (within 50 units)
        local playerPos = GetEntityCoords(p:ped())
        local randomX = playerPos.x + math.random(-50, 50)
        local randomY = playerPos.y + math.random(-50, 50)
        local randomZ = playerPos.z
        local ground, groundZ = GetGroundZFor_3dCoord(randomX, randomY, randomZ, 0)
        if ground then
            pos = vector3(randomX, randomY, groundZ)
        end
    end
    
    -- Reset player state
    isDead = false
    ClearTimecycleModifier()
    SetEntityCoordsNoOffset(p:ped(), pos.x, pos.y, pos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(pos, 0.0, true, false)
    p:setHealth(200)
    
    -- Clean up scaleform
    if Scalform then
        SetScaleformMovieAsNoLongerNeeded(Scalform)
        Scalform = nil
    end
    DoScreenFadeIn(1000)
end

function PlayerInComa(data)
    if isDead then
        TriggerServerEvent('core:death:RequestInteract', Token)
        SetTimecycleModifier("IslandPeriscope")
        if data.killedByPlayer then
            local ped = GetPlayerPed(GetPlayerFromServerId(data.killerServerId))
            Orbit.End()
            Orbit.Start(vector3(0.0, 0.0, 0.5), ped)
        end
        if _SETTINGS.canRespawn then
            Scalform = CreateScaleform("INSTRUCTIONAL_BUTTONS", ActiveScalform(true))
            Citizen.CreateThread(function()
                while isDead do
                    DrawScaleformMovieFullscreen(Scalform, 255, 255, 255, 255, 0)
                    
                    -- Check for respawn controls
                    if IsControlJustPressed(0, 38) then -- E key
                        RespawnPlayer(false)
                    elseif IsControlJustPressed(0, 45) then -- R key
                        RespawnPlayer(true)
                    end
                    
                    Wait(0)
                end
            end)
        end
    end
end


