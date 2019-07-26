RegisterServerEvent("chat:commandEntered")
RegisterServerEvent("chat:messageEntered")
RegisterServerEvent("playerActivated")

local acetags = {
	-- {"the.permission.name", "tag"}
	{"group.admin", "^1*^0"},
	{"group.moderator", "^9*^0"},
	{"group.friend", "^2*^0"}
}

AddEventHandler("chat:commandEntered", function(author, rawCommand)
	print(("[CHAT] %s executed the command '%s'"):format(author, rawCommand))
end)

AddEventHandler("chat:messageEntered", function(author, message)
	if not WasEventCanceled() then
		local acetag = ""

		if author then
			for k, v in pairs(acetags) do
				if IsPlayerAceAllowed(source, v[1]) then
					acetag = v[2]
					break
				end
			end
		end

		TriggerClientEvent("chat:addMessage", -1, acetag..author, message)
		print(("[CHAT] %s: %s"):format(escape(author), escape(message)))
	end
end)

AddEventHandler("playerActivated", function()
	local name = GetPlayerName(source)

	if name then
		TriggerClientEvent("chat:addMessage", -1, "", (" * %s joined"):format(name))
	end
end)

AddEventHandler("playerDropped", function(reason)
	local name = GetPlayerName(source)

	if name then
		if reason:find("Exiting") or reason:find("Disconnect") then
			reason = "left"
		elseif reason:find("Timed out") then
			reason = "timed out"
		elseif reason:find("Reconnecting") then
			reason = "reconnecting"
		elseif reason:find("Could not connect to session provider.") then
			reason = "can't connect to session."
		else
			reason = "kicked ("..reason..")"
		end

		TriggerClientEvent("chat:addMessage", -1, "", (" * %s %s"):format(name, reason))
	end
end)

local function RefreshAllowedCommands(player)
	local chatAllowedCommands = {}
	local registeredCommands = GetRegisteredCommands()

	if registeredCommands and player then
		for _, command in ipairs(registeredCommands) do
			if IsPlayerAceAllowed(player, ("command.%s"):format(command.name)) then
				for i, v in ipairs(chatAllowedCommands) do -- сheck for duplicate commands
					if v:lower() == command.name:lower() then
						table.remove(chatAllowedCommands, i) -- remove if available
					end
				end
				table.insert(chatAllowedCommands, command.name:lower())
			end
		end

		TriggerClientEvent("chat:allowedCommand", player, chatAllowedCommands)
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
			TriggerClientEvent("chat:addMessage", -1, "", " ^6*^/"..name..action)
		else
			TriggerClientEvent("chat:addMessage", _source, " ^1Usage^0", "/me <your action from the third person>")
		end
	end
end, false)

RegisterCommand("say", function(source, args)
	local _source = source
	local isConsole = (_source == 0)
	local message = table.concat(args, " ")

	if #message:gsub(" ", "") > 0 then
		TriggerEvent("chat:messageEntered", (isConsole and "^5Console^0" or GetPlayerName(_source)), message)
	else
		if isConsole then
			print("Argument count mismatch (passed 0, wanted 1)")
		end
	end
end, false)

RegisterCommand("pm", function(source, args, rawCommand)
	if source ~= 0 then
		if args[2] then
			local sender = tonumber(source)
			local player = tonumber(args[1]) or -1
			local message = table.concat(args, " ", 2)

			if GetPlayerPing(player) > 0 then
				if sender ~= player then
					local coolthing = {
						{sender, ":incoming_envelope: "..GetPlayerName(player)},
						{player, ":envelope_with_arrow: "..GetPlayerName(sender)}
					}

					for k, v in pairs(coolthing) do
						TriggerClientEvent("chat:addMessage", v[1], v[2], message)
					end
				elseif sender == player then
					TriggerClientEvent("chat:addMessage", sender, ":e_mail:", "Our services are currently unavailable. Please callback later. :hammer::monkey:")
				end
			else
				TriggerClientEvent("chat:addMessage", sender, ":e_mail:", "Player not found")
			end
		else
			TriggerClientEvent("chat:addMessage", source, " ^1Usage^0", "/pm <playerid> <message>")
		end
	end
end, false)
