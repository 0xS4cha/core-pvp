local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

Admin = Admin or {}
Admin.CamTarget = {}
Admin.Timer = 0
Admin.Timer2 = 0
Admin.Scalform = nil 
Admin.BringCoords = false
Admin.SpeedNoclip = 1
Admin.CamCalculate = nil
Admin.Cam = nil 
Admin.InSpec = false
Admin.isInService = false
Admin.HasGamerTag = false;
Admin.HasHitbox = false;
Admin.HasSkeleton = false;
Admin.HasPlayerLine = false;
Admin.HasBlips = false;
Admin.HasPropsName = false;
Admin.HasBonesName = false;
Admin.HasGroundName = false;
Admin.AllTags = { GAMER_NAME = 0, CREW_TAG = 1, healthArmour = 2, BIG_TEXT = 3, AUDIO_ICON = 4, MP_USING_MENU = 5, MP_PASSIVE_MODE = 6, WANTED_STARS = 7, MP_DRIVER = 8, MP_CO_DRIVER = 9, MP_TAGGED = 10, GAMER_NAME_NEARBY = 11, ARROW = 12, MP_PACKAGES = 13, INV_IF_PED_FOLLOWING = 14, RANK_TEXT = 15, MP_TYPING = 16 }
Admin.DetailsScalform = {
    speed = {
        control = 178,
        label = GetPhrase('SpeedModif_spectate')
    },
    spectateplayer = {
        control = 24,
        label = GetPhrase('Spectate_player')
    },
    gotopos = {
        control = 51,
        label = GetPhrase('GoToPos_Spectate')
    },
    sprint = {
        control = 21,
        label = GetPhrase('Speed_spectate')
    },
    slow = {
        control = 36,
        label = GetPhrase('Slow_Spectate')
    },
    back2player = {
        control = 45,
        label = GetPhrase('BackToPlayer')
    },
    bringMyCharacter = {
        control = 246,
        label = GetPhrase('BringMyCharacter')
    },
}

Admin.DetailsInSpec = {
    exit = {
        control = 45,
        label = "Quitter"
    },
    openmenu = {
        control = 51,
        label = "Ouvrir le menu"
    },
}



CreateThread(function()
    while p == nil do Wait(1) end
    TriggerServerEvent("core:loadVariables", Token)
    Admin.PlyGroup = p:getPermission()
end)

local function TeleportCoords(vector, peds)
	if not vector or not peds then return end
	local x, y, z = vector.x, vector.y, vector.z + 0.98
	peds = peds or PlayerPedId()

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local TimerToGetGround = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(peds, x, y, z)

	TimerToGetGround = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(peds) do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	local retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
	TimerToGetGround = GetGameTimer()
	while not retval do
		z = z + 5.0
		retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
		Wait(0)

		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
	end

	SetEntityCoordsNoOffset(peds, x, y, retval and GroundPosZ or z)
	NewLoadSceneStop()
	return true
end

local function TeleporteToPoint(ped)
    local pPed = ped or PlayerPedId()
    local bInfo = GetFirstBlipInfoId(8)
    if not bInfo or bInfo == 0 then
        return
    end
    local entity = IsPedInAnyVehicle(pPed, false) and GetVehiclePedIsIn(pPed, false) or pPed
    local bCoords = GetBlipInfoIdCoord(bInfo)
    TeleportCoords(bCoords, entity)
end

local function CheckTimeRemaning(time)
    local d = 0
    local h = 0
    local m = 0
    local perm = false
    if tonumber(time) ~= 0 then
        if (tonumber(time)) > os.time() then
            local tempsrestant = (((tonumber(time)) - os.time()) / 60)
            if tempsrestant >= 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = (day - math.floor(day)) * 24
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant >= 60 and tempsrestant < 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = tempsrestant / 60
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant < 60 then
                d = 0
                h = 0
                m = math.ceil(tempsrestant)
            end
        end
    else
        perm = true
    end
    return perm, d, h, m
end


local function menuOnSelected(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)
    local currentMenu = tblData.currentMenu
    local tempData = tblData.temp
    local pPed = p:ped()
    local player = PlayerId()
    if currentMenu == 'GENERAL' then
        if tblButton.name == "ADMIN_TakeService" then
            local Valided = TriggerServerCallback("core:admin:TakeService", Token, not Admin.isInService)
            if not Admin.isInService and Valided then
                Admin.isInService = not Admin.isInService
            elseif Admin.isInService and Valided then
                Admin.isInService = not Admin.isInService
            end
        end
    elseif currentMenu == 'admin_playerlist' then
        tblData.temp = { source = tblButton.source, name = tblButton.playerName, data = tblButton.data }
        PMenu:OpenMenu('player_view')
    elseif currentMenu == 'admin_stafflist' then
        tblData.temp = { source = tblButton.source, name = tblButton.playerName, data = tblButton.data }
        PMenu:OpenMenu('player_view')
    elseif currentMenu == 'player_view' then
        local idPlayer = tblData.temp.source
        if tblButton.name == "admin_playermenu_sendmessage" then
            AskEntry(function(msg)
                if msg and string.len(msg) ~= 0 then
                    TriggerPlayerEvent('core:admin:SendMessageToPlayer', idPlayer, msg)
                end
            end, "Message", 255)
        elseif tblButton.name == "admin_playermenu_teleport2player" then
            local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
            TriggerServerEvent('core:admin:Teleport2', Token, idPlayer)
        elseif tblButton.name == "admin_playermenu_teleport2me" then
            local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
            Admin.BringCoords = GetEntityCoords(idPed)
            TriggerServerEvent('core:admin:Teleport', Token, GetEntityCoords(PlayerPedId()), idPlayer)
        elseif tblButton.name == "admin_playermenu_teleport2camera" then
            if Admin.Cam then
                local pCam = GetCamCoord(Admin.Cam)
                local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
                Admin.BringCoords = GetEntityCoords(idPed)
                TriggerServerEvent('core:admin:Teleport', Token, pCam, idPlayer)
            else
                Utils.ShowNotification(GetPhrase("admin_not_in_cam"))
            end
        elseif tblButton.name == "admin_playermenu_bringback" then
            if Admin.BringCoords then
                TriggerServerEvent('core:admin:Teleport', Token, Admin.BringCoords, idPlayer)
                Admin.BringCoords = false
            end
        elseif tblButton.name == 'admin_playermenu_advertplayer' then
            AskEntry(function(msg)
                if msg and string.len(msg) ~= 0 then
                    TriggerServerEvent('core:admin:AdvertPlayer', Token, idPlayer, msg)
                end
            end, GetPhrase("admin_ban_reason"), 255)
        elseif tblButton.name == 'admin_playermenu_screenshot' then
            TriggerServerEvent('core:admin:Screenshot', Token, idPlayer)
        elseif tblButton.name == 'admin_playermenu_clip' then
            TriggerServerEvent('core:admin:Video', Token, idPlayer, tonumber(tblButton.slidename))
            Utils.ShowNotification(GetPhrase('WaitClip'))
        elseif tblButton.name == 'admin_givevehicle' then
            TriggerServerEvent('core:admin:GiveVehicle', Token, idPlayer, tblButton.slidename,
                GetDisplayNameFromVehicleModel(tblButton.slidename))
        elseif tblButton.name == 'admin_playermenu_advertmenu' then
            OpenMenu('admin_advertmenu')
        elseif tblButton.name == 'admin_playermenu_kick' then
            AskEntry(function(reason)
                if reason and string.len(reason) ~= 0 then
                    TriggerServerEvent('core:admin:kick', Token, idPlayer, reason)
                    CloseMenu(true)
                end
            end, GetPhrase("admin_ban_reason"), 255)
        elseif tblButton.name == 'admin_playermenu_ban' then
            if tblButton.slidenum == 1 then
                AskEntry(function(reason)
                    if reason and string.len(reason) ~= 0 then
                        TriggerServerEvent('core:admin:ban', Token, idPlayer, reason, 0, tblButton.slidename)
                        CloseMenu(true)
                    end
                end, GetPhrase("admin_ban_reason"), 255)
            elseif tblButton.slidenum == 2 or tblButton.slidenum == 3 then
                AskEntry(function(time)
                    if time and tonumber(time) > 0 then
                        AskEntry(function(reason)
                            if reason and string.len(reason) ~= 0 then
                                TriggerServerEvent('core:admin:ban', Token, idPlayer, reason, tonumber(time),
                                    tblButton.slidename)
                                CloseMenu(true)
                            end
                        end, GetPhrase("admin_ban_reason"), 255)
                    end
                end, "Time", 255)
            end
        end
    elseif currentMenu == 'admin_myplayer' then
        if tblButton.name == "admin_invicibility" then
            p:setGodmode(not tblButton.checkbox)
        elseif tblButton.name == "admin_invisibility" then
            p:setInvisible(not tblButton.checkbox)
        elseif tblButton.name == "admin_heal" then
            p:setHealth(200)
        end
    elseif currentMenu == 'admin_managereport' then
        tblData.temp = { source = tblButton.source, data = tblButton.data }
        OpenMenu("admin_report")
    elseif currentMenu == 'admin_report' then
        if tblButton.name == 'admin_report_claim' then
            local response = TriggerServerCallback('core:admin:claimReport', Token, tblData.temp.data['tempId'],
                tblData.temp.data['time'])
            if response then
                local oldTemp = tblData.temp
                tblData.temp = { source = oldTemp['tempId'], name = oldTemp['playerName'], data = oldTemp['data'] }
                OpenMenu("player_view")
            else
                Utils.ShowNotification(GetPhrase('ReportAlreadyClaim'))
            end
        elseif tblButton.name == 'admin_report_delete' then
            TriggerServerEvent('core:admin:closeReport', Token, tblData.temp.data['tempId'], tblData.temp.data['time'])
            CloseMenu(true)
        end
    elseif currentMenu == 'admin_vehiclemanager' then
        if tblButton.name == 'admin_vehicle_create' then
            AskEntry(function(modelName)
                if not IsModelInCdimage(modelName) then
                    Utils.ShowNotification("~r~This model does not exist.")
                    return
                end
                local vehData = GetHashKey(modelName)

                local veh = Utils.SpawnVehicle(vehData, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
                SetVehicleWindowTint(veh, 3)
            end, "Vehicle model")
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
    elseif currentMenu == 'admin_advertmenu' then
        CloseMenu(true)
        TriggerServerEvent('core:admin:RemoveAdvertPlayer', Token, tblButton.idAdvert)
    elseif currentMenu == 'admin_management' then
        if tblButton.name == 'admin_announce' then
            AskEntry(function(reason)
                if reason and string.len(reason) ~= 0 then
                    TriggerServerEvent('core:admin:announce', Token, reason)
                end
            end, GetPhrase("admin_ban_reason"), 255)
        elseif tblButton.name == "admin_ban_offline" then
            if tblButton.slidenum == 1 then
                AskEntry(function(uuid)
                    if uuid and tonumber(uuid) > 0 then
                        AskEntry(function(reason)
                            if reason and string.len(reason) ~= 0 then
                                TriggerServerEvent('core:admin:banoffline', Token, tonumber(uuid), reason, 0,
                                    tblButton.slidename)
                                CloseMenu(true)
                            end
                        end, GetPhrase("admin_ban_reason"), 255)
                    end
                end, "UUID", 32)
            elseif tblButton.slidenum == 2 or tblButton.slidenum == 3 then
                AskEntry(function(uuid) 
                    if uuid and tonumber(uuid) > 0 then
                            AskEntry(function(time)
                                if time and tonumber(time) > 0 then
                                AskEntry(function(reason)
                                    if reason and string.len(reason) ~= 0 then
                                        TriggerServerEvent('core:admin:banoffline', Token, tonumber(uuid), reason, tonumber(time), e.slidename)
                                        CloseMenu(true)
                                    end
                                end, GetPhrase("admin_ban_reason"), 255)
                            end
                        end, "Time", 255)
                    end
                end, "UUID", 32)
            end
        end
    elseif currentMenu == 'admin_unbanmanager' then
        tblData.temp = tblButton.data
        OpenMenu("admin_banmenu")
    elseif currentMenu == 'admin_coordsmanager' then
        if tblButton.name == "{x, y, z}" then
            local pCoords = GetEntityCoords(pPed)
            local coords = '{' .. pCoords.x .. ', ' .. pCoords.y .. ', ' .. pCoords.z .. '}'
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        elseif tblButton.name == "{x = x, y = y, z = z}" then
            local pCoords = GetEntityCoords(pPed)
            local coords = '{x = ' .. pCoords.x .. ', y = ' .. pCoords.y .. ', z = ' .. pCoords.z .. '}'
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        elseif tblButton.name == "vector3(x, y, z)" then
            local pCoords = GetEntityCoords(pPed)
            local coords = 'vector3(' .. pCoords.x .. ', ' .. pCoords.y .. ', ' .. pCoords.z .. ')'
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        elseif tblButton.name == 'vector4(x, y, z, w)' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = 'vector4(' .. pCoords.x .. ', ' .. pCoords.y .. ', ' .. pCoords.z .. ',' .. heading .. ')'
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        elseif tblButton.name == 'vector2(x, y)' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = 'vector2(' .. pCoords.x .. ', ' .. pCoords.y .. ')'
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        elseif tblButton.name == 'heading' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = tostring(heading)
            if tblButton.slidenum == 1 then
                _NUI.Copy(coords)
            elseif tblButton.slidenum == 2 then
                Logger:info('ADMIN', coords)
            end
        end
    elseif currentMenu == 'admin_tools' then
        if tblButton.name == 'admin_teleportpoint' then
            TeleporteToPoint(pPed)
        elseif tblButton.name == "admin_showgamertag" then
            if not Admin.HasGamerTag then
                Admin.HasGamerTag = true
                ToogleGamerTag()
            else
                Admin.HasGamerTag = false
                DestroyGamerTag()
            end
        elseif tblButton.name == "admin_hitbox" then
            if not Admin.HasHitbox then
                Admin.HasHitbox = true
                ToogleHitbox()
            else
                Admin.HasHitbox = false
            end
        elseif tblButton.name == 'admin_playerline' then
            if not Admin.HasPlayerLine then
                Admin.HasPlayerLine = true
                ToggleLine()
            else
                Admin.HasPlayerLine = false
            end
        elseif tblButton.name == 'admin_skeleton' then
            if not Admin.HasSkeleton then
                Admin.HasSkeleton = true
                ToogleSkeleton()
            else
                Admin.HasSkeleton = false
            end
        elseif tblButton.name == 'admin_propsname' then
            if not Admin.HasPropsName then
                Admin.HasPropsName = true
                TooglePropsName()
            else
                Admin.HasPropsName = false
            end
        elseif tblButton.name == 'admin_groundname' then
            if not Admin.HasGroundName then
                Admin.HasGroundName = true
                ToggleGroundName()
            else
                Admin.HasGroundName = false
            end
        elseif tblButton.name == 'admin_bonesname' then
            if not Admin.HasBonesName then
                Admin.HasBonesName = true
                ToggleBonesName()
            else
                Admin.HasBonesName = false
            end
        elseif tblButton.name == "admin_showblips" then
            Admin.HasBlips = not Admin.HasBlips
            
            CreateBlips()
            end
    end
end

local function getButtons(PMenu)
    return {
        { name = "admin_playerlist",     cantUse = not Admin.isInService },
        { name = "admin_stafflist",      cantUse = not Admin.isInService },
        { name = "admin_myplayer",       cantUse = not Admin.isInService },
        { name = "admin_managereport",   cantUse = not Admin.isInService },
        { name = "admin_vehiclemanager", cantUse = not Admin.isInService },
        { name = "admin_management",     cantUse = not Admin.isInService },
        { name = "admin_tools",          locked = not Admin.isInService },
        { name = "ADMIN_TakeService",    checkbox = Admin.isInService },
    }
end

local function getToolsButtons(PMenu)
    return {
        { name = "admin_teleportpoint" },
        { name = "admin_showgamertag", checkbox = Admin.HasGamerTag },
        { name = "admin_hitbox",       checkbox = Admin.HasHitbox },
        { name = "admin_playerline",   checkbox = Admin.HasPlayerLine },
        { name = "admin_skeleton",     checkbox = Admin.HasSkeleton },
        { name = 'admin_propsname',    checkbox = Admin.HasPropsName },
        { name = 'admin_bonesname',    checkbox = Admin.HasBonesName },
        { name = 'admin_groundname',   checkbox = Admin.HasGroundName },
        { name = "admin_showblips",    checkbox = Admin.HasBlips },

    }
end

local function getCoordsButtons(PMenu)
    return {
        { name = "{x, y, z}",             slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } },
        { name = "{x = x, y = y, z = z}", slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } },
        { name = "vector3(x, y, z)",      slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } },
        { name = "vector4(x, y, z, w)",   slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } },
        { name = "vector2(x, y)",         slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } },
        { name = "heading",               slidemax = { 'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT' } }
    }
end

local function getBanButtons(PMenu)
    local temp = PMenu.Data.temp
    return {
        { name = "~r~" .. temp.playerName },
        { name = "admin_ban_id",          ask = temp.id,     askX = true },
        { name = "admin_ban_reason",      ask = temp.reason, askX = true },
        { name = "admin_ban_date",        ask = temp.Date,   askX = true },
        { name = "admin_ban_staff",       ask = temp.Banner, askX = true },
        {
            name = "admin_ban_timeremaining",
            ask = function()
                local perm, d, h, m = CheckTimeRemaning(temp.Expiration)
                print(perm, d, h, m, temp.Expiration)
                if perm then
                    return 'PERMANENT'
                else
                    return ('%s jour(s) %s heure(s) %s minute(s)'):format(d, h, m)
                end
            end,
            askX = true
        },
        { name = "admin_ban_revok", colorFree = { 205, 45, 45, 165 }, Description = 'Tu es sûr ?' }
    }
end

local function getBanManager(PMenu)
    local Banlist = TriggerServerCallback("core:admin:GetAllBan", Token)
    local blList = {}

    for i = 1, #Banlist do
        local v = Banlist[i]
        if v and i ~= 1 then
            local perm, d, h, m = CheckTimeRemaning(v.Expiration)
            if perm then
                table.insert(blList,
                    {
                        name = ('%s - ~b~%s~s~ - %s'):format(v.id, v.playerName, v.Date),
                        ask = v.Banner,
                        data = v,
                        askX = true,
                        Description = ('Raison: %s\nPar: %s\nExpiration: PERM')
                        :format(v.reason, v.Banner)
                    })
            else
                table.insert(blList,
                    {
                        name = ('%s - ~b~%s~s~ - %s'):format(v.id, v.playerName, v.Date),
                        ask = v.Banner,
                        data = v,
                        askX = true,
                        Description = ('Raison: %s\nPar: %s\nExpiration: %sJour(s) %sHeure(s) %sMinute(s)')
                            :format(v.reason, v.Banner, d, h, m)
                    })
            end
        end
    end
    return blList
end

local function getManagementButtons(PMenu)
    return {
        { name = "admin_ban_offline",  colorFree = { 205, 45, 45, 165 }, slidemax = { 'perm', 'days', 'hours' } },
        {
            name = "admin_announce",
            canSee = function()
                if p:getPermission() >= _PERMISSION['ANNOUNCE'] then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = "admin_unbanmanager",
            canSee = function()
                if p:getPermission() >= _PERMISSION['UNBAN'] then
                    return true
                else
                    return false
                end
            end
        },
        { name = "admin_coordsmanager" },
    }
end

local function getAdvertButtons(PMenu)
    local temp = PMenu.Data.temp
    local AdvertList = TriggerServerCallback("core:admin:GetAdvertList", Token, temp.source)


    local advlist = {}
    local CantUse = true
    if p:getPermission() >= _PERMISSION['DELETE_ADVERT'] then
        CantUse = false
    end
    for i = 1, #AdvertList do
        local v = AdvertList[i]
        if v ~= nil then
            table.insert(advlist,
                {
                    name = ('~b~%s~s~ - %s'):format(v.id, v.text),
                    idAdvert = v.id,
                    ask = 'admin_delete_advert',
                    askX = true,
                    Description = ('Advert by: %s\nDate: %s')
                        :format(v.staff, v.date),
                    cantUse = CantUse
                })
        end
    end
    return advlist
end

local function getVehicleManagerButtons(PMenu)
    return {
        { name = "admin_vehicle_create" },
        { name = "admin_vehicle_repair",            cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_deformationrepair", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_fullrepair",        cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_wash",              cantUse = not IsPedInAnyVehicle(PlayerPedId(), true) },
        { name = "admin_vehicle_delete",            cantUse = not IsPedInAnyVehicle(PlayerPedId(), true), colorFree = { 205, 45, 45, 165 } },
    }
end

local function getReportButtons(PMenu)
    local temp = PMenu.Data.temp
    return {
        { name = ("~r~[%s]~s~ %s"):format(temp.data['tempId'], temp.data['playerName']), Description = ('UUID: %s\nReason: %s'):format(temp.data['uuid'], temp.data['reason']) },
        { label = temp.data['reason'],                                                   multiline = true },
        { name = 'admin_report_claim' },
        { name = 'admin_report_delete',                                                  colorFree = { 205, 45, 45, 165 },                                                     Description = 'Tu es sûr ?' },
    }
end

local function getReportList(PMenu)
    local reportList = TriggerServerCallback("core:admin:GetAllReports", Token)
    local rptList = {}
    for k, v in pairs(reportList) do
        if not v.taken then
            --table.insert(rptList, {name = '['..v['tempId']..'] '..v['playerName'], ask = v['time'], source = v.id, data = v, askX = true, Description = 'UUID: '..v['uuid']..'\nReason: '..v['reason']})
            table.insert(rptList,
                {
                    name = v['playerName'],
                    ask = v['time'],
                    source = v.id,
                    data = v,
                    askX = true,
                    Description = 'UUID: ' ..
                        v['uuid'] .. '\nReason: ' .. v['reason']
                })
        else
            table.insert(rptList,
                {
                    name = '~y~[' .. v['tempId'] .. '] ' .. v['playerName'],
                    ask = v['time'],
                    source = v.id,
                    data = v,
                    askX = true,
                    Description =
                        'Staff: ' .. v['staff'] .. '\nUUID: ' .. v['uuid'] .. '\nReason: ' .. v['reason']
                })
        end
    end
    return rptList
end

local function getMyPlayerButtons(PMenu)
    return {
        { name = 'admin_invicibility', checkbox = p:getGodmode() },
        { name = 'admin_invisibility', checkbox = p:getInvisible() },
        { name = 'admin_heal' },
    }
end

local function getPlayerList(PMenu)
    local PlayerList = TriggerServerCallback("core:GetAllPlayer", Token)
    local list = {}
    for k, v in pairs(PlayerList.players) do
        if v ~= nil then
            table.insert(list,
                {

                    name = '[' .. v.id .. '] ~b~[' .. _PERMISSION_ROLE[v.permission].prefix .. ']~s~ ' .. v.name,
                    playerName =
                        v.name,
                    source = v.id,
                    data = v,
                    askX = true,
                })
        end
    end
    return list
end

local function getStaffList(PMenu)
    local StaffList = TriggerServerCallback("core:GetAllStaff", Token)
    local stfList = {}
    for i = 1, #StaffList do
        local v = StaffList[i]
        if v ~= nil then
            if v.isInStaffMode then
                table.insert(stfList,
                    {
                        name = ('[%s] [~g~STAFF MODE~s~] - %s'):format(v.source, v.name),
                        playerName = v.name,
                        source = v
                            .source,
                        data = v,
                        ask = _PERMISSION_ROLE[v.permission].label,
                        askX = true,
                        Description = ('UUID: %s\nTempID: %s')
                            :format(v.id, v.source)
                    })
            else
                table.insert(stfList,
                    {
                        name = ('[%s] - %s'):format(v.source, v.name),
                        playerName = v.name,
                        source = v.source,
                        data = v,
                        ask =
                            _PERMISSION_ROLE[v.permission].label,
                        askX = true,
                        Description = ('UUID: %s\nTempID: %s'):format(
                            v.id, v.source)
                    })
            end
        end
    end
    return stfList
end

local function getPlayerView(PMenu)
    local data = PMenu.Data.temp
    return {
        { name = ("~r~[%s]~s~ %s"):format(data.source, data.name) },
        { name = "admin_playermenu_sendmessage" },
        { name = "admin_playermenu_teleport2player" },
        { name = "admin_playermenu_teleport2me" },
        { name = "admin_playermenu_teleport2camera",              cantUse = not Admin.Cam },
        { name = "admin_playermenu_bringback",                    cantUse = not Admin.BringCoords },
        { name = "admin_playermenu_showinformation" },
        { name = "admin_playermenu_screenshot" },
        { name = "admin_playermenu_clip",                         Description = 'Seconds',          slidemax = { 5, 10, 15 } },
        { name = "admin_playermenu_advertplayer" },
        { name = "admin_playermenu_advertmenu" },
        { name = "admin_playermenu_wipe",                         colorFree = { 205, 45, 45, 165 }, Description = 'Tu es sûr ?' },
        { name = "admin_playermenu_kick",                         colorFree = { 205, 45, 45, 165 }, Description = 'Tu es sûr ?' },
        { name = "admin_playermenu_ban",                          colorFree = { 205, 45, 45, 165 }, slidemax = { 'perm', 'days', 'hours' }, Description = 'Tu es sûr ?' },
    }
end


Admin.Menu = {
    Base = { Header = { "commonmenu", "interaction_bgd" }, HeaderColor = { 255, 255, 255, 255 }, Title = '', intX = 0.95 },
    Data = { currentMenu = "GENERAL", MaxPagination = 15, },
    Events = { onSelected = menuOnSelected, onAdvSlide = menu_onAdvSlide, onRender = menu_onRender, onSlide = menu_onSlide },
    Menu = {
        ['GENERAL'] = { refresh = true, b = getButtons },
        ['admin_playerlist'] = { useFilter = true, filters = {playerName = "^playerName:(%S+)",}, b = getPlayerList },
        ['player_view'] = { b = getPlayerView },
        ['admin_stafflist'] = { b = getStaffList },
        ['admin_advertmenu'] = { b = getAdvertButtons },
        ['admin_myplayer'] = { b = getMyPlayerButtons },
        ['admin_managereport'] = { refresh = true, useFilter = true, refreshTime = 2000, b = getReportList },
        ['admin_report'] = { b = getReportButtons },
        ['admin_vehiclemanager'] = { refresh = true, b = getVehicleManagerButtons },
        ['admin_management'] = { b = getManagementButtons },
        ['admin_unbanmanager'] = { useFilter = true, b = getBanManager },
        ['admin_banmenu'] = { b = getBanButtons },
        ['admin_coordsmanager'] = { b = getCoordsButtons },
        ['admin_tools'] = { b = getToolsButtons }
    }
}



-- Active Scalform
function Admin:ActiveScalform(bool)
    local dataSlots = {
        {
            name = "CLEAR_ALL",
            param = {}
        }, 
        {
            name = "TOGGLE_MOUSE_BUTTONS",
            param = { 0 }
        },
        {
            name = "CREATE_CONTAINER",
            param = {}
        } 
    }
    local dataId = 0
    for k, v in pairs(bool and Admin.DetailsInSpec or Admin.DetailsScalform) do
        dataSlots[#dataSlots + 1] = {
            name = "SET_DATA_SLOT",
            param = {dataId, GetControlInstructionalButton(2, v.control, 0), v.label}
        }
        dataId = dataId + 1
    end
    dataSlots[#dataSlots + 1] = {
        name = "DRAW_INSTRUCTIONAL_BUTTONS",
        param = { -1 }
    }
    return dataSlots
end

-- Controls cam
function Admin:ControlInCam()
    local p10, p11 = IsControlPressed(1, 10), IsControlPressed(1, 11)
    local pSprint, pSlow = IsControlPressed(1, Admin.DetailsScalform.sprint.control), IsControlPressed(1, Admin.DetailsScalform.slow.control)
    if p10 or p11 then
        Admin.SpeedNoclip = math.max(0, math.min(100, round(Admin.SpeedNoclip + (p10 and 0.01 or -0.01), 2)))
    end
    if Admin.CamCalculate == nil then
        if pSprint then
            Admin.CamCalculate = Admin.SpeedNoclip * 2.0
        elseif pSlow then
            Admin.CamCalculate = Admin.SpeedNoclip * 0.1
        end
    elseif not pSprint and not pSlow then
        if Admin.CamCalculate ~= nil then
            Admin.CamCalculate = nil
        end
    end
    if IsControlJustPressed(0, Admin.DetailsScalform.speed.control) then
        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", Admin.SpeedNoclip, "", "", "", 5)
        while UpdateOnscreenKeyboard() == 0 do
            Citizen.Wait(10)
            if UpdateOnscreenKeyboard() == 1 and GetOnscreenKeyboardResult() and string.len(GetOnscreenKeyboardResult()) >= 1 then
                Admin.SpeedNoclip = tonumber(GetOnscreenKeyboardResult()) or 1.0
                break
            end
        end
    end
end

-- Manage pos cam
function Admin:ManageCam()
    local p32, p33, p35, p34 = IsControlPressed(1, 32), IsControlPressed(1, 33), IsControlPressed(1, 35), IsControlPressed(1, 34)
    local g220, g221 = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    if g220 ~= 0.0 or g221 ~= 0.0 then
        local cRot = GetCamRot(Admin.Cam, 2)
        new_z = cRot.z + g220 * -1.0 * 10.0;
        new_x = cRot.x + g221 * -1.0 * 10.0
        SetCamRot(Admin.Cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(), new_z)
    end
    if p32 or p33 or p35 or p34 then
        local rightVector, forwardVector, upVector = GetCamMatrix(Admin.Cam)
        local cPos = (GetCamCoord(Admin.Cam)) + ((p32 and forwardVector or p33 and -forwardVector or vector3(0.0, 0.0, 0.0)) + (p35 and rightVector or p34 and -rightVector or vector3(0.0, 0.0, 0.0))) * (Admin.CamCalculate ~= nil and Admin.CamCalculate or Admin.SpeedNoclip)
        SetCamCoord(Admin.Cam, cPos)
        SetFocusPosAndVel(cPos)
    end
end

-- Start spectate
function Admin:StartSpectate(player)
    Admin.CamTarget = player
    Admin.CamTarget.PedHandle = GetPlayerPed(player.id)
    if not DoesEntityExist(Admin.CamTarget.PedHandle) then
        Utils.ShowNotification("~r~Vous etes trop loin de la cible.")
        return
    end
    NetworkSetInSpectatorMode(1, Admin.CamTarget.PedHandle)
    SetCamActive(Admin.Cam, false)
    RenderScriptCams(false, false, 0, false, false)
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(true))
    ClearFocus()
end

-- Stop spectate
function Admin:ExitSpectate()
    local pPed = PlayerPedId()
    if DoesEntityExist(Admin.CamTarget.PedHandle) then
        SetCamCoord(Admin.Cam, GetEntityCoords(Admin.CamTarget.PedHandle))
    end
    NetworkSetInSpectatorMode(0, pPed)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.CamTarget = {}
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(true))
end

function Admin:ScalformSpectate()
    if IsControlJustPressed(0, Admin.DetailsInSpec.exit.control) then
        Admin:ExitSpectate()
    end
    if IsControlJustPressed(0, Admin.DetailsInSpec.openmenu.control) then
        Admin.tId = GetPlayerServerId(Admin.CamTarget.id)
        if Admin.tId and Admin.tId > 0 then
            CreateMenu(Admin.Menu)
            Wait(15)
            OpenMenu("admin_playermenu")
        end
    end
    if GetGameTimer() > Admin.Timer then
        Admin.Timer = GetGameTimer() + 1000
        SetFocusPosAndVel(GetEntityCoords(GetPlayerPed(Admin.CamTarget.id)))
    end
end

function Admin:SpecAndPos()
    if not Admin.CamTarget.id and IsControlJustPressed(0, Admin.DetailsScalform.spectateplayer.control) then
        local qTable = {}
        local CamCoords = GetCamCoord(Admin.Cam)
        local pId = PlayerId()
        for k, v in pairs(GetActivePlayers()) do
            local vPed = GetPlayerPed(v)
            local vPos = GetEntityCoords(vPed)
            local vDist = GetDistanceBetweenCoords(vPos, CamCoords)
            if v ~= pId and vPed and vDist <= 20 and (not qTable.pos or GetDistanceBetweenCoords(qTable.pos, CamCoords) > vDist) then
                qTable = {
                    id = v,
                    pos = vPos
                }
            end
        end
        if qTable and qTable.id then
            Admin:StartSpectate(qTable)
        end
    end
    if IsControlJustPressed(1, Admin.DetailsScalform.gotopos.control) then
        local camActive = GetCamCoord(Admin.Cam)
        Admin:Spectate(camActive)
    end
    if IsControlJustPressed(1, Admin.DetailsScalform.back2player.control) then
   
        SetCamCoord(Admin.Cam, p:pos().x, p:pos().y, p:pos().z)
    end
    if IsControlJustPressed(1, Admin.DetailsScalform.bringMyCharacter.control) then
        local camActive = GetCamCoord(Admin.Cam)
        SetEntityCoords(p:ped(), camActive)
    end
end

-- Render Cam
function Admin:RenderCam()
    if not NetworkIsInSpectatorMode() then
        Admin:ControlInCam()
        Admin:ManageCam()
        Admin:SpecAndPos()
    else
        Admin:ScalformSpectate()
    end
    if Admin.Scalform then
        DrawScaleformMovieFullscreen(Admin.Scalform, 255, 255, 255, 255, 0)
    end
    if GetGameTimer() > Admin.Timer2 then
        Admin.Timer2 = GetGameTimer() + 15000
    end
end

-- Create Cam
function Admin:CreateCam()
    Admin.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.Scalform = CreateScaleform("INSTRUCTIONAL_BUTTONS", Admin:ActiveScalform())
end

-- Destroy Cam
function Admin:DestroyCam()
    DestroyCam(Admin.Cam)
    RenderScriptCams(false, false, 0, false, false)
    ClearFocus()
    SetScaleformMovieAsNoLongerNeeded(Admin.Scalform)
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, Admin.CamTarget.id and GetPlayerPed(Admin.CamTarget.id) or 0)
    end
    Admin.Scalform = nil
    Admin.Cam = nil
    lockEntity = nil
    Admin.CamTarget = {}
end

-- Spectate
function Admin:Spectate(pPos)
    local player = PlayerPedId()
    local pPed = player
    Admin.InSpec = not Admin.InSpec
    Wait(0)
    if not Admin.InSpec then
        Admin:DestroyCam()
        SetEntityVisible(pPed, true, true)
        SetEntityInvincible(pPed, false)
        SetEntityCollision(pPed, true, true)
        FreezeEntityPosition(pPed, false)
        if pPos then
            SetEntityCoords(pPed, pPos)
        end
    else
        Admin:CreateCam()

        SetEntityVisible(pPed, false, false)
        SetEntityInvincible(pPed, true)
        SetEntityCollision(pPed, false, false)
        FreezeEntityPosition(pPed, true)
        
        SetCamCoord(Admin.Cam, GetEntityCoords(player))
        CreateThread(function()
            while Admin.InSpec do
                Wait(0)
                Admin:RenderCam()
            end
        end)
    end
end

Keys.Register({
    name = 'spectateMode',
    description = GetPhrase('Spec_mode'),
    defaultKey = 'O',
    onPressed = function()
        if Admin.PlyGroup >= _PERMISSION['SPECTATE'] and Admin.isInService then
            Admin:Spectate()
        end
    end
})

Keys.Register({
    name = 'adminMenu',
    description = GetPhrase('Menu_Admin'),
    defaultKey = 'F4',
    onPressed = function()
        if Admin.PlyGroup >= _PERMISSION['ADMINMENU'] then
            CreateMenu(Admin.Menu)
        end
    end
})