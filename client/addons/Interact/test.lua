

InteractAPI.addModelInteraction({
    modelData = {
        { model = 'prop_burgerstand_01', offset = vec(-0.5, 0.0, 1.0) },
    },
    distance = 7.0, 
    interactDst = 1.5,
    offset = vec(0.0, 0.0, 0.0),
    options = {
            {
                label = GetPhrase('Interact_buy_burger'),
                canInteract = function(entity, coords, args)
                    return true
                end,
                action = function(entity, coords, args)

                end,

             },
            }
})