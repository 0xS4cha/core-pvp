function _DROP.Client:SpawnPlane(a)
    local model = GetHashKey(_DROP.Vehicle.Model)
    LoadModel(model)

    local pilotModel = GetHashKey(_DROP.Vehicle.Pilot)
    Utils.LoadModel(pilotModel)

    local startTime = GetGameTimer()
    local lastUpdate = startTime

    local rad = GetRandomFloatInRange(-3.14, 3.14)
    local direction = vector3(math.cos(rad), math.sin(rad), 0.0)
    local vehicleCoords = vector3(3500, -3500, _DROP.Vehicle.Height)
    local heading = rad * 57.2958 - 90
    color = 1
    Vehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
    Pilot = CreatePed(4, pilotModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)

    planeblip = AddBlipForEntity(Vehicle)
    SetBlipSprite(planeblip, 307)
    SetBlipRotation(planeblip, GetEntityHeading(Pilot))
    SetPedIntoVehicle(Pilot, Vehicle, -1)

    ControlLandingGear(Vehicle, 3)
    SetVehicleEngineOn(Vehicle, true, true, false)
    SetEntityVelocity(Vehicle, direction.x * _DROP.Vehicle.Speed, direction.y * _DROP.Vehicle.Speed, 0.0)

    while DoesEntityExist(Vehicle) do
        if not NetworkHasControlOfEntity(Vehicle) then
            NetworkRequestControlOfEntity(Vehicle)
            Citizen.Wait(50)
        end

        SetBlipRotation(planeblip, Ceil(GetEntityHeading(Pilot)))
        if color == 1 then
            SetBlipColour(planeblip, 6)
            color = 2
        else
            SetBlipColour(planeblip, 3)
            color = 1
        end


        local delta = (GetGameTimer() - lastUpdate) / 1000.0
        lastUpdate = GetGameTimer()

        local coords = coords
        local vehicle = 0
        if ped then
            if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
                vehicle = GetVehiclePedIsIn(ped)
            end
        else
            ped = 0
        end
        local _pos = a
        TaskPlaneMission(Pilot, Vehicle, vehicle, ped, _pos.x, _pos.y, _pos.z + 250, 6, 0, 0, heading, 2000.0, 400.0)
        local pcoords = GetEntityCoords(Vehicle)
        local dist = #(pcoords - _pos)
        if dist < 350 or dropped then
            dropped = true
            Wait(1000)
            if dropped then end
            TaskPlaneMission(Pilot, Vehicle, vehicle, ped, -3500, 3500, _DROP.Vehicle.Height, 6, 0, 0, heading, 2000.0,
                400.0)
            --print('drop')
            --print(_pos)
            TriggerEvent('core:airdrop:drop', _pos)
            if dist > 1500 then
                DeleteEntity(Vehicle)
                Vehicle = 0
                DeleteEntity(Pilot)
                Pilot = 0
                return
            end
        end

        Citizen.Wait(1000)
    end

    Citizen.Wait(5000)
end
