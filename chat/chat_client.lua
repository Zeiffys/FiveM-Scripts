local isPauseMenuActive = false
local chatInputActive = false
local chatInputActivating = false
local chatAllowedCommands = {}
local registeredCommands = {}

RegisterNetEvent("chat:sendMessage")
AddEventHandler("chat:sendMessage", function(name, message)
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
					TriggerEvent("chat:sendMessage", "", " ^1*^0Command \""..command.."\" not found")
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
	while true do
		Citizen.Wait(0)
		if not chatInputActive then
			if IsControlJustReleased(2, 245) then
				chatInputActive = true
				SetNuiFocus(true)
				SendNUIMessage({meta = "openChatBox"})
			end
		end

		if IsPauseMenuActive() then
			if not isPauseMenuActive then
				SendNUIMessage({meta = "pauseMenuActive"})
				isPauseMenuActive = true
			end
		else
			if isPauseMenuActive then
				SendNUIMessage({meta = "pauseMenuNotActive"})
				isPauseMenuActive = false
			end
		end
	end
end)
