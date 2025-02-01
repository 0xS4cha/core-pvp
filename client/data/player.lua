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




AddEventHandler("playerSpawned", function()
    while p == nil do Wait(1000) end
    DisableIdleCamera(true)
    FreezeEntityPosition(p:ped(), true)
    DisablePlayerVehicleRewards(p:ped())
    ShutdownLoadingScreenNui()
    SetEntityInvincible(p:ped(), true)
    RequestAllIpls()
    if json.encode(p:getCloths().skin) == "[]" then
        LoadNewCharCreator()
    elseif json.encode(p:getCloths().skin) ~= "" then
        LoadPlayerData(false)
        TriggerEvent("skinchanger:loadSkin", p:getCloths().skin)
        -- TriggerEvent('rcore_tattoos:applyOwnedTattoos')
        FreezeEntityPosition(p:ped(), false)
    end
    SetPedInfiniteAmmo(PlayerPedId(), true)
    TriggerScreenblurFadeOut(10)
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
    table.insert(p:getCloths().cloths, { name = name, data = data })
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
AddEventHandler("core:setGroupPlayer", function(crew, id)
    p:setGroup(crew)
    p:setGroupID(id)
end)

RegisterNetEvent("core:setSkinPlayer")
AddEventHandler("core:setSkinPlayer", function(skin)
    p:setSkin(skin)
end)



RegisterNetEvent("core:addItemPlayer")
AddEventHandler("core:addItemPlayer", function(item)
    local inv = p:getInventaire()
    table.insert(inv, item)
    p:setInventaire(inv)
    RefreshInventory()
end)


RegisterNetEvent("core:RemoveItemFromInventoryNil")
AddEventHandler("core:RemoveItemFromInventoryNil", function(name, quantity, metadatas)
    local inv = p:getInventaire()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].metadatas == nil then
                    if inv[i].name == "money" and inv[i].metadatas == nil then
                        if inv[i].count - quantity <= 0 then
                            table.remove(inv, i)
                        else
                            inv[i].count = inv[i].count - quantity
                        end
                        p:setInventaire(inv)
                        break
                    end
                end
            end
        end
    end
end)
RegisterNetEvent("core:RemoveItemInventory")
AddEventHandler("core:RemoveItemInventory", function(name, quantity, slot)
    local inv = p:getInventaire()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].name == name then
                    if slot then
                        if inv[i].slot == slot then
                            if inv[i].count - quantity <= 0 then
                                table.remove(inv, i)
                            else
                                inv[i].count = inv[i].count - quantity
                            end
                            p:setInventaire(inv)
                            break
                        end
                    else
                        if inv[i].count - quantity <= 0 then
                            table.remove(inv, i)
                        else
                            inv[i].count = inv[i].count - quantity
                        end
                        p:setInventaire(inv)
                        break
                    end
                end
            end
        end
        RefreshInventory()
    end
end)
RegisterNetEvent("core:RemoveItemStorage", function(name, quantity, slot)
    local inv = p:getStorage()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].name == name and inv[i].slot == slot then
                    if inv[i].count - quantity <= 0 then
                        table.remove(inv, i)
                    else
                        inv[i].count = inv[i].count - quantity
                    end
                    p:setStorage(inv)
                    break
                end
            end
        end
        RefreshInventory2(p:getStorage(), GetPhrase('your_storage'))
    end
end)
