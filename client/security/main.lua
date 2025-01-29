local token = nil
AlertANTICHEAT = {}
local tokenAcces = {
    ["core"] = 500,
}
local AntiStop = {
    ['core'] = true
}
AddEventHandler("core:RequestTokenAcces", function(ressource, cb)
    while token == nil do Wait(100) end
    local granted = false
    if tokenAcces[ressource] ~= nil then
        if tokenAcces[ressource] > 0 then
            granted = true
            tokenAcces[ressource] = tokenAcces[ressource] - 1
            cb(token)
        end
    end

    if not granted then
        TriggerServerEvent("core:WrongTokenRequest", ressource)
    end
end)

LastTimePlayer = 0

function PrioEvent()
    LastTimePlayer += 1
    Wait(150*LastTimePlayer)
    return true
end

substitutionTable = {          
    ["a"] = "8", ["b"] = "@", ["c"] = "#", ["d"] = "4",
    ["e"] = "1", ["f"] = "!", ["g"] = "9", ["h"] = "0",
    ["i"] = "2", ["j"] = "&", ["k"] = "3", ["l"] = "$",
    ["m"] = "5", ["n"] = "%", ["o"] = "7", ["p"] = "*",
    ["q"] = "6", ["r"] = "(", ["s"] = ")", ["t"] = "-",
    ["u"] = "_", ["v"] = "+", ["w"] = "=", ["x"] = "[",
    ["y"] = "]", ["z"] = "{",
    
    ["A"] = "Q", ["B"] = "W", ["C"] = "E", ["D"] = "R",
    ["E"] = "T", ["F"] = "Y", ["G"] = "U", ["H"] = "I",
    ["I"] = "O", ["J"] = "P", ["K"] = "A", ["L"] = "S",
    ["M"] = "D", ["N"] = "F", ["O"] = "G", ["P"] = "H",
    ["Q"] = "J", ["R"] = "K", ["S"] = "L", ["T"] = "Z",
    ["U"] = "X", ["V"] = "C", ["W"] = "V", ["X"] = "B",
    ["Y"] = "N", ["Z"] = "M",
    
    ["0"] = "t", ["1"] = "u", ["2"] = "v", ["3"] = "w",
    ["4"] = "x", ["5"] = "y", ["6"] = "z", ["7"] = "a",
    ["8"] = "b", ["9"] = "c",
    
    [" "] = " ", ["_"] = "?"
}

function _TRGSE(input)
    local encrypted = ""
    for i = 1, #input do
        local char = input:sub(i, i)
        local encryptedChar = substitutionTable[char] or char
        encrypted = encrypted .. encryptedChar
    end
    return encrypted
end



function TriggerSecurEvent(name, ...) -- Utilsier cette event
    if PrioEvent() then
        local time, idPlayer  = tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId()))
        local message = _TRGSE(time..idPlayer)
        LastTimePlayer -= 1
        TriggerServerEvent(name, time, message, ...)
    end
end
weaponsNames = {
	'WEAPON_DAGGER',
	'WEAPON_BAT',
	'WEAPON_BOTTLE',
	'WEAPON_CROWBAR',
	'WEAPON_UNARMED',
	'WEAPON_FLASHLIGHT',
	'WEAPON_GOLFCLUB',
	'WEAPON_HAMMER',
	'WEAPON_HATCHET',
	'WEAPON_KNUCKLE',
	'WEAPON_KNIFE',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_WRENCH',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_STONE_HATCHET',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_STUNGUN',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_DOUBLEACTION',
	'WEAPON_RAYPISTOL',
	'WEAPON_CERAMICPISTOL',
	'WEAPON_NAVYREVOLVER',
	'WEAPON_GADGETPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_SMG_MK2',
	'WEAPON_ASSAULTSMG',
	'WEAPON_COMBATPDW',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_MINISMG',
	'WEAPON_RAYCARBINE',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_MUSKET',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMBATSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_ASSAULTRIFLE_MK2',
	'WEAPON_CARBINERIFLE',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_SPECIALCARBINE_MK2',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_BULLPUPRIFLE_MK2',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MILITARYRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_COMBATMG_MK2',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_HEAVYSNIPER_MK2',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_MARKSMANRIFLE_MK2',
	'WEAPON_RPG',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_GRENADELAUNCHER_SMOKE',
	'WEAPON_MINIGUN',
	'WEAPON_FIREWORK',
	'WEAPON_RAILGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_RAYMINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_STICKYBOMB',
	'WEAPON_PROXMINE',
	'WEAPON_SNOWBALL',
	'WEAPON_PIPEBOMB',
	'WEAPON_BALL',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_FLARE',
	'WEAPON_PETROLCAN',
	'WEAPON_FIREEXTINGUISHER',
	'WEAPON_HAZARDCAN'
}

weaponHashes = {}

for k,v in pairs(weaponsNames) do
	weaponHashes[GetHashKey(v)] = v
end





local function GeneratePlayerToken()
    local token = math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009)
    return token
end

Citizen.CreateThread(function()
    while p == nil do
        Wait(100)
    end
    local t = GeneratePlayerToken()
    TriggerServerEvent("core:RegisterPlayerToken", t)
    token = t
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end 
    while not GetEntityModel(p:ped()) do Wait(1) end 
    while not HasCollisionLoadedAroundEntity(p:ped()) do Wait(1) end 
    Wait(15000)
    TriggerServerEvent("core:secu:ImConnected")
end)

CreateThread(function()
    while p == nil do
        Wait(100)
    end
    
    while true do
        HudWeaponWheelIgnoreSelection()
        HideHudComponentThisFrame(19)

        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
        if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("weapon_unarmed") and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("weapon_pickaxe") and GetSelectedPedWeapon(PlayerPedId()) ~= 0 then 
            if GetPedAmmoByType(PlayerPedId(), GetPedAmmoType(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()))) ~= -1 then
                SetPedInfiniteAmmo(p:ped(), true)
            end
        end
        DisablePlayerVehicleRewards(p:ped())
        DisablePlayerVehicleRewards(PlayerId())
        SetEveryoneIgnorePlayer(p:ped(), true)

        HideHudComponentThisFrame(20)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 12, true)
        DisableControlAction(0, 13, true)
        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)
        DisableControlAction(0, 17, true)
        SetPedConfigFlag(PlayerPedId(), 438, true)
        Wait(1)
    end
end)
local Detect = {
    found = false,
    weapon = nil,
}
CreateThread(function()
    while p == nil do
        Wait(0)
    end
    while true do
        Detect.found = false
        if IsPedArmed(PlayerPedId(), 1) or IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 2) then
            for k, v in pairs(p:getInventaire()) do
                if v.name and string.find(v.name, "WEAPON_") then 
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v.name) then 
                        Detect.found = true
                    end
                end
            end
            if not Detect.found then 
                if weaponHashes[GetSelectedPedWeapon(PlayerPedId())] then
                    Detect.weapon = weaponHashes[GetSelectedPedWeapon(PlayerPedId())]
                else
                    Detect.weapon = GetSelectedPedWeapon(PlayerPedId()).." (Hash)"
                end
               SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
            end
        end
        Wait(3000)
    end
end)


RegisterNetEvent("core:takescreensw", function(http, id)
    exports["screenshot-basic"]:requestScreenshotUpload(http, "files[]",function(data)
        local resp = json.decode(data)
        local att = 1000
        while not resp do 
            Wait(1) 
            att = att - 1 
            if att <= 0 then 
                break 
            end 
        end
        TriggerServerEvent("core:getscreenshotsw", resp.files[1].url, id)
    end)
end)

if not _CONFIG.Debug then
    AddEventHandler('onClientResourceStop', function(resourceName)
        if AntiStop[resourceName] then
            TriggerServerEvent('core:admin:anticheat', 'Stop resource: '..resourceName)

        end
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if AntiStop[resourceName] then
            
            TriggerServerEvent('core:admin:anticheat', 'Stop resource: '..resourceName)

        end
    end)
end