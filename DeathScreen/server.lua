RegisterServerEvent('freznva:deathscreen:playerDied')
AddEventHandler('freznva:deathscreen:playerDied',function(id, killer, reason)
	TriggerClientEvent('freznva:deathscreen:showNotification', -1, id, GetPlayerName(source), killer)
end)