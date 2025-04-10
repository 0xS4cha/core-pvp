local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }

local activeBars = {}
local totalBars = 0

function AddTimerBar(title, itemData)
	Logger:info("Core", "AddTimerBar", title)

	if not itemData then return end

	if not HasStreamedTextureDictLoaded("timerbars") then
		RequestStreamedTextureDict("timerbars", true)
	end

	totalBars = totalBars + 1
	activeBars[totalBars] = {
		title = GetPhrase(title),
		text = itemData.text,
		textColor = itemData.color or { 255, 255, 255, 255 },
		percentage = itemData.percentage,
		endTime = itemData.endTime,
		endNetTime = itemData.endNetTime,
		startedAt = itemData.startedAt,
		pbarBgColor = itemData.pbarBgColor or itemData.bg or { 155, 155, 155, 255 },
		pbarFgColor = itemData.pbarFgColor or itemData.fg or { 255, 255, 255, 255 }
	}

	return totalBars
end

function AddStageBar(title, itemData)
	if not itemData then return end

	totalBars = totalBars + 1
	activeBars[totalBars] = {
		title = GetPhrase(title),
		textColor = itemData.color or { 255, 255, 255, 255 },
		maxStage = itemData.maxStage,
		stage = itemData.stage,
		-- TODO: add default color
		bgColor = itemData.bgColor or { 255, 255, 255, 255 },
		bgActiveColor = itemData.bgActiveColor or { 255, 255, 255, 255 },
	}

	return totalBars
end

function RemoveTimerBar()
	Logger:info("Core", "RemoveTimerBar", "ALL")
	activeBars = {}
end

function IsTimerBarValid(barIndex)
	return barIndex and activeBars[barIndex] and true or false
end

function SetTimerBarAsNoLongerNeeded(barIndex)
	Logger:info("Core", "SetTimerBarAsNoLongerNeeded", barIndex)
	activeBars[barIndex] = nil
end

function UpdateTimerBar(barIndex, itemData)
	if not activeBars[barIndex] or not itemData then return end
	for k,v in pairs(itemData) do
		activeBars[barIndex][k] = v
	end
end


local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local safeZone = GetSafeZoneSize()
		local safeZoneX = (1.0 - safeZone) * 0.5
		local safeZoneY = (1.0 - safeZone) * 0.5

		if table.Count(activeBars, 1) then
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)

			local totalVisible = 0
			local sortedActiveBars = {}

			for k,v in pairs(activeBars) do
				sortedActiveBars[#sortedActiveBars + 1] = { id = k, name = v.title }
			end

			table.sort(sortedActiveBars, function(a, b) return a.name > b.name end)

			for _, data in pairs(sortedActiveBars) do
				local v = activeBars[data.id]
				totalVisible = totalVisible + 1

				local drawY = (ScreenCoords.baseY - safeZoneY) - (tonumber(totalVisible) * Sizes.timerBarMargin);
				DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
				DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

				if v.percentage then
					local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
					local pbarY = drawY + ScreenCoords.pbarOffsetY;
					local width = Sizes.pbarWidth * v.percentage;

					DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

					DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
				elseif v.text then
					DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
				elseif v.endTime then
					local remainingTime = math.floor(v.endTime - GetGameTimer())
					DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				elseif v.endNetTime then
					local remainingTime = math.floor(v.endNetTime - GetNetworkTimeAccurate())
					DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				elseif v.stage then
					DrawOutlinedRectWithBoxes((ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX, drawY + 0.002, 0.06, 0.0125, v.bgColor, v.bgActiveColor, v.maxStage, v.stage, { heightOffsetMult = 4 })
				elseif v.startedAt then
					local remainingTime = math.floor(GetNetworkTimeAccurate() - v.startedAt)
					DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				end
			end
		end
	end
end)

