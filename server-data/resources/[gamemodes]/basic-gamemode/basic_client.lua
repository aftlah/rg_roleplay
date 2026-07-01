-- RG Roleplay: disable default auto-spawn; QBCore multichar handles player spawn.
AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:setAutoSpawn(false)
end)
