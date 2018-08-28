local maxplayers = 32
local afktime = 30*1000

local defaultColor = {r = 245, g = 245, b = 245, a = 255}
local armorColor = {r = 220, g = 220, b = 220, a = 200}
local bgColor = {r = 0, g = 0, b = 0, a = 100}

function DrawNametags()
	local _wait = GetFrameTime()*1000-((GetFrameTime()*1000)/4) -- experimental optimisation
	SetTimeout(0, DrawNametags)

	if not NetworkIsGameInProgress() then return end
	if GetNumberOfPlayers() <= 1 then return end
	if IsPauseMenuActive() then return end
	

	local localPed = PlayerPedId()
	local gameplayCamCoords = GetGameplayCamCoord()
	local localFPS = 1 / GetFrameTime()
	
	for i = 0, maxplayers do
		if NetworkIsPlayerActive(i) and i ~= PlayerId() then
			local playerPed = GetPlayerPed(i)
			local playerHead = GetPedBoneCoords(playerPed, 12844, 0, 0, 0) + vector3(0, 0, 0.5) + (GetEntityVelocity(playerPed) / localFPS)
			local dist = #(gameplayCamCoords - playerHead)

			if dist < 25 then
				local isAimingAtEntity = IsPlayerFreeAimingAtEntity(localPed, ped)
				local hasClearLos = HasEntityClearLosToEntity(localPed, playerPed, 17)

				if not isAimingAtEntity and hasClearLos then
					local isAfk = GetGameTimer() - afkChecks[i][3] > afktime
					local playerName = isAfk and "~r~AFK~s~~n~" .. GetPlayerName(i) or GetPlayerName(i)
					local sizeOffset = math.max(1 - dist / 30, 0.3)

					SetDrawOrigin(playerHead, false)

					SetTextColour(defaultColor.r, defaultColor.g, defaultColor.b, defaultColor.a)
					SetTextScale(0.0, 0.4*sizeOffset)
					SetTextCentre(true)
					SetTextOutline()
					BeginTextCommandDisplayText("STRING")
					AddTextComponentSubstringPlayerName(playerName)
					EndTextCommandDisplayText(0.0, 0.0)

					local healthPercent = math.min(math.max((GetEntityHealth(playerPed) - 100) / 100, 0.0), 1.0)
					local armorPercent = math.min(math.max(GetPedArmour(playerPed) / 100, 0.0), 1.0)
					local armorBar = math.round(150 * armorPercent) * sizeOffset

					GTAN_DrawRectangle(-75 * sizeOffset, 36 * sizeOffset, armorBar, 20 * sizeOffset, armorColor.r, armorColor.g, armorColor.b, armorColor.a)
					GTAN_DrawRectangle(-75 * sizeOffset + armorBar, 36 * sizeOffset, sizeOffset * 150 - armorBar, sizeOffset * 20, bgColor.r, bgColor.g, bgColor.b, bgColor.a)
					GTAN_DrawRectangle(-71 * sizeOffset, 40 * sizeOffset, 142 * healthPercent * sizeOffset, 12 * sizeOffset, 50, 250, 50, 150)

					ClearDrawOrigin()
				end
			end
		end
	end
end

function AfkCheck()
	SetTimeout(1000, AfkCheck)

	local timer = GetGameTimer()

	for i = 0, maxplayers do
		if NetworkIsPlayerActive(i) and i ~= PlayerId() then
			afkChecks[i][1] = GetEntityCoords(GetPlayerPed(i))
			if afkChecks[i][1] ~= afkChecks[i][2] then
				afkChecks[i][3] = timer
			end
			afkChecks[i][2] = afkChecks[i][1]
		else
			afkChecks[i] = {vector, vector, timer}
		end
	end
end



function math.round(number)
	local _, decimals = math.modf(number)
	if decimals < 0.5 then return math.floor(number) end
	return math.ceil(number)
end

function GTAN_DrawRectangle(xPos, yPos, wSize, hSize, r, g, b, alpha)
	local _width, _height = GetActiveScreenResolution()
	local height = 1080
	local ratio = _width / _height
	local width = height * ratio

	local w = wSize / width
	local h = hSize / height
	local x = (xPos / width) + w * 0.5
	local y = (yPos / height) + h * 0.5

	DrawRect(x, y, w, h, r, g, b, alpha)
end

AddEventHandler("onClientResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		afkChecks = {}
		vector = vector3(0, 0, 0)

		for i = 0, maxplayers do
			afkChecks[i] = {vector, vector, GetGameTimer()}
		end

		Citizen.CreateThread(AfkCheck)
		Citizen.CreateThread(DrawNametags)
	end
end)

AddEventHandler("onClientResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		for i = 0, maxplayers do
			afkChecks[i] = 1
			afkChecks[i] = nil
		end

		afkChecks = 1
		afkChecks = nil
	end
end)
