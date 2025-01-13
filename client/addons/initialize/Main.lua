_INITIALIZE = _INITIALIZE or {}

CreateThread = Citizen.CreateThread


function _INITIALIZE.ClothingStore(v)
    Utils.CreateBlips(v.Pos, v.Blip.display, v.Blip.colour, GetPhrase(v.Blip.name), false, v.Blip.size)
    local ped = entity:CreatePedLocal("a_f_m_beach_01", v.Pos, v.Heading)
    ped:setFreeze(true)

    SetEntityInvincible(ped:getEntityId(), true)
    NetworkSetEntityInvisibleToNetwork(ped:getEntityId(), true)
    SetEntityCanBeDamaged(ped:getEntityId(), false)
    SetBlockingOfNonTemporaryEvents(ped:getEntityId(), true)
    InteractAPI.addLocalEntityInteraction({
        entity = ped:getEntityId(),
        distance = 10.0,
        interactDst = 10.0,
        offset = vec(0.0, 0.0, 0.5),
        options = {
            {
                label = GetPhrase(v.Blip.name),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)
                    startClothingStore()
                end,
            },
        }
    })
end


function _INITIALIZE.SpawnSelector(v)
    Utils.CreateBlips(v.Pos, v.Blip.display, v.Blip.colour, GetPhrase(v.Blip.name), false, v.Blip.size)
    local ped = entity:CreatePedLocal("s_m_m_movspace_01", v.Pos, v.Heading)
    ped:setFreeze(true)

    SetEntityInvincible(ped:getEntityId(), true)
    NetworkSetEntityInvisibleToNetwork(ped:getEntityId(), true)
    SetEntityCanBeDamaged(ped:getEntityId(), false)
    SetBlockingOfNonTemporaryEvents(ped:getEntityId(), true)
    InteractAPI.addLocalEntityInteraction({
        entity = ped:getEntityId(),
        distance = 10.0,
        interactDst = 10.0,
        offset = vec(0.0, 0.0, 0.5),
        options = {
            {
                label = GetPhrase(v.Blip.name),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)
                    local zone = {}
                    for k,v in pairs(_SAFEZONE.SafeZones) do
                        table.insert(zone, {
                            Name = v.Name,
                            Description = v.Description,
                            Image = v.Image,
                        })
                    end
                    SetNuiFocus(true, true)
                    _NUI.SendNUIMessage('showSpawnSelector', {
                        show = true,
                        translation = {
                            select = GetPhrase('SELECT')
                        },
                        lobby = zone
                    })
                end,
            },
        }
    })
end

CreateThread(function()
    for i = 1, #_SAFEZONE.SafeZones do
        _INITIALIZE.SpawnSelector(_SAFEZONE.SafeZones[i].lobbySelector)
        _INITIALIZE.ClothingStore(_SAFEZONE.SafeZones[i].clothingStore)
    end
end)
