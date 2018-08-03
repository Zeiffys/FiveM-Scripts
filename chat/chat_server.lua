RegisterServerEvent("chat:commandEntered")
RegisterServerEvent("chat:messageEntered")
RegisterServerEvent("playerActivated")

AddEventHandler("chat:commandEntered", function(author, rawCommand)
	print(" *"..author.." executed the command /"..rawCommand)
end)

AddEventHandler("chat:messageEntered", function(author, message)
	if not WasEventCanceled() then
		TriggerClientEvent("chat:addMessage", -1, author, message)
		print(" *"..escape(author)..": "..escape(message))
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
			reason = "reconnecting"
		else
			reason = "kicked ("..reason..")"
		end
		TriggerClientEvent("chat:addMessage", -1, "", " ^1*"..GetPlayerName(source).." ^0"..reason)
	end
end)

local function RefreshAllowedCommands(player)
	if GetRegisteredCommands and player then
		local registeredCommands = GetRegisteredCommands()
		local allowedCommands = {}

		for _, command in ipairs(registeredCommands) do
			if IsPlayerAceAllowed(player, ("command.%s"):format(command.name)) then
				for i, v in ipairs(allowedCommands) do -- remove old shit and fix fivem shit
					if v:lower() == command.name:lower() then
						table.remove(allowedCommands, i)
					end
				end
				table.insert(allowedCommands, command.name:lower())
			end
		end

		TriggerClientEvent("chat:allowedCommand", player, allowedCommands)
	end
end

AddEventHandler("onServerResourceStart", function(resName)
	Wait(500)

	for _, player in ipairs(GetPlayers()) do
		RefreshAllowedCommands(player)
	end
end)

AddEventHandler("playerActivated", function()
	local player = source
	Wait(500)
	RefreshAllowedCommands(player)
end)

RegisterCommand("me", function(source, args, raw)
	if source ~= 0 then
		local _source = source
		local name = GetPlayerName(_source)
		local action = escape(raw:sub(3, #raw))

		if #action:gsub(" ", "") > 0 then
			TriggerClientEvent("chat:addMessage", -1, "", " ^6*"..name..action)
		else
			TriggerClientEvent("chat:addMessage", _source, " ^1*Usage^0", "/me <your action from the third person>")
		end
	end
end, false)

RegisterCommand("say", function(source, args)
	if source == 0 then
		local message = escape(table.concat(args, " "))

		if #message:gsub(" ", "") > 0 then
			TriggerEvent("chat:messageEntered", "^5Console^0", message)
		else
			print("Argument count mismatch (passed 0, wanted 1)")
		end
	end
end, false)
--ExecuteCommand("add_ace builtin.everyone command.say deny")
--ExecuteCommand("add_ace system.console command.say allow")
