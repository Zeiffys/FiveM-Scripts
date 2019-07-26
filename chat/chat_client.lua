local shouldBeHidden = false
local chatInputActive = false
local chatAllowedCommands = {}
local registeredCommands = {}

RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage", function(name, message)
	SendNUIMessage({
		meta = "outputChatBox",
		name = emojit(tostring(name)),
		message = emojit(tostring(message))
	})
end)

RegisterNUICallback("chatResult", function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)

	if data.hasMessage then
		local author = GetPlayerName(PlayerId())
		local message = data.message:gsub("%s+", " "):sub(1, 256)
		local messageLen = escape(message):gsub(" ", ""):len()

		if messageLen > 0 then
			if message:sub(1, 1) == "/" and messageLen > 1 then
				local rawCommand = message:sub(2)
				local command = string.split(escape(rawCommand))[1]:lower()
				if command then
					for _, allowedCommand in ipairs(chatAllowedCommands) do
						if command == allowedCommand then
							ExecuteCommand(rawCommand)
							TriggerServerEvent("chat:commandEntered", author, rawCommand)
							return
						end
					end
					TriggerEvent("chat:addMessage", "^1Error^0", "Command '"..command.."' not found")
				end
			else
				TriggerServerEvent("chat:messageEntered", author, message)
			end
		end
	end
end)

RegisterNetEvent("chat:allowedCommand")
AddEventHandler("chat:allowedCommand", function(allowedCommands)
	chatAllowedCommands = allowedCommands
	registeredCommands = GetRegisteredCommands()

	if registeredCommands then
		for _, command in ipairs(registeredCommands) do
			if IsAceAllowed(("command.%s"):format(command.name)) then
				for i, v in ipairs(chatAllowedCommands) do -- сheck for duplicate commands
					if v:lower() == command.name:lower() then
						table.remove(chatAllowedCommands, i) -- remove if available
					end
				end
				table.insert(chatAllowedCommands, command.name:lower())
			end
		end
	end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false)
	SetTextChatEnabled(false)
	DecorRegister("chat:isTyping", 2)

	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() or IsScreenFadedOut() then
			if not shouldBeHidden then
				SendNUIMessage({meta = "shouldBeHidden"})
				shouldBeHidden = true
			end
		else
			if shouldBeHidden then
				SendNUIMessage({meta = "shouldNotBeHidden"})
				shouldBeHidden = false
			else
				if not chatInputActive then
					if IsControlJustReleased(0, 245) then
						chatInputActive = true
						SetNuiFocus(true)
						SendNUIMessage({meta = "openChatBox"})
					end
				end
			end
		end

		DecorSetBool(PlayerPedId(), "chat:isTyping", chatInputActive)
	end
end)
