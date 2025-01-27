Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    SetDiscordAppId(999247110392266773)
    SetDiscordRichPresenceAsset("ldo_logo-upscale")
    SetDiscordRichPresenceAssetText("discord.gg/LDO-PVP")

    SetDiscordRichPresenceAction(0, "Jouer", "https://discord.gg/LDO-PVP")
    SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/LDO-PVP")
end)

RegisterNetEvent("core:UpdateRichPresence")
AddEventHandler("core:UpdateRichPresence", function(number)
    SetRichPresence(_CONFIG.ServerName .. " - " .. number .. " " .. GetPhrase('Player_Connected'))
end)
