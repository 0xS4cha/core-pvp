
_INVENTORY.PlayerPedPreview = nil

GetFieldValueFromName = function(stringName)
	local data = GetResourceKvpString(stringName)
	return data and json.decode(data) or {}
end

function CreatePedScreen(first)
    CreateThread(function()
        nopedinv = GetFieldValueFromName('core').pedscreen
        if nopedinv == true then
            return
        end
        local heading = GetEntityHeading(PlayerPedId())
        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_JOINING_SCREEN"), true, -1)
        Wait(100)
        PlayerPedPreview = ClonePed(PlayerPedId(), heading, true, false)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedPreview))
        SetEntityCoords(PlayerPedPreview, x, y, z - 10)
        SetMouseCursorVisibleInMenus(false)
        FreezeEntityPosition(PlayerPedPreview, true)
        SetEntityVisible(PlayerPedPreview, false, false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedPreview, false)
        Wait(200)
        SetPedAsNoLongerNeeded(PlayerPedPreview)
        GivePedToPauseMenu(PlayerPedPreview, 0.5)
        SetPauseMenuPedLighting(true)
        if first then
            SetPauseMenuPedSleepState(false)
            Wait(1000)
            SetPauseMenuPedSleepState(true)
        else
            SetPauseMenuPedSleepState(true)
        end
    end)
end

function DeletePedScreen()
    DeleteEntity(PlayerPedPreview)
    SetFrontendActive(false)
end

function RefreshPedScreen()
    if DoesEntityExist(PlayerPedPreview) then
        DeletePedScreen()
        Wait(500)
        if _INVENTORY.open then
            CreatePedScreen(false)
        end
    end
end