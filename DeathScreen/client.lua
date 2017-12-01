local deathTypes = {
	--table layout: [hash] = {"pl1 killed you", "you killed pl2", "pl1 killed pl2"}
	[0] = {"DM_TICK1", "DM_TICK2", "DM_TICK6"},
}

local function IsStringValid(string)
	-- IsStringNullOrEmpty() or IsStringNull() always returns true
	local string = GetLabelText(string)
	if string == "" or string:find("NULL") then
		return false
	end
	return true
end

Citizen.CreateThread(function()
	while true do
		local playerId = PlayerId()
		local playerPed = PlayerPedId()
		local playerName = GetPlayerName(playerId)
		local killerId = nil
		local killerPed = nil
		local killerName = nil
		local killerEntity = nil
		local causeHash = nil
		local weaponHash = nil
		local deathReason = nil

		SetAudioFlag("LoadMPData", true)
		RequestScriptAudioBank("mp_wasted", 1)
		local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

		if IsEntityDead(playerPed) then

			killerEntity, weaponHash = NetworkGetEntityKillerOfPlayer(playerId)
			killerId = NetworkGetPlayerIndexFromPed(killerEntity)
			killerPed = GetPedKiller(playerPed)
			killerName = GetPlayerName(killerId)
			causeHash = GetPedCauseOfDeath(playerPed)

			if killerId == playerId then
				TriggerServerEvent('huyax:deathscreen:playerDied', 0, 0)
			elseif killerId ~= playerId and killerName ~= "**Invalid**" then
				TriggerServerEvent('huyax:deathscreen:playerDied', 1, killerName)
			else
				TriggerServerEvent('huyax:deathscreen:playerDied', 2, 0)
			end

			StartScreenEffect("DeathFailMPDark", 0, 0)
			ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
			SetCamEffect(2)

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end

			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			BeginTextCommandScaleformString("RESPAWN_W")
			EndTextCommandScaleformString()

			if killerName ~= "**Invalid**" then
				if killerId == playerId then
					BeginTextCommandScaleformString("DM_U_SUIC")
				elseif killerId ~= playerId and killerName ~= "**Invalid**" then
					if IsStringValid(deathTypes[causeHash]) then
						BeginTextCommandScaleformString(deathTypes[causeHash])
					else
						if IsStringValid(deathTypes[weaponHash]) then
							BeginTextCommandScaleformString(deathTypes[weaponHash])
						else
							BeginTextCommandScaleformString("DM_TICK1")
						end
					end
					AddTextComponentSubstringPlayerName("<C>" .. killerName .. "</C>")
				end
				EndTextCommandScaleformString()
			end

			PopScaleformMovieFunctionVoid()

			Citizen.Wait(750)

			PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", true)

			Citizen.Wait(250)

			while IsEntityDead(PlayerPedId()) do
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)
			end

			StopScreenEffect("DeathFailMPDark")
			StopGameplayCamShaking()
			PlaySoundFrontend(-1, "MP_Impact", "WastedSounds", true)

		end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("huyax:deathscreen:showNotification")
AddEventHandler("huyax:deathscreen:showNotification", function(id, target, killer)
	local player = GetPlayerName(PlayerId())

	if player == target then
		if id == 0 then
			SetNotificationTextEntry("DM_U_SUIC")
		elseif id == 1 then
			SetNotificationTextEntry("DM_TICK1")
			AddTextComponentSubstringPlayerName("<C>" .. killer .. "</C>")
		elseif id == 2 then
			SetNotificationTextEntry("DM_TK_YD1")
		end
	elseif player == killer then
		if id == 1 then
			SetNotificationTextEntry("DM_TICK2")
			AddTextComponentSubstringPlayerName("<C>" .. target .. "</C>")
		end
	elseif player ~= target and player ~= killer then
		if id == 0 then
			SetNotificationTextEntry("DM_O_SUIC")
			AddTextComponentSubstringPlayerName("<C>" .. target .. "</C>")
		elseif id == 1 then
			SetNotificationTextEntry("TICK_KILL")
			AddTextComponentSubstringPlayerName("<C>" .. killer .. "</C>")
			AddTextComponentSubstringPlayerName("<C>" .. target .. "</C>")
		elseif id == 2 then
			SetNotificationTextEntry("TICK_DIED")
			AddTextComponentSubstringPlayerName("<C>" .. target .. "</C>")
		end
	end

	DrawNotification(false, false)
end)
