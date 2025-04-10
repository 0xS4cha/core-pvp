Modules.UI = {}
Modules.UI.cooldown = false
Modules.UI.font = {}
Modules.UI.AnimatedFrames = {}
Modules.UI.pages = {

  
}
Modules.UI.lockedControls = {
    { 24, 30, 31, 32, 33, 34, 35, 69, 70, 92, 114, 121, 140, 141, 142, 257, 263, 264, 331, 1, 2, 4, 5, 17, 16, 15, 14 }
}

function Modules.UI.IsAnySubMenuActive()
    for k, v in pairs(Modules.UI.pages) do
        if v.active then
            return true
        end
    end
    return false
end

function Modules.UI.SetPageActive(page)
    Modules.UI.pages[page].active = true
end

function Modules.UI.SetPageInactive(page)
    if Modules.UI.pages[page] then
        Modules.UI.pages[page].active = false
    end
end

function Modules.UI.SetFullscreenLoaderActive(status)
    if status then
        SendNUIMessage({
            type = 'toggleLoaderOn',
        })
    else
        SendNUIMessage({
            type = 'toggleLoaderOff',
        })
    end
end

function Modules.UI.ForceStopIntro()
    SendNUIMessage({
        type = 'stopIntro',
    })
end

Citizen.CreateThread(function()
    while true do
        local lockControls = false
        local showCursor = false


        for k, v in pairs(Modules.UI.pages) do
            if v.active then
                if v.showCursor then
                    showCursor = true
                end
                if v.lockControls then
                    lockControls = true
                end
                v.drawFunction()
            end
        end

        if showCursor then
            ShowCursorThisFrame()
            SetMouseCursorSprite(1)
        end

        if lockControls then
            for k, v in pairs(Modules.UI.lockedControls[1]) do
                if v ~= nil then
                    DisableControlAction(0, v, true)
                end
            end
        end

        Wait(0)
    end
end)

function Modules.UI.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end

function Modules.UI.LoadStreamDict(dict)
    while not HasStreamedTextureDictLoaded(dict) do
        RequestStreamedTextureDict(dict, 1)
        -- print("Loading dict ", dict)
        Wait(0)
    end
    Modules.UI.RealWait(100)
end

function Modules.UI.LoadFont(font)
    RegisterFontFile(font[1]) -- the name of your .gfx, without .gfx
    local fontId = RegisterFontId(font[2]) -- the name from the .xml

    Modules.UI.font[font[2]] = fontId
    Modules.Utils.RealWait(100)
end

local cachedResult = nil
function Modules.UI.GetTopLeftMinimap()
    if cachedResult == nil then
        SetScriptGfxAlign(string.byte('L'), string.byte('B'))
        local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
        ResetScriptGfxAlign()
        local w, h = GetActiveScreenResolution()
        cachedResult = { w * minimapTopX, h * minimapTopY }
        return { w * minimapTopX, h * minimapTopY }
    else
        return cachedResult
    end
end

-- DrawRectangle(vector2(self.baseX, self.baseY - 0.005), vector2(self.baseWidth, self.baseHeight - 0.025), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})
function Modules.UI.DrawRectangle(center, screenX, screenY, width, height, color, action, hoverColor, actions, hoverAction, sound, devmod)
    if devmod ~= nil and devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        print(x, y)
        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
        position = vector2(x, y)
    end
    local pos
    if center == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end
    DrawRect(pos[1], pos[2], width, height, color[1], color[2], color[3], color[4])

    if action ~= nil and action ~= false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = screenX, y = screenY }, width, height) then
            SetMouseCursorSprite(4)
            if hoverColor[4] ~= 0 then -- Avoid drawing anything if alpha == 0, performaaaaance
                DrawRect(pos[1], pos[2],  width + 0.003, height + 0.003, hoverColor[1], hoverColor[2], hoverColor[3],
                    hoverColor[4])
            end

            if Modules.UI.HandleControl() then
                if sound == nil then
                    --PlayCustomSound("ui_click.ogg", 0.02)
                else
                    --PlayCustomSound(sound, 0.02)
                end
                actions()
            end

            if hoverAction ~= nil then
                hoverAction()
            end
            return true
        else
            return false
        end
    end
end

function Modules.UI.DrawSlider(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height

    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3], progressColor[4])
    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = screenX, y = screenY }, width, height) then
            SetMouseCursorSprite(4)
            if IsDisabledControlPressed(0, 24) then

                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size

                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end


function Modules.ColorPanel(x, y, color, max, box, MinimumIndex, CurrentIndex, cb)
    local Maximum = (#color > max) and max or #color

    
    for Index = 1, Maximum do
        Modules.UI.DrawRectangle(true, x + (box.width * (Index - 1) * 1.3), y, box.width, box.height, { color[MinimumIndex + Index - 1][1], color[MinimumIndex + Index - 1][2], color[MinimumIndex + Index - 1][3], 255 }, false, { 255, 255, 255, 0 }, function() end, nil, false, false)
    end
    Modules.UI.DrawRectangle(true, x + (box.width * (CurrentIndex - MinimumIndex) * 1.3), y + (box.height/2), box.width, 0.008, { 255, 255, 255, 255 }, false, { 255, 255, 255, 0 }, function() end, nil, false, false)
    local arrowLeft = {x = x - 0.03, w = 0.015*1.5, h = 0.03*1.5}
    local arrowRight = {x = 0.03 + x + (box.width * (Maximum - 1) * 1.3), w = 0.015*1.5, h = 0.03*1.5}
    DrawSprite("commonmenu", "arrowleft", x - 0.03, y, .015*1.5, .03*1.5, 0.0, 255, 255, 255, 255)
    DrawSprite("commonmenu", "arrowright", 0.03 + x + (box.width * (Maximum - 1) * 1.3), y, .015*1.5, .03*1.5, 0.0, 255, 255, 255, 255)
    if IsMouseInBounds(arrowLeft.x, y, arrowLeft.w, arrowLeft.h) then
        if Modules.UI.HandleControl() then
            CurrentIndex = CurrentIndex - 1

            if CurrentIndex < 1 then
                CurrentIndex = #color
                MinimumIndex = #color - Maximum + 1
            elseif CurrentIndex < MinimumIndex then
                MinimumIndex = MinimumIndex - 1
            end
        end
    end
    if IsMouseInBounds(arrowRight.x, y, arrowRight.w, arrowRight.h) then
        if Modules.UI.HandleControl() then
            CurrentIndex = CurrentIndex + 1

            if CurrentIndex > #color then
                CurrentIndex = 1
                MinimumIndex = 1
            elseif CurrentIndex > MinimumIndex + Maximum - 1 then
                MinimumIndex = MinimumIndex + 1
            end
        end
    end
    cb(MinimumIndex, CurrentIndex)
end



SlideData = {}
TableNum = 1

function Modules.UI.DrawSlide(id, font, x, y, variale, addX, addY, settings)
    if not SlideData[id] then
        SlideData[id] = { currentItemIndex = 1 }  -- Créez des données de glissière spécifiques à ce sous-menu s'il n'en existe pas encore
    end

    local slideData = SlideData[id]  -- Obtenez les données de glissière spécifiques à ce sous-menu


		local itemText = variale[slideData.currentItemIndex]
	--	UI:DrawText('all', font, itemText, taille, x, y, 255, 255, 255, false, 0)
        if settings.parent ~= nil then
            Modules.UI.DrawTexts(x, y, settings.parent..itemText, true, font, { 255, 255, 255, 255 }, Sunflowerlight, false, false)
        else
            Modules.UI.DrawTexts(x, y, itemText, true, font, { 255, 255, 255, 255 }, Sunflowerlight, false, false)
        end
        local left = {x = (tonumber(x - addX)), y = (tonumber(y + addY))}
        local right = {x = (tonumber(x + addX)), y = (tonumber(y + addY))}
		DrawSprite("commonmenu", "arrowright", x + addX, y + addY, .015, .03, 0.0, 255, 255, 255, 255)
		DrawSprite("commonmenu", "arrowleft", x - addX, y + addY, .015, .03, 0.0, 255, 255, 255, 255)

        
		if IsMouseInBounds(right.x, right.y, 0.01, 0.015) then
			if  Modules.UI.HandleControl() then
				slideData.currentItemIndex = slideData.currentItemIndex + 1
				if slideData.currentItemIndex > #variale then
						slideData.currentItemIndex = 1
				end
		    end
		end
		--if IsMouseInBounds(x + 0.03, y + 0.01,) then

		--if IsMouseInBounds(x - 0.03, y + 0.01, 0.01, 0.015) then
		if IsMouseInBounds(left.x, left.y, 0.015, 0.03) then
			if Modules.UI.HandleControl() then
                slideData.currentItemIndex = slideData.currentItemIndex - 1
                if slideData.currentItemIndex < 1 then
                    slideData.currentItemIndex = #variale
                end
            end
        end
	return itemText
end

function Modules.UI.DrawProgressBar(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings
                                    , cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width + 0.005, height + 00.005, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height

    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3],
        progressColor[4])

    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = screenX, y = screenY }, width, height) then
            SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size

                --print(newValue)
                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end

function Modules.UI.DrawSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue,
                               alpha, actions, hover)

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)

    if Modules.Sheets.IsSpriteAnimated(textureDict, textureName) then
        textureName = textureName .. Modules.Sheets.GetActualFrame(textureDict, textureName)
    end

    if hover == nil then
        DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
    else
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = screenX, y = screenY }, width, height) then
            DrawSprite(hover[1], hover[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        else
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        end
    end

    if actions ~= nil then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = screenX, y = screenY }, width, height) then
            SetMouseCursorSprite(4)

            if Modules.UI.HandleControl() then
                --PlayCustomSound("ui_click.ogg", 0.02)
                actions()
            end

            return true
        else
            return false
        end
    end
end

Modules.UI.HoveredCache = {}

function Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
    local uniqueID = textureDict .. textureName .. screenX .. screenY
    if Modules.UI.HoveredCache[uniqueID] == nil then
        Modules.UI.HoveredCache[uniqueID] = false
        return false, uniqueID
    else
        return Modules.UI.HoveredCache[uniqueID], uniqueID
    end
end

function Modules.UI.SetHoveredStatus(uniqueID, status)
    if Modules.UI.HoveredCache[uniqueID] ~= nil then
        Modules.UI.HoveredCache[uniqueID] = status
    end
end






function Modules.UI.DrawLists(list, cb)
    local scrollAmount = 1
    if IsControlPressed(0, 16) or IsDisabledControlPressed(0, 16) then -- Scroll Drown
        if #list > scrollAmount then
            scrollAmount = scrollAmount + 1
        else
            scrollAmount = 0
        end
    end
    if IsControlPressed(0, 17) or IsDisabledControlPressed(0, 17) then -- Scroll Up
        if #list < scrollAmount then
            scrollAmount = scrollAmount - 1
        else
            scrollAmount = 0
        end
    end
    cb(scrollAmount)
end

function Modules.UI.DrawSpriteNew(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false

    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        print(x, y)

        screenX = x
        screenY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    local pos
    if settings.centerDraw ~= nil and settings.centerDraw == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end

    if Modules.Sheets.IsSpriteAnimated(textureDict, textureName) then
        textureName = textureName .. Modules.Sheets.GetActualFrame(textureDict, textureName)
    end

    if settings.Draw3d ~= nil then
        SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
        pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
    end

    if settings.NoHover ~= nil and settings.NoHover == true then
        DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
    else
        if settings.Draw3d ~= nil then
            _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y,
                settings.Draw3d.pos.z)
        end
        if  IsMouseInBounds(pos[1],  pos[2], width, height)  then
            onHovered = true
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX,
                screenY)
            if not aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, true)
               -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
            end
            if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                if settings.CustomHoverTexture[4] ~= nil and settings.CustomHoverTexture[5] ~= nil then
                    local x, y = Modules.UI.ConvertToPixel(settings.CustomHoverTexture[4], settings.CustomHoverTexture[5])
                    width = x
                    height = y
                end

                DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height
                    , heading, settings.CustomHoverTexture[3][1], settings.CustomHoverTexture[3][2], settings.CustomHoverTexture[3][3], settings.CustomHoverTexture[3][4])
            else
                DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            end
        else
            onHovered = false
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX,
                screenY)
            if aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, false)
            end
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        end
    end


    if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
        if IsMouseInBounds(pos[1],  pos[2], width, height) then
            SetMouseCursorSprite(4)
            onHovered = true
            if Modules.UI.HandleControl() then
                --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
              --  Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.02)
                onSelected = true
            end
        end
    end

    if settings.Draw3d ~= nil then
        ClearDrawOrigin()
    end

    cb(onSelected, onHovered, pos)
end

function Modules.UI.FadeOutSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha, time,
                                  remove)
    Citizen.CreateThread(function()
        local originalAlpha = alpha
        for i = 0, originalAlpha do
            alpha = alpha - remove
            DrawSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha)

            if alpha <= 0 then
                break
            end
            Wait(time)
        end
    end)
end


function IsMouseInBounds(X, Y, Width, Height)
	local MX, MY = GetControlNormal(0, 239) + Width / 2, GetControlNormal(0, 240) + Height / 2
	return (MX >= tonumber(X) and MX <= tonumber(X) + Width) and (MY > Y and MY < Y + Height)
end
-- Position = mouse pos
function Modules.UI.isMouseOnButton(position, buttonPos, Width, Heigh)
    -- print(position, buttonPos, Width, Heigh)
    return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + Width and
        position.y < buttonPos.y + Heigh
end

function Modules.UI.HandleCooldown()
    if not Modules.UI.cooldown then
        Modules.UI.cooldown = true
        Citizen.CreateThread(function()
            Wait(150)
            Modules.UI.cooldown = false
        end)
    end
end

local clickControl = { 24, 176 }
function Modules.UI.HandleControl()
    for k, v in pairs(clickControl) do
        if not Modules.UI.cooldown then
            if IsControlJustReleased(0, v) or IsDisabledControlJustReleased(0, v) then
                Modules.UI.HandleCooldown()
                return true
            end
        end
    end
    return false
end

local Down = { 16 }
function Modules.UI.HandleControlDown()
    for k, v in pairs(Down) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then

                return true
            end
        end
    end
    return false
end

local Up = { 17 }
function Modules.UI.HandleControlUp()
    for k, v in pairs(Up) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then
                return true
            end
        end
    end
    return false
end

local Z = { 172 }
function Modules.UI.HandleControlZ()
    for k, v in pairs(Z) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then
                return true
            end
        end
    end
    return false
end


local Q = { 174 }
function Modules.UI.HandleControlQ()
    for k, v in pairs(Q) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then
                return true
            end
        end
    end
    return false
end

local S = { 173 }
function Modules.UI.HandleControlS()
    for k, v in pairs(S) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then
                return true
            end
        end
    end
    return false
end

local D = { 175 }
function Modules.UI.HandleControlD()
    for k, v in pairs(D) do
        if not Modules.UI.cooldown then
            if IsControlPressed(0, v) or IsDisabledControlPressed(0, v) then
                return true
            end
        end
    end
    return false
end


function Modules.UI.FadeInSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha, time, add)
    Citizen.CreateThread(function()
        local originalAlpha = alpha
        for i = 0, originalAlpha do
            alpha = alpha + add
            DrawSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha)

            if alpha <= originalAlpha then
                break
            end
            Wait(time)
        end
    end)
end

function Modules.UI.DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod, alpha, add, time, cb)

    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        x = x2
        y = y2

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end
    if not alpha or not add or not time or alpha == nil or add == nil or time == nil then
        SetTextFont(font)
        SetTextScale(scale, scale)

        SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x, y)
    else
        Citizen.CreateThread(function()
            local originalAlpha = alpha
            for i = 0, 255 do
                alpha = alpha + add
                SetTextFont(font)
                SetTextScale(scale, scale)
        
                SetTextColour(rgb[1], rgb[2], rgb[3], alpha)
                SetTextEntry("STRING")
                SetTextCentre(center)
                AddTextComponentString(text)
                EndTextCommandDisplayText(x, y)
                if alpha >= 255  then
                    break
                end
                Wait(time)
            end
        end)
    end
end

function Modules.UI.DrawTextsNoLimit(x, y, text, center, scale, rgb, font, rightJustify, devmod)
    AddTextEntry("text", text)

    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        print(x2, y2)

        x = x2
        y = y2
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function Modules.UI.Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255) -- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- pos.xyz
-- textureDict
-- textureName
-- x
-- y
-- width
-- height
-- heading
-- r
-- g
-- b
-- a
function Modules.UI.DrawSprite3d(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x, y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        --print(get, x, y)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
        
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = ((1 / dist) * 2) * fov
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            (data.x or 0) * scale,
            (data.y or 0) * scale,
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

function Modules.UI.DrawSprite3dNoDownSize(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x, y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local scale = 1
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            data.x or (0 * scale),
            data.y or (0 * scale),
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw

end

-- function Modules.UI.ConvertToPixel(x, y)
--     return (x * 1920), (y * 1080)
-- end

function Modules.UI.ConvertToPixel(x, y)
    return (x / 1920), (y / 1080)
end

function Modules.UI.ConvertToRes(x, y)
    return (x * 1920), (y * 1080)
end

function Modules.UI.MeasureStringWidth(str, font, scale)
    local len
    local function Execute(str, font, scale)
        BeginTextCommandGetWidth("CELL_EMAIL_BCON")
        AddTextComponentSubstringPlayerName(str)
        SetTextFont(font or 0)
        SetTextScale(1.0, scale or 0)
        len, _ = Modules.UI.ConvertToPixel(EndTextCommandGetWidth(true) * 1920, 0)
    end


    return len
end
function MeasureStringWidth(str, font, scale)
	BeginTextCommandWidth("STRING")
	AddTextComponentSubstringPlayerName(str)
	SetTextFont(font or 0)
	SetTextScale(1.0, scale or 0)
	return EndTextCommandGetWidth(true)
end


PanelColour = {
    HairCut = {
        { 28, 31, 33 }, -- 0
        { 39, 42, 44 }, -- 1
        { 49, 46, 44 }, -- 2
        { 53, 38, 28 }, -- 3
        { 75, 50, 31 }, -- 4
        { 92, 59, 36 }, -- 5
        { 109, 76, 53 }, -- 6
        { 107, 80, 59 }, -- 7
        { 118, 92, 69 }, -- 8
        { 127, 104, 78 }, -- 9
        { 153, 129, 93 }, -- 10
        { 167, 147, 105 }, -- 11
        { 175, 156, 112 }, -- 12
        { 187, 160, 99 }, -- 13
        { 214, 185, 123 }, -- 14
        { 218, 195, 142 }, -- 15
        { 159, 127, 89 }, -- 16
        { 132, 80, 57 }, -- 17
        { 104, 43, 31 }, -- 18
        { 97, 18, 12 }, -- 19
        { 100, 15, 10 }, -- 20
        { 124, 20, 15 }, -- 21
        { 160, 46, 25 }, -- 22
        { 182, 75, 40 }, -- 23
        { 162, 80, 47 }, -- 24
        { 170, 78, 43 }, -- 25
        { 98, 98, 98 }, -- 26
        { 128, 128, 128}, -- 27
        { 170, 170, 170 }, -- 28
        { 197, 197, 197 }, -- 29
        { 70, 57, 85 }, -- 30
        { 90, 63, 107 }, -- 31
        { 118, 60, 118 }, -- 32
        { 237, 116, 227 }, -- 33
        { 235, 75, 147 }, -- 34
        { 242, 153, 188 }, -- 35
        { 4, 149, 158 }, -- 36
        { 2, 95, 134 }, -- 37
        { 2, 57, 116 }, -- 38
        { 63, 161, 106 }, -- 39
        { 33, 124, 97 }, -- 40
        { 24, 92, 85 }, -- 41
        { 182, 192, 52 }, -- 42
        { 112, 169, 11 }, -- 43
        { 67, 157, 19 }, -- 44
        { 220, 184, 87 }, -- 45
        { 229, 177, 3 }, -- 46
        { 230, 145, 2 }, -- 47
        { 242, 136, 49 }, -- 48
        { 251, 128, 87 }, -- 49
        { 226, 139, 88 }, -- 50
        { 209, 89, 60 }, -- 51
        { 206, 49, 32 }, -- 52
        { 173, 9, 3 }, -- 53
        { 136, 3, 2 }, -- 54
        { 31, 24, 20 }, -- 55
        { 41, 31, 25 }, -- 56
        { 46, 34, 27 }, -- 57
        { 55, 41, 30 }, -- 58
        { 46, 34, 24 }, -- 59
        { 35, 27, 21 }, -- 60
        { 2, 2, 2 }, -- 61
        { 112, 108, 102 }, -- 62
        { 157, 122, 80 } -- 63
    },
    MakeUp = {
        { 153, 37, 50 }, -- 0
        { 200, 57, 93 }, -- 1
        { 189, 81, 108 }, -- 2
        { 184, 99, 122 }, -- 3
        { 166, 82, 107 }, -- 4
        { 177, 67, 76 }, -- 5
        { 127, 49, 51 }, -- 6
        { 164, 100, 93 }, -- 7
        { 193, 135, 121 }, -- 8
        { 203, 160, 150 }, -- 9
        { 198, 145, 143 }, -- 10
        { 171, 111, 99}, -- 11
        { 176, 96, 80 }, -- 12
        { 168, 76, 51 }, -- 13
        { 180, 113, 120 }, -- 14
        { 202, 127, 146 }, -- 15
        { 237, 156, 190 }, -- 16
        { 231, 117, 164 }, -- 17
        { 222, 62, 129 }, -- 18
        { 179, 76, 110 }, -- 19
        { 113, 39, 57 }, -- 20
        { 79, 31, 42 }, -- 21
        { 170, 34, 47 }, -- 22
        { 222, 32, 52 }, -- 23
        { 207, 8, 19 }, -- 24
        { 229, 84, 112 }, -- 25
        { 220, 63, 181 }, -- 26
        { 192, 39, 178 }, -- 27
        { 160, 28, 169 }, -- 28
        { 110, 24, 117 }, -- 29
        { 115, 20, 101 }, -- 30
        { 86, 22, 92 }, -- 31
        { 109, 26, 157 }, -- 32
        { 27, 55, 113 }, -- 33
        { 29, 78, 167 }, -- 34
        { 30, 116, 187 }, -- 35
        { 33, 163, 206 }, -- 36
        { 37, 194, 210 }, -- 37
        { 35, 204, 165 }, -- 38
        { 39, 192, 125 }, -- 39
        { 27, 156, 50 }, -- 40
        { 20, 134, 4 }, -- 41
        { 112, 208, 65 }, -- 42
        { 197, 234, 52 }, -- 43
        { 225, 227, 47 }, -- 44
        { 255, 221, 38 }, -- 45
        { 250, 192, 38 }, -- 46
        { 247, 138, 39 }, -- 47
        { 254, 89, 16 }, -- 48
        { 190, 110, 25 }, -- 49
        { 247, 201, 127 }, -- 50
        { 251, 229, 192 }, -- 51
        { 245, 245, 245 }, -- 52
        { 179, 180, 179 }, -- 53
        { 145, 145, 145 }, -- 54
        { 86, 78, 78 }, -- 55
        { 24, 14, 14 }, -- 56
        { 88, 150, 158 }, -- 57
        { 77, 111, 140 }, -- 58
        { 26, 43, 85 }, -- 59
        { 160, 126, 107 }, -- 60
        { 130, 99, 85 }, -- 61
        { 109, 83, 70 }, -- 62
        { 62, 45, 39 } -- 63
    }
}
