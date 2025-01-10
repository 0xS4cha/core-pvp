local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

Admin = Admin or {}
CreateThread(function()
    while p == nil do Wait(1) end
    TriggerServerEvent("core:loadVariables", Token)
    Admin.PlyGroup = p:getPermission()
end)


Admin.tId = nil
Admin.Cam = nil 
Admin.InSpec = false
Admin.SpeedNoclip = 1
Admin.CamCalculate = nil
Admin.Timer = 0
Admin.Timer2 = 0
Admin.CamTarget = {}
Admin.GetGamerTag = {}
Admin.Menu = {}
Admin.Scalform = nil 
Admin.BringCoords = false
Admin.NameTarget = nil
Admin.NameBanned = nil 
Admin.isInService = false
Admin.Players = {}
Admin.Banned = {}

Admin.ListBanned = {}
Admin.DataReport = {}

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

function Admin:getPlayerList()
    local PlayerList = nil
    while PlayerList == nil do 
        PlayerList = TriggerServerCallback("core:GetAllPlayer", Token)
        Wait(100) 
    end
    local plyList = {}
    for i = 1, #PlayerList.players do
        local v = PlayerList.players[i]
        table.insert(plyList, {name = '['..v.id..'] ~b~['.._PERMISSION_ROLE[v.permission].prefix..']~s~ '..v.name, playerName = v.name, source = v.id, data = v, askX = true})
    end
    
    return plyList
end
local RprtList = {}
function Admin:getReportList()
    local ReportList = TriggerServerCallback("core:admin:GetAllReports", Token)
    RprtList = {}
    for k,v in pairs(ReportList) do
        v.reportId = k
        if v.alreadyTake then
            table.insert(RprtList, {name = "~g~("..v.id..") "..v.name, ask = v.time, data = v, askX = true, playerName = v.name, id = v.id, uniqueID = v.uniqueID, time = v.time, reason = v.reason, Description = v.reason.." Pris par "..v.staff})
        else
            table.insert(RprtList, {name = "("..v.id..") "..v.name, ask = v.time, askX = true, data = v, playerName = v.name, id = v.id, uniqueID = v.uniqueID, time = v.time, reason = v.reason, Description = v.reason})
        end
    end
end

function Admin:TeleportCoords(vector, peds)
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

-- Scalforms


-- Teleport to point
function Admin:TeleporteToPoint(ped)
    local pPed = ped or PlayerPedId()
    local bInfo = GetFirstBlipInfoId(8)
    if not bInfo or bInfo == 0 then
        return
    end
    local entity = IsPedInAnyVehicle(pPed, false) and GetVehiclePedIsIn(pPed, false) or pPed
    local bCoords = GetBlipInfoIdCoord(bInfo)
    Admin:TeleportCoords(bCoords, entity)
end

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
            OpenMenu("joueur")
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

Admin.HasGamerTag = false;
Admin.HasBlips = false;
Admin.AllTags = { GAMER_NAME = 0, CREW_TAG = 1, healthArmour = 2, BIG_TEXT = 3, AUDIO_ICON = 4, MP_USING_MENU = 5, MP_PASSIVE_MODE = 6, WANTED_STARS = 7, MP_DRIVER = 8, MP_CO_DRIVER = 9, MP_TAGGED = 10, GAMER_NAME_NEARBY = 11, ARROW = 12, MP_PACKAGES = 13, INV_IF_PED_FOLLOWING = 14, RANK_TEXT = 15, MP_TYPING = 16 }







-- Fonction pour donner une arme à un joueur



local SelectedMenu = {
    ["MainMenu"] = function(menu, curMenu, btnName, self)
        if btnName == "admin_takeservice" then
            local Valided = TriggerServerCallback("core:admin:TakeService", Token, not Admin.isInService)
            if not Admin.isInService and Valided then
                Admin.isInService = not Admin.isInService
            elseif Admin.isInService and Valided then
                Admin.isInService = not Admin.isInService
            end
            
        elseif btnName == 'reportlist' then
            Admin:getReportList()
        end
    end,
    ["admin_vehiclemanager"] = function(menu, curMenu, name, self)
        if name == 'admin_vehicle_create' then
            AskEntry(function(modelName) 
                if not IsModelInCdimage(modelName) then Utils.ShowNotification("~r~This model does not exist.") return end
                local vehData = GetHashKey(modelName)
                
                local veh = Utils.SpawnVehicle(vehData, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
                SetVehicleWindowTint(veh, 3)

            end, "Vehicle model")
        elseif name == 'admin_vehicle_delete' then
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
                Console.Success("Vehicle deleted")
                RemoveLoadingPrompt()
            end
        elseif name == 'admin_vehicle_deformationrepair' then
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true) 
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_deformationrepair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleDeformationFixed(pVeh)
                Console.Success("Vehicle repaired")
                RemoveLoadingPrompt()
            end
        elseif name == 'admin_vehicle_wash' then
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
        elseif name == 'admin_vehicle_fullrepair' then
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
        elseif name == 'admin_vehicle_repair' then
           
            local pVeh = GetVehiclePedIsIn(PlayerPedId(), true) 
            if pVeh then
                ShowLoadingPrompt('admin_vehicle_repair', 'BUSY_SPINNER_LEFT')
                NetworkRequestControlOfEntity(pVeh)
                local timer = GetGameTimer()
                while not NetworkHasControlOfEntity(pVeh) and timer + 2000 > GetGameTimer() do
                    Citizen.Wait(0)
                end
                SetVehicleEngineHealth(pVeh, 1000.0)
                Console.Success("Vehicle repaired")
                RemoveLoadingPrompt()
            end
        end
    end,
    ["admin_playermenu"] = function(menu, curMenu, btnName, self)
        local idPlayer = curMenu.temp or Admin.tId
        if btnName == "admin_playermenu_sendmessage" then
            AskEntry(function(msg)
                if msg and string.len(msg) ~= 0 then
                    TriggerPlayerEvent('core:admin:SendMessageToPlayer', idPlayer, msg)
                end
            end, "Message", 255)
        elseif btnName == "admin_playermenu_teleport2player" then
            local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
            TriggerServerEvent('core:admin:Teleport', Token, GetEntityCoords(idPed))
        elseif btnName == "admin_playermenu_teleport2me" then
            local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
            Admin.BringCoords = GetEntityCoords(idPed)
            TriggerServerEvent('core:admin:Teleport', Token, GetEntityCoords(PlayerPedId()), idPlayer)
        elseif btnName == "admin_playermenu_teleport2camera" then
            if Admin.Cam then
                local pCam = GetCamCoord(Admin.Cam)
                local idPed = GetPlayerPed(GetPlayerFromServerId(idPlayer))
                Admin.BringCoords = GetEntityCoords(idPed)
                TriggerServerEvent('core:admin:Teleport', Token, pCam)
            else
                Utils.ShowNotification(GetPhrase("admin_not_in_cam"))
            end
        elseif btnName == "admin_playermenu_bringback" then
            if Admin.BringCoords then
                TriggerServerEvent('core:admin:Teleport', Token, Admin.BringCoords, idPlayer)
                Admin.BringCoords = false
            end
        end
    end,
    ["admin_register_doors"] = function(m, s, name, e, q)
        local pPed = PlayerPedId()
        local results = GetOnscreenKeyboardResult()
        if name == "admin_doors_usepin" then
            _MANAGER.DOORS.ADMIN.UsePin = not _MANAGER.DOORS.ADMIN.UsePin
        elseif name == "admin_doors_label" then
            _MANAGER.DOORS.ADMIN.creator_data.Label = results
            Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
        elseif name == "admin_doors_coords" then
            CloseMenu(true)
            DoorsBuilder()
        elseif name == "admin_doors_usejob" then
            _MANAGER.DOORS.ADMIN.UseJob = not _MANAGER.DOORS.ADMIN.UseJob
        elseif name == "admin_doors_pin" then
            _MANAGER.DOORS.ADMIN.creator_data.pin = results
            Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
        elseif name == 'admin_doors_locked' then
            _MANAGER.DOORS.ADMIN.creator_data.DefaultLockStatus = not _MANAGER.DOORS.ADMIN.creator_data.DefaultLockStatus
            Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
        elseif name ==  'admin_doors_distance' then
                _MANAGER.DOORS.ADMIN.creator_data.distance = tonumber(results)
                Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
        elseif name == 'admin_doors_job' then
            if e.slidenum == 1 then
                AskEntry(function(msg)
                    if msg and string.len(msg) ~= 0 then
                        _MANAGER.DOORS.ADMIN.creator_data.jobs[msg] = true
                        _MANAGER.DOORS.ADMIN.String_Job = Utils.tableToString(_MANAGER.DOORS.ADMIN.creator_data.jobs)
                        local slidemax = {'ADMIN_DOORS_ADD_SLIDE'}
                        for k,v in pairs(_MANAGER.DOORS.ADMIN.creator_data.jobs) do
                            table.insert(slidemax, k)
                        end
                        Admin.Menu.Menu["admin_register_doors"].b[7].slidemax = slidemax
                        Admin.Menu.Menu["admin_register_doors"].b[7].Description = ('Whitelist Job: %s'):format(_MANAGER.DOORS.ADMIN.String_Job)
                        Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
                    end
                end, "Job name", 255)
            else
                _MANAGER.DOORS.ADMIN.creator_data.jobs[e.slidename] = nil
                _MANAGER.DOORS.ADMIN.String_Job = Utils.tableToString(_MANAGER.DOORS.ADMIN.creator_data.jobs)
                local slidemax = {'ADMIN_DOORS_ADD_SLIDE'}
                for k,v in pairs(_MANAGER.DOORS.ADMIN.creator_data.jobs) do
                    table.insert(slidemax, k)
                end
                Admin.Menu.Menu["admin_register_doors"].b[7].slidemax = slidemax
                Admin.Menu.Menu["admin_register_doors"].b[7].Description = ('Whitelist Job: %s'):format(_MANAGER.DOORS.ADMIN.String_Job)
                Console.Debug("Doors settings: ", json.encode(_MANAGER.DOORS.ADMIN.creator_data))
            end
        elseif name == 'admin_doors_confirm' then
            if _MANAGER.DOORS.ADMIN.creator_data.Label and (_MANAGER.DOORS.ADMIN.creator_data.pin or _MANAGER.DOORS.ADMIN.creator_data.jobs) then
                if #_MANAGER.DOORS.ADMIN.creator_data.doors >= 1 then
                    TriggerServerEvent('core:doors:Register', Token,  _MANAGER.DOORS.ADMIN.creator_data)
                    OpenMenu('admin_management')
                    _MANAGER.DOORS.ADMIN = {
                        UsePin = false,
                        UseJob = false,
                        Locked = true,
                        String_Job = '',
                        creator_data = {jobs = {}, pin = nil, label = nil, doors = {}, DefaultLockStatus = true}
                    }
                    Utils.ShowLoadingPromptWithTime('Inizializing', 5000, 'BUSY_SPINNER_LEFT')
                    Utils.ShowNotification("~b~Door being initialized~~.")
                else
                    Console.debugPrint(_MANAGER.DOORS.ADMIN.creator_data)
                    Utils.ShowNotification("~r~You must add at least one door~s~.")
                end
            else
                Utils.ShowNotification("~r~You must fill all fields~s~.")
            end
        end
    end,
    ["admin_coordsmanager"] = function(m, s, name, e, q)
        local pPed = PlayerPedId()
        local results = GetOnscreenKeyboardResult()
        if name == "{x, y, z}" then
            local pCoords = GetEntityCoords(pPed)
            local coords = '{'..pCoords.x..', '..pCoords.y..', '..pCoords.z..'}'
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        elseif name == "{x = x, y = y, z = z}" then
            local pCoords = GetEntityCoords(pPed)
            local coords = '{x = ' .. pCoords.x .. ', y = ' .. pCoords.y .. ', z = ' .. pCoords.z .. '}'
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        elseif name == "vector3(x, y, z)" then
            local pCoords = GetEntityCoords(pPed)
            local coords = 'vector3('..pCoords.x..', '..pCoords.y..', '..pCoords.z..')'
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        elseif name == 'vector4(x, y, z, w)' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = 'vector4('..pCoords.x..', '..pCoords.y..', '..pCoords.z..','..heading..')'
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        elseif name == 'vector2(x, y)' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = 'vector2('..pCoords.x..', '..pCoords.y..')'
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        elseif name == 'heading' then
            local pCoords = GetEntityCoords(pPed)
            local heading = GetEntityHeading(pPed)
            local coords = tostring(heading)
            if  e.slidenum == 1 then
                _NUI.Copy(coords)
            elseif e.slidenum == 2 then
                Console.Success(coords)
            end
        end
    end,
    ['admin_tools'] = function(m, s, name, e, q)
        local pPed = PlayerPedId()
        if name == 'admin_teleportpoint' then
            Admin:TeleporteToPoint(pPed)
        elseif name == "admin_showgamertag" then
            if not Admin.HasGamerTag then
                Admin.HasGamerTag = true
                ToogleGamerTag()
            else
                Admin.HasGamerTag = false
                DestroyGamerTag()
            end

        elseif name == "admin_showblips" then
            Admin:CreateBlips()
            Admin.HasBlips = e.checkbox
        end
    end,


}
LoadModel = function(model)
    while not HasModelLoaded(model) do
        RequestModel(model)

        Citizen.Wait(1)
    end
end

local function OnBack(Data, lastMenu)
    if Data.currentMenu == "reportlist" then
        Admin:getReportList()
    end

end
local function OnSelected(menu, menuData, btnData, eg)
    local currentMenu = menuData.currentMenu
    local name = btnData.name:lower()
    if currentMenu == "admin_playerlist" then
        menuData.temp = btnData.source
        Admin.NameTarget = btnData.playerName
        Admin.IdTarget = btnData.source
        Admin.TargetInfo = btnData.data
        menu:OpenMenu("admin_playermenu")
    elseif currentMenu == "admin_weathermanager" then
        Utils.ShowLoadingPromptWithTime('Inizializing', 5000, 'BUSY_SPINNER_LEFT')
        TriggerServerEvent('core:weather:admin:changeWeather', Token, btnData.zone, btnData.slidename)
    elseif currentMenu == "admin_doorsmanager" then
        if btnData.slidenum == 1 and btnData.DoorsButton then
            SetEntityCoords(PlayerPedId(), btnData.DoorsData.coords)
        elseif btnData.slidenum == 2 then
            CloseMenu(true)
            TriggerServerEvent('core:doors:Delete', Token, btnData.id)
        end
    else
        if SelectedMenu[currentMenu] then
            SelectedMenu[currentMenu](menu, menuData, name, btnData, eg)
        end
    end
end

local function OnSlide(menu, menuData, btnData, slide)

end
local function onOpended()
    Admin.Players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(Admin.Players, { name = "[" .. GetPlayerServerId(player) .. "] - " .. GetPlayerName(player), source = GetPlayerServerId(player), temp = GetPlayerServerId(player)})
        Admin.NameTarget = GetPlayerName(player)
    end
    Admin.Banned = {}
    TriggerServerEvent('Freeroam:GetBan')

end

local function onExited()
    Admin.NameTarget = nil
end




Admin.Menu = {
    Base = {
        Header = {"commonmenu", "interaction_bgd"},
        Title = "ADMIN_TITLE",
        intX = 0.95,
        HeaderColor = { 40, 40, 40, 255 },
        Checkbox = { Icon =  { [0] = { "commonmenu", "shop_box_blank" }, [1] = { "commonmenu", "shop_box_tickb" }, [2] = { "commonmenu", "shop_box_tick" } } }
    },
    Data = {
        MaxPagination = 15,
        currentMenu = "MainMenu"
    },
    Events = {
        onSelected = OnSelected,
        onOpened = onOpended,
        onExited = onExited,
        onBack = OnBack,
        onSlide = OnSlide,
    },
    Menu = {
        ["MainMenu"] = {
            refresh = true,
            b = function()
                return {
                    { name = "ADMIN_TakeService", checkbox = Admin.isInService },
                    { name = "admin_playerlist", cantUse = not Admin.isInService},
                    { name = "ADMIN_Stafflist", cantUse = not Admin.isInService },
                    { name = "ADMIN_MyPlayer", cantUse = not Admin.isInService },
                    { name = "ADMIN_ManageReport", cantUse = not Admin.isInService },
                    { name = "admin_vehiclemanager", cantUse = not Admin.isInService },
                    { name = "ADMIN_NearbyManage", cantUse = not Admin.isInService },
                    { name = "admin_management", cantUse = not Admin.isInService },
                    { name = "ADMIN_preference", cantUse = not Admin.isInService },
                    { name = "admin_tools", cantUse = not Admin.isInService },

                }
            end
        },
        ['admin_vehiclemanager'] = {
            refresh = true,
            b = function()
                return {
                    {name = "admin_vehiclelist"},
                    {name = "admin_vehicle_create"},
                    {name = "admin_vehicle_repair", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true)},
                    {name = "admin_vehicle_deformationrepair", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true)},
                    {name = "admin_vehicle_fullrepair", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true)},
                    {name = "admin_vehicle_wash", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true)},
                    {name = "admin_vehicle_delete", cantUse = not IsPedInAnyVehicle(PlayerPedId(), true), colorFree = {205, 45, 45, 165}},
                }
            end
        },
        ['admin_vehiclelist'] = {
            refresh = true,
            refreshTime = 2000,
            b = function()
                local vehicleList = TriggerServerCallback("core:admin:GetVehicleNetwork", Token)
                local menu = {}
                for k,v in pairs(vehicleList) do
                    local dist = Utils.Round(#(GetEntityCoords(PlayerPedId()) - v.coords), 2)
                    table.insert(menu, {name = ('[~b~%s~s~] %sm'):format(v.plate, dist)})
                end
                return menu
            end
        },
        ['admin_playerlist'] = {
            useFilter = true,
            b = function()
                return Admin:getPlayerList()
            end
        },
        ['admin_playermenu'] = {
            refresh = true, 
            b = function()
                return {
                    {name = ("~r~[%s]~s~ %s"):format(Admin.IdTarget, Admin.NameTarget)}, 
                    {name = "admin_playermenu_sendmessage"},
                    {name = "admin_playermenu_teleport2player"},
                    {name = "admin_playermenu_teleport2me"},
                    {name = "admin_playermenu_teleport2camera", cantUse = not Admin.Cam},
                    {name = "admin_playermenu_bringback", cantUse = not Admin.BringCoords},
                    {name = "admin_playermenu_showinformation"},
                    {name = "admin_playermenu_screenshot"},
                    {name = "admin_playermenu_advertPlayer"},
                    {name = "admin_playermenu_advertmenu"},
                    {name = "admin_playermenu_notePlayer"},
                    {name = "admin_playermenu_notemenu"},
                    {name = "admin_playermenu_wipe", colorFree = {205, 45, 45, 165}},
                    {name = "admin_playermenu_kick", colorFree = {205, 45, 45, 165}},
                    {name = "admin_playermenu_ban", colorFree = {205, 45, 45, 165}},
                    
                }
            end
        },
        ['admin_playermenu_showinformation'] = {
            b = function()
                return {
                    {name = ("~r~[%s]~s~ %s"):format(Admin.IdTarget, Admin.NameTarget)}, 
                    {name = 'admin_information_uuid', ask = Admin.TargetInfo.id},
                    {name = 'admin_information_serverid', ask = Admin.IdTarget},
                    {name = 'admin_information_permission', ask = _PERMISSION_ROLE[Admin.TargetInfo.permission].label},
                    {name = 'admin_information_playerrpname', ask = ('%s %s'):format(Admin.TargetInfo.firstname, Admin.TargetInfo.lastname)},
                    {name = 'admin_information_bankcount', price = Admin.TargetInfo.banque},
                    {name = 'admin_information_job', ask = Admin.TargetInfo.job},
                    {name = 'admin_information_group', ask = ('(%s) %s'):format(Admin.TargetInfo.groupid, Admin.TargetInfo.group)},
                }
            end
        },
        ['admin_anticheatalert'] = {
            refresh = true,
            refreshTime = 2000,
            b = function()
            end
        },
        ['admin_management'] = {
            b = function()
                return {
                    {name = "admin_anticheatalert", canSee = function()
                        return true
                    end},
 
                    {name = "admin_coordsmanager", canSee = function()
                        return true
                    end},
                }
            end,
        },

        ["admin_coordsmanager"] = {
            b = {
                {name = "{x, y, z}", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}},
                {name = "{x = x, y = y, z = z}", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}},
                {name = "vector3(x, y, z)", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}},
                {name = "vector4(x, y, z, w)", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}},
                {name = "vector2(x, y)", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}},
                {name = "heading", slidemax = {'ADMIN_COORDS_COPY', 'ADMIN_COORDS_PRINT'}}
            }
        },
        ["admin_tools"] = {
            b = {
                {name = "admin_teleportpoint"},
                {name = "admin_showgamertag", checkbox = Admin.HasGamerTag},
                {name = "admin_showblips", checkbox = Admin.HasBlips},

            }
        },

        ["admin_register_doors"] = {
            refresh = true,
            b = {
                    {name = "ADMIN_DOORS_LABEL", ask = ""},
                    {name = "ADMIN_DOORS_COORDS", ask = "", askX = true, Description = ('Data Doors: %s'):format(json.encode(_MANAGER.DOORS.ADMIN.creator_data.doors))},
                    {name = "ADMIN_DOORS_DISTANCE", ask = ""},
                    {name = "ADMIN_DOORS_LOCKED", checkbox = function() return _MANAGER.DOORS.ADMIN.creator_data.DefaultLockStatus end},
                    {name = "ADMIN_DOORS_USEPIN", checkbox = function() return _MANAGER.DOORS.ADMIN.UsePin end},
                    {name = "ADMIN_DOORS_PIN", ask = "1234", canSee = function() return _MANAGER.DOORS.ADMIN.UsePin end},
                    {name = "ADMIN_DOORS_USEJOB", checkbox = function() return _MANAGER.DOORS.ADMIN.UseJob end},
                    {name = "ADMIN_DOORS_JOB", slidemax = {'ADMIN_DOORS_ADD_SLIDE'}, canSee = function() return _MANAGER.DOORS.ADMIN.UseJob end, Description = ('Whitelist Job: %s'):format(_MANAGER.DOORS.ADMIN.String_Job)},
                    {name = "ADMIN_DOORS_Confirm" , colorFree = {45, 119, 205, 165}, askX = true, ask = ""}, 
            }
            
            
        },

    }
}

RegisterKeyMapping("spec", "Mode Spectate", "keyboard", "O")
RegisterCommand("spec", function()
    if Admin.PlyGroup >= _PERMISSION['SPECTATE'] then
        Admin:Spectate()
    end
end)

RegisterKeyMapping("menuadmin", "Menu Admin", "keyboard", "F4")
RegisterCommand("menuadmin", function()
    if Admin.PlyGroup >= _PERMISSION['ADMINMENU'] then
        CreateMenu(Admin.Menu)
    end
end)
