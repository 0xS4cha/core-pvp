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

function _INITIALIZE.ChestMenu(v)
    Utils.CreateBlips(v.Pos, v.Blip.display, v.Blip.colour, GetPhrase(v.Blip.name), false, v.Blip.size)
    local ped = entity:CreatePedLocal("u_m_y_imporage", v.Pos, v.Heading)
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
                label = GetPhrase('your_chest'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)
                    OpenStorage()
                end,
            },
            {
                label = GetPhrase('Crew_chest (SOON)'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)

                end,
            },
        }
    })
end

function _INITIALIZE.SquadMenu(v)
    Utils.CreateBlips(v.Pos, v.Blip.display, v.Blip.colour, GetPhrase(v.Blip.name), false, v.Blip.size)
    local ped = entity:CreatePedLocal("csb_maude", v.Pos, v.Heading)
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
                label = GetPhrase('Squad_MENU (SOON)'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)

                end,
            },
            {
                label = GetPhrase('Crew_MENU (SOON)'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)

                end,
            },
        }
    })
end

function _INITIALIZE.VehicleMenu(v)
    Utils.CreateBlips(v.Pos, v.Blip.display, v.Blip.colour, GetPhrase(v.Blip.name), false, v.Blip.size)
    local ped = entity:CreatePedLocal("u_m_m_vince", v.Pos, v.Heading)
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
                label = GetPhrase('your_garage_menu'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)
                    SetNuiFocus(true, true)
                    vehListSelector = {}
                    local paid = nil

                    while paid == nil do
                        paid = TriggerServerCallback("core:vehicle:GetVehicles")
                        Wait(100)
                    end
                    for k,v in pairs(paid) do 
                        table.insert(vehListSelector, {
                            name = v.label,
                            type = "PAID",
                            image = v.name,
                            vehicle = v.name,
                            plate = v.plate
                        })
                    end
                    for k,v in pairs(_VEHICLE.LIST.FREE) do 
                        table.insert(vehListSelector, {
                            name = v.name,
                            type = "FREE",
                            image = v.image,
                            vehicle = v.vehicle
                        })
                    end
                    
                    _NUI.SendNUIMessage('showRental', {
                        show = true,
                        data = vehListSelector
                    })
                end,
            },
            {
                label = GetPhrase('cardealer'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)
                    SetNuiFocus(true, true)
                    _NUI.SendNUIMessage('showCardealer', {
                        show = true,
                        data = _VEHICLE.LIST.CARDEALER
                    })
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
        _INITIALIZE.SquadMenu(_SAFEZONE.SafeZones[i].squadMenu)
        _INITIALIZE.VehicleMenu(_SAFEZONE.SafeZones[i].vehicleMenu)
        _INITIALIZE.SpawnSelector(_SAFEZONE.SafeZones[i].lobbySelector)
        _INITIALIZE.ClothingStore(_SAFEZONE.SafeZones[i].clothingStore)
        _INITIALIZE.ChestMenu(_SAFEZONE.SafeZones[i].chestMenu)
    end
end)
