_VEHICLE.OUT = {}
local vehiculesTmp = {}

local function LoadAllVehicle() -- done
    MySQL.Async.fetchAll('SELECT * FROM players_vehicles', {}, function(result)
        for k, v in pairs(result) do
            local veh = vehicle:new(v)
            --vehicles[v.plate] = veh
            --print(json.encode(veh))
        end
    end)
    Console.Success("All the vehicles of the BDD were load.")
end

MySQL.ready(function()
    Wait(1000)
    LoadAllVehicle()
end)

local function GeneratePlate()
    return string.upper(Generate.Code({includeLetters = true, length = 4}) .. "" .. Generate.Code({includeLetters = true, length = 4}))
end

function GenerateNotOwnedPlate()
    local free = false
    local plate = ""
    while not free do
        plate = GeneratePlate()
        local result = MySQL.Sync.fetchAll('SELECT plate FROM players_vehicles WHERE plate = @plate', { ['@plate'] = plate })
        if result[1] == nil then
            free = true
        end
    end
    return tostring(plate)
end
function MarkVehicleAsNotSaved(source, plate) -- done
    local veh = GetVehicle(plate)
    if veh == nil then return end
    veh:setNeedSave(true)
end



function SetVehicleProps(plate, props) -- done
    local veh = GetVehicle(plate)
    if veh == nil then return end
    veh:setVehiclePropsClass(props)
end
function getAllVehicleFromId(id) -- done replace of GetVehicleIndexFromPlate
    local vehList = {}
    local vehicles = GetAllVehiclesClass()
    for k, v in pairs(vehicles) do
        if v.owner == id then
            table.insert(vehList, v)
        end
    end
    return vehList
end

RegisterServerCallback('core:vehicle:GetVehicles', function(source, plate) -- done
    local id = GetPlayer(source):getId()

    return getAllVehicleFromId(id)
end)
RegisterServerEvent("core:vehicle:spawn", function(token, vehicleName, lobbyid, isPaid, plate)
    local source = source
    if CheckPlayerToken(source, token) then
        local p = GetPlayer(source)
        local props = nil
        local vehicleDB = nil
        local license = p:getLicense()
        if (not isPaid and not _VEHICLE.Whitelist.Free[vehicleName] or _VEHICLE.Whitelist.Paid[vehicleName]) and (isPaid and not _VEHICLE.Whitelist.Paid[vehicleName] or _VEHICLE.Whitelist.Free[vehicleName]) then
            _ANTICHEAT.punish_player(source, "Trigger Event with an excutor core:vehicle:spawn", 'events_anticheat', 'Ban')
            return
        end
        if isPaid then
            vehicleDB = GetVehicle(plate)
            if not vehicleDB then
                _ANTICHEAT.punish_player(source, "Trigger Event with an excutor core:vehicle:spawn", 'events_anticheat', 'Ban')
                return
            end
            if vehicleDB:getOwner() ~= p:getId() then
                _ANTICHEAT.punish_player(source, "Trigger Event with an excutor core:vehicle:spawn", 'events_anticheat', 'Ban')
                return
            end
            props = vehicleDB:getprops()
        end
        local LobbyCoords = _SAFEZONE.SafeZones[lobbyid].vehicle.coords
        local heading = _SAFEZONE.SafeZones[lobbyid].vehicle.heading
        local vehicleModel = joaat(vehicleName)
        local vehicle = CreateVehicleServerSetter(vehicleModel, 'automobile', LobbyCoords.x, LobbyCoords.y, LobbyCoords.z, heading)
        while not DoesEntityExist(vehicle) do Wait(0) end 
        local tries = 0

        while not vehicle or NetworkGetEntityOwner(vehicle) == -1 do
            Wait(200)
            tries = tries + 1
            if tries > 40 then
                if promise then
                    return promise:reject(("Could not spawn vehicle - ^5%s^7!"):format(vehicle))
                end
                error(("Could not spawn vehicle - ^5%s^7!"):format(vehicle))
            end
        end

        if _VEHICLE.OUT[license] then
            for k,v in pairs(_VEHICLE.OUT[license]) do
                if not DoesEntityExist(v) then
                    _VEHICLE.OUT[license][k] = nil
                else

                    DeleteEntity(v)
                    _VEHICLE.OUT[license][k] = nil
                end
            end
            _VEHICLE.OUT[license][#_VEHICLE.OUT[license] + 1] = vehicle
        else
            _VEHICLE.OUT[license] = {}
            _VEHICLE.OUT[license][1] = vehicle
       
        end
        --SetEntityOrphanMode(vehicle, 2)

        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
        if isPaid then
            SetVehicleNumberPlateText(vehicle, vehicleDB:getPlate())
            TriggerClientEvent('core:vehicle:loadProps', source, vehicle, props)
        end
    end
end) 

RegisterServerEvent('core:vehicle:buy', function(token, tab, id)
    local source = source
    if CheckPlayerToken(source, token) then
        local p = GetPlayer(source)
        local data = _VEHICLE.LIST.CARDEALER[tab][id]
        for k,v in pairs(p:getInventaire()) do
            if v.name == 'money' then
                if RemoveItemFromInventory(source, 'money', data.price) then
                    local props = {}
                    local plate = GenerateNotOwnedPlate()
                    props.plate = plate

                    MySQL.Async.execute("INSERT INTO players_vehicles (owner, props, plate, name, label) VALUES (@1, @2, @3, @4, @5)"
                    , {
                        ["1"] = p:getId(),
                        ["2"] = json.encode(props),
                        ["3"] = props.plate,
                        ["4"] = data.vehicle,
                        ["5"] = data.name,

                    }, function(affectedRows)
                    if affectedRows ~= 0 then
            

                        local veh = vehicle:new({
                            plate = props.plate,
                            owner = p:getId(),
                            label = data.name,
                            name = data.vehicle,
                            props = json.encode(props),
                        })
                        TriggerClientEvent('core:ShowNotification', source, ('You have bought a vehicle (~b~<C>%s</C>~s~)'):format(data.name))
                    end
                    end)
                end
            end
        end
    end
end)


RegisterServerEvent("core:admin:GiveVehicle", function(token, target, vehicleModel, vehicleName)
    local source = source
    if CheckPlayerToken(source, token) then
        local p = GetPlayer(source)
        local t = GetPlayer(target)
        if p:getPermission() < _PERMISSION['GIVE_VEHICLE'] or not _VEHICLE.Whitelist.Paid[vehicleModel] then
            _ANTICHEAT.punish_player(source, "Trigger Event with an excutor core:admin:GiveVehicle", 'events_anticheat', 'Ban')
            return
        end
        local props = {}
        local plate = GenerateNotOwnedPlate()
        props.plate = plate
        MySQL.Async.execute("INSERT INTO players_vehicles (owner, props, plate, name, label) VALUES (@1, @2, @3, @4, @5)"
        , {
            ["1"] = t:getId(),
            ["2"] = json.encode(props),
            ["3"] = props.plate,
            ["4"] = vehicleModel,
            ["5"] = vehicleName,

        }, function(affectedRows)
        if affectedRows ~= 0 then
  

            local veh = vehicle:new({
                plate = props.plate,
                owner = t:getId(),
                label = vehicleName,
                name = vehicleModel,
                props = json.encode(props),
            })
            TriggerClientEvent('core:ShowNotification', target, ('You have received a vehicle (~b~<C>%s</C>~s~) from an administrator.'):format(vehicleName))
        end
        end)

    end
end)


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        Console.Success("Resource stopping, saving vehicles.")
        local vehicles
        vehicles = GetAllVehiclesClass()
        for k, v in pairs(vehicles) do
            if v.tmpVeh == false then
                v:saveVehicle()
            end
        end
    end
end)