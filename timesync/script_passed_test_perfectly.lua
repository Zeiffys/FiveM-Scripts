local timezone = 0
local resource = GetCurrentResourceName()

if IsDuplicityVersion() then
	RegisterCommand("sv_settimezone", function(source, args, rawCommand)
		local a = tonumber(args[1])
		if a and -24 < a and a < 24 then
			timezone = a
			TriggerClientEvent(resource .. ":setTimezone", -1, a)
			if source ~= 0 then
				print((" *timesync: %s(%s) set time zone to %s"):format(GetPlayerName(source), source, timezone))
			end
		end
	end, false)

	RegisterNetEvent(resource .. ":getTimezone")
	AddEventHandler(resource .. ":getTimezone", function()
		TriggerClientEvent(resource .. ":setTimezone", source, timezone)
	end)
else
	local function GetTimeFromUnix(unix, full)
		local hours = math.floor(unix / 3600 % 24)
		if full then hours = math.floor(unix / 3600) end
		local minutes = math.floor(unix / 60 % 60)
		local seconds = math.floor(unix % 60)

		local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(unix/86400)

		while days >= day_count(year) do
			days = days - day_count(year) year = year + 1
		end

		local tab_overflow = function(seed, table)
			for i = 1, #table do
				if seed - table[i] <= 0 then
					return i, seed
				end
				seed = seed - table[i]
			end
		end

		month, days = tab_overflow(days, {31,(day_count(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31})
		
		return hours, minutes, seconds, year, month, days
	end

	local function GetClockTimeParams(oneminute, timer, hoursoffset)
		local timer = timer or (NetworkIsSessionActive() and GetNetworkTime() or GetPosixTime()*1000)
		local oneminute = oneminute or GetMillisecondsPerGameMinute()
		local onesecond = oneminute/60
		local dayinmins = (oneminute * 1440 / 1000)/60
		local unix = timer/onesecond
		local hours, minutes, seconds, year, month, day = GetTimeFromUnix(unix + (3600 * (hoursoffset or 0)))

		--local dayinmins = (oneminute * 1440 / 1000)/60
		--test3(("1s: %sms\nduration of day: %sm\nunix: %.0f\nresult: %02d:%02d:%02d\ngame timer: %03d:%02d:%02d"):format(onesecond, dayinmins, unix, hours, minutes, seconds, GetTimeFromUnix(timer/1000, true)))

		return hours, minutes, seconds, year, month, day
	end

	function GetPosixTime() -- ahh ficking fixes
		return Citizen.InvokeNative(0x9A73240B49945C76, Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
	end

	Citizen.CreateThread(function()
		TriggerServerEvent(resource .. ":getTimezone")
		while true do
			local from2002 = (GetPosixTime() - 1455000000) * 1000
			local hour, munite, second, year, month, day = GetClockTimeParams(5000, from2002, timezone)
			NetworkOverrideClockTime(hour, munite, second)
			SetClockDate(day or 1, month or 7, year or 2013)
			Citizen.Wait(0)
		end
	end)

	RegisterCommand("settimezone", function(source, args, rawCommand)
		local a = tonumber(args[1])
		if a and -24 < a and a < 24 then
			timezone = a
		end
	end, false)

	RegisterCommand("gettimezone", function(source, args, rawCommand)
		TriggerServerEvent(resource .. ":getTimezone")
	end, false)

	RegisterNetEvent(resource .. ":setTimezone")
	AddEventHandler(resource .. ":setTimezone", function(a)
		if a and -24 < a and a < 24 then
			timezone = a
		end
	end)
end
