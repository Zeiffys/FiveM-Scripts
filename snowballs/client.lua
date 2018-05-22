local animDict = "anim@mp_snowball"
local animName = "pickup_snowball"

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerId = PlayerId()
		local playerPed = PlayerPedId()

		local canPickUpSnowBall = (
			(GetAmmoInPedWeapon(playerPed, 126349499) < 1) and -- allow only 1 snowball
			(IsPedAPlayer(playerPed)) and
			(IsPedOnFoot(playerPed)) and
			--(IsPedStopped(playerPed)) and
			(not IsEntityDead(playerPed)) and
			(not IsEntityInWater(playerPed)) and
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
			(not IsPedReloading(playerPed)) and
			(not IsPedShooting(playerPed)) and
			(not IsPedSwimming(playerPed)) and
			(not IsPedSwimmingUnderWater(playerPed)) and
			(not IsPedTryingToEnterALockedVehicle(playerPed)) and
			(not IsPedUsingAnyScenario(playerPed)) and
			(not IsPedVaulting(playerPed)) and
			(not IsPedWearingHelmet(playerPed)) and
			(not IsPlayerFreeAiming(playerId)) and
			(not IsPlayerRidingTrain(playerId))
		)

		if DoesAnimDictExist(animDict) then
			RequestAnimDict(animDict)
			if HasAnimDictLoaded(animDict) and canPickUpSnowBall then
				if IsControlJustPressed(2, 58) then -- G key
					GiveWeaponToPed(playerPed, -1569615261, 0, true, true) -- switch to hands
					TaskPlayAnim(playerPed, animDict, animName, 8.0, 0.0, -1, 16785408, false, false, false, false)
					Citizen.Wait(500)
					GiveWeaponToPed(playerPed, 126349499, 1, true, true)
					while IsEntityPlayingAnim(playerPed, animDict, animName, 3) do
						Citizen.Wait(0)
					end
					ClearPedTasksImmediately(playerPed) -- this eliminates player freezing after playing animation
				end
			end
		else -- if something went wrong
			error("Anim dict \"".. animDict .."\" not exist.")
		end
	end
end)
