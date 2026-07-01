local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

QBCore.Functions.CreateCallback('qb-spawn:server:getOwnedHouses', function(_, cb, cid)
    if cid == nil or GetResourceState('qb-houses') ~= 'started' then
        cb({})
        return
    end

    local ok, houses = pcall(MySQL.query.await, 'SELECT * FROM player_houses WHERE citizenid = ?', { cid })
    if ok and houses and houses[1] ~= nil then
        cb(houses)
    else
        cb({})
    end
end)
