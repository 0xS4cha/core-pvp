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
    storage = {}, ---@private
    cloths = { skin = {}, cloths = {} }, ---@private
    permission = 0, ---@private

    group = "None", ---@private
    groupID = 0, ---@private
    vip = 0,
    needSave = false, ---@private
    active = 1,
}

player.__index = player

local p = {} ---@type player

---@return player
function GetPlayer(source)
    return p[source]
end

function RemovePlayer(source)
    p[source] = nil
end

---@return player
function player:new(data, default, source, perm)
    local self = setmetatable({}, player)
    if not default then
        self.id = data.id
        self.source = source
        self.license = data.license
        self.identifier = GetSteam(source)
        self.liveid = GetLive(source)
        self.xblid = GetXbl(source)
        self.discord = GetDiscord(source)
        self.playerip = GetIp(source)
        self.playerName = GetPlayerName(source)
        self.cloths = json.decode(data.cloths)
        self.permission = data.permission
        self.instance = 0
        self.vip = data.vip
        self.needSave = false
        self.active = data.active or 1
        if self.cloths.cloths == nil then
            self.cloths.cloths = {}
        end

    else
        self.source = source
        self.license = GetLicense(source)
        self.identifier = GetSteam(source)
        self.liveid = GetLive(source)
        self.xblid = GetXbl(source)
        self.discord = GetDiscord(source)
        self.playerip = GetIp(source)
        self.playerName = GetPlayerName(source)
        self.cloths = { skin = {}, cloths = {} }
        self.permission = perm or 0
        self.subscription = data.subscription
        self.vip = 0
        self.instance = 0
        self.needSave = false
        self.active = 1


    end
    Logger:info('CORE', GetPlayerName(source)..' joined')
    p[source] = self
    return self
end

--getters and setters

function player:getId()
    return self.id
end

function player:setId(id)
    self.id = id
end

function player:setInstance(id)
    SetPlayerRoutingBucket(self.source, id)
    self.instance = id
end

function player:getInstance()
    local bucket = GetPlayerRoutingBucket(self.source)
    self.instance = bucket
    return self.instance
end

function player:setSource(source)
    self.source = source
end

function player:getSource()
    return self.source
end



function player:setLicense(license)
    self.license = license
end

function player:ShowNotification(message)
    TriggerClientEvent('core:ShowNotification', self.source, message)
end

function player:getLicense()
    return self.license
end



function player:GetId()
    return self.id
end

function player:getId() -- copie de GetId() pour fix les fautes de frappes maj
    return self.id
end

function player:setId(id)
    self.id = id
end

function player:getSkin()
    return self.cloths.skin
end

function player:getCloths()
    return self.cloths
end


function player:getGroup()
    return self.group
end

function player:getNeedSave()
    return self.needSave
end

function player:getWeapons()
    return self.weapons
end

function player:setWeapons(weapon)
    self.weapons  = weapon
end

function player:setCloths(cloths)
    self.cloths = cloths
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


function player:getPermission()
    return self.permission
end

function player:setPermission(permission)
    self.permission = permission
end


function player:getJobGrade()
    return self.job_grade
end

function player:setGroup(group)
    self.group = group
end


function player:setGroupID(groupID)
    self.groupID = groupID
end

function player:getGroupID()
    return self.groupID
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


function player:setHunger(hunger)
    self.status.hunger = hunger
end

function player:getHunger()
    return self.status.hunger
end

function player:setThirst(thirst)
    self.status.thirst = thirst
end

function player:getThirst()
    return self.status.thirst
end

function player:setHealth(health)
    self.status.health = health
end

function player:getHealth()
    return self.status.health
end

function player:setNeedSave(status)
    self.needSave = status
end

function player:getNeedSave()
    return self.needSave
end

function player:setNeedPosSave(status)
    self.needPosSave = status
end

function player:getNeedPosSave()
    return self.needPosSave
end


function player:getStatus()
    return self.status
end

function player:setActive(active)
    self.active = active
end

function player:getActive()
    return self.active
end

function player:setIdPerso(idPerso)
    self.idPerso = idPerso
end

function player:getIdPerso()
    return self.idPerso
end



---@return boolean
function player:DoesWeaponExist(name)
    if weapons[name] ~= nil then
        return true
    else
        return false
    end
end

---@return data
function player:GetWeaponData(name)
    return weapons[name]
end

---@return boolean
function player:HaveWeapon(name)
    if self.weapons[name] ~= nil then
        return true
    else
        return false
    end
end

function player:AddWeaponIfPossible(name, ammo)
    if self:DoesWeaponExist(name) then
        -- if not self:HaveWeapon(name, ammo) then
        --     local weapon = self:GetWeaponData(name)
        --     self.weapons[name] = {
        --         ammo = ammo,
        --         hash = weapon.hash,
        --         nameGXT = weapon.NameGXT,
        --         descGXT = weapon.DescriptionGXT,
        --         name = name,
        --     }
        --     return true
        -- else
        --     return false, "Possède déja l'arme"
        -- end
    else
        return false, "Arme inconnu"
    end
end





function player:getLive()
    return self.liveid
end

function player:setLive(liveid)
    self.liveid = liveid
end

function player:getXbl()
    return self.xblid
end

function player:setXbl(xblid)
    self.xblid = xblid
end

function player:getDiscord()
    return self.discord
end

function player:setDiscord(discord)
    self.discord = discord
end

function player:getIp()
    return self.ip
end

function player:setIp(ip)
    self.ip = ip
end




function player:SetWeaponAmmo(name, ammo)
    if self:HaveWeapon(name) then
        self.weapons[name].ammo = ammo
        return true
    else
        return false
    end
end

function player:SetWeaponComponents(name, components, option)
    if self:HaveWeapon(name) then

        if components == 'suppressor' then
            self.weapons[name].metadatas.suppressor = option
            --[[ print("OK SERVER SUPPRESSOR") ]]
        elseif components == 'flashlight' then
            self.weapons[name].metadatas.flashlight = option
            --[[ print("OK SERVER FLASHLIGHT") ]]
        elseif components == 'grip' then
            self.weapons[name].metadatas.grip = option
            --[[ print("OK SERVER GRIP") ]]
        end
        return true
    else
        return false
    end
end

function player:RemoveWeapon(name)
    if self:HaveWeapon(name) then
        self.weapons[name] = nil
        return true
    else
        return false
    end
end

function player:GiveWeaponIfPossible(name, source, target)
    if self:HaveWeapon(name) then
        -- TODO
        if not GetPlayer(target):HaveWeapon(name) then
            local weapon = GetPlayer(target):GetWeaponData(name)
            GetPlayer(target).weapons[name] = {
                ammo = self.weapons[name].ammo,
                hash = weapon.hash,
                nameGXT = weapon.NameGXT,
                descGXT = weapon.DescriptionGXT,
            }
            self:RemoveWeapon(name)
        else
            --TriggerClientEvent("core:ShowNotification", source, "La personne possède déja l'arme")
            TriggerClientEvent("__vision::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s La personne possède déja l'arme"
            })
        end
    else
        --TriggerClientEvent("core:ShowNotification", source, "Vous ne possède pas l'arme")
        TriggerClientEvent("__vision::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous ne possède pas l'arme"
        })
    end
end



function player:AddMoneyAccount(money)
    self.banque = self:getBanque() + money
end



function player:RemoveMoneyAccount(money)
    if self:getBanque() >= money then
        self.banque = self:getBanque() - money
        return true
    else
        return false
    end
end

-- players fct

function player:isMale()
    if p:getSex() == "M" then
        return true
    else
        return false
    end
end


function player:getPlayerName()
    return GetPlayerName(self.source)
end

function player:getIdentifier()
    return self.identifier
end

function player:getLiveid()
    return self.liveid
end

function player:getXblid()
    return self.xblid
end

function player:getPlayerIp()
    return self.playerip
end


GetPlayer = function(source)
    return p[source]
end

-- export



GetPlayerPerm = function(source) -- NE PAS TOUCHER SVPPPP
    local perm
    if GetPlayer(source) then
        perm = GetPlayer(source):getPermission()
    else
        perm = 0
    end
    return perm
end

function GetAllplayer()
    return p
end

function GetPlayerFromId(id)
    for k, v in pairs(p) do
        if v:getId() == id then
            return v
        end
    end
    return nil
end
exports('GetPlayerIdbdd', function(source)
    while GetPlayer(source) == nil do Wait(1000) end
    return GetPlayer(source):GetId()
end)

