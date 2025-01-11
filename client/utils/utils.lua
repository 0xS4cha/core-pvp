local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}


local SetTextScale = SetTextScale
local SetTextFont = SetTextFont
local SetTextColour = SetTextColour
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local SetTextCentre = SetTextCentre
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local SetTextJustification = SetTextJustification
local EndTextCommandDisplayText = EndTextCommandDisplayText
local SetScriptGfxAlignParams = SetScriptGfxAlignParams
local SetDrawOrigin = SetDrawOrigin
local ResetScriptGfxAlign = ResetScriptGfxAlign
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin
local DoesEntityExist = DoesEntityExist
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local IsEntityAPed = IsEntityAPed
local GetEntityCoords = GetEntityCoords

local SetTextScale = SetTextScale
local SetTextFont = SetTextFont
local SetTextColour = SetTextColour
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local SetTextCentre = SetTextCentre
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local SetTextJustification = SetTextJustification
local EndTextCommandDisplayText = EndTextCommandDisplayText
local SetScriptGfxAlignParams = SetScriptGfxAlignParams
local SetDrawOrigin = SetDrawOrigin
local ResetScriptGfxAlign = ResetScriptGfxAlign
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin



Utils = Utils or {}
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function Utils.EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function Utils.EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function Utils.EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function Utils.EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end



function Utils.GetAllEnumerators()
    return { vehicles = EnumerateVehicles, objects = EnumerateObjects, peds = EnumeratePeds, pickups = EnumeratePickups }
end


function Utils.GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function Utils.GetClosestVehicle(coords)
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local playerPed = GetPlayerPed(-1)
	local coords = coords
	if coords == nil then
		coords = GetEntityCoords(playerPed)
	end

	for k, v in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = v
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function Utils.GetClosestVehicleNoCoords()
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local playerPed = GetPlayerPed(-1)
	local coords = coords
	if coords == nil then
		coords = GetEntityCoords(playerPed)
	end

	for k, v in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = v
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function Utils.GetClosestPlayer()
	local pPed = GetPlayerPed(-1)
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k, v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

function Utils.GetAllPlayersInArea(coords, zone)
	local playersInArea = {}
	if zone == nil then
		zone = 150.0
	end
	for k, v in pairs(GetActivePlayers()) do
		local pPed = GetPlayerPed(v)
		local pCoords = GetEntityCoords(pPed)
		if GetDistanceBetweenCoords(pCoords, coords, false) <= zone then
			table.insert(playersInArea, v)
		end
	end
	return playersInArea
end

function Utils.GetAllVehicleInArea(coords, zone)
	local playersInArea = {}
	if zone == nil then
		zone = 150.0
	end
	for k, v in pairs(GetVehicles()) do
		local pCoords = GetEntityCoords(v)
		if GetDistanceBetweenCoords(pCoords, coords, false) <= zone then
			table.insert(playersInArea, v)
		end
	end
	return playersInArea
end

function closeUI()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end

function Utils.isJson(data)
	if type(data) == 'string' then
		return json.decode(data)
	end
	return data
end

function Utils.ChoicePlayersInZone(range, choiceSelfPlayer)
	Utils.ShowNotification("Appuyer sur ~g~E~s~ pour valider\nAppuyer sur ~b~L~s~ pour changer de cible\nAppuyer sur ~r~X~s~ pour annuler")

	if choiceSelfPlayer == nil then
		choiceSelfPlayer = true
	end
	local timer = GetGameTimer() + 10000
	local inChoice = true
	local selectedPlayer = 1

	local players = GetAllPlayersInArea(p:pos(), range)
	if choiceSelfPlayer == false then
		for k, v in pairs(players) do
			if v == PlayerId() then
				table.remove(players, k)
			end
		end
	end
	if #players == 0 then
		-- New notif
		Utils.ShowNotification("~r~Aucun joueur dans la zone")

		inChoice = false
		return nil
	else
		-- New notif
		Utils.ShowNotification("Appuyer sur ~g~E~s~ pour valider\nAppuyer sur ~b~L~s~ pour changer de cible\nAppuyer sur ~r~X~s~ pour annuler")
		
	end

	while inChoice do
		local players = GetAllPlayersInArea(p:pos(), range)
		if choiceSelfPlayer == false then
			for k, v in pairs(players) do
				if v == PlayerId() then
					table.remove(players, k)
				end
			end
		end
		if #players == 0 then
			Utils.ShowNotification("~r~Aucun joueur dans la zone")


			inChoice = false
			return nil
		end
		local mCoors = GetEntityCoords(GetPlayerPed(players[selectedPlayer]))
		DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255 , 120, 0, 1, 2, 0, nil, nil, 0)
		if GetGameTimer() > timer then
			Utils.ShowNotification("~r~Le délai est dépassé")


			inChoice = false
			return nil
		elseif IsControlJustPressed(0, 51) then -- E
			inChoice = false
			return players[selectedPlayer]
		elseif IsControlJustPressed(0, 182) then -- L
			timer = GetGameTimer() + 10000
			selectedPlayer = selectedPlayer + 1
		elseif IsControlJustPressed(0, 73) then -- X

			Utils.ShowNotification("~r~Vous avez annulé")
			


			inChoice = false
			return nil
		elseif selectedPlayer > #players then
			selectedPlayer = 1
		end
		Wait(0)
	end
end

function Utils.DisplayClosetVeh()
	local pCloset = GetClosestVehicle()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(pCloset)
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1
			, 2, 0, nil, nil, 0)
	end
end

function Utils.DisplayClosetPlayer()
	local pPed = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestPlayer()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(GetPlayerPed(pCloset))
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1
			, 2, 0, nil, nil, 0)
	end
end

GlobalBlockWeaponsKeys = false

function Utils.KeyboardImput(text)
	local amount = nil
	AddTextEntry("CUSTOM_AMOUNT", text)
	DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 255)
	GlobalBlockWeaponsKeys = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(1)
	end
	GlobalBlockWeaponsKeys = false
	if UpdateOnscreenKeyboard() ~= 2 then
		amount = GetOnscreenKeyboardResult()
		Citizen.Wait(1)
	else
		Citizen.Wait(1)
	end
	return amount
end

function Utils.DrawText3D(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 210)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

function Utils.LoadModel(model)
	local models
	if models == model then
		models = model
	else
		models =  GetHashKey(model)
	end

	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	end
	SetModelAsNoLongerNeeded(model)
	return models
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function Utils.RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x,
		destination.y, destination.z, 1, p:ped(), 1))
	return b, c, e
end

function Utils.RayCastGamePlayCameraEntity(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x,
		destination.y, destination.z, -1, p:ped(), 0))
	return b, c, e
end

function Utils.ShowNotification(text, beep)
	if beep then
		PlaySoundFrontend(-1, 'Goon_Paid_Small', 'GTAO_Boss_Goons_FM_Soundset', false)
	end
	text = text:gsub("^%l", string.upper)
	AddTextEntry('core:notif', text)
	BeginTextCommandThefeedPost('core:notif')
	AddTextComponentSubstringPlayerName(text)
	return EndTextCommandThefeedPostTicker(true, true)
end

function Utils.ShowNotificationWithButton(button, message, back, ...)
	PlaySoundFrontend(-1, 'Goon_Paid_Small', 'GTAO_Boss_Goons_FM_Soundset', false)
	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("jamyfafi")
	return EndTextCommandThefeedPostReplayInput(1, button, GetPhrase(message, ...))
end



function Utils.DrawTopNotificationWithTime(message, beep, time, ...)
	AddTextEntry("SHOP_JUGG_NONE", GetPhrase(message, ...))
	BeginTextCommandDisplayHelp("SHOP_JUGG_NONE")
	EndTextCommandDisplayHelp(0, false, beep, time or -1)
end
function ShowLoadingPrompt(showText, showType, ...)
	BeginTextCommandBusyspinnerOn("STRING")
	AddTextComponentSubstringPlayerName(GetPhrase(showText, table.unpack({...})))
	EndTextCommandBusyspinnerOn(showType)
end

function RemoveLoadingPrompt()
	BusyspinnerOff()
end


function DrawTopNotification(message, beep, ...)
	AddTextEntry("SHOP_JUGG_NONE", GetPhrase(message, ...))
	BeginTextCommandDisplayHelp("SHOP_JUGG_NONE")
	EndTextCommandDisplayHelp(0, false, beep, -1)
end

function Utils.ShowLoadingPromptWithTime(showText, showTime, showType)
	Citizen.CreateThread(function()
		ShowLoadingPrompt(showText, showType)
		Citizen.Wait(showTime)
		RemoveLoadingPrompt()
	end)
end

function Utils.ShowNotificationWithButtonWithDuration(button, message, back, duration, ...)
	local id = Utils.ShowNotificationWithButton(button, message, back, ...)
	SetTimeout(duration or 5000, function() RemoveNotification(id) end)
end

function Utils.ShowHelpNotification(msg, beep)
	local beep = beep
	if beep == nil then
		beep = false
	end
	AddTextEntry('core:HelpNotif', msg)
	BeginTextCommandDisplayHelp('core:HelpNotif')
	EndTextCommandDisplayHelp(0, false, false, 1)
end
exports("ShowNotification", function (msg)
	Utils.ShowNotification(msg)
end)
exports("ShowHelpNotification", function (msg)
	Utils.ShowHelpNotification(msg)
end)
function Utils.ShowAdvancedNotification(title, subtitle, msg, img1, img2)
	AddTextEntry('core:AdvancedNotif', msg)
	BeginTextCommandThefeedPost('core:AdvancedNotif')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostMessagetext(img1, img2, 1, 0, title, subtitle)
	EndTextCommandThefeedPostTicker(false, true)
end

function Utils.TeleportPlayer(coords)
	local pPed = PlayerPedId()
	local x, y, z = coords.x, coords.y, coords.z or coords.z + 1.0

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local sceneLoadTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - sceneLoadTimer > 2000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(pPed, x, y, z)
	sceneLoadTimer = GetGameTimer()

	while not HasCollisionLoadedAroundEntity(pPed) do
		if GetGameTimer() - sceneLoadTimer > 2000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ = GetGroundZFor_3dCoord(x, y, z, 0, 0)
	if foundNewZ and newZ > 0 then
		z = newZ
	end

	SetEntityCoordsNoOffset(pPed, x, y, z)
	NewLoadSceneStop()

	return true
end

function Utils.Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

-- credit http://richard.warburton.it
function Utils.GroupDigits(value)
	local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. _U('locale_digit_grouping_symbol')):reverse()) .. right
end

function Utils.Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function Utils.LoadDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
end

-- Events

RegisterNetEvent("core:ShowNotification")
AddEventHandler("core:ShowNotification", function(text)
	Utils.ShowNotification(text)
end)

RegisterNetEvent("core:ShowAdvancedNotification")
AddEventHandler("core:ShowAdvancedNotification", function(title, subtitle, msg, img1, img2)
	Utils.ShowAdvancedNotification(title, subtitle, msg, img1, img2)
end)

-- Loops

Citizen.CreateThread(function()
	LoadMpDlcMaps()
	SetInstancePriorityMode(true)
	OnEnterMp()
end)

local islandVec = vector3(4840.571, -5174.425, 2.0)
local isOnIsland = false
Citizen.CreateThread(function()
	while true do
		local pCoords = GetEntityCoords(GetPlayerPed(-1))
		local distance1 = #(pCoords - islandVec)
		if distance1 < 2000.0 then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true) -- load the map and removes the city
			Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map

			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
			Citizen.InvokeNative(0x53797676AD34A9AA, false)
			SetScenarioGroupEnabled('Heist_Island_Peds', true)

			SetAudioFlag('PlayerOnDLCHeist4Island', true)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
			SetZoneEnabled(59, false)
			isOnIsland = true

		else
			--if isOnIsland then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
			Citizen.InvokeNative("0x5E1460624D194A38", false)

			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
			Citizen.InvokeNative(0x53797676AD34A9AA, true)
			SetScenarioGroupEnabled('Heist_Island_Peds', false)

			SetAudioFlag('PlayerOnDLCHeist4Island', false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
			isOnIsland = false
			--end
		end
		Citizen.Wait(1000)
	end
end)

CreateThread(function()
	while p == nil do Wait(100) end
	while true do
		Wait(500)
		if p:isInVeh() then
			SetVehicleHandlingFloat(p:currentVeh(), "CHandlingData", "fLowSpeedTractionLossMult", 0.0)
		else
			Wait(1500)
		end
	end
end)

TriggerServerCallback = function(eventName, ...)
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))

	local p = promise.new()
	local ticket = GetGameTimer()

	RegisterNetEvent(('__pmc_callback:client:%s:%s'):format(eventName, ticket))
	local e = AddEventHandler(('__pmc_callback:client:%s:%s'):format(eventName, ticket), function(...)
		p:resolve({ ... })
	end)

	TriggerServerEvent('__pmc_callback:server', eventName, ticket, ...)

	local result = Citizen.Await(p)
	RemoveEventHandler(e)
	return table.unpack(result)
end
exports("TriggerServerCallback", function(eventName, ...)
	return TriggerServerCallback(eventName, ...)
end)
RegisterClientCallback = function(eventName, fn, ...)
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
	assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

	AddEventHandler(('c__pmc_callback:%s'):format(eventName), function(cb, ...)
		cb(fn(...))
	end)
end

RegisterNetEvent('__pmc_callback:client', function(eventName, ...)
	local p = promise.new()

	TriggerEvent(('c__pmc_callback:%s'):format(eventName), function(...)
		p:resolve({ ... })
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(('__pmc_callback:server:%s'):format(eventName), table.unpack(result))
end)

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

function Utils.DrawTexts(x, y, text, center, scale, rgb, font)
	SetTextFont(font)
	SetTextScale(scale, scale)

	SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
	SetTextEntry("STRING")
	SetTextCentre(center)
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end

function Utils.PlayEmote(dict, anim, flag, duration)
	--[[
		FLAGS
		0 = NORMAL
		1 = REPEAT
		2 = STOP LAST FRAME
		16 = UPPERBODY
		32 = ENABLE PLAYER CONTROL
		120 = CANCELABLE
	]]
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, 1.0, duration, flag or 32, 1.0, 0, 0, 0)
	RemoveAnimDict(dict)
end

----loadStreamTexture

-- function LoadStreamTexture()
-- 	local Texture = {"4life","ui_market", "ui_concess", "ui_autoecole", "ui_armurerie"}
-- 	Citizen.CreateThread(function()
-- 		for k,v in pairs(Texture) do while not HasStreamedTextureDictLoaded(v)  do Wait(100) RequestStreamedTextureDict(v, true) print(v) end end
-- 	end)
-- end

-- LoadStreamTexture()


-- function isMouseOnButton(position, buttonPos, widthandheight)

-- 	return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + widthandheight.width and position.y < buttonPos.y + widthandheight.height

-- end


function Utils.LoadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function Utils.SecondsToClock(ms)
	local seconds = math.floor(ms / 1000)
	local mseconds = math.fmod(ms, 1000);

	if seconds <= 0 then
		return "00:00:00";
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600));
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
		local msecs = string.format("%02.f", math.floor(mseconds));
		return mins, secs, msecs
	end
end

--[[local function getEntityMatrix(element)
    local rot = GetEntityRotation(element) -- ZXY
    local rx, ry, rz = rot.x, rot.y, rot.z
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1
    
    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1
	
    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1
	
    matrix[4] = {}
    local pos = GetEntityCoords(element)
    matrix[4][1], matrix[4][2], matrix[4][3] = pos.x, pos.y, pos.z - 1.0
    matrix[4][4] = 1
	
    return matrix
end

function GetOffsetFromEntityInWorldCoords(entity, offX, offY, offZ)
    local m = getEntityMatrix(entity)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return vector3(x, y, z)
end
]]
function Utils.RealRandom(x, y)
	math.randomseed(GetGameTimer())
	return math.random(x, y)
end

function Utils.CompareMetadatas(t1, t2)
    -- Compare each entry of table t1 with the same entry of table t2
    -- If entry is a table, recursively call this function
    -- If t1 entry is not the same as t2 entry, return false
    -- If tables are not exactly the same, return false

    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end

    for k,v in pairs(t1) do
        if type(v) == "table" then
            if not CompareMetadatas(v, t2[k]) then
                return false
            end
        else
			print(v, t2[k])
            if v ~= t2[k] then
                return false
            end
        end
    end
	return true
end

local function DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext) -- Créer un text 2D a l'écran
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text,Text+.1)
    end;
    AddTextComponentString(Text2)
    DrawText(Text,Text3)
end
-- Progres bars
local HaveProgress
function ProgressBarExists() -- Si une barre de progression existe
    return HaveProgress 
end

local petitpoint = {".","..","...",""}
function ProgressBar(Text, r, g, b, a, Timing, NoTiming) -- Créer une progress bar
    if not Timing then 
        return 
    end
    RemoveProgressBar()
    HaveProgress = true
    Citizen.CreateThread(function()
        local Timing1, Timing2 = .0, GetGameTimer() + Timing
        local E, Timing3 = ""
        while HaveProgress and (not NoTiming and Timing1 < 1) do
            Citizen.Wait(0)
            if not NoTiming or Timing1 < 1 then 
                Timing1 = 1-((Timing2 - GetGameTimer())/Timing)
            end
            if not Timing3 or GetGameTimer() >= Timing3 then
                Timing3 = GetGameTimer()+500;
                E = petitpoint[string.len(E)+1] or ""
            end;
            DrawRect(.5,.875,.15,.03,0,0,0,100)
            local y, endroit=.15-.0025,.03-.005;
            local chance = math.max(0,math.min(y,y*Timing1))
            DrawRect((.5-y/2)+chance/2,.875,chance,endroit,r,g,b,a) -- 0,155,255,125
            DrawTextScreen(.5,.875-.0125,.3,(Text or"Action en cours")..E,0,0,false)
        end;
        RemoveProgressBar()
    end)
end

function RemoveProgressBar() -- Delete les progress bar
    HaveProgress = nil 
end


function SetScaleformParams(scaleform, data) -- Set des éléments dans un scalform
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end
function CreateScaleform(name, data) -- Créer un scalform
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

function Utils.GetControlLabel(controlName, blIncludeTT)
	local inputName = string.format("INPUT_%08X", GetHashKey(controlName) & 0xFFFFFFFF)

	return blIncludeTT and ("~" .. inputName .. "~") or inputName
end

function Utils.DoesFileExist(file) 
    local fileHandle = LoadResourceFile(file, "r")
	print(fileHandle)
    if fileHandle then
        io.close(fileHandle)
        return true
    else
        return false
    end
end

function Utils.tableToString(tbl, separator)
    separator = separator or ", " -- Définit le séparateur par défaut
    return table.concat(tbl, separator)
end

function Utils.getNet(entity)
    return NetworkGetNetworkIdFromEntity(entity)
end

function Utils.getEntity(netID)
    return NetworkGetEntityFromNetworkId(netID)
end

function Utils.getTrunkOffset(entity)
    local min, _ = GetModelDimensions(GetEntityModel(entity))
    return GetOffsetFromEntityInWorldCoords(entity, 0.0, min.y - 0.5, 0.0)
end


function Utils.getNearbyObjects(coords, maxDistance)
	local objects = GetGamePool('CObject')
	local nearby = {}
	local count = 0
	maxDistance = maxDistance or 2.0

	for i = 1, #objects do
		local object = objects[i]

        local objectCoords = GetEntityCoords(object)
        local distance = #(coords - objectCoords)

        if distance < maxDistance then
            count += 1
            nearby[count] = {
                object = object,
                coords = objectCoords
            }
        end
	end

	return nearby
end

function Utils.getNearbyVehicles(coords, maxDistance, includePlayerVehicle)
	local vehicles = GetGamePool('CVehicle')
	local nearby = {}
	local count = 0
	maxDistance = maxDistance or 2.0

	for i = 1, #vehicles do
		local vehicle = vehicles[i]

		if not GetVehiclePedIsIn(PlayerPedId(), false) or vehicle ~= GetVehiclePedIsIn(PlayerPedId(), false) or includePlayerVehicle then
			local vehicleCoords = GetEntityCoords(vehicle)
			local distance = #(coords - vehicleCoords)

			if distance < maxDistance then
				count += 1
				nearby[count] = {
					vehicle = vehicle,
					coords = vehicleCoords
				}
			end
		end
	end

	return nearby
end
function Utils.getOptionsWidth(options)
    if IsDuplicityVersion() then
        Console.Error('This function is not available on server side')
        return
    end
    local width = 0.0
    for _, data in ipairs(options) do
        local factor = (string.len(data.label)) / 370
        local newWidth = 0.03 + factor

        if newWidth > width then
            width = newWidth
        end
    end

    return width
end


function Utils.getCoordsFromInteract(interaction)
    if interaction.entity then
        if DoesEntityExist(interaction.entity) then
            if interaction.bone then
                return GetEntityBonePosition_2(interaction.entity, GetEntityBoneIndexByName(interaction.entity, interaction.bone))
            elseif interaction.model then
                return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
            else
                if IsEntityAPed(interaction.entity) then
                    if interaction.offset and interaction.offset ~= vec3(0.0, 0.0, 0.0) then
                        return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
                    end
                    return GetEntityBonePosition_2(interaction.entity, 0) -- SKEL_ROOT
                else
                    if interaction.offset and interaction.offset ~= vec3(0.0, 0.0, 0.0) then
                        return GetOffsetFromEntityInWorldCoords(interaction.entity, 0.0 + interaction.offset.x, 0.0 + interaction.offset.y, 0.0 + interaction.offset.z)
                    end
                    return GetEntityCoords(interaction.entity)
                end
            end
        end
    end

    return vec3(0.0, 0.0, 0.0)
end


function Utils.SpawnVehicle(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	if not IsModelValid(model) or not IsModelInCdimage(model) then Utils.ShowNotification("~r~Ce modèle de véhicule n'éxiste pas ("..model.." / "..modelName..")") return end

	local ped = PlayerPedId()
	LoadModel(model)
	local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false, 3)
	local id = NetworkGetNetworkIdFromEntity(vehicle)
	SetNetworkIdCanMigrate(id, true)
	SetEntityAsMissionEntity(vehicle, true, false)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
	SetVehicleOnGroundProperly(vehicle)
	SetModelAsNoLongerNeeded(model)
	SetVehicleRadioLoud(vehicle, true)
	SetDisableVehiclePetrolTankFires(vehicle, true)
	SetVehicleCanLeakOil(vehicle, true)
	SetVehicleCanLeakPetrol(vehicle, true)

	local maxFuel = math.floor(GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume"))
	SetVehicleFuelLevel(vehicle, math.floor(maxFuel / 2) + 0.0)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	while not HasCollisionLoadedAroundEntity(vehicle) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end
	return vehicle
end

function Utils.drawOption(coords, text, spriteDict, spriteName, row, width, showDot)
    SetScriptGfxAlignParams((showDot == true and 0.03 or 0.018) + (width / 2), row * 0.03 - 0.0125, 0.0, 0.0)
    SetTextScale(0, 0.3)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 255)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextJustification(0)
    EndTextCommandDisplayText(0.0, 0.0)
    ResetScriptGfxAlign()

    SetScriptGfxAlignParams((showDot == true and 0.03 or 0.018) + (width / 2), row * 0.03 - 0.015, 0.0, 0.0)
    DrawSprite(spriteDict, spriteName, 0.0, 0.014, width, 0.025, 0.0, 255, 255, 255, 255)
    ResetScriptGfxAlign()

    if showDot then
        local newSpritename = spriteName == _INTERACT.Textures.selected and _INTERACT.Textures.select_opt or _INTERACT.Textures.unselect_opt
        SetScriptGfxAlignParams(0.018, row * 0.03 - 0.015, 0.0, 0.0)
        DrawSprite(spriteDict, newSpritename, 0.0, 0.014, 0.01, 0.02, 0.0, 255, 255, 255, 255)
        ResetScriptGfxAlign()
    end

    ClearDrawOrigin()
end







function Utils.table_deepclone(tbl)
    tbl = table.clone(tbl)

    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            tbl[k] = Utils.table_deepclone(v)
        end
    end

    return tbl
end




-- Blips

function Utils.CreateBlipCircle(coords, text, radius, color, sprite)
    local blip = AddBlipForRadius(coords, radius)

    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 2)
    SetBlipAlpha (blip, 128)


    blip = AddBlipForCoord(coords)
    SetBlipHighDetail(blip, true)
    SetBlipSprite (blip, sprite)
    SetBlipScale  (blip, 0.5)
    SetBlipColour (blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

function Utils.CreateBlips(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale, intDisplay, intAlpha, Title, Image, InfoName, Texts, InfoText, Header) -- Créer un blips
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
    if Title then
        SetBlipInfoTitle(blip, Title, false)
    end
    if Image then
        RequestStreamedTextureDict(Image[1], 1)
        while not HasStreamedTextureDictLoaded(Image[1]) do
            Wait(0)
        end
    
        SetBlipInfoImage(blip, Image[1], Image[2])
    end
    if InfoName then
        AddBlipInfoName(blip, InfoName[1], InfoName[2])
    end
    if Texts then
        for k, v in pairs (Texts) do
            AddBlipInfoText(blip, v[1], v[2])
        end
    end
    if InfoText then
        AddBlipInfoText(blip, InfoText)
    end
    if Header then
        AddBlipInfoHeader(blip, "") 
    end
	return blip
end

function GetAllBlipsWithSprite(spriteId) -- Get Des blips
	local blip = GetFirstBlipInfoId(spriteId)
	if blip == 0 then return {} end

	local allBlips = {}
	local nextBlip = blip

	while nextBlip ~= 0 do
		allBlips[#allBlips + 1] = nextBlip
		nextBlip = GetNextBlipInfoId(spriteId)
	end

	return allBlips
end

-- BLIPS INFOS
local BLIP_INFO_DATA = {}

--[[
    Default state for blip info
]]

function ensureBlipInfo(blip)
    if blip == nil then blip = 0 end
    SetBlipAsMissionCreatorBlip(blip, true)
    if not BLIP_INFO_DATA[blip] then BLIP_INFO_DATA[blip] = {} end
    if not BLIP_INFO_DATA[blip].title then BLIP_INFO_DATA[blip].title = "" end
    if not BLIP_INFO_DATA[blip].rockstarVerified then BLIP_INFO_DATA[blip].rockstarVerified = false end
    if not BLIP_INFO_DATA[blip].info then BLIP_INFO_DATA[blip].info = {} end
    if not BLIP_INFO_DATA[blip].money then BLIP_INFO_DATA[blip].money = "" end
    if not BLIP_INFO_DATA[blip].rp then BLIP_INFO_DATA[blip].rp = "" end
    if not BLIP_INFO_DATA[blip].dict then BLIP_INFO_DATA[blip].dict = "" end
    if not BLIP_INFO_DATA[blip].tex then BLIP_INFO_DATA[blip].tex = "" end
    return BLIP_INFO_DATA[blip]
end

--[[
    Export functions, use these via an export pls
]]

function ResetBlipInfo(blip)
    BLIP_INFO_DATA[blip] = nil
end

function SetBlipInfoTitle(blip, title, rockstarVerified)
    local data = ensureBlipInfo(blip)
    data.title = title or ""
    data.rockstarVerified = rockstarVerified or false
end

function SetBlipInfoImage(blip, dict, tex)
    local data = ensureBlipInfo(blip)
    data.dict = dict or ""
    data.tex = tex or ""
end

function SetBlipInfoEconomy(blip, rp, money)
    local data = ensureBlipInfo(blip)
    data.money = tostring(money) or ""
    data.rp = tostring(rp) or ""
end

function SetBlipInfo(blip, info)
    local data = ensureBlipInfo(blip)
    data.info = info
end

function AddBlipInfoText(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    if rightText then
        table.insert(data.info, {1, leftText or "", rightText or ""})
    else
        table.insert(data.info, {5, leftText or "", ""})
    end
end

function AddBlipInfoName(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {3, leftText or "", rightText or ""})
end

function AddBlipInfoHeader(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {4, leftText or "", rightText or ""})
end

function AddBlipInfoIcon(blip, leftText, rightText, iconId, iconColor, checked)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {2, leftText or "", rightText or "", iconId or 0, iconColor or 0, checked or false})
end


-- Scalforms
function SetScaleformParams(scaleform, data) -- Set des éléments dans un scalform
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end
function CreateScaleform(name, data) -- Créer un scalform
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end
function Utils.Instructions(instructions, cam) -- Mettre une instruction (scalform)
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(1) end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

	local counter = 0
    for _, instruction in pairs(instructions) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(counter)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, instruction.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(instruction.message)
        EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		counter = counter + 1
	end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

function DrawTexts(x, y, text, center, scale, rgb, font)
	SetTextFont(font)
	SetTextScale(scale, scale)

	SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
	SetTextEntry("STRING")
	SetTextCentre(center)
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end

function PlayEmote(dict, anim, flag, duration)
	--[[
		FLAGS
		0 = NORMAL
		1 = REPEAT
		2 = STOP LAST FRAME
		16 = UPPERBODY
		32 = ENABLE PLAYER CONTROL
		120 = CANCELABLE
	]]
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, 1.0, duration, flag or 32, 1.0, 0, 0, 0)
	RemoveAnimDict(dict)
end



function TeleportTopCoords(pos, ent, trustPos) -- TP Un joueur (Sans bug de collision)
	if not pos or not pos.x or not pos.y or not pos.z or (ent and not DoesEntityExist(ent)) then return true end
	local x, y, z = pos.x, pos.y, pos.z + 1.0
	ent = ent or GetPlayerPed(-1)

	RequestCollisionAtCoord(x, y, z)
	--NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local tempTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(ent, x, y, z)

	tempTimer = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(ent) do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ
	if not trustPos then
		foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
		tempTimer = GetGameTimer()
		while not foundNewZ do
			z = z + 10.0
			foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
			Wait(0)

			if GetGameTimer() - tempTimer > 2000 then
				break
			end
		end
	end

	Utils.LastCoords = vector3(x, y, foundNewZ and newZ or z)
	SetEntityCoordsNoOffset(ent, x, y, foundNewZ and newZ or z)
	--NewLoadSceneStop()
	
	if type(pos) ~= "vector3" and pos.w then SetEntityHeading(ent, pos.w) end
	return true
end

local done
function Utils.GoPlayerToPos(pos, ent) -- TP Un joueur (Sans bug de collision) avec Cinématique
	Utils.LastCoords = pos
	done = true
	Citizen.Wait(100)
	done = TeleportTopCoords(pos, ent)
	while not done do
		Citizen.Wait(0)
	end

end