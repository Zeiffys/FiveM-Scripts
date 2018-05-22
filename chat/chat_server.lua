RegisterServerEvent("chat:commandEntered")
RegisterServerEvent("chat:messageEntered")
RegisterServerEvent("playerActivated")

AddEventHandler("chat:commandEntered", function(name, command)
    print(" *"..name.." executed the command /"..command)
end)

AddEventHandler("chat:messageEntered", function(name, message)
    if not WasEventCanceled() then
        TriggerClientEvent("chat:addMessage", -1, name, message)
		print(" *"..string.gsub(name, "%^([0-9*_~=r])", "")..": "..string.gsub(message, "%^([0-9*_~=r])", ""))
    end
end)

AddEventHandler("playerActivated", function()
    TriggerClientEvent("chat:addMessage", -1, "", " ^1*"..GetPlayerName(source).." ^0joined")
end)

AddEventHandler("playerDropped", function(reason)
	if GetPlayerName(source) then
		if reason:find("Exiting") or reason:find("Disconnect") then
			reason = "left"
		elseif reason:find("Timed out") then
			reason = "timed out"
		elseif reason:find("Reconnecting") then
			reason = "kicked (old client version)"
		else
			reason = "kicked ("..reason..")"
		end
		TriggerClientEvent("chat:addMessage", -1, "", " ^1*"..GetPlayerName(source).." ^0"..reason)
	end
end)

local function RefreshAllowedCommands(player)
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()
		local allowedCommands = {}

		for _, command in ipairs(registeredCommands) do
			if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
				for i, v in ipairs(allowedCommands) do -- fix fivem shit
					if v:lower() == command.name:lower() then
						table.remove(allowedCommands, i)
					end
				end
				table.insert(allowedCommands, command.name:lower())
			end
		end

		TriggerClientEvent('chat:allowedCommand', player, allowedCommands)
	end
end

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        RefreshAllowedCommands(player)
    end
end)

AddEventHandler("playerActivated", function()
    Wait(500)
	RefreshAllowedCommands(source)
end)
