-- CREDITS
-- Andyyy7666: https://github.com/overextended/ox_lib/pull/453
-- AvarianKnight: https://forum.cfx.re/t/allow-drawgizmo-to-be-used-outside-of-fxdk/5091845/8?u=demi-automatic

local dataview = require 'files.lua.dataview'

local enableScale = false -- allow scaling mode. doesnt scale collisions and resets when physics are applied it seems

local gizmoEnabled = false
local currentMode = 'translate'
local isRelative = false
local currentEntity

-- FUNCTIONS

local function normalize(x, y, z)
    local length = math.sqrt(x * x + y * y + z * z)
    if length == 0 then
        return 0, 0, 0
    end
    return x / length, y / length, z / length
end

local function makeEntityMatrix(entity)
    local f, r, u, a = GetEntityMatrix(entity)
    local view = dataview.ArrayBuffer(60)

    view:SetFloat32(0, r[1])
        :SetFloat32(4, r[2])
        :SetFloat32(8, r[3])
        :SetFloat32(12, 0)
        :SetFloat32(16, f[1])
        :SetFloat32(20, f[2])
        :SetFloat32(24, f[3])
        :SetFloat32(28, 0)
        :SetFloat32(32, u[1])
        :SetFloat32(36, u[2])
        :SetFloat32(40, u[3])
        :SetFloat32(44, 0)
        :SetFloat32(48, a[1])
        :SetFloat32(52, a[2])
        :SetFloat32(56, a[3])
        :SetFloat32(60, 1)
    return view
end

local function applyEntityMatrix(entity, view)
    local x1, y1, z1 = view:GetFloat32(16), view:GetFloat32(20), view:GetFloat32(24)
    local x2, y2, z2 = view:GetFloat32(0), view:GetFloat32(4), view:GetFloat32(8)
    local x3, y3, z3 = view:GetFloat32(32), view:GetFloat32(36), view:GetFloat32(40)
    local tx, ty, tz = view:GetFloat32(48), view:GetFloat32(52), view:GetFloat32(56)

    if not enableScale then
        x1, y1, z1 = normalize(x1, y1, z1)
        x2, y2, z2 = normalize(x2, y2, z2)
        x3, y3, z3 = normalize(x3, y3, z3)
    end

    SetEntityMatrix(entity,
        x1, y1, z1,
        x2, y2, z2,
        x3, y3, z3,
        tx, ty, tz
    )
end

-- LOOPS

local function gizmoLoop(entity)
    if not gizmoEnabled then
        return LeaveCursorMode()
    end

    EnterCursorMode()

    if IsEntityAPed(entity) then
        SetEntityAlpha(entity, 200)
    else
        SetEntityDrawOutline(entity, true)
    end

    while gizmoEnabled and DoesEntityExist(entity) do
        Wait(0)

        DisableControlAction(0, 24, true)  -- lmb
        DisableControlAction(0, 25, true)  -- rmb
        DisableControlAction(0, 140, true) -- r
        DisablePlayerFiring(p:ped(), true)

        local matrixBuffer = makeEntityMatrix(entity)
        local changed = DrawGizmo(matrixBuffer:Buffer(), 'Editor1', Citizen.ReturnResultAnyway())


        if changed then
            applyEntityMatrix(entity, matrixBuffer)
        end
    end

    LeaveCursorMode()

    if DoesEntityExist(entity) then
        if IsEntityAPed(entity) then SetEntityAlpha(entity, 255) end
        SetEntityDrawOutline(entity, false)
    end

    gizmoEnabled = false
    currentEntity = nil
end

local function textUILoop()
    CreateThread(function()
        while gizmoEnabled do
            Wait(1)
            local scaleText = (enableScale and '[S]     - Scale Mode  \n') or ''
            Utils.ShowHelpNotification(('Mode ~b~<C>actuels</C>~s~: %s | %s  \n'):format(currentMode,
                    (isRelative and 'Objet') or 'Monde') ..
                '[Z]     - Mode ~b~<C>translation</C>~s~  \n' ..
                '[R]     - Mode ~b~<C>rotation</C>~s~  \n' ..
                scaleText ..
                '[Q]     - Objet/Monde  \n' ..
                '[LALT]  - Placer sur ~b~<C>sol</C>~s~  \n' ..
                '[ENTER] - Terminer l\'~b~<C>édition</C>~s~  \n'
            )
        end
    end)
end

-- EXPORTS

function useGizmo(entity)
    gizmoEnabled = true
    currentEntity = entity
    textUILoop()
    gizmoLoop(entity)

    return {
        handle = entity,
        position = GetEntityCoords(entity),
        rotation = GetEntityRotation(entity)
    }
end

-- CONTROLS these execute the existing gizmo commands but allow me to add additional logic to update the mode display.


Keys.Register({
    name = '_gizmoSelect',
    description = 'Sélectionne le gizmo actuellement mis en surbrillance',
    defaultMapper = 'MOUSE_BUTTON',
    defaultKey = 'MOUSE_LEFT',
    onPressed = function(self)
        if not gizmoEnabled then return end
        ExecuteCommand('+gizmoSelect')
    end,
    onReleased = function(self)
        ExecuteCommand('-gizmoSelect')
    end
})

Keys.Register({
    name = '_gizmoTranslation',
    description = 'Définit le mode du Gizmo en traduction',
    defaultKey = 'Z',
    onPressed = function(self)
        if not gizmoEnabled then return end
        currentMode = 'Translation'
        ExecuteCommand('+gizmoTranslation')
    end,
    onReleased = function(self)
        ExecuteCommand('-gizmoTranslation')
    end
})

Keys.Register({
    name = '_gizmoRotation',
    description = 'Définit le mode pour le gizmo en rotation',
    defaultKey = 'R',
    onPressed = function(self)
        if not gizmoEnabled then return end
        currentMode = 'Rotate'
        ExecuteCommand('+gizmoRotation')
    end,
    onReleased = function(self)
        ExecuteCommand('-gizmoRotation')
    end
})

Keys.Register({
    name = '_gizmoLocal',
    description = "Basculez Gizmo pour être local à l'entité plutôt qu'au monde",
    defaultKey = 'Q',
    onPressed = function(self)
        if not gizmoEnabled then return end
        isRelative = not isRelative
        ExecuteCommand('+gizmoLocal')
    end,
    onReleased = function(self)
        ExecuteCommand('-gizmoLocal')
    end
})

Keys.Register({
    name = 'gizmoclose',
    description = 'close gizmo',
    defaultKey = 'RETURN',
    onPressed = function(self)
        if not gizmoEnabled then return end
        gizmoEnabled = false
    end,
})

Keys.Register({
    name = 'gizmoSnapToGround',
    description = "Place Objet sur sol / sur la surface",
    defaultKey = 'LMENU',
    onPressed = function(self)
        if not gizmoEnabled then return end
        PlaceObjectOnGroundProperly_2(currentEntity)
    end,
})

if enableScale then
    Keys.Register({
        name = '_gizmoScale',
        description = "Définit le mode pour le gizmo à l'échelle",
        defaultKey = 'S',
        onPressed = function(self)
            if not gizmoEnabled then return end
            currentMode = 'Scale'
            ExecuteCommand('+gizmoScale')
        end,
        onReleased = function(self)
            ExecuteCommand('-gizmoScale')
        end
    })
end
