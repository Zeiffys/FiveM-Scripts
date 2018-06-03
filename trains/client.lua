local _fix_, _random_ = math.randomseed(tonumber((GetClockHours() / GetClockMinutes()) * (GetClockSeconds() * (GetClockHours() + GetClockMinutes())))), math.random(tonumber(string.format("%s%s%s", GetClockSeconds(), GetClockHours(), GetClockMinutes()))) -- damn
createBlip = true
trains = {}
metrotrains = {}

models = {"freight", "freightcar", "freightgrain", "freightcont1", "freightcont2", "freighttrailer", "tankercar", "metrotrain", "s_m_m_lsmetro_01"}
function LoadTrainModels()
	Citizen.CreateThread(function()
	for _, model in ipairs(models) do
		tempmodel = GetHashKey(model)
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
	end
	end)
end

LoadTrainModels()

trainLocations = {
	{2533.0,2833.0,38.0},
	{2606.0,2927.0,40.0},
	{2463.0,3872.0,38.8},
	{1164.0,6433.0,32.0},
	--{537.0,-1324.1,29.1}, --bad path. maybe it used in mission
	{219.1,-2487.7,6.0}
}

metrotrainLocations = {
	{40.2,-1201.3,31.0},
	{-618.0,-1476.8,16.2}
}

function DeleteTrains()
	for k, v in ipairs(trains) do
		SetMissionTrainAsNoLongerNeeded(v)
		DeleteMissionTrain(v)
		DeleteAllTrains()
		DeleteVehicle(v)
		DeleteEntity(v)
	end
end

function DeleteMetroTrains()
	for k, v in ipairs(metrotrains) do
		SetMissionTrainAsNoLongerNeeded(v)
		DeleteMissionTrain(v)
		DeleteAllTrains()
		DeleteVehicle(v)
		DeleteEntity(v)
	end
end

local trainvar = {
	short = {0, 18, 19, 20},
	medium = {2, 6, 12},
	long = {1, 3, 4, 5, 7, 8, 9, 10, 11, 13, 14, 15, 16, 23},
	itreallyfuckinglongtrain = {17, 22},

	all = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 23}
}
local metrovar = {
	short = {21},
	medium = {24}
	--[[ idk how it
		21 - 1 - texture bug
		24 - 2 = 1 full
	]]
}

function StartTrain()
	Citizen.Trace(" *"..GetCurrentResourceName()..": train creating started")

	DeleteTrains()

	for k, v in ipairs(trainLocations) do
		direction = true --math.random(0,1)
		--print("direction:"..direction)

		x, y, z = v[1], v[2], v[3]

		-- variation is max 24 by default. maybe it's can be modify and add more
		local train = CreateMissionTrain(trainvar.all[math.random(17)], x, y, z, direction)

		SetTrainSpeed(train, 25.0)
		SetTrainCruiseSpeed(train, 25.0)

		CreatePedInsideVehicle(train, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true)

		SetEntityAsMissionEntity(train, true, true)

		if createBlip then
			local blip = AddBlipForEntity(train)
			SetBlipSprite(blip, 373)
			SetBlipScale(blip, 0.3)
			SetBlipAlpha(blip, 180)
			SetBlipColour(blip, 36)
			SetBlipAsShortRange(blip, true)
			SetBlipDisplay(blip, 11)
		end

		table.insert(trains, train)
	end
end

function StartMetroTrain()
	Citizen.Trace(" *"..GetCurrentResourceName()..": metro trains creating started")

	DeleteMetroTrains()

	for k, v in ipairs(metrotrainLocations) do
		x, y, z = v[1], v[2], v[3]

		metrotrain = CreateMissionTrain(24, x, y, z, true)

		CreatePedInsideVehicle(metrotrain, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true)

		SetEntityAsMissionEntity(metrotrain, true, true)

		if createBlip then
			local blip = AddBlipForEntity(metrotrain)
			SetBlipSprite(blip, 373)
			SetBlipScale(blip, 0.3)
			SetBlipAlpha(blip, 180)
			SetBlipColour(blip, 0)
			SetBlipAsShortRange(blip, true)
			SetBlipDisplay(blip, 11)
		end

		table.insert(metrotrains, metrotrain)
	end
end

RegisterNetEvent(GetCurrentResourceName()..":startTrain")
RegisterNetEvent(GetCurrentResourceName()..":startMetroTrain")
AddEventHandler(GetCurrentResourceName()..":startTrain", StartTrain)
AddEventHandler(GetCurrentResourceName()..":startMetroTrain", StartMetroTrain)

AddEventHandler('onResourceStop', function (resource)
	local currentResource = GetCurrentResourceName()
    if resource == currentResource then
		DeleteTrains()
		DeleteMetroTrains()
    end
end)
