local trainspawned = false
local playerCount = 0
local playerList = {}
local msCheck = 5000

RegisterServerEvent("playerActivated")
RegisterServerEvent("playerDropped")

function ActivateTrain()
	--print(" *"..GetCurrentResourceName()..": train spawn check. next check from " .. msCheck/1000 .. "s.")
	--print(" *"..GetCurrentResourceName()..": host:"..GetHostId().." hostname:"..GetPlayerName(GetHostId()))
	if playerCount == 1 and (not trainspawned) then
		TriggerClientEvent(GetCurrentResourceName()..":startTrain", GetHostId())
		TriggerClientEvent(GetCurrentResourceName()..":startMetroTrain", GetHostId())
		trainspawned = true
	else
		SetTimeout(msCheck, ActivateTrain)
		if playerCount == 0 then
			trainspawned = false
		end
	end
end

AddEventHandler("playerActivated", function()
	if not playerList[source] then
		playerCount = playerCount + 1
		playerList[source] = true

		if playerCount == 1 then
			SetTimeout(msCheck, ActivateTrain)
		end
	end
end)

AddEventHandler("playerDropped", function()
	if playerList[source] then
		playerCount = playerCount - 1
		playerList[source] = nil
	end
end)

AddEventHandler('onResourceStart', function (resource)
	local currentResource = GetCurrentResourceName()
    if resource == currentResource then
		for v in ipairs(GetPlayers()) do
			playerCount = playerCount + 1
			playerList[v] = true
		end

		if playerCount > 0 then
			print(" *"..GetCurrentResourceName()..": #players > 0 - spawn trains")
			--print(" *"..GetCurrentResourceName()..": host:"..GetHostId().." hostname:"..GetPlayerName(GetHostId()))

			SetTimeout(msCheck/2, function()
				TriggerClientEvent(GetCurrentResourceName()..":startTrain", GetHostId())
				TriggerClientEvent(GetCurrentResourceName()..":startMetroTrain", GetHostId())
				trainspawned = true
			end)
			SetTimeout(msCheck, ActivateTrain)
		end
    end
end)
