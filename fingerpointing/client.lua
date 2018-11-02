local isPointingActive = false

local function IsAllOk()
	local playerId = PlayerId()
	local playerPed = PlayerPedId()
	local isAllOk = (
		(IsPedAPlayer(playerPed)) and
		(IsPedOnFoot(playerPed)) and
		(not IsEntityDead(playerPed)) and
		(not IsPedFalling(playerPed)) and
		(not IsPedInAnyVehicle(playerPed, true)) and
		(not IsPedInMeleeCombat(playerPed)) and
		(not IsPedInParachuteFreeFall(playerPed)) and
		(not IsPedJumping(playerPed)) and
		(not IsPedPerformingStealthKill(playerPed)) and
		(not IsPedPlantingBomb(playerPed)) and
		(not IsPedProne(playerPed)) and
		(not IsPedRagdoll(playerPed)) and
		(not IsPedShooting(playerPed)) and
		(not IsPedSwimming(playerPed)) and
		(not IsPedSwimmingUnderWater(playerPed)) and
		(not IsPedUsingAnyScenario(playerPed)) and
		(not IsPedVaulting(playerPed)) and
		(not IsPlayerFreeAiming(playerId)) and
		(not IsControlPressed(2, 24)) and
		(not IsControlPressed(2, 25))
	)

	return isAllOk
end

local function IsPointingActive()
	return isPointingActive
end

local function SetLocalPlayerPointing(toggle)
	local playerPed = PlayerPedId()

	if toggle then
		RequestAnimDict("anim@mp_point")

		while not HasAnimDictLoaded("anim@mp_point") do
			Citizen.Wait(0)
		end

		TaskMoveNetwork(playerPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
		SetPedConfigFlag(playerPed, 36, true)
	else
		N_0xd01015c7316ae176(playerPed, "Stop")
		SetPedConfigFlag(playerPed, 36, false)
		ClearPedSecondaryTask(playerPed)
	end

	isPointingActive = toggle
end

local function ProcessFingerPointing()
	local playerPed = PlayerPedId()
	local camPitch = GetGameplayCamRelativePitch()
	local camHeading = GetGameplayCamRelativeHeading()
	local isFirstPerson = GetFollowPedCamViewMode() == 4

	camPitch = math.max(math.min(camPitch, 42.0), -70.0)
	camHeading = math.max(math.min(camHeading, 180.0), -180.0)

	camPitch = (camPitch + 70.0) / 112.0
	camHeading = ((camHeading + 180.0) / 360.0) * -1.0 + 1.0

	local coords = GetOffsetFromEntityInWorldCoords(playerPed, -0.2, 0.4 * camHeading + 0.3, 0.6)
	local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, playerPed, 7);
	local _, isBlocked, _, _ = GetShapeTestResult(ray)

	N_0xd5bb4025ae449a4e(playerPed, "Pitch", camPitch)
	N_0xd5bb4025ae449a4e(playerPed, "Heading", camHeading)
	N_0xb0a6cfd2c69c1088(playerPed, "isBlocked", isBlocked)
	N_0xb0a6cfd2c69c1088(playerPed, "isFirstPerson", isFirstPerson)
end

Citizen.CreateThread(function()
	while true do
		local isAllOk = IsAllOk()
		local isPressed = IsControlJustPressed(2, 29)

		if isAllOk and not isPointingActive then
			if isPressed then
				SetLocalPlayerPointing(true)
			end
		elseif isAllOk and isPointingActive then
			ProcessFingerPointing()
			if isPressed then
				SetLocalPlayerPointing(false)
			end
		elseif not isAllOk and isPointingActive then
			SetLocalPlayerPointing(false)
		end

		Citizen.Wait((GetFrameTime()*1000)/2)
	end
end)

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		SetLocalPlayerPointing(false)
		RemoveAnimDict("anim@mp_point")
	end
end)
