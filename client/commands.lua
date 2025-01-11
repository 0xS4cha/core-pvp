







-- UTILS --


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DrawBoxAroundEntity(entity)
    local model = GetEntityModel(entity)
    local maxDim , minDim = GetModelDimensions(model)
    local a = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, minDim.z)
    local b = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, minDim.z)
    local c = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, minDim.z)
    local d = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, minDim.z)
    local e = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, maxDim.z)
    local f = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, maxDim.z)
    local g = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, maxDim.z)
    local h = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, maxDim.z)
    DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 255, 0, 0, 255)
    DrawLine(b.x, b.y, b.z, c.x, c.y, c.z, 255, 0, 0, 255)
    DrawLine(c.x, c.y, c.z, d.x, d.y, d.z, 255, 0, 0, 255)
    DrawLine(d.x, d.y, d.z, a.x, a.y, a.z, 255, 0, 0, 255)
    DrawLine(e.x, e.y, e.z, f.x, f.y, f.z, 255, 0, 0, 255)
    DrawLine(f.x, f.y, f.z, g.x, g.y, g.z, 255, 0, 0, 255)
    DrawLine(g.x, g.y, g.z, h.x, h.y, h.z, 255, 0, 0, 255)
    DrawLine(h.x, h.y, h.z, e.x, e.y, e.z, 255, 0, 0, 255)
    DrawLine(a.x, a.y, a.z, e.x, e.y, e.z, 255, 0, 0, 255)
    DrawLine(b.x, b.y, b.z, f.x, f.y, f.z, 255, 0, 0, 255)
    DrawLine(c.x, c.y, c.z, g.x, g.y, g.z, 255, 0, 0, 255)
    DrawLine(d.x, d.y, d.z, h.x, h.y, h.z, 255, 0, 0, 255)
end

