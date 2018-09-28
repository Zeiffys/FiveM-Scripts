local isPointingActive = false

local function IsAllOk()
	local playerId = PlayerId()
	local playerPed = PlayerPedId()
	local isAllOk = (
		(IsPedAPlayer(playerPed)) and
		(IsPedOnFoot(playerPed)) and
		(not IsEntityDead(playerPed)) and
		(not IsPedDucking(playerPed)) and
		(not IsPedFalling(playerPed)) and
		(not IsPedFleeing(playerPed)) and
		(not IsPedGettingIntoAVehicle(playerPed)) and
		(not IsPedHangingOnToVehicle(playerPed)) and
		(not IsPedInAnyVehicle(playerPed, true)) and
		(not IsPedInCombat(playerPed)) and
		(not IsPedInMeleeCombat(playerPed)) and
		(not IsPedInParachuteFreeFall(playerPed)) and
		(not IsPedJacking(playerPed)) and
		(not IsPedJumping(playerPed)) and
		(not IsPedJumpingOutOfVehicle(playerPed)) and
		(not IsPedPerformingStealthKill(playerPed)) and
		(not IsPedPlantingBomb(playerPed)) and
		(not IsPedProne(playerPed)) and
		(not IsPedRagdoll(playerPed)) and
		(not IsPedShooting(playerPed)) and
		(not IsPedSwimming(playerPed)) and
		(not IsPedSwimmingUnderWater(playerPed)) and
		(not IsPedTryingToEnterALockedVehicle(playerPed)) and
		(not IsPedUsingAnyScenario(playerPed)) and
		(not IsPedVaulting(playerPed)) and
		(not IsPedWearingHelmet(playerPed)) and
		(not IsPlayerFreeAiming(playerId)) and
		(not IsPlayerRidingTrain(playerId)) and
		(not IsControlPressed(2, 24)) and
		(not IsControlPressed(2, 25))
	)

	return isAllOk
end

local function IsNetworkTaskMoveActive()
	return N_0x921ce12c489c4c41(PlayerPedId())
end

local function IsPointingActive()
	return isPointingActive
end

local function SetLocalPlayerPointing(toggle)
	local playerPed = PlayerPedId()

	if toggle then
		RequestAnimDict("anim@mp_point")

		while not HasAnimDictLoaded("anim@mp_point") do
			Wait(0)
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local isPressed = IsControlJustPressed(2, 29)

		if IsAllOk() and not IsPointingActive() then
			if isPressed then
				SetLocalPlayerPointing(true)
			end
		elseif IsAllOk() and IsPointingActive() then
			if isPressed then
				SetLocalPlayerPointing(false)
			end
		elseif not IsAllOk() and IsPointingActive() then
			SetLocalPlayerPointing(false)
		end
	end
end)

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		SetLocalPlayerPointing(false)
		RemoveAnimDict("anim@mp_point")
	end
end)
