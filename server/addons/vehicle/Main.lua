RegisterServerEvent("core:vehicle:spawn", function(token, vehicleName, lobbyid)
    local src = source
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(src)
        if not _VEHICLE.Whitelist.Free[vehicleName] and not _VEHICLE.Whitelist.Paid[vehicleName] then
            _ANTICHEAT.punish_player(source, "Trigger Event with an excutor core:vehicle:spawn", 'events_anticheat', time)
            return
        end
        local LobbyCoords = _SAFEZONE.SafeZones[lobbyid].vehicle.coords
        local heading = _SAFEZONE.SafeZones[lobbyid].vehicle.heading
        local vehicleModel = joaat(vehicleName)
        local vehicle = CreateVehicleServerSetter(vehicleModel, LobbyCoords.x, LobbyCoords.y, LobbyCoords.z, heading)
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
        SetEntityOrphanMode(vehicle, 2)
        local networkId = NetworkGetNetworkIdFromEntity(vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(source), networkId, -1)
    end
end) 