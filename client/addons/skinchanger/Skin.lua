function GetFullSkin()
    local playerPed = PlayerPedId()
    local headBlendData = {}

    -- Récupérer les données du mélange génétique
    local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix = GetPedHeadBlendData(playerPed)
    if success then
        headBlendData = {
            dad = shapeFirst,
            mom = shapeSecond,
            face = shapeMix,
            skin = skinMix
        }
    end

    -- Fonction pour récupérer les overlays correctement
    local function GetOverlayData(overlayID)
        local _, value, opacity, colorType, color, secondColor = GetPedHeadOverlayData(playerPed, overlayID)
        return value, opacity, color, secondColor
    end
    local skin = 1
    
    for k,v in pairs(PedsCharCreator) do
        if v == GetEntityArchetypeName(playerPed) then
            skin = k
        end
    end

    local skinData = {
        sex = GetEntityArchetypeName(playerPed),
        eye_color = GetPedEyeColor(playerPed),
        hair_1 = GetPedDrawableVariation(playerPed, 2),
        hair_2 = GetPedTextureVariation(playerPed, 2),
        hair_color_1 = GetPedHairColor(playerPed),
        hair_color_2 = GetPedHairHighlightColor(playerPed),
        beard_1, beard_2, beard_3, beard_4 = GetOverlayData(1),
        eyebrows_1, eyebrows_2, eyebrows_3, eyebrows_4 = GetOverlayData(2),
        age_1, age_2 = GetOverlayData(3),
        makeup_1, makeup_2, makeup_3, makeup_4 = GetOverlayData(4),
        lipstick_1, lipstick_2, lipstick_3, lipstick_4 = GetOverlayData(8),
        blemishes_1, blemishes_2 = GetOverlayData(0),
        complexion_1, complexion_2 = GetOverlayData(6),
        sun_1, sun_2 = GetOverlayData(7),
        moles_1, moles_2 = GetOverlayData(9),
        chest_1, chest_2, chest_3 = GetOverlayData(10),
        bodyb_1, bodyb_2 = GetOverlayData(11),
        neck_thick = GetPedFaceFeature(playerPed, 13),
        cheeks_1 = GetPedFaceFeature(playerPed, 8),
        cheeks_2 = GetPedFaceFeature(playerPed, 9),
        cheeks_3 = GetPedFaceFeature(playerPed, 10),
        eye_open = GetPedFaceFeature(playerPed, 11),
        chin_width = GetPedFaceFeature(playerPed, 12),
        chin_height = GetPedFaceFeature(playerPed, 14),
        chin_lenght = GetPedFaceFeature(playerPed, 15),
        chin_hole = GetPedFaceFeature(playerPed, 16),
        jaw_1 = GetPedFaceFeature(playerPed, 17),
        jaw_2 = GetPedFaceFeature(playerPed, 18),
        nose_1 = GetPedFaceFeature(playerPed, 0),
        nose_2 = GetPedFaceFeature(playerPed, 1),
        nose_3 = GetPedFaceFeature(playerPed, 2),
        nose_4 = GetPedFaceFeature(playerPed, 3),
        nose_5 = GetPedFaceFeature(playerPed, 4),
        nose_6 = GetPedFaceFeature(playerPed, 5),
        face_md_weight = 0,
        skin_md_weight = 16,
        tshirt_1 = GetPedDrawableVariation(playerPed, 8),
        tshirt_2 = GetPedTextureVariation(playerPed, 8),
        torso_1 = GetPedDrawableVariation(playerPed, 11),
        torso_2 = GetPedTextureVariation(playerPed, 11),
        decals_1 = GetPedDrawableVariation(playerPed, 10),
        decals_2 = GetPedTextureVariation(playerPed, 10),
        arms = GetPedDrawableVariation(playerPed, 3),
        arms_2 = 0,
        pants_1 = GetPedDrawableVariation(playerPed, 4),
        pants_2 = GetPedTextureVariation(playerPed, 4),
        shoes_1 = GetPedDrawableVariation(playerPed, 6),
        shoes_2 = GetPedTextureVariation(playerPed, 6),
        mask_1 = GetPedDrawableVariation(playerPed, 1),
        mask_2 = GetPedTextureVariation(playerPed, 1),
        bproof_1 = GetPedDrawableVariation(playerPed, 9),
        bproof_2 = GetPedTextureVariation(playerPed, 9),
        chain_1 = GetPedDrawableVariation(playerPed, 7),
        chain_2 = GetPedTextureVariation(playerPed, 7),
        bags_1 = GetPedDrawableVariation(playerPed, 5),
        bags_2 = GetPedTextureVariation(playerPed, 5),
        helmet_1 = GetPedPropIndex(playerPed, 0),
        helmet_2 = GetPedPropTextureIndex(playerPed, 0),
        glasses_1 = GetPedPropIndex(playerPed, 1),
        glasses_2 = GetPedPropTextureIndex(playerPed, 1),
        watches_1 = GetPedPropIndex(playerPed, 6),
        watches_2 = GetPedPropTextureIndex(playerPed, 6),
        bracelets_1 = GetPedPropIndex(playerPed, 7),
        bracelets_2 = GetPedPropTextureIndex(playerPed, 7),
        ears_1 = GetPedPropIndex(playerPed, 2),
        ears_2 = GetPedPropTextureIndex(playerPed, 2),
        degrade_collection = 0,
        degrade_hashname = 0
    }

    -- Fusionner les données headBlend avec skinData
    for k, v in pairs(headBlendData) do
        skinData[k] = v
    end

    return skinData
end
