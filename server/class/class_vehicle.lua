vehicle = {
    plate = "", ---@private
    owner = "", ---@private
    name = "", ---@private
    props = {}, ---@private
    body = {}, ---@private
    needSave = false,
    netId = 0,
    entity = 0,
    tmpVeh = false
}

vehicle.__index = vehicle

local classVeh = {} ---@type vehicle

---@return vehicle
function GetVehicle(plate)
    return classVeh[getOriginalPlate(plate)]
end

--@return vehicles
function GetAllVehiclesClass()
    return classVeh
end

function getOriginalPlate(plate)
    local vehicles = GetAllVehiclesClass()
    for k, v in pairs(vehicles) do
        if v.currentPlate == plate then
            return v.plate
        end
    end
    return plate
end

function RemoveVehicle(plate)
    classVeh[getOriginalPlate(plate)] = nil
end

---@return vehicle
function vehicle:new(data, playerVeh)
    local self = setmetatable({}, vehicle)
    self.plate = data.plate

    self.owner = data.owner
    self.name = data.name
    self.props = json.decode(data.props)

    self.label = data.label
    self.needSave = false
    self.netId = data.netId or 0
    self.entity = data.entity or 0
    self.usedTrunk = nil
    if playerVeh then
        self.tmpVeh = true
    else
        self.tmpVeh = false
    end
    Console.Success("The vehicle " .. self.plate  .. " was created for " .. self.owner)
    -- print(data.plate, json.encode(self))
    classVeh[data.plate] = self
    return self
end

--vehicles methods

function vehicle:getPlate()
    return self.plate
end

function vehicle:getOwner()
    return self.owner
end

---@private
function vehicle:setOwner(owner)
    self.owner = owner
end

function vehicle:getName()
    return self.name
end

function vehicle:getLabel()
    return self.label
end

function vehicle:setLabel(label)
    self.label = label
end

---@private
function vehicle:setName(name)
    self.name = name
end

function vehicle:getprops()
    return self.props
end

---@private
function vehicle:setProps(props)
    self.props = props
end

function vehicle:getGarage()
    return self.garage
end

---@private
function vehicle:setGarage(garage)
    self.garage = garage
end

function vehicle:getStored()
    return self.stored
end

---@private
function vehicle:setStored(stored)
    self.stored = stored
end

function vehicle:getVente()
    return self.vente
end

---@private
function vehicle:setVente(vente)
    self.vente = vente
end

function vehicle:getCoowner()
    return self.coowner
end

---@private
function vehicle:setCoowner(coowner)
    self.coowner = coowner
end

function vehicle:getJob()
    return self.job
end

---@private
function vehicle:setJob(job)
    self.job = job
end

function vehicle:getInventory()
    return self.inventory
end

---@private
function vehicle:setInventory(inventory)
    self.inventory = inventory
end

function vehicle:getMileage()
    return self.mileage
end

---@private
function vehicle:setMileage(mileage)
    self.mileage = mileage
end

function vehicle:getFuel()
    return self.fuel
end

---@private
function vehicle:setFuel(fuel)
    self.fuel = fuel
end

function vehicle:getBody()
    return self.body
end

---@private
function vehicle:setBody(body)
    self.body = body
end

function vehicle:getCurrentPlate()
    return self.currentPlate
end

---@private
function vehicle:setCurrentPlate(currentPlate)
    self.currentPlate = currentPlate
end

function vehicle:getNeedSave()
    return self.needSave
end

---@private
function vehicle:setNeedSave(needSave)
    self.needSave = needSave
end

function vehicle:getNetId()
    return self.netId
end

---@private
function vehicle:setNetId(netId)
    self.netId = netId
end

function vehicle:getEntity()
    return self.entity
end

---@private
function vehicle:setEntity(entity)
    self.entity = entity
end

function vehicle:getUsedTrunk()
    return self.usedTrunk
end

---@private
function vehicle:setUsedTrunk(usedTrunk)
    self.usedTrunk = usedTrunk
end

function vehicle:getTmpVeh()
    return self.tmpVeh
end

---@private
function vehicle:setTmpVeh(tmpVeh)
    self.tmpVeh = tmpVeh
end

--vehicle functions

function vehicle:plateExist()
    if self == nil then return false end
    return true
end

function vehicle:isOwner(id)
    if self.owner == id then return true end
    return false
end

function vehicle:isCoowner(id)
    for k, v in ipairs(self.coowner) do
        if v == id then return true end
    end
    return false
end

function vehicle:setVehiclePound(pound)
    self:setStored(pound)
    self:setNeedSave(true)
end

function vehicle:setVehicleOut(netId, entity)
    print("setVehicleOut", netId, entity)
    self:setStored(1)
    self:setNetId(netId)
    self:setEntity(entity)
    self:setNeedSave(true)
end

function vehicle:setVehicleIn()
    self:setStored(2)
    self:setNetId(0)
    self:setEntity(0)
    self:setNeedSave(true)
end

function vehicle:setVehiclePropsClass(props)
    self:setProps(props)
    self:setNeedSave(true)
end

function vehicle:setVehicleInventory(inventory)
    self:setInventory(inventory)
    self:setNeedSave(true)
end

function vehicle:changePlate(plate)
    self:setCurrentPlate(plate)
    self:setNeedSave(true)
end

function vehicle:saveVehicle()
    MySQL.Async.execute(
        "UPDATE players_vehicles SET players_vehicles.owner = @owner, players_vehicles.plate = @plates, players_vehicles.props = @props, players_vehicles.name = @name, players_vehicles.label = @label  WHERE players_vehicles.plate = @plates",
        {
            ['owner'] = self.owner,
            ['plates'] = self.plate,
            ['props'] = json.encode(self.props),
            ['name'] = self.name,
            ['label'] = self.label

        }, function(affectedRows)
            self:setNeedSave(false)
        end
    )
end

function vehicle:changeOwner(id, crew, job)
    self:setOwner(id)
    self:setVente(crew)
    self:setJob(job)
    self:setCoowner({})
    self:setNeedSave(true)
end

