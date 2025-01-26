local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

player = {
    id = 0, ---@private
    source = 0,
    license = "", ---@private
    identifier = "", ---@private
    liveid = "", ---@private
    xblid = "", ---@private
    discord = "", ---@private
    playerip = "", ---@private
    playerName = "", ---@private
    inventaire = {}, ---@private
    storage = {}, ---@private
    weapons = {}, ---@private
    cloths = { skin = {}, cloths = {} }, ---@private
    permission = 0, ---@private
    group = "None", ---@private
    groupID = 0, ---@private
    vip = 0,
    needSave = false, ---@private
    active = 1,
}

p = nil ---@type player


function player:new(data)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = data.id

    obj.license = data.license ---@private
    obj.identifier = data.identifier ---@private
    obj.liveid = data.liveid ---@private
    obj.xblid = data.xblid ---@private
    obj.discord =   data.discord ---@private
    obj.playerip = data.playerip ---@private
    obj.playerName = data.playerName ---@private
    obj.inventaire = data.inventaire ---@private
    obj.cloths = data.cloths ---@private
    obj.permission = data.permission ---@private
    obj.storage = data.storage --@private

    obj.group = data.group
    obj.vip = data.vip ---@private
    obj.active = data.active

    if obj.weapons == nil then
        obj.weapons = {}
    end



    p = obj
end

--getters and setters

function player:getStorage()
    return self.storage
end
function player:setStorage(storage)
    self.storage = storage
end
function player:getId()
    return self.id
end

function player:setId(id)
    self.id = id
end

function player:setLicense(license)
    self.license = license
end

function player:getLicense()
    return self.license
end

function player:getFullName()
    return self.firstname.." "..self.lastname
end

function player:getFirstname()
    return self.firstname
end



function player:getAge()
    return self.age
end

function player:setAge(age)
    self.age = age
end

function player:getSex()
    return self.sex
end

function player:setSex(sex)
    self.sex = sex
end

function player:getSize()
    return self.size
end

function player:setSize(size)
    self.size = size
end

function player:getBirthplaces()
    return self.birthplaces
end

function player:setBirthplaces(birthplaces)
    self.birthplaces = birthplaces
end

function player:setInventaire(inventaire)
    self.inventaire = inventaire
end

function player:getInventaire()
    return self.inventaire
end

function player:getWeapons()
    return self.weapons
end

function player:setWeapons(weapon)
    self.weapons = weapon
end

function player:setCloths(cloths)
    self.cloths = cloths
end

function player:getCloths()
    return self.cloths
end

function player:setSkin(skin)
    self.cloths.skin = skin
end

function player:getSkin()
    return self.cloths.skin
end

function player:setClothsCloths(cloths)
    self.cloths.cloths = cloths
end

function player:getClothsCloths()
    return self.cloths.cloths
end

function player:setTattoos(tattoo)
    self.tattoos = tattoo
end

function player:getTattoos()
    return self.tattoos
end

function player:getDegrader()
    return self.degrader
end

function player:setDegrader(degrader)
    self.degrader = degrader
end

function player:setBanque(banque)
    self.banque = banque
end

function player:getBanque()
    return self.banque
end

function player:getPermission()
    return self.permission
end

function player:setJob(job)
    self.job = job
end

function player:getBalance()
    return self.balance
end

function player:getSubscription()
    return self.subscription
end

function player:getJob()
    return self.job
end

function player:setJobGrade(job_grade)
    self.job_grade = job_grade
end

function player:getJobGrade()
    return self.job_grade
end

function player:setGroup(group)
    self.group = group
end

function player:getGroup()
    return self.group
end

function player:setVip(vip)
    self.vip = vip
end

function player:getVip()
    return self.vip
end

function player:setStatus(status)
    self.status = status
end

function player:getStatus()
    return self.status
end



function player:setHealth(health)
    self.status.health = health
end

function player:getHealth()
    return self.status.health
end

function player:setPosMethods(position)
    self.position = position
end

function player:getPos()
    return self.position
end

function player:setNeedSave(needSave)
    self.needSave = needSave
end

function player:getNeedSave()
    return self.needSave
end

function player:setinAction(inAction)
    self.inAction = inAction
    if inAction then
        RageUI.CloseAll()
    end
end

function player:getInAction()
    return self.inAction
end

function player:setActive(active)
    self.active = active
end

function player:setActive()
    return self.active
end

-- weapon

function player:SetWeaponAmmo(index, ammo)
    self.weapons[index].ammo = ammo
end

function player:SetWeaponComponents(index, components, option)
    if components == 'suppressor' then
        self.weapons[index].metadatas.suppressor = option
    elseif components == 'flashlight' then
        self.weapons[index].metadatas.flashlight = option
    elseif components == 'grip' then
        self.weapons[index].metadatas.grip = option
    end
end

-- player fct
function player:ped()
    return PlayerPedId()
end

function player:serverId()
    return GetPlayerServerId(GetPlayerPed(-1))
end



function player:getHealth2()
    return GetEntityHealth(self:ped())
end

function player:getArmour()
    return GetPedArmour(self:ped())
end

function player:skin()
    return SkinChangerGetSkin()
end

function player:setCloth(type, value, freezeface)
    SkinChangerChange(type, value, freezeface)
end

function player:saveSkin()
    local skin = p:skin()
    TriggerServerEvent("core:SetPlayerActiveSkin", Token, skin, true)
end

function player:isMale()
    if p:getSex() == "M" then
        return true
    else
        return false
    end
end

function player:pos()
    local ped = self:ped()
    return GetEntityCoords(ped)
end

function player:heading()
    return GetEntityHeading(self:ped())
end

function player:heal(heal)
    local health = p:getHealth()
    SetEntityHealth(self:ped(), health + heal)
end

function player:setHealth(heal)
    SetEntityHealth(self:ped(), heal)
end

function player:setShield(health)
    SetPedArmour(self:ped(), health)
end

function player:setArmour(armour)
    SetPedArmour(self:ped(), armour)
end

function player:isNearPlayer()
    local _, dst = GetClosestPlayer()
    if dst ~= nil and dst <= 3.0 then
        return true
    else
        return false
    end
end

function player:setPos(pos)
    TeleportPlayer(pos)
end

function player:setSkin(cloths)
    TriggerEvent("skinchanger:loadSkin", cloths)
end

function player:setVisible(status)
    if not status then
        SetEntityVisible(self:ped(), false, false)
    else
        SetEntityVisible(self:ped(), true, true)
    end
end

function player:setVisibleLocal(status)
    if not status then
        SetEntityLocallyInvisible(self:ped())
    else
        SetEntityLocallyVisible(self:ped())
    end
end

function player:SetAnimSet(walk)
    if dict ~= "" then
        RequestAnimSet(walk)
        while not HasAnimSetLoaded(walk) do Wait(1) end
        SetPedMovementClipset(self:ped(), walk, 0.2);
        RemoveAnimSet(walk);
    end
end

function player:PlayAnim(dict, anim, flag)
    if dict ~= "" then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
        TaskPlayAnim(self:ped(), dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
        RemoveAnimDict(dict)
    end
end

function player:GetAllLastDamage()
    local _, bone = GetPedLastDamageBone(p:ped())
    if _ and bone then
        for k, v in pairs(Death.GetBonesType) do
            if Death.GetValueWithTable(v, bone) then
                return k, bone
            end
        end
    end
end

function player:updateJob(job, grade)
    self:setJob(job)
    self:setJobGrade(grade)
end

function player:updateStatus(hunger, thirst, health)
    self:setHunger(hunger)
    self:setThirst(thirst)
    self:setHealth(health)
end

function player:updateIdentity(nom, prenom, age, sexe, taille, birthplaces)
    self:setLastname(nom)
    self:setFirstname(prenom)
    self:setAge(age)
    self:setSex(sexe)
    self:setSize(taille)
    self:setBirthplaces(birthplaces)
end

-- players cars fct

function player:model()
    return GetEntityModel(self:ped())
end

function player:currentVeh()
    return GetVehiclePedIsIn(self:ped(), false)
end

function player:lastVeh()
    return GetVehiclePedIsIn(self:ped(), true)
end

function player:isInVeh()
    return IsPedInAnyVehicle(self:ped(), false)
end

function player:getPlayerName()
    return self:playerName()
end
-- banks fct

function player:haveEnoughMoney(number)
    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" then
            if v.count >= number then
                return true
            else
                return false
            end
        end
    end
    return false
end

function player:pay(number)
    local pay = TriggerServerCallback("core:pay", Token, tonumber(number))
    return pay
end

function player:payLiquide(number)
    local pay = TriggerServerCallback("core:payLiquide", Token, tonumber(number))
    return pay
end

-- inventory fct

function player:haveItem(item)
    for k, v in pairs(p:getInventaire()) do
        if v.name == item then
            return true
        end
    end
    return false
end

function player:haveItemWithCount(item, number)
    for k, v in pairs(p:getInventaire()) do
        if v.name == item then
            if v.count >= number then
                return true
            else
                return false
            end
        end
    end
    return false
end

function player:getItemCount(item)
    for k, v in pairs(p:getInventaire()) do
        if v.name == item then
            if v.count >= 1 then
                return v.count
            else
                return 0
            end
        end
    end
    return false
end

function player:AddItem(item, count, metadatas)
    TriggerSecurGiveEvent("core:addItemToInventory", Token, item, count, metadatas)
end

-- others fct

function player:PlayLoadingBar(time, text)
    local done = true
    SendNUIMessage({
        action = "startBar",
        time = time,
        text = text,
    })
    local timer = GetGameTimer() + time
    while timer > GetGameTimer() do
        ShowHelpNotification("Appuyer sur ~INPUT_VEH_DUCK~ pour annuler l'action", false)
        if IsControlJustReleased(0, 73) then
            SendNUIMessage({
                action = "startBar",
                time = 1,
                text = "Annulé",
            })
            done = false
            break
        end
        Wait(0)
    end
    return done
end

function player:GetAllCauseOfDeath()
    local exist, lastBone = GetPedLastDamageBone(p:ped())
    local cause, what_cause, timeDeath = GetPedCauseOfDeath(p:ped()), GetPedSourceOfDeath(p:ped()),
        GetPedTimeOfDeath(p:ped())
    if IsEntityAPed(what_cause) then
        what_cause = "Traces de combat"
    elseif IsEntityAVehicle(what_cause) then
        what_cause = "Écrasé par un véhicule"
    elseif IsEntityAnObject(what_cause) then
        what_cause = "Semble s'être pris un objet"
    end
    what_cause = type(what_cause) == "string" and what_cause or "Non-Identifiée"
    if IsWeaponValid(cause) then
        cause = Death.GetDeathType[GetWeaponDamageType(cause)] or "Non-Identifiée"
    elseif IsModelInCdimage(cause) then
        cause = "Véhicule"
    end
    cause = type(cause) == "string" and cause or "Mêlée"
    local boneName = "Dos"

    if exist and lastBone then
        for k, v in pairs(Death.GetBonesType) do
            if Death.GetValueWithTable(v, lastBone) then
                boneName = k
                break
            end
        end
    end
    return timeDeath, what_cause, cause, boneName
end

-- exports

exports("haveitem", function(item)
    return p:haveItem(item)
end)

exports('GetJobPlayer', function()
    return p:getJob()
end)

exports('getPlayer', function()
    return p
end)

exports('GetInventoryPlayer', function()
    return p:getInventaire()
end)

exports('getPermission', function()
    return p:getPermission()
end)