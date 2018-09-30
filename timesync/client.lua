local function GetTimeFromUnix(unix)
	local hours = math.floor(unix / 3600 % 24)
	local minutes = math.floor(unix / 60 % 60)
	local seconds = math.floor(unix % 60)
	return hours, minutes, seconds
end

local function GetClockTimeParams(oneminute, timer, hoursoffset)
	local timer = timer or (NetworkIsSessionActive() and GetNetworkTime() or GetPosixTime()*1000)
	local oneminute = oneminute or GetMillisecondsPerGameMinute()
	local onesecond = oneminute/60
	local unix = timer/onesecond
	local hours, minutes, seconds = GetTimeFromUnix(unix + (3600 * (hoursoffset or 0)))

	--local dayinmins = (oneminute * 1440 / 1000)/60

	return hours, minutes, seconds
end

Citizen.CreateThread(function()
	while true do
		NetworkOverrideClockTime(GetClockTimeParams(5000, GetGameTimer(), 5))
		Citizen.Wait(0)
	end
end)
