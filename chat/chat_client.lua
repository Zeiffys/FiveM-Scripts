local chatInputActive = false
local chatInputActivating = false
local chatAllowedCommands = {}

RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage", function(name, message)
	SendNUIMessage({name = tostring(name), message = tostring(message)})
end)

RegisterNUICallback("chatResult", function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)

	if data.message then
		local author = GetPlayerName(PlayerId())
		local message = data.message:sub(1, 256)
		local messageLen = escape(message):gsub(" ", ""):len()

		if messageLen > 0 then
			if message:sub(1, 1) == "/" then
				local rawCommand = message:sub(2)
				local command = string.split(escape(rawCommand))[1]
				if command then
					for _, allowedCommand in ipairs(chatAllowedCommands) do
						if command == allowedCommand then
							ExecuteCommand(rawCommand)
							TriggerServerEvent("chat:commandEntered", author, rawCommand)
							return
						end
					end
					TriggerEvent("chat:addMessage", "", " ^1*^0Command \""..command.."\" not found")
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

	if GetRegisteredCommands() then
		local registeredCommands = GetRegisteredCommands()

		for _, command in ipairs(registeredCommands) do
			if IsAceAllowed(("command.%s"):format(command.name)) then
				for i, v in ipairs(chatAllowedCommands) do -- remove old shit and fix fivem shit
					if v:lower() == command.name:lower() then
						table.remove(chatAllowedCommands, i)
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
			if IsControlPressed(0, 245) then
				chatInputActive = true
				chatInputActivating = true
				SendNUIMessage({meta = "openChatBox"})
			end
		end
		if chatInputActivating then
			if not IsControlPressed(0, 245) then
				SetNuiFocus(true)
				chatInputActivating = false
			end
		end
	end
end)
