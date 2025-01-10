Modules = {}

exports('GetModules', function()
    return Modules
end)


p = {} 
function p:ped()
    return PlayerPedId()
end

function p:serverId()
    return GetPlayerServerId(PlayerPedId())
end

function p:getHealth()
    return GetEntityHealth(self:ped())
end

function p:getArmour()
    return GetPedArmour(self:ped())
end

function p:skin()
    return SkinChangerGetSkin()
end

function p:setCloth(type, value, freezeface)
    SkinChangerChange(type, value, freezeface)
end


function p:pos()
    local ped = self:ped()
    return GetEntityCoords(ped)
end


function p:heading()
    return GetEntityHeading(self:ped())
end

function p:heal(heal)
    local health = p:getHealth()
    SetEntityHealth(self:ped(), health + heal)
end

function p:setHealth(heal)
    SetEntityHealth(self:ped(), heal)
end

function p:setShield(health)
    SetPedArmour(self:ped(), health)
end

function p:setArmour(armour)
    SetPedArmour(self:ped(), armour)
end

function p:isNearp()
    local _, dst = GetClosestp()
    if dst ~= nil and dst <= 3.0 then
        return true
    else
        return false
    end
end


function p:setVisible(status)
    if not status then
        SetEntityVisible(self:ped(), false, false)
    else
        SetEntityVisible(self:ped(), true, true)
    end
end

function p:setVisibleLocal(status)
    if not status then
        SetEntityLocallyInvisible(self:ped())
    else
        SetEntityLocallyVisible(self:ped())
    end
end


function p:model()
    return GetEntityModel(self:ped())
end

function p:currentVeh()
    return GetVehiclePedIsIn(self:ped(), false)
end

function p:lastVeh()
    return GetVehiclePedIsIn(self:ped(), true)
end

function p:isInVeh()
    return IsPedInAnyVehicle(self:ped(), false)
end

