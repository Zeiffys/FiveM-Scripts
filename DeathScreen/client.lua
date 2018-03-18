local cinematicStart = 2500 --5000 or 7500 for GTAO (ms)
local deathTypes = {
	--table layout: ["WEAPON_TYPE"] = {"pl1 killed you", "you killed pl2", "pl1 killed pl2"}
	["DEFAULT"] = {"DM_TICK1", "DM_TICK2", "DM_TICK6"},
}

local function IsLabelValid(string)
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
				TriggerServerEvent('freznva:deathscreen:playerDied', 0, 0)
			elseif killerId ~= playerId and killerName ~= "**Invalid**" then
				TriggerServerEvent('freznva:deathscreen:playerDied', 1, killerName)
				Citizen.CreateThread(function()
					while not HasScaleformMovieLoaded(scaleform) do
						Citizen.Wait(0)
					end
					Citizen.Wait(cinematicStart)
					SetCamEffect(0)
					NetworkSetOverrideSpectatorMode(true)
					NetworkSetInSpectatorMode(true, killerPed)
					SetCinematicModeActive(true)
					SetFocusEntity(killerPed)
				end)
			else
				TriggerServerEvent('freznva:deathscreen:playerDied', 2, 0)
			end

			StartScreenEffect("DeathFailMPIn", 0, 0)
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
					if IsLabelValid(deathTypes[causeHash]) then
						BeginTextCommandScaleformString(deathTypes[causeHash])
					else
						if IsLabelValid(deathTypes[weaponHash]) then
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
				if NetworkIsInSpectatorMode() then
					DisableAllControlActions(0)
				end
				Citizen.Wait(0)
			end

			SetCamEffect(0)
			StopGameplayCamShaking()
			StopScreenEffect("DeathFailMPIn")
			SetCinematicModeActive(false)
			NetworkSetInSpectatorMode(false, playerPed)
			NetworkSetOverrideSpectatorMode(false)
			SetFocusEntity(playerPed)
			PlaySoundFrontend(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", true)

		end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("freznva:deathscreen:showNotification")
AddEventHandler("freznva:deathscreen:showNotification", function(id, target, killer)
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
