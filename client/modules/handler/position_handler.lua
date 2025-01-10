
function InitPositionHandler(pos)
    Utils.TeleportPlayer(vector3(pos.x, pos.y, pos.z))


    local _, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)
    SetEntityCoordsNoOffset(PlayerPedId(), pos.x, pos.y, z, 0.0, 0.0, 0.0)
end