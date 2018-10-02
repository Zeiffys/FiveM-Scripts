Citizen.CreateThread(function()
	local isTeleportInProgress = false

	while true do
		if IsControlJustPressed(2, 344) then
			if isTeleportInProgress then return end
			if IsPauseMenuActive() then return end

			local waypoint = GetFirstBlipInfoId(8)

			if (waypoint > 0) then
				isTeleportInProgress = true

				local playerPed = PlayerPedId()
				local getUs = function()
					if IsPedSittingInAnyVehicle(playerPed) then
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						local driverPed = GetPedInVehicleSeat(vehicle, -1)
						if driverPed == playerPed then
							return vehicle
						end
					end
					return playerPed
				end
				local blip = GetBlipCoords(waypoint)
				local isFound = false
				local newZ = 0.0
				local timer = GetGameTimer() + 10000

				DoScreenFadeOut()

				while not isFound and timer > GetGameTimer() do
					SetFocusArea(blip.x, blip.y, 1000.0)
					for i = 0, 1000, 50 do
						local tempZ = i + 0.1
						RequestCollisionAtCoord(blip.x, blip.y, tempZ)
						zFound, newZ = GetGroundZFor_3dCoord(blip.x, blip.y, tempZ, false)
						if zFound and newZ ~= 0.0 then
							isFound = true
							break
						end
						Citizen.Wait(0)
					end
					Citizen.Wait(0)
				end

				SetEntityCoords(getUs(), blip.x, blip.y, (isFound and newZ or -199.9), 0.0, 0.0, 0.0, false)
				SetGameplayCamRelativeHeading(0)
				SetGameplayCamRelativePitch(0, 0)

				SetFocusEntity(playerPed)
				DoScreenFadeIn(250)

				isTeleportInProgress = false
			end
		end

		Citizen.Wait(GetFrameTime()*1000)
	end
end)

AddEventHandler("onResourceStop", function(resource)
	local currentResource = GetCurrentResourceName()

	if resource == currentResource then
		SetFocusEntity(PlayerPedId())
		DoScreenFadeIn(250)
	end
end)

Citizen.CreateThread(function()
	while false do
		local waypoint = GetFirstBlipInfoId(8)

		if (waypoint > 0) then
			local ped = GetEntityCoords(PlayerPedId(), true)
			local blip = GetBlipCoords(waypoint)
			local r, g, b = GetHudColour(142)

			local dist = #(vector2(ped.x, ped.y) - vector2(blip.x, blip.y))
			local size = 128 * dist / 8192
			local alpha = math.floor(math.min(dist / 8, 128))

			DrawMarker(1, blip.x, blip.y, blip.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, 2048.0, r, g, b, alpha, false, false, 2, false, false, false, false)
		end

		Citizen.Wait(GetFrameTime()*1000 / 2)
	end
end)
