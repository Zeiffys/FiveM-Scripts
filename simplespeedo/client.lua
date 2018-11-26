Citizen.CreateThread(function()
	local mx = 9800
	local mn = tonumber(("%.0f"):format(mx * 0.1120))
	local useKmh = true

	function math.round(number, dec)
		dec = dec or 0
		return tonumber(("%.".. dec .."f"):format(number))
	end

	local function GetVehicleRpmFloat(vehicle)
		if IsEntityAVehicle(vehicle) then
			if GetIsVehicleEngineRunning(vehicle) then
				local rpm = GetVehicleCurrentRpm(vehicle)
				local rpmf = math.max(0.0, rpm - (0.1244 - (0.1244 * rpm)))
				return rpmf
			end
		end
		return 0.0
	end

	local function GetVehicleRpmInt(vehicle, mx)
		if IsEntityAVehicle(vehicle) then
			if GetIsVehicleEngineRunning(vehicle) then
				local rpmf = GetVehicleRpmFloat(vehicle)
				local rpmi = math.round(rpmf * mx)
				return rpmi
			end
		end
		return 0
	end

	local models = {
		["DEFAULT"] = 9800,
		["150gt"] = 7800,
		["blista"] = 6750,
		["blistata"] = 7850,
		["comet99"] = 8050,
		["elegypace"] = 7900,
		["elegypolice"] = 7900,
		["elegyrh5"] = 7900,
		["euros"] = 8850,
		["flash"] = 7900,
		["futo3"] = 7900,
		["jester5"] = 7850,
		["kurumata"] = 11000,
		["savestra"] = 7700,
		["sigma2"] = 8950,
		["zr"] = 7500,
		["rebel01"] = 6700,
		["rebel02"] = 6700,
		["riata"] = 5000,
		["rancherx"] = 6750,
		["fugitive"] = 7000,
		["comet3"] = 8100,
		["futo"] = 7900,
		["comet5"] = 8800,
		["feltzer"] = 6600,
		["michelli"] = 7700,
		["markii"] = 6950,
		["rloader"] = 6600,
		["stratum"] = 6850,
		["schafter"] = 6700,
		["elegy2"] = 8900,
		["entity2"] = 8950,
		["boxville5"] = 2225,
		["cavcade"] = 5550,
		["dominato"] = 7800,
		["sentinel2"] = 8900,
	}

	local classes = {
		[0] = 6750,
		[1] = 6750,
		[2] = 5500,
		[3] = 6750,
		[4] = 7875,
		[5] = 7800,
		[6] = 8250,
		[7] = 8250,
		[8] = 12200,
		[9] = 7800,
		[10] = 2200,
		[11] = 2200,
		[12] = 5500,
		[13] = 0,
		[14] = 2200,
		[15] = 0,
		[16] = 0,
		[17] = 2200,
		[18] = 5500,
		[19] = 5500,
		[20] = 2200,
		[21] = 0
	}

	while true do
		local ped = PlayerPedId()
		local safezone = (1 - GetSafeZoneSize()) / 2
		local useKmh = N_0xd3d15555431ab793() -- https://github.com/citizenfx/natives/pull/33

		if IsPedSittingInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
			local class = GetVehicleClass(vehicle)
			local mx = models[model] or classes[class]
			local mn = math.round(mx * 0.1005)

			-- local turbo = GetVehicleTurboPressure(vehicle) -- (turbo > 0 and math.round(turbo*100) or 0) .. "%"
			local gear = GetVehicleCurrentGear(vehicle)
			local rpmf = math.round(GetVehicleRpmFloat(vehicle), 4)
			local rpmi = GetVehicleRpmInt(vehicle, mx)
			local physspeed = GetEntitySpeed(vehicle)
			local dashspeed = GetVehicleDashboardSpeed(vehicle)
			local speed = ((class == 13 or class == 15 or class == 16 or class == 21 or dashspeed == 0.00) and physspeed or dashspeed) * (useKmh and 3.6 or 2.2369362920544)

			if IsVehicleStopped(vehicle) then
				gear = "N"
			elseif gear == 0 then
				gear = "R"
			end

			if class == 13 then
				rpmi = math.round(physspeed * 3.6 * 10) -- wtf
			elseif mx == 0 then
				rpmi = 0
			else
				if rpmi == mx then
					rpmi = mx + math.random(-150, 150)
				elseif rpmf == 0.1005 then
					rpmi = mn + math.random(-50, 50)
				end
			end

			SetTextFont(2)
			SetTextScale(1.0, 0.45)
			SetTextDropShadow()
			SetTextCentre(true)
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(("%04d~n~%03.0f %s"):format(rpmi, speed, gear, model))
			EndTextCommandDisplayText(0.987 - safezone, 0.8222222222222222)
		end

		Citizen.Wait(0)
	end
end)
