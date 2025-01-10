local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

function TriggerPlayerEvent(eventName, source,  ...)
	TriggerServerEvent('core:adminPlayerEvent', eventName, source, Token, ...)
end

RegisterNetEvent("core:admin:SendMessageToPlayer")
AddEventHandler("core:admin:SendMessageToPlayer", function(msg)
    Utils.ShowNotification(("~b~%s.~s~\n%s."):format(GetPhrase('admin_send_messsage_administrator'), msg), true)
end)

RegisterNetEvent("core:admin:anticheatAlert")
AddEventHandler("core:admin:anticheatAlert", function(data, type, event, id, alert)
    AlertANTICHEAT = data

    if alert then
        PlaySoundFrontend(-1, 'HACKING_FAILURE', 0, false)
        Utils.ShowAdvancedNotification('~r~STAFF~s~', '~italic~ANTICHEAT Alert~italic~', ('~bold~%s~bold~\nDistance: ~b~%s~s~\n%s'):format(GetPhrase(event), Utils.Round(#(GetEntityCoords(PlayerPedId()) -  AlertANTICHEAT[type][event][id]['coords']), 2), GetPhrase('anticheat_action')), 'CHAR_ACTING_UP', 1)
    end
end)