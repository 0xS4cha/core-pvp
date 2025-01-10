PlayerUtils = {}

--@class Keys
Keys = {};

---Register
---@param Controls string
---@param ControlName string
---@param Description string
---@param Action function
---@return Keys
---@public

Keys = {
    keysAllow = true 
}

function Keys.Register(Controls, ControlName, Description, Action)
    local _Keys = {
        CONTROLS = Controls
    }
    RegisterKeyMapping(string.format('rageui-%s', ControlName), Description, "keyboard", Controls)
    RegisterCommand(string.format('rageui-%s', ControlName), function(source, args)
        if (Action ~= nil) then
            if Keys.keysAllow then 
               Action();

            end 
        end
    end, false)
    return setmetatable(_Keys, Keys)
end

---Exists
---@param Controls string
---@return boolean
function Keys:Exists(Controls)
    return self.CONTROLS == Controls and true or false
end



local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
PlayerUtils.handsup = false
PlayerUtils.radgoll = false
PlayerUtils.pointing = false
local CreateThread = Citizen.CreateThread





local gEquip = false
-- thread to update weapon ammo count every 100ms
CreateThread(function()
    while not loaded do
        Wait(100)
    end
    while p == nil do
        Wait(100)
    end
    while true do
        gEquip = false
        local ped = PlayerPedId()
        local hash = GetSelectedPedWeapon(ped)
        if hash ~= -1569615261 then
            gEquip = true
            local ammo = GetAmmoInPedWeapon(ped, hash)
            if ammo ~= 0 then
                for k, v in pairs(Weapons) do
                    if GetHashKey(v.name) == GetSelectedPedWeapon(ped) then
                        if v.metadatas.ammo ~= ammo then -- if ammo count is different
                            Weapons[k].metadatas.ammo = ammo
                            for key, value in pairs(p:getInventaire()) do
                                if value.name == v.name then
                                    value.metadatas.ammo = v.metadatas.ammo
                                end
                            end
                            TriggerServerCallback("core:RefreshInventory", token, p:getInventaire())
                            TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                        end
                    end
                end
            end
        end
        if gEquip then
            Wait(60 * 1000) -- 1 minute
        else
            Wait(2 * 60 * 1000) -- 2 minutes
        end
    end
end)



-- TODO: faire fouiller la personne si main lever ou Ragdoll (touche: k)
local relationshipTypes = { "PLAYER", "CIVMALE", "CIVFEMALE", "COP", "SECURITY_GUARD", "PRIVATE_SECURITY", "FIREMAN",
    "GANG_1", "GANG_2", "GANG_9", "GANG_10", "AMBIENT_GANG_LOST", "AMBIENT_GANG_MEXICAN",
    "AMBIENT_GANG_FAMILY", "AMBIENT_GANG_BALLAS", "AMBIENT_GANG_MARABUNTE", "AMBIENT_GANG_CULT",
    "AMBIENT_GANG_SALVA", "AMBIENT_GANG_WEICHENG", "AMBIENT_GANG_HILLBILLY", "DEALER",
    "HATES_PLAYER", "HEN", -- "WILD_ANIMAL",
    -- "SHARK",
    -- "COUGAR",
    "NO_RELATIONSHIP", "SPECIAL", "MISSION2", "MISSION3", "MISSION4", "MISSION5", "MISSION6", "MISSION7", "MISSION8",
    "ARMY", "GUARD_DOG", "AGGRESSIVE_INVESTIGATE", "MEDIC", "CAT" }
local RELATIONSHIP_HATE = 1

CreateThread(function()
    while p == nil do
        Wait(1)
    end
    AddTextEntry('PM_PANE_CFX', '~HUD_COLOUR_PM_MITEM_HIGHLIGHT~Vision')

    for k, v in pairs(relationshipTypes) do
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey('PLAYER'), GetHashKey(v))
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey(v), GetHashKey('PLAYER'))
    end
    SetCanAttackFriendly(PlayerId(), true, false)
    NetworkSetFriendlyFireOption(true)
    SetAudioFlag("PoliceScannerDisabled", true)
    for i = 0, 15 do
        EnableDispatchService(i, false)
    end

    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
end)

local spawnVeh = { "rhino", "hydra", "buzzard", "lazer", "titan", "cargobob", "adder", "zentorno", "blimp", "blimp2",
    "blimp3" }

local scenario = { "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
}





local pVeh = false
-- create loop to check if player is driver in a vehicle and if so, disable shooting
CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        if p:isInVeh() and GetPedInVehicleSeat(GetVehiclePedIsIn(p:ped(), false), -1) == p:ped() then
            pVeh = true
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 92, true)
        end
        if pVeh and not p:isInVeh() then
            pVeh = false
        end
        if pVeh then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)
-- CreateThread(function()
--     while true do
--         HudForceWeaponWheel(false)
--         BlockWeaponWheelThisFrame()
--         HudWeaponWheelIgnoreControlInput(true)
--         HudWeaponWheelIgnoreSelection()
--         HideHudComponentThisFrame(19)
--         HideHudComponentThisFrame(20)
--         HideHudComponentThisFrame(17)
--         DisableControlAction(1, 37)
--         DisableControlAction(0, 199)
--         Wait(0)
--     end
-- end)

local knocked = false
local wait = 10
local count = 60
local tires = { {
    bone = "wheel_lf",
    index = 0
}, {
    bone = "wheel_rf",
    index = 1
}, {
    bone = "wheel_lm",
    index = 2
}, {
    bone = "wheel_rm",
    index = 3
}, {
    bone = "wheel_lr",
    index = 4
}, {
    bone = "wheel_rr",
    index = 5
}, {
    bone = "wheel_lr",
    index = 45
}, {
    bone = "wheel_rr",
    index = 47
} }





-- REMOVE WEAPON DROPS FROM PEDS 
function RemoveWeaponDrops()
    local pickupList = {"PICKUP_AMMO_BULLET_MP","PICKUP_AMMO_FIREWORK","PICKUP_AMMO_FLAREGUN","PICKUP_AMMO_GRENADELAUNCHER","PICKUP_AMMO_GRENADELAUNCHER_MP","PICKUP_AMMO_HOMINGLAUNCHER","PICKUP_AMMO_MG","PICKUP_AMMO_MINIGUN","PICKUP_AMMO_MISSILE_MP","PICKUP_AMMO_PISTOL","PICKUP_AMMO_RIFLE","PICKUP_AMMO_RPG","PICKUP_AMMO_SHOTGUN","PICKUP_AMMO_SMG","PICKUP_AMMO_SNIPER","PICKUP_ARMOUR_STANDARD","PICKUP_CAMERA","PICKUP_CUSTOM_SCRIPT","PICKUP_GANG_ATTACK_MONEY","PICKUP_HEALTH_SNACK","PICKUP_HEALTH_STANDARD","PICKUP_MONEY_CASE","PICKUP_MONEY_DEP_BAG","PICKUP_MONEY_MED_BAG","PICKUP_MONEY_PAPER_BAG","PICKUP_MONEY_PURSE","PICKUP_MONEY_SECURITY_CASE","PICKUP_MONEY_VARIABLE","PICKUP_MONEY_WALLET","PICKUP_PARACHUTE","PICKUP_PORTABLE_CRATE_FIXED_INCAR","PICKUP_PORTABLE_CRATE_UNFIXED","PICKUP_PORTABLE_CRATE_UNFIXED_INCAR","PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL","PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW","PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE","PICKUP_PORTABLE_PACKAGE","PICKUP_SUBMARINE","PICKUP_VEHICLE_ARMOUR_STANDARD","PICKUP_VEHICLE_CUSTOM_SCRIPT","PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW","PICKUP_VEHICLE_HEALTH_STANDARD","PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW","PICKUP_VEHICLE_MONEY_VARIABLE","PICKUP_VEHICLE_WEAPON_APPISTOL","PICKUP_VEHICLE_WEAPON_ASSAULTSMG","PICKUP_VEHICLE_WEAPON_COMBATPISTOL","PICKUP_VEHICLE_WEAPON_GRENADE","PICKUP_VEHICLE_WEAPON_MICROSMG","PICKUP_VEHICLE_WEAPON_MOLOTOV","PICKUP_VEHICLE_WEAPON_PISTOL","PICKUP_VEHICLE_WEAPON_PISTOL50","PICKUP_VEHICLE_WEAPON_SAWNOFF","PICKUP_VEHICLE_WEAPON_SMG","PICKUP_VEHICLE_WEAPON_SMOKEGRENADE","PICKUP_VEHICLE_WEAPON_STICKYBOMB","PICKUP_WEAPON_ADVANCEDRIFLE","PICKUP_WEAPON_APPISTOL","PICKUP_WEAPON_ASSAULTRIFLE","PICKUP_WEAPON_ASSAULTSHOTGUN","PICKUP_WEAPON_ASSAULTSMG","PICKUP_WEAPON_AUTOSHOTGUN","PICKUP_WEAPON_BAT","PICKUP_WEAPON_BATTLEAXE","PICKUP_WEAPON_BOTTLE","PICKUP_WEAPON_BULLPUPRIFLE","PICKUP_WEAPON_BULLPUPSHOTGUN","PICKUP_WEAPON_CARBINERIFLE","PICKUP_WEAPON_COMBATMG","PICKUP_WEAPON_COMBATPDW","PICKUP_WEAPON_COMBATPISTOL","PICKUP_WEAPON_COMPACTLAUNCHER","PICKUP_WEAPON_COMPACTRIFLE","PICKUP_WEAPON_CROWBAR","PICKUP_WEAPON_DAGGER","PICKUP_WEAPON_DBSHOTGUN","PICKUP_WEAPON_FIREWORK","PICKUP_WEAPON_FLAREGUN","PICKUP_WEAPON_FLASHLIGHT","PICKUP_WEAPON_GRENADE","PICKUP_WEAPON_GRENADELAUNCHER","PICKUP_WEAPON_GUSENBERG","PICKUP_WEAPON_GOLFCLUB","PICKUP_WEAPON_HAMMER","PICKUP_WEAPON_HATCHET","PICKUP_WEAPON_HEAVYPISTOL","PICKUP_WEAPON_HEAVYSHOTGUN","PICKUP_WEAPON_HEAVYSNIPER","PICKUP_WEAPON_HOMINGLAUNCHER","PICKUP_WEAPON_KNIFE","PICKUP_WEAPON_KNUCKLE","PICKUP_WEAPON_MACHETE","PICKUP_WEAPON_MACHINEPISTOL","PICKUP_WEAPON_MARKSMANPISTOL","PICKUP_WEAPON_MARKSMANRIFLE","PICKUP_WEAPON_MG","PICKUP_WEAPON_MICROSMG","PICKUP_WEAPON_MINIGUN","PICKUP_WEAPON_MINISMG","PICKUP_WEAPON_MOLOTOV","PICKUP_WEAPON_MUSKET","PICKUP_WEAPON_NIGHTSTICK","PICKUP_WEAPON_PETROLCAN","PICKUP_WEAPON_PIPEBOMB","PICKUP_WEAPON_PISTOL","PICKUP_WEAPON_PISTOL50","PICKUP_WEAPON_POOLCUE","PICKUP_WEAPON_PROXMINE","PICKUP_WEAPON_PUMPSHOTGUN","PICKUP_WEAPON_RAILGUN","PICKUP_WEAPON_REVOLVER","PICKUP_WEAPON_RPG","PICKUP_WEAPON_SAWNOFFSHOTGUN","PICKUP_WEAPON_SMG","PICKUP_WEAPON_SMOKEGRENADE","PICKUP_WEAPON_SNIPERRIFLE","PICKUP_WEAPON_SNSPISTOL","PICKUP_WEAPON_SPECIALCARBINE","PICKUP_WEAPON_STICKYBOMB","PICKUP_WEAPON_STUNGUN","PICKUP_WEAPON_SWITCHBLADE","PICKUP_WEAPON_VINTAGEPISTOL","PICKUP_WEAPON_WRENCH", "PICKUP_WEAPON_RAYCARBINE"}
    for a = 1, #pickupList do
		N_0x616093ec6b139dd9(PlayerId(), GetHashKey(pickupList[a]), false)
    end
end

CreateThread(function()     
    RemoveWeaponDrops()
end)


-- ne pas toucher merci bien
-- nope
RegisterNUICallback("setTyping", function(data)
    if data.value then
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocusKeepInput(true)
    end
end)


----------------------------------No Shuffle
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end


local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
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

local function GetEntity()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function DetachObjet(entity)

    local playerPosition = GetEntityCoords(entity)
    for object in GetEntity() do
        if object and DoesEntityExist(object) and IsEntityAttached(object) and GetDistanceBetweenCoords(GetEntityCoords(object), playerPosition) <= 1.5  then
            DeleteEntity(object)
        end
    end

    local entity = GetEntityAttachedTo(PlayerPedId())
    if entity ~= 0 then 
        if IsEntityAttachedToAnyObject(PlayerPedId()) then 
            DetachEntity(entity)
            DeleteEntity(entity)
        end
    end
end

function DetachProps(entity)
    ClearAllPedProps(PlayerPedId())
end



CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while not NetworkIsSessionStarted() do
        Wait(1)
    end
    TriggerEvent("core:playerSpawned")
end)

local yLimitation = 1490
function coordsIsInSouth(coords)
    return coords.y < yLimitation
end


RegisterNetEvent("Core:PrintChangeInstance")
AddEventHandler("Core:PrintChangeInstance", function(playerid, instance, reason)

    print("Vous avez change d'instance : "..reason .. "I Nouvelle instance : ".. instance)
end)
