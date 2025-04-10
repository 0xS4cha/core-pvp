
local interactions, filteredInteractions = {}, {}
local table_sort = table.sort

-- CACHE.
local MODELS = {}
local ENTITIES = {}
local ENTITY_BONES = {}
local NETWORKED_ENTITIES = {}

InteractAPI = {}

AddEventHandler('interactions:groupsChanged', function(newgroups)
    -- Use this event handler to loop through all current interactions and remove any that are not in the new groups that way we limit the amount of iterations needed
end)

local function checkParams(entity, options)
    if not entity then
        Logger:error('INTERACTIONS', 'Entity is required to add an interaction')
        return
    else
        if type(entity) ~= 'number' then
            Logger:error('INTERACTIONS', 'Entity must be a number')
            return
        end

        if not DoesEntityExist(entity) then
            Logger:error('INTERACTIONS', 'Entity %s does not exist', entity)
            return
        end
    end

    if not options then
        Logger:error('INTERACTIONS', 'Options are required to add an interaction')
        return
    end

    return true
end


local function filterInteractions()
    local myGroups = 'police'

    local newInteractions = {}
    local amount = 0
    for k ,v in pairs(interactions) do
        amount += 1
        newInteractions[amount] = v
    end

    filteredInteractions = newInteractions
end

---@param model number|string : The model to add the interaction to
---@param options table : { label, canInteract, action, event, serverEvent, args }
---@param data table : { distance, interactDst, resource }
local function addModel(model, options, data)
    if type(model) ~= "number" then
        model = joaat(model)
    end

    if not IsModelValid(model) then
        Logger:error('INTERACTIONS', 'Model %s is not valid', model)
        return
    end

    if not MODELS[model] then
        Logger:info('INTERACTIONS', 'Adding model %s to interactions', model)
        MODELS[model] = {
            model = model,
            offset = data.offset,
            options = options,
            distance = data.distance,
            interactDst = data.interactDst,
            resource = data.resource,
        }
    else
        Logger:info('INTERACTIONS', ('Updating model %s in interactions'):format(model))
        for _, option in pairs(options) do
            MODELS[model].options[#MODELS[model].options + 1] = option
        end

        -- Update the distance and interactDst if the new data is greater
        if data.distance > MODELS[model].distance then
            MODELS[model].distance = data.distance
        end

        if data.interactDst > MODELS[model].interactDst then
            MODELS[model].interactDst = data.interactDst
        end

        -- Update the offset if there is new data
        if data.offset then
            MODELS[model].offset = data.offset
        end
    end
end

---@param data table : { name, coords, options, distance, interactDst, groups }
---@return number : The id of the interaction
-- Add an interaction point at a set of coords
function InteractAPI.addInteraction(data)
    if not data.coords then
        Logger:error('INTERACTIONS', 'Coords are required to add an interaction')
        return
    end

    if not data.options then
        Logger:error('INTERACTIONS', 'Options are required to add an interaction')
        return
    end

    local id = #interactions + 1
    interactions[id] = {
        id = id,
        name = data.name or 'interaction:'..id,
        coords = data.coords,
        options = data.options or {},
        distance = data.distance or 10.0,
        interactDst = data.interactDst or 1.0,
        groups = data.groups or nil,
        resource = GetInvokingResource()
    }

    filterInteractions()

    return id
end exports('AddInteraction', InteractAPI.addInteraction)

---@param data table : { name, entity, options, distance, interactDst, groups }
---@return number : The id of the interaction
-- Add an interaction point on a local (client side) entity
function InteractAPI.addLocalEntityInteraction(data)
    local entity = data.entity
    if not checkParams(entity, data.options) then
        if ENTITIES[entity] then
            ENTITIES[entity] = nil
        end
        return
    end
    local id = #interactions + 1
    -- If then entity not registered yet, add it
    if not ENTITIES[entity] then
        Logger:info('INTERACTIONS', ('Adding entity %s to interactions'):format(entity))
        
        interactions[id] = {
            id = id,
            name = data.name or 'interaction:'..id,
            entity = entity,
            options = data.options or {},
            distance = data.distance or 8.0,
            interactDst = data.interactDst or 1.0,
            offset = data.offset or vec(0.0, 0.0, 0.0),
            groups = data.groups or nil,
            resource = GetInvokingResource()
        }

        ENTITIES[entity] = interactions[id]

        filterInteractions()
        return id
    end

    -- If the entity is already registered, update it
    Logger:info('INTERACTIONS', 'Updating entity %s in interactions', entity)
    for index, option in pairs(data.options) do
        if option.name and ENTITIES[entity].options[index]?.name == option.name then
            Logger:info('INTERACTIONS', ('Option with name: ( %s ) already exists, updating'):format(option.name))
            ENTITIES[entity].options[index] = option
        else
            ENTITIES[entity].options[#ENTITIES[entity].options + 1] = option
        end
    end

    -- Update the distance and interactDst if the new data is greater
    if data.distance > ENTITIES[entity].distance then
        ENTITIES[entity].distance = data.distance
    end

    if data.interactDst > ENTITIES[entity].interactDst then
        ENTITIES[entity].interactDst = data.interactDst
    end

    -- Update the offset if there is new data
    if data.offset then
        ENTITIES[entity].offset = data.offset
    end

    interactions[id] = {
        id = id,
        entity = entity,
        options = ENTITIES[entity].options,
        distance = ENTITIES[entity].distance,
        interactDst = ENTITIES[entity].interactDst,
        offset = ENTITIES[entity].offset,
        resource = GetInvokingResource()
    }

    filterInteractions()

    return id
end exports('AddLocalEntityInteraction', InteractAPI.addLocalEntityInteraction)

---@param data table : { name, netId, options, distance, interactDst, groups }
---@return number : The id of the interaction
-- Add an interaction point on a networked entity
function InteractAPI.addEntityInteraction(data)
    
    local netId = data.netId
    -- If the netId does not exist, we assume it is an entity
    local entity
    if type(netId) == 'number' and not NetworkDoesNetworkIdExist(netId) then
        entity = netId
        netId = Utils.getEntity(netId)
    end

    if not checkParams(entity, data.options) then
        if NETWORKED_ENTITIES[netId] then
            NETWORKED_ENTITIES[netId] = nil
        end
        return
    end

    -- If the entity is not networked, add it as a local entity
    if not NetworkGetEntityIsNetworked(entity) then
        Logger:info('INTERACTIONS', ('Entity %s is not networked, adding as a local entity'):format(entity))
        data.entity = entity
        return InteractAPI.addLocalEntityInteraction(data)
    end
    local id = #interactions + 1
    -- If then netId not registered yet, add it
    --if not NETWORKED_ENTITIES[netId] then #TODO: REMETTRE
    if true then
        Logger:info('INTERACTIONS', ('Adding networkID %s to interactions'):format(netId))

        
        interactions[id] = {
            id = id,
            name = data.name or 'interaction:'..id,
            entity = entity,
            options = data.options or {},
            distance = data.distance or 10.0,
            interactDst = data.interactDst or 1.0,
            offset = data.offset or vec(0.0, 0.0, 0.0),
            groups = data.groups or nil,
            resource = GetInvokingResource()
        }

        NETWORKED_ENTITIES[netId] = interactions[id]

        filterInteractions()
        return id
    end

    -- If the networkID is already registered, update it
    Logger:info('INTERACTIONS', ('Updating networkID %s in interactions'):format(netId))
    for index, option in pairs(data.options) do
        if option.name and NETWORKED_ENTITIES[netId].options[index]?.name == option.name then
            Logger:info('INTERACTIONS', ('Option with name: ( %s ) already exists, updating'):format(option.name))
            NETWORKED_ENTITIES[netId].options[index] = option
        else
            NETWORKED_ENTITIES[netId].options[#NETWORKED_ENTITIES[netId].options + 1] = option
        end
    end

    -- Update the distance and interactDst if the new data is greater
    if data.distance > NETWORKED_ENTITIES[netId].distance then
        NETWORKED_ENTITIES[netId].distance = data.distance
    end

    if data.interactDst > NETWORKED_ENTITIES[netId].interactDst then
        NETWORKED_ENTITIES[netId].interactDst = data.interactDst
    end

    -- Update the offset if there is new data
    if data.offset then
        NETWORKED_ENTITIES[netId].offset = data.offset
    end

    interactions[id] = {
        id = id,
        entity = entity,
        options = NETWORKED_ENTITIES[netId].options,
        distance = NETWORKED_ENTITIES[netId].distance,
        interactDst = NETWORKED_ENTITIES[netId].interactDst,
        offset = NETWORKED_ENTITIES[netId].offset,
        resource = GetInvokingResource()
    }

    filterInteractions()

    return id
end exports('AddEntityInteraction', InteractAPI.addEntityInteraction)

---@param data table : { name, entity[number|string], bone[string], options, distance, interactDst, groups }
---@return number : The id of the interaction
-- Add an interaction point on a networked entity's bone
function InteractAPI.addEntityBoneInteraction(data)
 
    if not data.entity then
        Logger:error('INTERACTIONS', 'Entity is required to add an interaction')
        return
    end

    if not data.bone then
        Logger:error('INTERACTIONS', 'Bone is required to add an interaction')
        return
    end

    if not data.options then
        Logger:error('INTERACTIONS', 'Options are required to add an interaction')
        return
    end

    -- temp workaround until table refactoring.
    local key = string.format('%s:%s', data.entity, data.bone)
    if not ENTITY_BONES[key] then
        Logger:info('INTERACTIONS', ('Added new entity bone interaction: %s'):format(key))
        ENTITY_BONES[key] = {
            entity = data.entity,
            bone = data.bone,
            distance = data.distance or 10.0,
            interactDst = data.interactDst or 1.0,
            offset = data.offset or vec(0.0, 0.0, 0.0),
            options = data.options,
            groups = data.groups or nil,
        }
    else
        Logger:info('INTERACTIONS', ('Updating %s in bone interactions'):format(key))

        for index, option in pairs(data.options) do
            if option.name and NETWORKED_ENTITIES[netId].options[index]?.name == option.name then
                Logger:info('INTERACTIONS', ('Option with name: ( %s ) already exists, updating'):format(option.name))
                ENTITY_BONES[key].options[index] = option
            else
                ENTITY_BONES[key].options[#ENTITY_BONES[key].options + 1] = option
            end
        end

        -- Update the distance and interactDst if the new data is greater
        if data.distance > ENTITY_BONES[key].distance then
            ENTITY_BONES[key].distance = data.distance
        end

        if data.interactDst > ENTITY_BONES[key].interactDst then
            ENTITY_BONES[key].interactDst = data.interactDst
        end

        -- Update the offset if there is new data
        if data.offset then
            ENTITY_BONES[key].offset = data.offset
        end

        Logger:info('INTERACTIONS', ('Updated entity bone interaction: %s'):format(key))
        ENTITY_BONES[key] = {
            entity = data.entity,
            bone = data.bone,
            options = ENTITY_BONES[key].options,
            distance = ENTITY_BONES[key].distance,
            interactDst = ENTITY_BONES[key].interactDst,
            offset = ENTITY_BONES[key].offset,
            resource = GetInvokingResource()
        }
    end

    filterInteractions()

    return id
end exports('AddEntityBoneInteraction', InteractAPI.addEntityBoneInteraction)

---@param data table : { name, modelData table : { model[string], offset[vec3] }, options, distance, interactDst, groups }
-- Add interaction(s) to a list of models
function InteractAPI.addModelInteraction(data)
    data.distance = data.distance or 8.0
    data.interactDst = data.interactDst or 1.0
    for i = 1, #data.modelData do
        local modelData = data.modelData[i]
        if IsModelValid(modelData.model) then
            local min, max = GetModelDimensions(modelData.model)
            local size = (max - min)
            data.interactDst += (size.x / 8)
            data.distance += (size.x / 4)
            data.resource = GetInvokingResource()
            addModel(modelData.model, data.options, { offset = modelData.offset, distance = data.distance, interactDst = data.interactDst, resource = data.resource })
        end
    end
end exports('AddModelInteraction', InteractAPI.addModelInteraction)

---@param id number : The id of the interaction to remove
-- Remove an interaction point by id.
function InteractAPI.removeInteraction(id)
    interactions[id] = nil
    Logger:info('INTERACTIONS', ('Removed interaction %s'):format(id))
    filterInteractions()
end 
exports('RemoveInteraction', InteractAPI.removeInteraction)

---@param entity number : The entity to remove the interaction from
-- Remove an interaction point by entity.
function InteractAPI.removeInteractionByEntity(entity)
    for i = #interactions, 1, -1 do
        local interaction = interactions[i]

        if interaction.entity == entity then
            InteractAPI.removeInteraction(i)
        end
    end
end exports('RemoveInteractionByEntity', InteractAPI.removeInteractionByEntity)

---@param id number : The id of the interaction to remove the option from
---@param name? string : The name of the option to remove
-- Remove an option from an interaction point by id.
function InteractAPI.removeInteractionOption(id, name)
    if not interactions[id] then
        Logger:error('INTERACTIONS', ('Interaction with id: ( %s ) does not exist'):format(id))
        return
    end

    if not name then
        InteractAPI.removeInteraction(id)
        return
    end

    local options = interactions[id].options

    if not options then
        Logger:error('INTERACTIONS', ('Interaction with id: ( %s ) does not have any options'):format(id))
        InteractAPI.removeInteraction(id)
        return
    end

    for i = #options, 1, -1 do
        local option = options[i]

        if option.name == name then
            options[i] = nil
            Logger:info('INTERACTIONS', ('Removed option %s from interaction %s'):format(name, id))
        end
    end
end exports('RemoveInteractionOption', InteractAPI.removeInteractionOption)

---@param id number : The id of the interaction to update
---@param options table : The new options to update the interaction with
-- Update an interaction point by id.
function InteractAPI.updateInteraction(id, options)
    if not options then
        Logger:error('INTERACTIONS', 'Options are required to update an interaction')
        return
    end

    if not interactions[id] then
        Logger:error('INTERACTIONS', ('Interaction with id: ( %s ) does not exist'):format(id))
        return
    end

    if interactions[id] then
        interactions[id].options = options
        filterInteractions()
    end
end exports('UpdateInteraction', InteractAPI.updateInteraction)

function InteractAPI.getNearbyInteractions()
    local options = {}
    local amount = 0

    local playercoords = GetEntityCoords(PlayerPedId())

    -- Temp loop : these checks need to be broken out into their own threads.
    local nearbyVehicles = Utils.getNearbyVehicles(playercoords, _INTERACT.nearbyVehicleDistance, false)
    for i = 1, #nearbyVehicles do
        local vehicle = nearbyVehicles[i].vehicle
        local vehicleCoords = nearbyVehicles[i].coords

        if _INTERACT.vehicleBoneDefaults.enabled then
            for bone, data in pairs(_INTERACT.vehicleBoneDefaults.bones) do
                local key = string.format('%s:%s', vehicle, bone)
                if not ENTITY_BONES[key] then
                    InteractAPI.addEntityBoneInteraction({
                        entity = vehicle,
                        bone = bone,
                        options = data.options,
                        distance = data.distance,
                        interactDst = data.interactDst,
                        offset = data.offset,
                    })
                end
            end
        end
    end

    for _, interaction in pairs(ENTITY_BONES) do
        local distance = #(Utils.getCoordsFromInteract(interaction) - playercoords)
        if distance <= interaction.distance then
            amount += 1
            interaction.curDist = distance
            options[amount] = interaction
        end
    end

    local nearbyObjects = Utils.getNearbyObjects(playercoords, _INTERACT.nearbyObjectDistance)
    for i = 1, #nearbyObjects do
        local nearby = nearbyObjects[i]
        local hash = GetEntityModel(nearby.object)

        if MODELS[hash] then
            local interaction = Utils.table_deepclone(MODELS[hash])
            -- put the functions to original references
            for k, v in pairs(interaction) do
                if type(v) == "table" then
                    for id, item in pairs(v) do
                        if item.action then
                            item.action = MODELS[hash].options[id].action
                        end
                        if MODELS[hash].options[id].canInteract then
                            item.canInteract = MODELS[hash].options[id].canInteract
                        end
                        if item.canInteract then
                            local canInteract = false
                            pcall(function()
                                canInteract = item.canInteract(nearby.object, nearby.coords, item.args)
                            end)
                            v[id] = canInteract and item or nil
                        end
                    end
                end
            end
            local distance = #(nearby.coords - playercoords)
            interaction.entity = nearby.object

            if distance <= interaction.distance then
                amount += 1
                interaction.curDist = distance
                options[amount] = interaction
            end
        end
    end

    local amountOfInteractions = #filteredInteractions
    if amountOfInteractions > 0 then
        for i = 1, amountOfInteractions do
            local interaction = filteredInteractions[i]

            local coords = interaction.coords or Utils.getCoordsFromInteract(interaction)

            local distance = #(coords - playercoords)

            if distance <= interaction.distance then
                amount += 1
                interaction.curDist = distance
                options[amount] = interaction
            end
        end
    end

    for _, v in pairs(options) do
        for i = 1, #v.options, 1 do
            if not v.options[i] then
                table.remove(v.options, i)
            end
        end
    end
    if amount > 1 then
        table_sort(options, function(a, b)
            return a.curDist < b.curDist
        end)
    end

    return options
end

function InteractAPI.disable(state)
    LocalPlayer.state:set('interactionsDisabled', state, true)
end exports('Disable', InteractAPI.disable)

AddEventHandler('onClientResourceStop', function(resource)
    for i = #interactions, 1, -1 do
        local interaction = interactions[i]

        if interaction.resource == resource then
            InteractAPI.removeInteraction(interaction.id)
        end
    end
end)

return InteractAPI