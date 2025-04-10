local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
local Weather = { "EXTRASUNNY", "CLEAR", "NEUTRAL", "SMOG", "FOGGY", "Overcast", "CLOUDS", "CLEARING", "RAIN", "THUNDER",
    "SNOW", "BLIZZARD", "SNOWLIGHT", "XMAS", "HALLOWEEN" }
local Time = { 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 }
local superJump = false
local fastrun = false
local fastswim = false
local lastVehicleId = 0
local temp = {
    weather = "EXTRASUNNY"
}
local NotifDoords = nil
Citizen.CreateThread(function()
    while true do
        SetWeatherTypeOverTime(temp.weather, 15.0)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(temp.weather)
        SetWeatherTypeNow(temp.weather)
        SetWeatherTypeNowPersist(temp.weather)
        Wait(100)
    end
end)

local ModsInBennys = { 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 44, 45, 48, 49, 50 }
local ModsInFirstPerson = { 27, 28, 29, 30, 33, 32, 34 }
local ModsCapotOpen = { 39, 40, 45 }
local ModsCoffreOpen = { 37 }

local ModsList = {
    { id = 0,  name = "Aileron",               prix = 400 },
    { id = 1,  name = "Pare-choc avant",       prix = 300 },
    { id = 2,  name = "Pare-choc arrière",     prix = 300 },
    { id = 3,  name = "Carroserie",            prix = 250 },
    { id = 4,  name = "Echappement",           prix = 400 },
    { id = 5,  name = "Cadre",                 prix = 400 },
    { id = 6,  name = "Calandre",              prix = 300 },
    { id = 7,  name = "Capot",                 prix = 400 },
    { id = 8,  name = "Autocollant gauche",    prix = 250 },
    { id = 9,  name = "Autocollant droit",     prix = 250 },
    { id = 10, name = "Toit",                  prix = 250 },
    { id = 25, name = "Support de plaque",     prix = 250 },
    { id = 26, name = "Plaque avant",          prix = 250 },
    { id = 27, name = "Style intérieur",       prix = 250 },
    { id = 28, name = "Figurine",              prix = 250 },
    { id = 29, name = "Tableau de bord motif", prix = 250 },
    { id = 30, name = "Cadran",                prix = 250 },
    { id = 31, name = "Haut parleur portes",   prix = 250 },
    { id = 32, name = "Motif sieges",          prix = 250 },
    { id = 33, name = "Volant",                prix = 250 },
    { id = 34, name = "Levier",                prix = 250 },
    { id = 35, name = "Logo custom",           prix = 250 },
    { id = 36, name = "Vitre",                 prix = 250 },
    { id = 37, name = "Haut parleur coffre",   prix = 250 },
    { id = 38, name = "Hydrolique",            prix = 250 },
    { id = 39, name = "Moteur",                prix = 250 },
    { id = 40, name = "Filtres à air",         prix = 250 },
    { id = 41, name = "Entretoises",           prix = 250 },
    { id = 42, name = "Couverture",            prix = 250 },
    { id = 43, name = "Antenne",               prix = 250 },
    --{ id = 44, name = "motif exterieur", prix = 250 },
    { id = 45, name = "Reservoir",             prix = 250 },
    { id = 46, name = "Fenêtre",               prix = 250 },
    { id = 48, name = "Style",                 prix = 250 },
}

local function GetModObjects(veh, mod)
    local tbl = { "default" }
    for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
        local toBeInserted = "0"
        local labelName = GetModTextLabel(veh, mod, i)
        if labelName ~= nil then
            local name = tostring(GetLabelText(labelName))
            if name ~= "NULL" then
                toBeInserted = name
            end
        end
        tbl[#tbl + 1] = toBeInserted
    end

    return tbl
end

local function toggleFastrun(enabled)
    fastrun = enabled
    if enabled then
        CreateThread(function()
            local Wait = Wait
            local pid = PlayerId()
            local ped = PlayerPedId()
            local frameCounter = 0
            while fastrun do
                frameCounter = frameCounter + 1
                if frameCounter > 200 then
                    RestorePlayerStamina(pid, 100.0)
                    ped = PlayerPedId()
                    frameCounter = 0
                end
                SetPedMoveRateOverride(ped, 1.75)
                Wait(0)
            end
        end)
    end
end

local function toggleFastswim(enabled)
    fastswim = enabled
    if enabled then
        CreateThread(function()
            local Wait = Wait
            local pid = PlayerId()
            while fastswim do
                SetSwimMultiplierForPlayer(pid, 1.30)
                Wait(0)
            end
        end)
    end
end

local function toggleSuperJump(enabled)
    superJump = enabled
    if enabled then
        CreateThread(function()
            local Wait = Wait
            local pid = PlayerId()
            while superJump do
                SetSuperJumpThisFrame(pid)
                Wait(0)
            end
        end)
    end
end

local function loadPed(ped, skin)
    local peds = GetHashKey(ped)
    local player = PlayerId()

    RequestModel(peds)

    Citizen.CreateThread(function()
        local attempts = 0
        while not HasModelLoaded(peds) and attempts < 100 do
            Citizen.Wait(100)
            RequestModel(peds)
            attempts = attempts + 1
        end

        if HasModelLoaded(peds) then
            SetPlayerModel(player, peds)
            Citizen.Wait(100)                              -- Laisser le modèle s'appliquer correctement
            SetPedDefaultComponentVariation(PlayerPedId()) -- Appliquer les composants de base
            SetModelAsNoLongerNeeded(peds)
            if skin then
                ApplySkin(skin)
            end
        end
    end)
end

local function menu_onButtonSelected(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    local pPed = p:ped()
    local player = PlayerId()
    local pVeh = GetVehiclePedIsIn(pPed, false)
    local Data = PMenu.Data
    if Data then
        if tblButton.idMod then
            local tempData = PMenu.Data.temp
            SetVehicleDoorShut(tempData, 5, true)
            SetVehicleDoorShut(tempData, 4, true)
            if GetFollowVehicleCamViewMode() == 4 then SetFollowVehicleCamViewMode(0) end
            local shouldOpenTrunk = Utils.TableGetValue(ModsCoffreOpen, tblButton.idMod)
            local shouldOpenCapot = Utils.TableGetValue(ModsCapotOpen, tblButton.idMod)
            local shouldToggleFirst = Utils.TableGetValue(ModsInFirstPerson, tblButton.idMod)

            if shouldOpenTrunk or shouldOpenCapot then
                SetVehicleDoorOpen(tempData, shouldOpenTrunk and 5 or 4, false, true)
            end

            if shouldToggleFirst then
                SetFollowVehicleCamViewMode(4)
            end
        end
    end
end

local function menuOnSelected(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    local currentMenu = tblData.currentMenu
    local tempData = tblData.temp
    local pPed = p:ped()
    local player = PlayerId()
    local pVeh = GetVehiclePedIsIn(pPed, false)
    if currentMenu == 'player_list' then
        tblData.temp = { id = tblButton.source, name = tblButton.name, uuid = tblButton.uuid }
        PMenu:OpenMenu('player_view')
    elseif currentMenu == 'player_view' then
        if tblButton.name == 'send_message' then
            AskEntry(function(text)
                if text and string.len(text) ~= 0 then
                    TriggerServerEvent('core:send_message', Token, text, tempData.id)
                end
            end, "Message")
        elseif tblButton.name == 'teleport_to_player' then
            TriggerServerEvent('core:teleport_to_player', Token, tempData.id)
        end
    elseif currentMenu == 'my_player' then
        if tblButton.name == 'rockstar_editor' then
            if tblButton.slidenum == 1 then
                StartRecording(1)
            elseif tblButton.slidenum == 2 then
                StopRecordingAndSaveClip()
            elseif tblButton.slidenum == 3 then
                StopRecordingAndDiscardClip()
            end
        elseif tblButton.name == 'fastrun' then
            toggleFastrun(not fastrun)
        elseif tblButton.name == 'fastswim' then
            toggleFastswim(not fastswim)
        elseif tblButton.name == 'superjump' then
            toggleSuperJump(not superJump)
        end
    elseif currentMenu == 'world' then
        if tblButton.name == "weather" then
            local weather = tblButton.slidename

            temp.weather = weather
        elseif tblButton.name == "time" then
            local time = tblButton.slidename
            NetworkOverrideClockTime(tonumber(time), 00, 00)
        end
    elseif currentMenu == 'peds_list' then
        loadPed(tblButton.name)
    elseif currentMenu == 'skin_submenu' then
        if tblButton.name == 'save_ped' then
            local skin = GetFullSkin()
            AskEntry(function(text)
                if text and string.len(text) ~= 0 then
                    TriggerServerEvent('core:save_skin', Token, skin, text)
                end
            end, "Message")
        end
    elseif currentMenu == 'peds_save' then
        if tblButton.slidenum == 1 then
            local skin = tblButton.skin
            loadPed(skin.sex, skin)
        elseif tblButton.slidenum == 2 then
            TriggerServerEvent('core:delete_skin', Token, tblButton.id)
            Wait(500)
            RefreshMenuButtons()
        end
    elseif currentMenu == 'vehicle_saved' then
        if tblButton.slidenum == 1 then
            local hash = GetHashKey(tblButton.vehName)
            if DoesEntityExist(lastVehicleId) then
                DeleteVehicle(lastVehicleId)
                lastVehicleId = 0
            end
            local veh = Utils.SpawnVehicle(hash, GetEntityCoords(pPed), GetEntityHeading(pPed))
            lastVehicleId = veh
            Utils.SetVehicleProperties(veh, tblButton.props)
            SetPedIntoVehicle(pPed, veh, -1)
        elseif tblButton.slidenum == 2 then
            TriggerServerEvent('core:delete_vehicle', Token, tblButton.id)
            Wait(500)
            RefreshMenuButtons()
        end
    elseif currentMenu == 'vehicle_list_categories' then
        tblData.temp = tblButton.id
        PMenu:OpenMenu('vehicle_list')
    elseif currentMenu == 'vehicle_list' then
        local vehicle = tblButton.ask
        local hash = GetHashKey(vehicle)
        if DoesEntityExist(lastVehicleId) then
            DeleteVehicle(lastVehicleId)
            lastVehicleId = 0
        end
        local veh = Utils.SpawnVehicle(hash, GetEntityCoords(pPed), GetEntityHeading(pPed))
        lastVehicleId = veh
        SetPedIntoVehicle(pPed, veh, -1)
    elseif currentMenu == 'vehicle_custom_classic' then
        if tblButton.name == 'vehicle_custom_xenon' then
            local enable = tblButton.checkbox
            ToggleVehicleMod(tempData, 22, enable)
        end
    elseif currentMenu == 'vehicle_custom_wheel' then
        if tblButton.name == 'vehicle_custom_wheels_custom' then
            local enable = tblButton.checkbox
            SetVehicleMod(tempData, 23, GetVehicleMod(tempData, 23), enable)
        end
    elseif currentMenu == 'vehicles' then
        if tblButton.name == 'save_vehicle' then
            if pVeh then
                AskEntry(function(text)
                    if text and string.len(text) ~= 0 then
                        local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(pVeh))
                        local vehProperties = Utils.GetVehicleProperties(pVeh)
                        if _VEHICLE.TRUNC[vehName] then
                            vehName = _VEHICLE.TRUNC[vehName]
                        end
                        TriggerServerEvent('core:save_vehicle', Token, text, vehName, vehProperties)
                    end
                end, "name")
            end
        elseif tblButton.name == 'vehicle_spawn' then
            AskEntry(function(modelName)
                if not IsModelInCdimage(modelName) then
                    Utils.ShowNotification("~r~This model does not exist.")
                    return
                end
                local vehData = GetHashKey(modelName)

                if DoesEntityExist(lastVehicleId) then
                    DeleteVehicle(lastVehicleId)
                    lastVehicleId = 0
                end
                local veh = Utils.SpawnVehicle(vehData, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                lastVehicleId = veh
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
                SetVehicleWindowTint(veh, 3)
            end, "Vehicle model")
        end
    elseif currentMenu == 'scenes' then
        onSelectedScenesButtons(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    elseif currentMenu == 'my_vehicle' then
        if tblButton.name == 'vehicle_doords' then
            if GetVehicleDoorAngleRatio(pVeh, tblButton.slidenum - 1) > 0.0 then
                Utils.ShowNotificationWithRemove("Porte ~b~" .. tblButton.slidename .. "~s~ fermées.")
                SetVehicleDoorShut(pVeh, tblButton.slidenum - 1, false)
            else
                Utils.ShowNotificationWithRemove("Porte ~b~" .. tblButton.slidename .. "~s~ ouvertes.")
                SetVehicleDoorOpen(pVeh, tblButton.slidenum - 1, false)
            end
        elseif tblButton.name == 'admin_vehicle_delete' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true)
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_deformationrepair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleDeformationFixed(pVeh)
                DeleteVehicle(pVeh)
                RemoveLoadingPrompt()
            end
        elseif tblButton.name == 'admin_vehicle_deformationrepair' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true)
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_deformationrepair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleDeformationFixed(pVeh)
                RemoveLoadingPrompt()
            end
        elseif tblButton.name == 'admin_vehicle_wash' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true)
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_wash', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                WashDecalsFromVehicle(pVeh, 1.0)
                SetVehicleDirtLevel(pVeh, 0.0)
                RemoveLoadingPrompt()
            end
        elseif tblButton.name == 'admin_vehicle_fullrepair' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true)
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_fullrepair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleFixed(pVeh)
                RemoveLoadingPrompt()
            end
        elseif tblButton.name == 'admin_vehicle_repair' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true)
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_repair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleEngineHealth(pVeh, 1000.0)
                RemoveLoadingPrompt()
            end
        end
    elseif currentMenu == 'weapons' then
        local hash = GetHashKey(tblButton.ask)
        local hasWeapon = HasPedGotWeapon(p:ped(), hash, false)
        if hasWeapon  then
            RemoveWeaponFromPed(p:ped(), hash)
            Utils.ShowNotificationWithRemove(('Vous avez ~r~<C>retiré</C>~s~ une arme dans votre inventaire.\n~b~<C>%s</C>~s~'):format(tblButton.name))
        else
            GiveWeaponToPed(p:ped(), hash, 100, false, true)
            Utils.ShowNotificationWithRemove(('Vous avez ~b~<C>ajouté</C>~s~ une arme dans votre inventaire.\n~b~<C>%s</C>~s~'):format(tblButton.name))
        end
    end
end


local function menu_onSlide(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    local currentMenu = tblData.currentMenu
    local tempData = tblData.temp
    local pPed = p:ped()
    local player = PlayerId()
    if currentMenu == 'edit_components' then
        local component = tblButton.component
        local drawable = tblButton.slidenum
        SetPedComponentVariation(pPed, component, drawable, 0, 2)
        tblButton.advSlider = { 0, (GetNumberOfPedTextureVariations(pPed, component, drawable) - 1), 0 }
    elseif currentMenu == 'edit_props' then
        local component = tblButton.component
        local drawable = tblButton.slidenum
        SetPedPropIndex(pPed, component, drawable, 0)
        tblButton.advSlider = { 0, (GetNumberOfPedPropTextureVariations(pPed, component, drawable) - 1), 0 }
    elseif currentMenu == 'vehicle_custom_color' then
        if tblButton.name == 'vehicle_paint_camaeleon' then
            local paint = tblButton.slidenum + 177
            SetVehicleModKit(tempData, 0)
            SetVehicleColours(tempData, paint, paint)
        elseif tblButton.name == 'vehicle_custom_primary' then
            local _, s = GetVehicleColours(tempData)
            local color = (tblButton.slidenum or 1) - 1
            ClearVehicleCustomPrimaryColour(tempData)
            SetVehicleColours(tempData, color, s)
        elseif tblButton.name == 'vehicle_custom_secondary' then
            local p = GetVehicleColours(tempData)
            local color = (tblButton.slidenum or 1) - 1
            ClearVehicleCustomSecondaryColour(tempData)
            SetVehicleColours(tempData, p, color)
        elseif tblButton.name == 'vehicle_custom_interiors' then
            SetVehicleInteriorColour(tempData, tblButton.slidenum and tblButton.slidenum - 1 or 0)
        elseif tblButton.name == 'vehicle_custom_pearlescent' then
            local _, w = GetVehicleExtraColours(tempData)
            SetVehicleExtraColours(tempData, tblButton.slidenum and tblButton.slidenum - 1 or 0, w)
        elseif tblButton.name == 'vehicle_custom_board' then
            SetVehicleDashboardColour(tempData, tblButton.slidenum and tblButton.slidenum - 1 or 0)
        end
    elseif currentMenu == 'vehicle_custom_wheel' then
        if tblButton.name == 'vehicle_custom_wheels_type' then
            SetVehicleWheelType(tempData, tblButton.slidenum - 1)
        elseif tblButton.name == 'vehicle_custom_wheels_rim_primary' then
            SetVehicleMod(tempData, 23, tblButton.slidenum - 2, GetVehicleModVariation(tempData, 23))
        elseif tblButton.name == 'vehicle_custom_wheels_rim_secondary' then
            SetVehicleMod(tempData, 24, tblButton.slidenum - 1, GetVehicleModVariation(tempData, 24))
        elseif tblButton.name == 'vehicle_custom_rim_color' then
            local color = GetVehicleExtraColours(tempData)
            SetVehicleExtraColours(tempData, color, tblButton.slidenum and tblButton.slidenum - 1 or 0)
        end
    elseif currentMenu == 'vehicle_custom_classic' then
        if tblButton.name == 'vehicle_custom_klaxon' then
            SetVehicleMod(tempData, 14, tblButton.slidenum, false)
        elseif tblButton.name == 'vehicle_custom_teint_windows' then
            SetVehicleWindowTint(tempData, tblButton.slidenum and tblButton.slidenum - 1 or 0)
        elseif tblButton.name == 'vehicle_custom_light' then
            SetVehicleXenonLightsColor(tempData, tblButton.slidenum and tblButton.slidenum - 1)
        elseif tblButton.name == 'vehicle_custom_plate' then
            SetVehicleNumberPlateTextIndex(tempData, tblButton.slidenum and tblButton.slidenum - 1 or 0)
        elseif tblButton.name == 'vehicle_custom_livery' then
            SetVehicleLivery(tempData, tblButton.slidenum and tblButton.slidenum - 1)
        end
    elseif currentMenu == 'vehicle_custom_customs' then
        SetVehicleMod(tempData, tblButton.idMod, tblButton.slidenum and tblButton.slidenum - 2 or -1)
    elseif currentMenu == 'vehicle_custom_bennys' then
        SetVehicleMod(tempData, tblButton.idMod, tblButton.slidenum and tblButton.slidenum - 2 or -1)
    elseif currentMenu == 'vehicle_custom_performance' then
        SetVehicleMod(tempData, tblButton.idMod, tblButton.slidenum and tblButton.slidenum - 2 or -1)
    end
end


local function menu_onAdvSlide(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    local currentMenu = tblData.currentMenu
    local ped = p:ped()
    if currentMenu == 'edit_components' then
        local advslider = tblButton.advSlider[3]
        SetPedComponentVariation(ped, tblButton.component, tblButton.slidenum, advslider)
    elseif currentMenu == 'edit_props' then
        local advslider = tblButton.advSlider[3]
        SetPedPropIndex(ped, tblButton.component, tblButton.slidenum, advslider)
    end
end


local function getPlayerList()
    local data = TriggerServerCallback("core:GetAllPlayer", Token)
    local playerList = data.players
    local list = {}
    for k, v in pairs(playerList) do
        table.insert(list, { name = v.name, source = v.id, uuid = v.uuid })
    end
    return list
end

local function getPedsList()
    local list = {}
    for k, ped in pairs(PedsCharCreator) do
        table.insert(list, { name = ped })
    end
    return list
end

local function getSkinSave()
    local data = TriggerServerCallback('core:getSkinSaved', Token)
    local list = {}
    for k, v in pairs(data) do
        table.insert(list,
            { id = v.id, name = v.id .. ' - ' .. v.label, skin = json.decode(v.skin), slidemax = { 'skin_load', 'skin_delete' } })
    end
    return list
end

local function getVehicleSave()
    local data = TriggerServerCallback('core:getVehicleSaved', Token)
    local list = {}
    for k, v in pairs(data) do
        table.insert(list,
            { id = v.id, name = v.id .. ' - ' .. v.label, vehName = v.vehicle, props = json.decode(v.props), slidemax = { 'vehicle_load', 'vehicle_delete' } })
    end
    return list
end

local function getVehicleListCategories()
    local data = _VEHICLE.List
    local list = {}
    for k, v in pairs(data) do
        table.insert(list, { id = k, name = k, ask = #data[k], askX = true })
    end
    return list
end


--TODO: CHANGER LE SYSTEM DU FOR K V CAR lA LISTE N'eST PAS DANS LE BON ODRE
local function getVehicleList(PMenu)
    local data = PMenu.Data.temp
    local list = {}
    for k, v in pairs(_VEHICLE.List[data]) do
        table.insert(list, { name = GetLabelText(GetDisplayNameFromVehicleModel(v)), ask = v, askX = true })
    end
    return list
end

local function getVehicleCustomButtons(PMenu)
    local pVeh = GetVehiclePedIsIn(p:ped(), false)
    PMenu.Data.temp = pVeh
    SetVehicleModKit(pVeh, 0)
    return {
        { name = "vehicle_custom_color" },
        { name = "vehicle_custom_wheel" },
        { name = "vehicle_custom_classic" },
        { name = "vehicle_custom_customs" },
        { name = "vehicle_custom_bennys" },
        { name = "vehicle_custom_performance" },
    }
end

local function getVehiclePerformanceButtons(PMenu)
    local veh = PMenu.Data.temp
    return {
        {
            name = "Suspension",
            slidemax = { "Stock", "Discount", "Street", "Sport", "Race" },
            customSlidenum = function()
                return
                    GetVehicleMod(veh, 15) + 2
            end,
            idMod = 15
        },
        {
            name = "Transmission",
            slidemax = { "Stock", "Street", "Sport", "Race" },
            customSlidenum = function()
                return
                    GetVehicleMod(veh, 13) + 2
            end,
            idMod = 13
        },
        {
            name = "Moteur",
            slidemax = { "Stock", "Discount", "Street", "Sport", "Race" },
            customSlidenum = function()
                return
                    GetVehicleMod(veh, 11) + 2
            end,
            idMod = 11
        },
        {
            name = "Frein",
            slidemax = { "Stock", "Street", "Sport", "Race" },
            customSlidenum = function()
                return
                    GetVehicleMod(veh, 12) + 2
            end,
            idMod = 12
        },
        { name = "Turbo", checkbox = IsToggleModOn(veh, 18) ~= false, canSee = IsThisModelACar(GetEntityModel(veh)) },
    }
end

local function getVehicleCustomsButtons(PMenu)
    local veh, tbl = PMenu.Data.temp, {}
    for k, v in pairs(ModsList) do
        local inside = Utils.TableGetValue(ModsInBennys, v.id)
        if not inside then
            local num = GetNumVehicleMods(veh, v.id)
            if num and num > 0 then
                tbl[#tbl + 1] = {
                    name = v.name,
                    slidemax = GetModObjects(veh, v.id),
                    customSlidenum = GetVehicleMod(veh,
                        v.id) + 2,
                    idMod = v.id
                }
            end
        end
    end
    return tbl
end

local function getVehicleBennysButtons(PMenu)
    local veh, tbl = PMenu.Data.temp, {}
    for k, v in pairs(ModsList) do
        local inside = Utils.TableGetValue(ModsInBennys, v.id)
        if inside then
            local num = GetNumVehicleMods(veh, v.id)
            if num and num > 0 then
                tbl[#tbl + 1] = {
                    name = v.name,
                    slidemax = GetModObjects(veh, v.id),
                    customSlidenum = GetVehicleMod(veh,
                        v.id) + 2,
                    idMod = v.id
                }
            end
        end
    end
    return tbl
end

local function getVehicleClassicButtons(PMenu)
    local veh = PMenu.Data.temp
    return {
        { name = 'vehicle_custom_klaxon',        slidemax = GetNumVehicleMods(veh, 14) - 1,                                               customSlidenum = GetVehicleMod(veh, 14) + 2 },
        { name = 'vehicle_custom_teint_windows', slidemax = { 'normal', 'black', 'smoke black', 'simple smoke', 'stock', 'limo' },        customSlidenum = math.max(1, math.min(GetVehicleWindowTint(veh) + 1)) },
        { name = 'vehicle_custom_xenon',         checkbox = IsToggleModOn(veh, 22) ~= false },
        { name = 'vehicle_custom_light',         slidemax = 12 },
        { name = 'vehicle_custom_plate',         slidemax = { 'default', 'sa black', 'sa blue', 'sa white', 'simple white', 'ny white' }, customSlidenum = GetVehicleNumberPlateTextIndex(veh) + 1 },
        { name = 'vehicle_custom_livery',        slidemax = GetVehicleLiveryCount(veh) - 1,                                               canSee = (GetVehicleLiveryCount(veh) > 0) },
        { name = 'vehicle_custom_extra' }
    }
end

local function getVehicleWheelsButtons(PMenu)
    local veh = PMenu.Data.temp
    return {
        {
            name = "vehicle_custom_wheels_type",
            slidemax = { "Sport", "Muscle", "Lowrider", "SUV", "Offroad", "Tuner", "Moto", "High end", "Bespokes Originals", "Bespokes Smokes" },
            customSlidenum = GetVehicleWheelType(veh) + 1
        },
        {
            name = "vehicle_custom_wheels_rim_primary",
            idMod = 23,
            slidemax = GetNumVehicleMods(veh, 23) - 1
        },
        {
            name = "vehicle_custom_wheels_rim_secondary",
            idMod = 24,
            slidemax = GetNumVehicleMods(veh, 24) - 1,
            canSee = IsThisModelABike(GetEntityModel(veh))
        },
        { name = "vehicle_custom_rim_color",     slidemax = 160 },
        { name = "vehicle_custom_wheels_custom", checkbox = GetVehicleModVariation(veh, 23) ~= false },
    }
end

local function getVehiclePaintButtons()
    return {
        { name = "vehicle_paint_camaeleon",    slidemax = 65 },
        { name = "vehicle_custom_primary",     slidemax = 159 },
        { name = "vehicle_custom_secondary",   slidemax = 159 },
        { name = "vehicle_custom_interiors",   slidemax = 158 },
        { name = "vehicle_custom_board",       slidemax = 158 },
        { name = "vehicle_custom_pearlescent", slidemax = 158 },
    }
end

local function getPlayerView(PMenu)
    local data = PMenu.Data.temp
    return {
        { name = 'name',              ask = data.name, askX = true },
        { name = 'id',                ask = data.id,   askX = true },
        { name = 'uuid',              ask = data.uuid, askX = true },
        { name = 'send_message' },
        { name = 'teleport_to_player' }

    }
end

local function getComponentsButtons()
    local playerPed = p:ped()
    return {
        { component = 0,  name = 'head',        canSee = (GetNumberOfPedDrawableVariations(playerPed, 0) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 0),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 0, GetPedDrawableVariation(playerPed, 0)) - 1), 0 } },
        { component = 1,  name = 'mask_1',      canSee = (GetNumberOfPedDrawableVariations(playerPed, 1) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 1),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 1, GetPedDrawableVariation(playerPed, 1)) - 1), 0 } },
        { component = 2,  name = 'hair_1',      canSee = (GetNumberOfPedDrawableVariations(playerPed, 2) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 2),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 2, GetPedDrawableVariation(playerPed, 2)) - 1), 0 } },
        { component = 3,  name = 'arms',        canSee = (GetNumberOfPedDrawableVariations(playerPed, 3) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 3),  advSlider = { 0, 10, 0 } },
        { component = 11, name = 'torso_1',     canSee = (GetNumberOfPedDrawableVariations(playerPed, 11) - 1 > 0), slidemax = GetNumberOfPedDrawableVariations(playerPed, 11), advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 11, GetPedDrawableVariation(playerPed, 11)) - 1), 0 } },
        { component = 4,  name = 'pants_1',     canSee = (GetNumberOfPedDrawableVariations(playerPed, 4) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 4),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 4, GetPedDrawableVariation(playerPed, 4)) - 1), 0 } },
        { component = 6,  name = 'shoes_1',     canSee = (GetNumberOfPedDrawableVariations(playerPed, 6) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 6),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 6, GetPedDrawableVariation(playerPed, 6)) - 1), 0 } },
        { component = 8,  name = 'tshirt_1',    canSee = (GetNumberOfPedDrawableVariations(playerPed, 8) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 8),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 8, GetPedDrawableVariation(playerPed, 8)) - 1), 0 } },
        { component = 10, name = 'decals_1',    canSee = (GetNumberOfPedDrawableVariations(playerPed, 10) - 1 > 0), slidemax = GetNumberOfPedDrawableVariations(playerPed, 10), advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 10, GetPedDrawableVariation(playerPed, 10)) - 1), 0 } },
        { component = 9,  name = 'bulletproof', canSee = (GetNumberOfPedDrawableVariations(playerPed, 9) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 9),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 9, GetPedDrawableVariation(playerPed, 9)) - 1), 0 } },
        { component = 5,  name = 'bags_1',      canSee = (GetNumberOfPedDrawableVariations(playerPed, 5) - 1 > 0),  slidemax = GetNumberOfPedDrawableVariations(playerPed, 5),  advSlider = { 0, math.max(0, GetNumberOfPedTextureVariations(playerPed, 5, GetPedDrawableVariation(playerPed, 5)) - 1), 0 } },
    }
end

local function getPropsButtons()
    local playerPed = p:ped()
    return {
        { component = 0, name = 'helmet_1',    canSee = (GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1 > 0), slidemax = GetNumberOfPedPropDrawableVariations(playerPed, 0), advSlider = { 0, math.max(0, GetNumberOfPedPropTextureVariations(playerPed, 0, GetPedPropIndex(playerPed, 0)) - 1), 0 } },
        { component = 1, name = 'glasses_1',   canSee = (GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1 > 0), slidemax = GetNumberOfPedPropDrawableVariations(playerPed, 1), advSlider = { 0, math.max(0, GetNumberOfPedPropTextureVariations(playerPed, 1, GetPedPropIndex(playerPed, 1)) - 1), 0 } },
        { component = 2, name = 'ears_1',      canSee = (GetNumberOfPedPropDrawableVariations(playerPed, 2) - 1 > 0), slidemax = GetNumberOfPedPropDrawableVariations(playerPed, 2), advSlider = { 0, math.max(0, GetNumberOfPedPropTextureVariations(playerPed, 2, GetPedPropIndex(playerPed, 2)) - 1), 0 } },
        { component = 6, name = 'watch_1',     canSee = (GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1 > 0), slidemax = GetNumberOfPedPropDrawableVariations(playerPed, 6), advSlider = { 0, math.max(0, GetNumberOfPedPropTextureVariations(playerPed, 6, GetPedPropIndex(playerPed, 6)) - 1), 0 } },
        { component = 7, name = 'bracelets_1', canSee = (GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1 > 0), slidemax = GetNumberOfPedPropDrawableVariations(playerPed, 7), advSlider = { 0, math.max(0, GetNumberOfPedPropTextureVariations(playerPed, 7, GetPedPropIndex(playerPed, 7)) - 1), 0 } },
    }
end


local function getSkinButtons()
    return {
        { name = 'edit_components' },
        { name = 'edit_props' },
        { name = 'peds_list' },
        { name = 'peds_save' },
        { name = 'save_ped',       colorFree = { 53, 146, 61, 165 } }
    }
end

local function getMyPlayerButtons()
    return {
        { name = 'rockstar_editor', slidemax = { 'Démarrer', 'Arrêter', 'Abandonner' } },
        { name = 'godmode',         cantUse = not _SETTINGS['pvp'],                    lockMessage = 'invisible_already_in_pvp' },
        { name = 'fastrun',         checkbox = fastrun },
        { name = 'fastswim',        checkbox = fastswim },
        { name = 'superjump',       checkbox = superJump },
        { name = 'skin_submenu' },
        { name = 'Heal' },
        { name = 'Armor' },
        { name = 'clean' },
        { name = 'suicide',         colorFree = { 200, 0, 0, 165 },                    cantUse = not _SETTINGS['pvp'] }
    }
end

local function getButtons(PMenu)
    return {
        { name = 'player_list' },
        { name = 'my_player' },
        {
            name = 'weapons',
            canSee = function()
                if _SETTINGS.pvp then
                    return true
                end
            end
        },
        {
            name = 'scenes',
            canSee = function()
                if not _SETTINGS.pvp then
                    return true
                end
            end
        },
        { name = 'vehicles' },
        {
            name = 'my_vehicle',
            canSee = function()
                if IsPedInAnyVehicle(p:ped(), true) then
                    return true
                else
                    return false
                end
            end
        },
        { name = 'world' },
        -- { name = 'settings' },
    }
end

local function getWeaponsButtons(PMenu)
    local data, list = _WEAPONS.list, {}
    for k,v in pairs(data) do
        list[#list + 1] = { name = GetPhrase(v.name), Description = v.label, ask = string.upper(v.name), askX = true }
    end
    return list
end

local function getMyVehicleButtons(PMenu)
    local pVeh = GetVehiclePedIsIn(p:ped())
    return {
        { name = 'vehicle_doords',                  cantUse = not IsPedInAnyVehicle(PlayerPedId(), true), slidemax = { 'Avant - Gauche', 'Arrière - gauche', 'Avant - Droite', 'Arrière - Droite', 'Capot', 'Coffre' } },
        { name = "admin_vehicle_repair",            cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_deformationrepair", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_fullrepair",        cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_wash",              cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_delete",            cantUse = not IsPedInAnyVehicle(PlayerPedId(), true), colorFree = { 205, 45, 45, 165 } },
    }
end
local function getVehicleButtons()
    return {
        { name = 'vehicle_list_categories' },
        { name = 'vehicle_saved' },
        { name = 'vehicle_spawn' },
        { name = 'vehicle_custom',         cantUse = not IsPedInAnyVehicle(p:ped(), true) },
        { name = 'save_vehicle',           colorFree = { 53, 146, 61, 165 },              cantUse = not IsPedInAnyVehicle(p:ped(), true) }
    }
end

local function getWorldButtons()
    return {
        { name = 'teleport_marker' },
        { name = 'teleport_interior' },
        { name = 'teleport_coords' },
        { name = 'weather',          slidemax = Weather },
        { name = 'time',             slidemax = 23 },

    }
end

local function getSettingsButtons()
    return {
        { name = 'gamertag_checkbox',  checkbox = false },
        { name = 'blips_checkbox',     checkbox = false },
        { name = 'voicechat_checkbox', checkbox = false },
        { name = 'hitmarker_checkbox', checkbox = false },
    }
end

function OpenOptionMenu()
    local Preference = {
        Base = { Header = { "commonmenu", "interaction_bgd" }, HeaderColor = { 255, 255, 255, 255 }, Title = '' },
        Data = { currentMenu = "GENERAL" },
        Events = { onSelected = menuOnSelected, onAdvSlide = menu_onAdvSlide, onButtonSelected = menu_onButtonSelected, onSlide = menu_onSlide },
        Menu = {
            ['GENERAL'] = { refresh = true, b = getButtons },
            ['player_view'] = { b = getPlayerView },
            ['player_list'] = { useFilter = true, b = getPlayerList },
            ['my_player'] = { b = getMyPlayerButtons },
            ['weapons'] = { useFilter = true, b = getWeaponsButtons },
            ['vehicle_list_categories'] = { b = getVehicleListCategories },
            ['vehicle_list'] = { b = getVehicleList },
            ['vehicles'] = { refresh = true, b = getVehicleButtons },
            ['vehicle_custom'] = { b = getVehicleCustomButtons },
            ['vehicle_custom_color'] = { slidertime = 100, b = getVehiclePaintButtons },
            ['vehicle_custom_classic'] = { b = getVehicleClassicButtons },
            ['vehicle_custom_wheel'] = { b = getVehicleWheelsButtons },
            ['scenes'] = { b = getScenesButtons },
            ['vehicle_custom_customs'] = { b = getVehicleCustomsButtons },
            ['scenes_manage'] = { b = getSceneManageButtons },
            ['my_vehicle'] = { b = getMyVehicleButtons },
            ['vehicle_custom_performance'] = { b = getVehiclePerformanceButtons },
            ['vehicle_custom_bennys'] = { b = getVehicleBennysButtons },
            ['vehicle_saved'] = { b = getVehicleSave },
            ['skin_submenu'] = { b = getSkinButtons },
            ['edit_props'] = { extra = true, slidertime = 100, b = getPropsButtons },
            ['peds_list'] = { useFilter = true, b = getPedsList },
            ['edit_components'] = { extra = true, slidertime = 100, b = getComponentsButtons },
            ['peds_save'] = { b = getSkinSave },
            ['world'] = { slidertime = 100, b = getWorldButtons },
            ['settings'] = { b = getSettingsButtons }
        }

    }

    if _SETTINGS['option'] then
        CreateMenu(Preference)
    end
end

Keys.Register({
    name = 'openOptionMenu',
    description = GetPhrase('Menu_Option'),
    defaultKey = 'F5',
    onPressed = function()
        if _SETTINGS.option then
            OpenOptionMenu()
        end
    end
})

Keys.Register({
    name = 'toggleRecording',
    description = GetPhrase('rockstar_editor'),
    defaultKey = 'F3',
    onPressed = function()
        if IsRecording() then 
            return StopRecordingAndSaveClip() 
        end
        StartRecording(1)
    end
})


RegisterNetEvent("core:SendMessageToPlayer")
AddEventHandler("core:SendMessageToPlayer", function(msg)
    Utils.ShowNotification(GetPhrase('receive_message', msg), true)
end)
