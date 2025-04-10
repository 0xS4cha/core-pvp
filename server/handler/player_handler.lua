RegisterNetEvent("core:SetPlayerActiveSkin")
AddEventHandler("core:SetPlayerActiveSkin", function(token, skin, bool)
    if CheckPlayerToken(source, token) then
        GetPlayer(source):getCloths().skin = skin
        if not bool then
            triggerEventPlayer("core:setSkinPlayer", source, skin)
        end
        MarkPlayerDataAsNonSaved(source)
        RefreshPlayerData(source)
    end
end)