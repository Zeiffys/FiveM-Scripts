Citizen.CreateThread(function()
	function math.round(number, dec)
		dec = dec or 0
		return tonumber(("%.".. dec .."f"):format(number))
	end

	local function GetVehicleRpmInt(vehicle, mno, mx)
		if IsEntityAVehicle(vehicle) then
			if GetIsVehicleEngineRunning(vehicle) then
				local rpm = GetVehicleCurrentRpm(vehicle)
				local rpmf = math.max(0.0, rpm - (mno - (mno * rpm)))
				local rpmi = math.round(rpmf * mx)
				return rpmi
			end
		end
		return 0
	end

	local models = {
		["DEFAULT"] = {9800},
		["ardent"] = {10000},
		["150gt"] = {7700, 0.1526},
		["blista"] = {6750, 0.1420},
		["blistata"] = {7900, 0.1230},
		["comet99"] = {8050},
		["elegypace"] = {7875, 0.0930},
		["elegypolice"] = {7875, 0.0930},
		["elegyrh5"] = {7875, 0.0930},
		["euros"] = {8900, 0.1100},
		["flash"] = {7900, 0.1280},
		["futo3"] = {7900, 0.1230},
		["jester5"] = {7850},
		["kurumata"] = {11000},
		["savestra"] = {7700},
		["sigma2"] = {8950},
		["zr"] = {7500},
		["rebel01"] = {6700},
		["rebel02"] = {6700},
		["riata"] = {5000},
		["rancherx"] = {6750},
		["fugitive"] = {7000},
		["comet3"] = {8100, 0.0800},
		["futo"] = {7900},
		["comet5"] = {8800, 0.0848},
		["feltzer"] = {6600},
		["michelli"] = {7700},
		["markii"] = {6950},
		["rloader"] = {6600},
		["stratum"] = {6850},
		["schafter"] = {6700},
		["elegy2"] = {8900},
		["entity2"] = {8950},
		["boxville5"] = {2225},
		["cavcade"] = {5550},
		["dominato"] = {7800},
		["sentinel2"] = {8900},
		["deluxo"] = {6900, 0.1375},
		["930mnc"] = {6800}
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
			local mx = models[model] and models[model][1] or classes[class]
			local mno = models[model] and models[model][2] or 0.1244
			local mnf = math.round(0.2 - (mno - (mno * 0.2)), 4)
			local mn = math.round(mx * mnf)

			local turbo = IsToggleModOn(vehicle, 18) and math.round(((GetVehicleTurboPressure(vehicle) + 1) / 2) * 9) or 0 -- (turbo > 0 and math.round(turbo*100) or 0) .. "%"
			local gear = GetVehicleCurrentGear(vehicle)
			local rpmi = GetVehicleRpmInt(vehicle, mno, mx)
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
				elseif rpmi == mn then
					rpmi = mn + math.random(-50, 50)
				end
			end

			SetTextFont(2)
			SetTextScale(1.0, 0.45)
			SetTextDropShadow()
			SetTextCentre(true)
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(("~HUD_COLOUR_WAYPOINT~%s~s~  %03.0f~n~~HUD_COLOUR_WAYPOINT~%01d~s~ %04d"):format(gear, speed, turbo, rpmi, model))
			EndTextCommandDisplayText(0.984375 - safezone, 0.8291666666666667 - safezone)
		end

		Citizen.Wait(0)
	end
end)
