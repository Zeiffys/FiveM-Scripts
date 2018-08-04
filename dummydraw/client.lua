Citizen.CreateThread(function()
	-- настройки для педа
	local pedbones = false -- default false
	local pedsize = 0.005 -- default 0.005 (0.0 - 0.015)
	local pedalpha = false  -- default true

	-- настройки для машины
	local carsize = 0.01 -- default 0.01 (0.0 - 0.025)
	local caralpha = false -- лучше выключить что бы не запутаться -- default false
	local carbonenames = true -- default true
	local carbonenamessize = 0.4 -- default 0.4 (0.0 - 1.0)
	local carbonenamesdist = 7.5 -- default 7.5 (0.0 - 25.0)

	-- рабочая часть --
	local carbonesstr = {"aileron_l", "aileron_r", "attach_female", "attach_male", "bodyshell", "bogie_f", "bogie_r", "bonnet", "boot", "bottle01", "bottle02", "bottle03", "bottle04", "bottle05", "brakelight_l", "brakelight_m", "brakelight_r", "bucket", "bumper_f", "bumper_r", "chassis", "chassis_dummy", "chassis_lowlod", "cockpit", "crane", "dashglow", "dials", "door_dside_f", "door_dside_r", "door_pside_f", "door_pside_r", "doorlight_lf", "doorlight_lr", "doorlight_rf", "doorlight_rl", "doorlight_rr", "elevator_l", "elevator_r", "emissives", "engine", "exhaust", "exhaust_1", "exhaust_2", "exhaust_3", "exhaust_4", "exhaust_5", "exhaust_6", "exhaust_7", "exhaust_8", "extra_1", "extra_11", "extra_12", "extra_13", "extra_14", "extra_15", "extra_16", "extra_17", "extra_18", "extra_19", "extra_2", "extra_3", "extra_4", "extra_5", "extra_6", "extra_7", "extra_8", "extra_9", "extra_ten", "extralight_1", "extralight_2", "extralight_3", "extralight_4", "gauges", "gear_door_fl", "gear_door_fr", "gear_door_rl1", "gear_door_rl2", "gear_door_rr1", "gear_door_rr2", "gear_f", "gear_rl", "gear_rr", "handle_dside_f", "handle_dside_r", "handle_pside_f", "handle_pside_r", "hbgrip_l", "hbgrip_r", "headlight_l", "headlight_r", "hub_lf", "hub_lm1", "hub_lm2", "hub_lm3", "hub_lr", "hub_rf", "hub_rm1", "hub_rm2", "hub_rm3", "hub_rr", "indicator_lf", "indicator_lr", "indicator_rf", "indicator_rr", "inkpot01", "inkpot02", "interior_1", "interior_2", "interior_3", "interior_4", "interior_detail", "interiorlight", "ladder", "legs", "lights", "misc_a", "misc_b", "misc_c", "misc_d", "misc_e", "misc_f", "misc_g", "misc_h", "misc_i", "misc_j", "misc_k", "misc_l", "misc_m", "misc_n", "misc_o", "misc_p", "misc_q", "misc_r", "misc_s", "misc_t", "misc_u", "misc_v", "misc_w", "misc_x", "misc_y", "misc_z", "mod_col_1", "mod_col_2", "mod_col_3", "mod_col_4", "mod_col_5", "mod_col_6", "mod_col_7", "mod_col_8", "mod_col_9", "neon_b", "neon_f", "neon_l", "neon_r", "overheat", "overheat_2", "petrolcap", "petroltank", "petroltank_l", "petroltank_r", "platelight", "radio", "reversinglight_l", "reversinglight_r", "roof", "rotor_main", "rotor_main_fast", "rotor_main_slow", "rotor_rear", "rotor_rear_fast", "rotor_rear_slow", "rudder", "rudder2", "scoop", "seat_dside_f", "seat_dside_r", "seat_dside_r1", "seat_dside_r2", "seat_dside_r3", "seat_pside_f", "seat_pside_r", "seat_pside_r1", "seat_pside_r2", "seat_pside_r3", "siren1", "siren10", "siren11", "siren12", "siren13", "siren14", "siren15", "siren16", "siren17", "siren18", "siren19", "siren2", "siren20", "siren21", "siren22", "siren23", "siren24", "siren25", "siren26", "siren27", "siren28", "siren29", "siren3", "siren4", "siren5", "siren6", "siren7", "siren8", "siren9", "siren_glass1", "siren_glass10", "siren_glass11", "siren_glass12", "siren_glass13", "siren_glass14", "siren_glass15", "siren_glass16", "siren_glass17", "siren_glass18", "siren_glass19", "siren_glass2", "siren_glass3", "siren_glass4", "siren_glass5", "siren_glass6", "siren_glass7", "siren_glass8", "siren_glass9", "slipstream_l", "slipstream_r", "soft_1", "soft_2", "soft_3", "soft_4", "soft_5", "soft_6", "static_prop", "static_prop2", "steeringwheel", "suspension_lf", "suspension_lm", "suspension_lr", "suspension_rf", "suspension_rm", "suspension_rr", "tail", "tail_damage", "taillight_l", "taillight_r", "track_l", "track_r", "transmission_f", "transmission_m", "transmission_r", "wheel_lf", "wheel_lm1", "wheel_lm2", "wheel_lr", "wheel_rf", "wheel_rm1", "wheel_rm2", "wheel_rr", "wheelmesh_lf", "wheelmesh_lf_l1", "wheelmesh_lf_l2", "wheelmesh_lf_ng", "wheelmesh_lr", "wheelmesh_lr_l1", "wheelmesh_lr_l2", "wheelmesh_lr_ng", "window_lf", "window_lf1", "window_lf2", "window_lm", "window_lm1", "window_lm2", "window_lm3", "window_lr", "window_rf", "window_rf1", "window_rf2", "window_rm", "window_rm1", "window_rm2", "window_rm3", "window_rr", "windscreen", "windscreen[L1]", "windscreen_left", "windscreen_r", "windscreen_right", "wing_l", "wing_lf", "wing_lr", "wing_r", "wing_rf", "wing_rr", "wingtip_1", "wingtip_2"}
	local carbonesid = {31604, 31546, 52286, 42470, 60113, 22732, 22616, 42990, 31608, 46816, 46817, 46818, 46819, 46820, 20608, 20609, 20678, 64547, 22841, 22821, 0, 39433, 37313, 61095, 53085, 11869, 16572, 60963, 61071, 35346, 35230, 11965, 11977, 11549, 11555, 11561, 2105, 2175, 45311, 30510, 4944, 50445, 50446, 50447, 50448, 50449, 50450, 50451, 50452, 8874, 10843, 10844, 10845, 10846, 10847, 10848, 10849, 10850, 10851, 8875, 8876, 8877, 8878, 8879, 8880, 8881, 8882, 41970, 51309, 51310, 51311, 51312, 12198, 59324, 59298, 994, 995, 834, 835, 16998, 20819, 20825, 49152, 49132, 23407, 23419, 46652, 46530, 10804, 10842, 35926, 63020, 63021, 63022, 35938, 36022, 64556, 64557, 64558, 36034, 41664, 41644, 40032, 40012, 42298, 42299, 49018, 49019, 49020, 49021, 25208, 37995, 53342, 4712, 4680, 58614, 58615, 58616, 58617, 58618, 58619, 58620, 58621, 58622, 58623, 58624, 58625, 58626, 58627, 58628, 58629, 58630, 58631, 58632, 58633, 58634, 58635, 58636, 58637, 58638, 58639, 17880, 17881, 17882, 17883, 17884, 17885, 17886, 17887, 17888, 49475, 49479, 49485, 49491, 15850, 65271, 2450, 23306, 50131, 50009, 5558, 54853, 34500, 34570, 31963, 61947, 56039, 8987, 42489, 58261, 41033, 30979, 36197, 1160, 20012, 20120, 35183, 35184, 35185, 59562, 59446, 33327, 33328, 33329, 24999, 5714, 5715, 5716, 5717, 5718, 5719, 5720, 5721, 5722, 5723, 25000, 5698, 5699, 5700, 5701, 5702, 5703, 5704, 5705, 5706, 5707, 25001, 25002, 25003, 25004, 25005, 25006, 25007, 63112, 16452, 16453, 16454, 16455, 16456, 16457, 16458, 16459, 16460, 16461, 63113, 63114, 63115, 63116, 63117, 63118, 63119, 63120, 33128, 33134, 47340, 47341, 47342, 47343, 47344, 47345, 673, 37396, 20285, 5577, 5584, 5589, 6505, 6512, 6517, 36481, 59192, 18400, 18438, 8607, 8517, 17066, 17073, 17046, 27922, 29921, 29922, 27902, 26418, 5857, 5858, 26398, 20247, 11707, 11708, 12049, 20227, 27353, 27354, 27695, 26734, 6137, 6138, 26741, 6249, 6250, 6251, 26746, 28174, 29177, 29178, 28181, 29289, 29290, 29291, 28186, 39561, 13749, 17020, 56413, 21663, 33042, 4218, 4198, 33048, 4186, 4166, 51517, 51518}
	local pedbonesid = {65068, 37193, 46240, 58331, 21550, 25260, 45750, 47419, 29868, 20279, 17188, 20623, 1356, 19336, 27474, 43536, 49979, 11174, 17719, 47495, 20178, 61839, 17932, 17933, 21826, 21773, 21775, 21776, 47100, 12379, 39439, 36598, 18302, 18308, 22525, 3360, 17833, 0, 47897, 56099, 28405, 6939, 12844, 65245, 36029, 35502, 6286, 56604, 22711, 46078, 2992, 16335, 57631, 53994, 21511, 26613, 57717, 60309, 24806, 28422, 54279, 22030, 60419, 58743, 5232, 61007, 23639, 35731, 37119, 43810, 6442, 24163, 0, 0, 31086, 63931, 64729, 26610, 4089, 4090, 26611, 4169, 4170, 26612, 4185, 4186, 26613, 4137, 4138, 26614, 4153, 4154, 14201, 61163, 18905, 58271, 2108, 45509, 39317, 11816, 0, 36864, 10706, 58866, 64016, 64017, 58867, 64096, 64097, 58868, 64112, 64113, 58869, 64064, 64065, 58870, 64080, 64081, 52301, 28252, 57005, 51826, 20781, 40269, 23553, 24816, 24817, 24818, 57597, 64654, 34911, 63414, 36796, 0, 0, 0, 0, 23874, 0, 0, 0, 1477, 4396, 19397, 64805, 3634, 4230, 31571, 31572, 31547, 31548, 31549, 31550}

	-- сброс прозрачности
	ResetEntityAlpha(PlayerPedId())
	ResetEntityAlpha(GetVehiclePedIsIn(PlayerPedId(), false))

	while true do
		Citizen.Wait(10)

		local ped = PlayerPedId()
		local pedpos = GetEntityCoords(ped, IsEntityDead(ped))
		local inVehicle = IsPedInAnyVehicle(ped, false)
		local vehicle = inVehicle and GetVehiclePedIsIn(ped, true) or false
		local vehiclepos = GetEntityCoords(vehicle, IsEntityDead(vehicle))

		if inVehicle then
			if pedbones and pedalpha then
				ResetEntityAlpha(ped)
			end

			if caralpha then
				SetEntityAlpha(vehicle, 255, true)
			end

			for k, v in ipairs(carbonesstr) do
				local bone = GetEntityBoneIndexByName(vehicle, v)
				local bone = GetWorldPositionOfEntityBone(vehicle, bone)

				if Vdist(bone.x, bone.y, bone.z, vehiclepos.x, vehiclepos.y, vehiclepos.z) > 0.005 then
					DrawBox(bone.x - carsize, bone.y - carsize, bone.z - carsize, bone.x + carsize, bone.y + carsize, bone.z + carsize, 0, 255, 0, 220)
					if carbonenames then
						local onScreen, _x, _y = World3dToScreen2d(bone.x, bone.y, bone.z)

						if onScreen then
							local campos = GetGameplayCamCoords()
							local dist = GetDistanceBetweenCoords(campos.x, campos.y, campos.z, bone.x, bone.y, bone.z, true)

							local scale = math.max(1.0 - dist / carbonenamesdist, 0.0)
							local scalea = math.max(1.0 - dist / (carbonenamesdist*0.5), 0.05)
							local alpha = ToInt(255*scalea)

							if alpha > 0 and scale > 0.001 then
								SetTextFont(0)
								SetTextScale(0.0*scale, carbonenamessize*scale)
								SetTextColour(255, 255, 255, alpha)
								SetTextWrap(0.0, 1.0)
								SetTextCentre(true)
								SetTextDropShadow(0, 0, 0, 0, 0)
								SetTextOutline()
								BeginTextCommandDisplayText("STRING")
								AddTextComponentSubstringPlayerName(tostring(v))
								if true then
									EndTextCommandDisplayText(_x, _y)
								else
									SetDrawOrigin(bone.x, bone.y, bone.z, 0) -- более корректное отображение по координатам, но имеет баги при 32+ вызоовах в кадр
									EndTextCommandDisplayText(0, 0)
									ClearDrawOrigin()
								end
							end
						end
					end
				else
					--DrawLine(bone.x, bone.y, bone.z, bone.x, bone.y, bone.z + 1500, 0, 255, 0, 220) --чекаем где эта кость вообще
				end
			end
		else
			if caralpha then
				ResetEntityAlpha(vehicle)
			end

			if pedbones then
				if pedalpha then
					SetEntityAlpha(ped, 128, false)
				end

				for k, v in ipairs(pedbonesid) do
					local bone = GetPedBoneCoords(ped, v, 0, 0, 0)

					if Vdist(bone.x, bone.y, bone.z, pedpos.x, pedpos.y, pedpos.z) > 0.005 then
						DrawBox(bone.x - pedsize, bone.y - pedsize, bone.z - pedsize, bone.x + pedsize, bone.y + pedsize, bone.z + pedsize, 0, 255, 0, 220)
					end
				end
			end
		end
	end
end)

-- утилиты

function ToInt(num)
	if type(num) == "number" then
		local dot = string.find(num, ".", 1, 1)
		if dot then
			return tonumber(string.sub(num, 1, dot-1)) or 0
		end
	end
	return 0
end
