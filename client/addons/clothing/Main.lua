local CreateThread <const> = CreateThread
local DisableAllControlActions <const> = DisableAllControlActions
local EnableControlAction <const> = EnableControlAction
local DrawScaleformMovieFullscreen <const> = DrawScaleformMovieFullscreen
local instruction = nil
local ControlDisable = { 24, 27, 178, 177, 189, 190, 187, 188, 202, 239, 240, 201, 172, 173, 174, 175 }
local inMenu = nil
local cameraSettings = {
    zoom = 2.0
}
local ClothSelected = {}
local pedPosition = {
    [1] = { coords = { x = 3.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
    [2] = { coords = { x = 2.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
    [3] = { coords = { x = 1.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
    [4] = { coords = { x = -1.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
    [5] = { coords = { x = -2.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
    [6] = { coords = { x = -3.0, y = 0.0, z = -0.9 }, ped = nil, variation = 0 },
}
local IdClothes = {
    ['torso'] = 11,
    ['mask'] = 1,
    ['bags'] = 5,
    ['tshirt'] = 8,
    ['pants'] = 4,
    ['shoes'] = 6,
    ['arms'] = 3,
}

function SetPedScale(clonedPed, scaleFactor)
    if DoesEntityExist(clonedPed) then
        local forward, right, up, position = GetEntityMatrix(clonedPed)

        forward = forward * scaleFactor
        right = right * scaleFactor
        up = up * scaleFactor

        SetEntityMatrix(clonedPed, forward, right, up, position)
    end
end

function VariationPedSpawn(id, type, variation, idclothes)
    if pedPosition[id].ped then
        DeleteEntity(pedPosition[id].ped)
        pedPosition[id].ped = nil
    end

    pedPosition[id].ped = createPed(0.0, 0.0, 0.0)

    local PedClonedVariation = pedPosition[id].ped
    SetEntityCollision(PedClonedVariation, false, true)
    SetEntityInvincible(PedClonedVariation, true)
    NetworkSetEntityInvisibleToNetwork(PedClonedVariation, true)
    ClonePedToTarget(PlayerPedId(), PedClonedVariation)
    SetEntityCanBeDamaged(PedClonedVariation, false)
    SetBlockingOfNonTemporaryEvents(PedClonedVariation, true)
    SetEntityHeading(PedClonedVariation, GetEntityHeading(PlayerPedId()))

    SetEntityCoords(
        PedClonedVariation,
        GetOffsetFromEntityInWorldCoords(PlayerPedId(), pedPosition[id].coords.x, pedPosition[id].coords.y - 0.9,
            pedPosition[id].coords.z),
        false,
        false,
        false,
        true
    )
    local originalScale = 1.0
    local newScale = originalScale / 5

    SetPedComponentVariation(PedClonedVariation, IdClothes[type], idclothes, variation, 2)



    Citizen.CreateThread(function()
        while true do
            if DoesEntityExist(PedClonedVariation) then
                SetPedScale(PedClonedVariation, newScale)
                SetEntityCoords(PedClonedVariation,
                    GetOffsetFromEntityInWorldCoords(PlayerPedId(), pedPosition[id].coords.x,
                        pedPosition[id].coords.y - 0.9, pedPosition[id].coords.z), false, false, false, true)
                crossArms(PedClonedVariation)
            else
                break
            end
            Wait(0)
        end
    end)
end

function isPlayerPed()
    if GetEntityModel(PlayerPedId()) ~= -1667301416 and GetEntityModel(PlayerPedId()) ~= 1885233650 then
        return true
    else
        return false
    end
end

RegisterNUICallback('clothingStoreClosed', function(res, cb)
    inMenu = nil
    _NUI.SendNUIMessage('Clothing:SendData', {
        gender = 'male',
        show = false,
        clothesData = {
            ['torso'] = {
                label = GetPhrase('STORE_Clothing_Torso'),
                max = 500,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['pants'] = {
                label = GetPhrase('STORE_Clothing_Pants'),
                max = 192,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['shoes'] = {
                label = GetPhrase('STORE_Clothing_Shoes'),
                max = 144,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },

            ['tshirt'] = {
                label = GetPhrase('STORE_Clothing_Tshirt'),
                max = 192,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['bags'] = {
                label = GetPhrase('STORE_Clothing_Bag'),
                max = 110,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['arms'] = {
                label = GetPhrase('STORE_Clothing_Arms'),
                max = 213,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
        },
        translation = {
            title = GetPhrase('STORE_Clothing'),
            desc = GetPhrase('STORE_Clothing_desc'),
            quit = GetPhrase('STORE_Clothing_Quit'),
            price = GetPhrase('STORE_Clothing_Price'),
            totalPrice = GetPhrase('STORE_Clothing_TotalPrice'),
            bank = GetPhrase('STORE_Clothing_Bank'),
            cash = GetPhrase('STORE_Clothing_Cash'),
            store = GetPhrase('STORE_Clothing'),
            basket = GetPhrase('STORE_Clothing_Basket'),
        }
    })
    for i = 1, 6 do
        if pedPosition[i].ped then
            DeleteEntity(pedPosition[i].ped)
            pedPosition[i].ped = nil
        end
    end
    SetNuiFocus(false, false)
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
        IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
        IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
        ClearPedTasks(PlayerPedId())
    end
    Cam.delete("clothingstore")
    cb('ok')
end)

RegisterNUICallback('clothingStoreSaved', function(res, cb)
    inMenu = nil
    _NUI.SendNUIMessage('Clothing:SendData', {
        gender = 'male',
        show = false,
        clothesData = {
            ['torso'] = {
                label = GetPhrase('STORE_Clothing_Torso'),
                max = 500,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['pants'] = {
                label = GetPhrase('STORE_Clothing_Pants'),
                max = 192,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['shoes'] = {
                label = GetPhrase('STORE_Clothing_Shoes'),
                max = 144,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },

            ['tshirt'] = {
                label = GetPhrase('STORE_Clothing_Tshirt'),
                max = 192,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['bags'] = {
                label = GetPhrase('STORE_Clothing_Bag'),
                max = 110,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
            ['arms'] = {
                label = GetPhrase('STORE_Clothing_Arms'),
                max = 213,
                defaultprice = 0,
                customprice = {},
                blacklist = {},
            },
        },
        translation = {
            title = GetPhrase('STORE_Clothing'),
            desc = GetPhrase('STORE_Clothing_desc'),
            quit = GetPhrase('STORE_Clothing_Quit'),
            price = GetPhrase('STORE_Clothing_Price'),
            totalPrice = GetPhrase('STORE_Clothing_TotalPrice'),
            bank = GetPhrase('STORE_Clothing_Bank'),
            cash = GetPhrase('STORE_Clothing_Cash'),
            store = GetPhrase('STORE_Clothing'),
            basket = GetPhrase('STORE_Clothing_Basket'),
        }
    })
    for i = 1, 6 do
        if pedPosition[i].ped then
            DeleteEntity(pedPosition[i].ped)
            pedPosition[i].ped = nil
        end
    end

    SetNuiFocus(false, false)
    local newSkin = GetFakeSkin()
    p:setSkin(newSkin)
    p:saveSkin()
    if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
        IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
        IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
        ClearPedTasks(PlayerPedId())
    end
    Cam.delete("clothingstore")
    cb('ok')
end)
RegisterNUICallback('removeClothing', function(data, cb)
    local oldSkin = p:skin()
    if type ~= 'arms' then
        local id = oldSkin[data.type .. '_1']
        SkinChangeFake(data.type .. '_1', id)
    else
        local id = oldSkin[data.type]
        SkinChangeFake(data.type, id)
    end
end)


RegisterNUICallback('clothingStoreZoom', function(data, cb)
    if data == 1 then
        if cameraSettings.zoom + 0.1 <= 3.0 then
            cameraSettings.zoom += 0.1
            Cam.setPos("clothingstore", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, cameraSettings.zoom, 0.0))
        end
    elseif data == 2 then
        if cameraSettings.zoom - 0.1 >= 0.5 then
            cameraSettings.zoom -= 0.1
            Cam.setPos("clothingstore", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, cameraSettings.zoom, 0.0))
        end
    end
    cb('ok')
end)
RegisterNUICallback('clothingStoreChangeVariation', function(data, cb)
    if data == 1 then
        if ClothSelected.variation - 1 < 0 then
            SkinChangeFake(ClothSelected.type .. '_2', ClothSelected.maxvariation)
            ClothSelected.variation = ClothSelected.maxvariation
        else
            SkinChangeFake(ClothSelected.type .. '_2', ClothSelected.variation - 1)
            ClothSelected.variation -= 1
        end
    elseif data == 2 then
        if ClothSelected.variation + 1 > ClothSelected.maxvariation then
            SkinChangeFake(ClothSelected.type .. '_2', 0)
        else
            SkinChangeFake(ClothSelected.type .. '_2', ClothSelected.variation + 1)
            ClothSelected.variation = 1
        end
    end
    if cb then
        cb("ok")
    end
end)


RegisterNUICallback('showcaseClothing', function(data, cb)
    local allVariations = GetNumberOfPedTextureVariations(p:ped(), IdClothes[data.type], data.id)
    ClothSelected = { type = data.type, id = data.id, variation = 0, maxvariation = allVariations }
    CreateThread(function()
        PlayEmote("clothingtrousers", "try_trousers_neutral_d", 49, -1)
        Wait(2000)
        ClearPedTasks(p:ped())
    end)

    if data.type ~= 'arms' then
        SkinChangeFake(data.type .. '_1', data.id)
    else
        SkinChangeFake('arms', data.id)
    end
    SkinChangeFake(data.type .. '_2', 0)
    cb('ok')
end)

function startClothingStore()
    if not inMenu then
        if not isPlayerPed() then
            local Skin = p:skin()
            ApplySkinFake(Skin)
        end
        instruction = Utils.Instructions({
            [1] = { key = 198, message = "Zoom" },
            [2] = { key = 18, message = "Camera" },
            [3] = { key = 308, message = "Previous variation" },
            [4] = { key = 307, message = "Next variation" }
        })
        SetNuiFocus(true, true)
        _NUI.SendNUIMessage('Clothing:SendData', {
            gender = 'male',
            show = true,
            clothesData = {
                ['torso'] = {
                    label = GetPhrase('STORE_Clothing_Torso'),
                    max = 500,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },
                ['pants'] = {
                    label = GetPhrase('STORE_Clothing_Pants'),
                    max = 192,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },
                ['shoes'] = {
                    label = GetPhrase('STORE_Clothing_Shoes'),
                    max = 144,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },

                ['tshirt'] = {
                    label = GetPhrase('STORE_Clothing_Tshirt'),
                    max = 192,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },
                ['bags'] = {
                    label = GetPhrase('STORE_Clothing_Bag'),
                    max = 110,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },
                ['arms'] = {
                    label = GetPhrase('STORE_Clothing_Arms'),
                    max = 213,
                    defaultprice = 0,
                    customprice = {},
                    blacklist = {},
                },
            },
            translation = {
                title = GetPhrase('STORE_Clothing'),
                desc = GetPhrase('STORE_Clothing_desc'),
                quit = GetPhrase('STORE_Clothing_Quit'),
                price = GetPhrase('STORE_Clothing_Price'),
                totalPrice = GetPhrase('STORE_Clothing_TotalPrice'),
                bank = GetPhrase('STORE_Clothing_Bank'),
                cash = GetPhrase('STORE_Clothing_Cash'),
                store = GetPhrase('STORE_Clothing'),
                basket = GetPhrase('STORE_Clothing_Basket'),
            }
        })
        Cam.create("clothingstore")
        Cam.setPos("clothingstore", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 2.0, 0.0))
        Cam.setFov("clothingstore", 70.0)
        Cam.lookAtEntity("clothingstore", p:ped())
        Cam.render("clothingstore", true, false, 0)
        inMenu = true

        while inMenu do
            DisableAllControlActions(0)
            DrawScaleformMovieFullscreen(instruction, 255, 255, 255, 255, 0)
            Wait(0)
        end
    end
end
