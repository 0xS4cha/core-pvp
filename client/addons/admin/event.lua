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
