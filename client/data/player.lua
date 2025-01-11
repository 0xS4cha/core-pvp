---@diagnostic disable: lowercase-global
playerData = {}
globalData = {}
loaded = false

RegisterNetEvent("core:RefreshPlayerData")
AddEventHandler("core:RefreshPlayerData", function(data)
    playerData = data
    Console.Success("Mise à jour des données du joueur")
    player:new(data)
    TriggerEvent("core:RefreshData", playerData)
end)

RegisterNetEvent("core:InitPlayer")
AddEventHandler("core:InitPlayer", function(globalDatas)
    globalData = globalDatas
end)



RegisterCommand('debug', function()
    TriggerEvent('playerSpawned')
end, false)
AddEventHandler("playerSpawned", function()

    while p == nil do Wait(1000) end

    FreezeEntityPosition(p:ped(), true)
    DisablePlayerVehicleRewards(p:ped())
    ShutdownLoadingScreenNui()
    SetEntityInvincible(p:ped(), true)
    RequestAllIpls()
    if p:getCloths().skin == "" then
        LoadNewCharCreator()
    elseif p:getCloths().skin ~= "" then
        LoadPlayerData(false)

        TriggerEvent("skinchanger:loadSkin", p:getCloths().skin)
        -- TriggerEvent('rcore_tattoos:applyOwnedTattoos')
        
        FreezeEntityPosition(p:ped(), false)
    end

end)

function LoadPlayerData(fromCharCreator) -- Tout les init irons ici
    InitPositionHandler(_CONFIG.Lobby, fromCharCreator)
end


TriggerServerEvent("core:InitPlayer")


-- function ToggleSound(state)
--     if state then
--         StartAudioScene("MP_LEADERBOARD_SCENE");
--     else
--         StopAudioScene("MP_LEADERBOARD_SCENE");
--     end
-- end

-- function InitialSetup()
--     ToggleSound(muteSound)
--     if not IsPlayerSwitchInProgress() then
--         SwitchOutPlayer(PlayerPedId(), 0, 1)
--     end
-- end

-- function ClearScreen()
--     SetCloudHatOpacity(cloudOpacity)
--     HideHudAndRadarThisFrame()
--     SetDrawOrigin(0.0, 0.0, 0.0, 0)
-- end



-- evt refresh

RegisterNetEvent("core:setJobPlayer")
AddEventHandler("core:setJobPlayer", function(job, grade)
    p:updateJob(job, grade)
end)

RegisterNetEvent("core:setStatusPlayer")
AddEventHandler("core:setStatusPlayer", function(hunger, thirst, health)
    p:updateStatus(hunger, thirst, health)
end)

RegisterNetEvent("core:addClothPlayer")
AddEventHandler("core:addClothPlayer", function(name, data)
    table.insert(p:getCloths().cloths, {name = name, data = data})
end)

RegisterNetEvent("core:removeClothPlayer")
AddEventHandler("core:removeClothPlayer", function(key)
    table.remove(p:getCloths().cloths, key)
end)

RegisterNetEvent("core:renameClothPlayer")
AddEventHandler("core:renameClothPlayer", function(key, name)
    p:getCloths().cloths[key].name = name
end)

RegisterNetEvent("core:setGroupPlayer")
AddEventHandler("core:setGroupPlayer", function(crew)
    p:setGroup(crew)
end)

RegisterNetEvent("core:setSkinPlayer")
AddEventHandler("core:setSkinPlayer", function(skin)
    p:setSkin(skin)
end)

RegisterNetEvent("core:setIdentityPlayer")
AddEventHandler("core:setIdentityPlayer", function(nom, prenom, age, sexe, taille, birthplaces)
    p:updateIdentity(nom, prenom, age, sexe, taille, birthplaces)
end)

RegisterNetEvent("core:addItemPlayer")
AddEventHandler("core:addItemPlayer", function(item)
    local inv = p:getInventaire()
    table.insert(inv, item)
    p:setInventaire(inv)
end)

RegisterNetEvent("core:addExistItemPlayer")
AddEventHandler("core:addExistItemPlayer", function(item, quantity)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name then
            v.count = v.count + quantity
            break
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:renameItemPlayer")
AddEventHandler("core:renameItemPlayer", function(item, name, metadatas)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if CompareMetadatas(v.metadatas, metadatas) then
                v.metadatas["renamed"] = name
            end
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:renameClothPlayer")
AddEventHandler("core:renameClothPlayer", function(item, name, metadatas)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name and v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            if v.metadatas == nil then v.metadatas = {} end
            v.metadatas["renamed"] = name
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:RemoveItemFromInventoryNil")
AddEventHandler("core:RemoveItemFromInventoryNil", function(name, quantity, metadatas)
    local inv = p:getInventaire()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].metadatas == nil then
                    if inv[i].name == "money" and inv[i].metadatas == nil then
                        if inv[i].count - quantity <= 0 then table.remove(inv, i)
                        else inv[i].count = inv[i].count - quantity end
                        p:setInventaire(inv)
                        break
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("core:RemoveMetadatasInventory")
AddEventHandler("core:RemoveMetadatasInventory", function(name, quantity, metadatas)
    local inv = p:getInventaire()
    if inv ~= nil then

        for i = 1, #inv do
            if inv[i] ~= nil then

                if inv[i].name ~= nil and inv[i].metadatas ~= nil and CompareMetadatas(inv[i].metadatas, metadatas) and inv[i].name == name then

                    if inv[i].count - quantity <= 0 then table.remove(inv, i)
                    else inv[i].count = inv[i].count - quantity end

                    p:setInventaire(inv)
                    break
                end
            end
        end
    end
end)