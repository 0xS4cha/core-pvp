local math_cos, math_sin, math_min, math_max, table_insert = math.cos, math.sin, math.min, math.max, table.insert
local tinyPi <const> = math.pi / 180.0
local default = {
    defaultMinRadius = 2.0,
    defaultMaxRadius = 7.0,
    radiusStepLength = 0.5,
    defaultTransitionSpeed = 1000,
    mouseSpeed		= 8.0,
    controllerSpeed	= 1.5,
}

Orbit = {
	cam = nil,
    
	trackedEntity = nil,
	camFocusPoint = vector3(0, 0, 0),
	entityOffset = nil,
	minRadius = default.defaultMinRadius,
	maxRadius = default.defaultMaxRadius,
	currentRadius = (default.defaultMinRadius + default.defaultMaxRadius) * 0.5,
	angleY = 0.0,
	angleZ = 0.0,
	disabledControls = { 14, 15, 16, 17, 81, 82, 99 },

	-- raycast - need instant result, no async possible
	RayCast = function(from, to, ignoreEntity)
		local _, hit, hitPosition = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, -1, ignoreEntity, 2))
		return hit, hitPosition
	end,

	ProcessNewPosition = function()
		-- calculate angle from player camera input
		local speedMult = IsInputDisabled(0) and default.mouseSpeed or default.controllerSpeed
		Orbit.angleZ = Orbit.angleZ - GetDisabledControlUnboundNormal(1, 1) * speedMult    -- around Z axis (left / right)
		Orbit.angleY = Orbit.angleY + GetDisabledControlUnboundNormal(1, 2) * speedMult -- around Y axis (up / down)
		Orbit.angleY = math_max(math_min(Orbit.angleY, 89.0), -89.0)                -- limit up / down angle to less than 90°

		-- calculate orbit height
		Orbit.currentRadius = Orbit.currentRadius + (GetDisabledControlNormal(0, 16) - GetDisabledControlNormal(0, 17)) * default.radiusStepLength
		Orbit.currentRadius = math_max(math_min(Orbit.currentRadius, Orbit.maxRadius), Orbit.minRadius)

		if (Orbit.trackedEntity and DoesEntityExist(Orbit.trackedEntity)) then
			Orbit.camFocusPoint = GetEntityCoords(Orbit.trackedEntity) + Orbit.entityOffset
		end
		
		-- do the thing with the math (calculate the orbit position)
		local cosY = math_cos(Orbit.angleY * tinyPi)
		local offset = vector3(math_cos(Orbit.angleZ * tinyPi) * cosY, math_sin(Orbit.angleZ * tinyPi) * cosY, math_sin(Orbit.angleY * tinyPi)) * Orbit.currentRadius

		local newPos = Orbit.camFocusPoint + offset

		local ignoreEnt = Orbit.trackedEntity or PlayerPedId()
		-- use raycasts to the new position offset by the cameras near clip planes' corners
		local right, _, up = GetCamMatrix(Orbit.cam)
		local verticalOffset, horizontalOffset = right * 0.125, up * 0.07
		local rayCastResults = {}
		rayCastResults[1] = { Orbit.RayCast(Orbit.camFocusPoint, newPos + verticalOffset + horizontalOffset, ignoreEnt) }
		rayCastResults[2] = { Orbit.RayCast(Orbit.camFocusPoint, newPos + verticalOffset - horizontalOffset, ignoreEnt) }
		rayCastResults[3] = { Orbit.RayCast(Orbit.camFocusPoint, newPos - verticalOffset - horizontalOffset, ignoreEnt) }
		rayCastResults[4] = { Orbit.RayCast(Orbit.camFocusPoint, newPos - verticalOffset + horizontalOffset, ignoreEnt) }

		local radius = Orbit.currentRadius
		for i = 1, #rayCastResults do
			if (rayCastResults[i][1]) then
				local dist = #(Orbit.camFocusPoint - rayCastResults[i][2])
				if (dist < radius) then
					radius = dist
				end
			end
		end

		-- recalc the offset with the new radius
		offset = offset * (radius / Orbit.currentRadius)

		return Orbit.camFocusPoint + offset
	end,

	ProcessCamControls = function()
		-- disable 1st person and some controls
		DisableFirstPersonCamThisFrame()
		for i, control in ipairs(Orbit.disabledControls) do
			DisableControlAction(0, control, true)
		end

		-- calculate new position
		local newPos = Orbit.ProcessNewPosition()

		-- set position of cam and focus
		SetCamCoord(Orbit.cam, newPos.x, newPos.y, newPos.z)
		PointCamAtCoord(Orbit.cam, Orbit.camFocusPoint.x, Orbit.camFocusPoint.y, Orbit.camFocusPoint.z)
		SetFocusPosAndVel(Orbit.camFocusPoint.x, Orbit.camFocusPoint.y, Orbit.camFocusPoint.z, 0.0, 0.0, 0.0)
	end,

	Start = function(position, entity, _minRadius, _maxRadius, transitionSpeed)
		if (Orbit.cam) then
			Logger:info("There is already an active camera!")
			return
		end

		-- set new focus point
		ClearFocus()
		if (entity) then
			Orbit.trackedEntity = entity
			Orbit.entityOffset = position
			Orbit.camFocusPoint = GetEntityCoords(Orbit.trackedEntity) + Orbit.entityOffset
		else
			Orbit.camFocusPoint = position
		end

		Orbit.minRadius = _minRadius or default.defaultMinRadius
		Orbit.maxRadius = _maxRadius or default.defaultMaxRadius
		Orbit.currentRadius = (Orbit.minRadius + Orbit.maxRadius) * 0.5

		local rot = GetGameplayCamRot(2)
		Orbit.angleY = -rot.x
		Orbit.angleZ = rot.z - 90

		-- setup camera
		Orbit.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Orbit.camFocusPoint.x, Orbit.camFocusPoint.y, Orbit.camFocusPoint.z, 0, 0, 0, GetGameplayCamFov())
		SetCamActive(Orbit.cam, true)
		RenderScriptCams(true, true, transitionSpeed or default.defaultTransitionSpeed, true, false)

		SetCamNearClip(Orbit.cam, 0.05)

		TriggerEvent("OrbitCam:camStarted", position, entity)

		-- start camera processing
		CreateThread(function()
			while (Orbit.cam ~= nil) do
				Orbit.ProcessCamControls()
				Wait(0)
			end
		end)
	end,

	End = function(transitionSpeed)
		if (Orbit.cam == nil) then
			Logger:info("OrbitCam", "There is no active camera!")
			return
		end

		ClearFocus()

		RenderScriptCams(false, true, transitionSpeed or default.defaultTransitionSpeed, true, false)
		DestroyCam(Orbit.cam, false)

		Orbit.cam = nil
		Orbit.trackedEntity = nil

		TriggerEvent("OrbitCam:camStopped")
	end,

	UpdatePosition = function(position, entity, _minRadius, _maxRadius)
		if (Orbit.cam == nil) then
			Logger:info("OrbitCam", "There is no active camera!")
			return
		end

		if (entity) then
			Orbit.trackedEntity = entity
			Orbit.entityOffset = position
			Orbit.camFocusPoint = GetEntityCoords(Orbit.trackedEntity) + Orbit.entityOffset
		else
			Orbit.camFocusPoint = position
		end

		Orbit.minRadius = _minRadius or default.defaultMinRadius
		Orbit.maxRadius = _maxRadius or default.defaultMaxRadius
	end,

	IsActive = function()
		return Orbit.cam ~= nil
	end,

	IsEntityBeingTracked = function(entity)
		return entity and entity == Orbit.trackedEntity or Orbit.trackedEntity ~= nil
	end,

	GetTrackedEntity = function()
		return Orbit.trackedEntity
	end
}
