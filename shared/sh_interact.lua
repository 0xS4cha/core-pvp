_INTERACT = _INTERACT or {}
_INTERACT.Style = 'core_ui'
_INTERACT.Textures = {
    pin = 'selected',
    interact = 'key',
    selected = 'label',
    unselected = 'label_no',
    select_opt = 'circle_selected',
    unselect_opt = 'circle',
}
_INTERACT.Disable = {
    onDeath = true, -- Disable interactions on death
    onNuiFocus = true, -- Disable interactions while NUI is focused
    onVehicle = true, -- Disable interactions while in a vehicle
    onHandCuff = true, -- Disable interactions while handcuffed
}

_INTERACT.nearbyObjectDistance = 20.0 -- Keep it at 15.0 at minimum.
_INTERACT.nearbyVehicleDistance = 4.0

_INTERACT.vehicleBoneDefaults = {
    enabled = true,
    bones = {
        ['boot']= {
            distance = 3.0,
            interactDst = 1.5,
            offset = vec3(0.0, 0.0, 0.0),
            options = {
                {
                    name = 'interact:trunk',
                    label = 'Ouvrir le coffre',
                    action = function(entity)      
                    end,
                },
                {
                    name = 'interact:trunk',
                    label = 'Entrer dans le coffre',
                    action = function(entity)
                    end,
                }
            },
        }
    }
}