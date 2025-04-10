-- Fonction pour créer un PED
clonedPed = nil
function createPed(locationx, locationy, locationz)
    -- Récupérer le hash du modèle du joueur
    local playerPed = PlayerPedId()
    local hash = GetEntityModel(playerPed)

    -- Charger le modèle
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
    end

    -- Créer le ped avec le même modèle que le joueur
    return CreatePed(26, hash, locationx, locationy, locationz, 0.0, false, false)
end

function crossArms(ped)
    -- Charger le dictionnaire d'animations et l'animation spécifique
    local dict = "anim@amb@nightclub@peds@"
    local anim = "rcmme_amanda1_stand_loop_cop"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end

    -- Jouer l'animation sur le ped avec les flags appropriés
    if not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end

-- Fonction principale pour démarrer le clonage du PED
function start(x, y)
    clonedPed = createPed(0.0, 0.0, 0.0) -- Coordonnées initiales à (0,0,0)
    SetEntityCollision(clonedPed, false, true)
    SetEntityInvincible(clonedPed, true)
    NetworkSetEntityInvisibleToNetwork(clonedPed, true)
    ClonePedToTarget(PlayerPedId(), clonedPed)
    SetEntityCanBeDamaged(clonedPed, false)
    SetBlockingOfNonTemporaryEvents(clonedPed, true)

    local positionBuffer = {}
    local bufferSize = 5

    while true do
        -- Obtenir les coordonnées du centre de l'écran
        local screenW, screenH = GetActiveScreenResolution()
        local centerX = screenW / 2
        local centerY = (screenH / 2) + (screenH * 0.25) -- Abaissé de 20% par rapport au centre

        -- Convertir les coordonnées de l'écran en coordonnées du monde
        local world, normal = GetWorldCoordFromScreenCoord(x, y)
        local depth = 3.5
        local target = world + normal * depth
        local camRot = GetGameplayCamRot(2)

        table.insert(positionBuffer, target)
        if #positionBuffer > bufferSize then
            table.remove(positionBuffer, 1)
        end

        local averagedTarget = vector3(0, 0, 0)
        for _, position in ipairs(positionBuffer) do
            averagedTarget = averagedTarget + position
        end
        averagedTarget = averagedTarget / #positionBuffer

        SetEntityCoords(clonedPed, averagedTarget.x, averagedTarget.y, averagedTarget.z, false, false, false, true)
        SetEntityHeading(clonedPed, camRot.z + 180.0)
        SetEntityRotation(clonedPed, camRot.x * (-1), 0.0, camRot.z + 180.0, 2, true)

        -- Appliquer l'animation des bras croisés dans la boucle principale
        crossArms(clonedPed)

        Citizen.Wait(0)
    end
end




AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and clonedPed then
        DeleteEntity(clonedPed)
        clonedPed = nil
    end
end)
