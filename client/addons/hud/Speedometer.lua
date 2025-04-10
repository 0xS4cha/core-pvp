Citizen.CreateThread(function()
    local hudEnabled = false
    local PlayerPedId, GetVehiclePedIsIn, GetIsVehicleEngineRunning, GetVehicleIndicatorLights, GetVehicleLightsState, SendNUIMessage, GetEntitySpeed, GetVehicleFuelLevel =
        PlayerPedId, GetVehiclePedIsIn, GetIsVehicleEngineRunning, GetVehicleIndicatorLights, GetVehicleLightsState,
        SendNUIMessage, GetEntitySpeed, GetVehicleFuelLevel

    while true do
        local ped, waitTime = PlayerPedId(), 1000
        local veh = GetVehiclePedIsIn(ped)

        if veh ~= 0 and GetIsVehicleEngineRunning(veh) then
            hudEnabled = true
            waitTime = 100

            local shouldUseMetric = ShouldUseMetricMeasurements()
            local _, positionLight, roadLight = GetVehicleLightsState(veh)

            SendNUIMessage({
                action = 'showSpeedometer',
                data = {
                    show = true,
                    data = {
                        speed = math.ceil(GetEntitySpeed(veh) * (shouldUseMetric and 3.6 or 2.236936)),
                        speedUnit = shouldUseMetric and "km/h" or "mph",
                    }
                }
            })
        elseif hudEnabled then
            hudEnabled = false
            SendNUIMessage({
                action = 'showSpeedometer',
                data = {
                    show = false,
                    data = {
                        speed = 1,
                        speedUnit = "",
                    }
                }
            })
        end

        Citizen.Wait(waitTime)
    end
end)
