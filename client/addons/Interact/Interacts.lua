

local textures = _INTERACT.Textures
local CURRENT_SELECTION = 1
local CURRENT_OPTION = 0

-- CACHE
local SetDrawOrigin = SetDrawOrigin
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin
local Wait = Wait
local IsControlJustPressed = IsControlJustPressed
local SetScriptGfxAlignParams = SetScriptGfxAlignParams
local ResetScriptGfxAlign = ResetScriptGfxAlign
local IsNuiFocused = IsNuiFocused
local IsPedDeadOrDying = IsPedDeadOrDying
local IsPedCuffed = IsPedCuffed

local selected, unselected, interact, pin = textures.selected, textures.unselected, textures.interact, textures.pin

local function createOptions(coords, options)
    local width = Utils.getOptionsWidth(options)
    if #options == 1 then
        if options[1].canInteract then
            if options[1].canInteract() then
                Utils.drawOption(coords, options[1].label, _INTERACT.Style, selected, 0, width, false)
            end
        else
            Utils.drawOption(coords, options[1].label, _INTERACT.Style, selected, 0, width, false)
        end
    else
        for i = 1, #options do
            if options[i].canInteract then
                if options[i].canInteract() then
                    Utils.drawOption(coords, options[i].label, _INTERACT.Style, CURRENT_SELECTION == i and selected or unselected, i - 1, width, true)
                end
            else
                Utils.drawOption(coords, options[i].label, _INTERACT.Style, CURRENT_SELECTION == i and selected or unselected, i - 1, width, true)
            end
        end
    end
end

local function CheckCanInteract(interaction)
    for _, option in ipairs(interaction.options) do
        if option.canInteract then
            if option.canInteract() then
                return true
            end
        else
            return true
        end
    end
    return false
end

local table_type = table.type

local nearby = {}
local function CreateInteractions()
    for i = 1, #nearby do
        local interaction = nearby[i]
        local coords = interaction.coords or Utils.getCoordsFromInteract(interaction)

        if CheckCanInteract(interaction) then

            if GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z) then
                if i == 1 and (interaction.curDist <= interaction.interactDst) and (interaction.entity and {(interaction.entity == CurrentTarget)} or {true})[1] then
                    if interaction.id ~= CURRENT_OPTION then
                        CURRENT_OPTION = interaction.id
                        CURRENT_SELECTION = 1
                    end

                    local options = interaction.options

                    SetScriptGfxAlignParams(0.0, 0.0, 0.0, 0.0)
                    SetDrawOrigin(coords.x, coords.y, coords.z)
                    DrawSprite(_INTERACT.Style, interact, 0, 0, 0.0185, 0.03333333333333333, 0, 255, 255, 255, 255)
                    ResetScriptGfxAlign()
                    local option = options[CURRENT_SELECTION]
                    if option.hovered then
                        pcall(function() option.hovered(interaction.entity, interaction.coords, option.args) end) 
                    end
                    if IsControlJustPressed(0, 38) then
                        if option.action then
                            pcall(function() option.action(interaction.entity, interaction.coords, option.args) end) 
                        elseif option.serverEvent then
                            TriggerServerEvent(option.serverEvent, option.args)
                        elseif option.event then
                            TriggerEvent(option.event, option)
                        end
                    end

                    if table_type(options) ~= 'empty' then
                        createOptions(coords, options)

                        if CURRENT_SELECTION ~= 1 and (IsControlJustPressed(0, 172) or IsDisabledControlJustPressed(0, 15)) then
    
                            CURRENT_SELECTION -= 1
                        elseif CURRENT_SELECTION ~= #options and (IsControlJustPressed(0, 173) or IsDisabledControlJustPressed(0, 14)) then
                            CURRENT_SELECTION += 1
                        end
                    end

                else
                    SetDrawOrigin(coords.x, coords.y, coords.z + 0.05)
                    DrawSprite(_INTERACT.Style, pin, 0, 0, 0.02, 0.035, 0, 255, 255, 255, 255)
                end

                ClearDrawOrigin()
            end
        end
    end
end

local function isDisabled()
    if LocalPlayer.state.interactionsDisabled then
        return true
    end

    if _INTERACT.Disable.onDeath and (IsPedDeadOrDying(PlayerPedId()) or LocalPlayer.state.isDead) then
        return true
    end

    if _INTERACT.Disable.onNuiFocus and IsNuiFocused() then
        return true
    end
    --[[
    if _INTERACT.Disable.onVehicle and cache.vehicle then
        return true
    end--]]

    if _INTERACT.Disable.onHandCuff and IsPedCuffed(PlayerPedId()) then
        return true
    end

    return false
end

-- Fast thread
CreateThread(function ()
    RequestStreamedTextureDict(_INTERACT.Style, 1)
	while not HasStreamedTextureDictLoaded(_INTERACT.Style) do
		Wait(50)
		Console.Debug("wait texture")
	end
    while true do
        local wait = 500
        if next(nearby) and not isDisabled() then
            wait = 0
            CreateInteractions()
        end
        Wait(wait)
    end
end)

-- Slow checker thread
CreateThread(function()
    while true do
        nearby = InteractAPI.getNearbyInteractions()
        Wait(500)
    end
end)