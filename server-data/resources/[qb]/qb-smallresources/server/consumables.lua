local QBCore = exports['qb-core']:GetCoreObject()

local function getReplenish(entry)
    if type(entry) == 'table' then
        return math.random(entry[1], entry[2])
    end
    return tonumber(entry) or 0
end

local function invRemove(source, itemName, amount, slot)
    return exports.ox_inventory:RemoveItem(source, itemName, amount or 1, nil, slot)
end

local function invAdd(source, itemName, amount)
    return exports.ox_inventory:AddItem(source, itemName, amount or 1)
end

local function applyHunger(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local hunger = math.min(100, (Player.PlayerData.metadata.hunger or 0) + amount)
    Player.Functions.SetMetaData('hunger', hunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, hunger, Player.PlayerData.metadata.thirst or 0)
end

local function applyThirst(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local thirst = math.min(100, (Player.PlayerData.metadata.thirst or 0) + amount)
    Player.Functions.SetMetaData('thirst', thirst)
    TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger or 0, thirst)
end

----------- / alcohol

for k, _ in pairs(Config.Consumables.alcohol) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('consumables:client:DrinkAlcohol', source, item.name, item.slot)
    end)
end

----------- / Eat

for k, _ in pairs(Config.Consumables.eat) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('consumables:client:Eat', source, item.name, item.slot)
    end)
end

----------- / Drink

for k, _ in pairs(Config.Consumables.drink) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('consumables:client:Drink', source, item.name, item.slot)
    end)
end

----------- / Custom

for k, _ in pairs(Config.Consumables.custom) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('consumables:client:Custom', source, item.name, item.slot)
    end)
end

local function createItem(name, type)
    QBCore.Functions.CreateUseableItem(name, function(source, item)
        TriggerClientEvent('consumables:client:' .. type, source, item.name, item.slot)
    end)
end

----------- / Drug

QBCore.Functions.CreateUseableItem('joint', function(source, item)
    TriggerClientEvent('consumables:client:UseJoint', source, item.slot)
end)

QBCore.Functions.CreateUseableItem('cokebaggy', function(source)
    TriggerClientEvent('consumables:client:Cokebaggy', source)
end)

QBCore.Functions.CreateUseableItem('crack_baggy', function(source)
    TriggerClientEvent('consumables:client:Crackbaggy', source)
end)

QBCore.Functions.CreateUseableItem('xtcbaggy', function(source)
    TriggerClientEvent('consumables:client:EcstasyBaggy', source)
end)

QBCore.Functions.CreateUseableItem('oxy', function(source)
    TriggerClientEvent('consumables:client:oxy', source)
end)

QBCore.Functions.CreateUseableItem('meth', function(source)
    TriggerClientEvent('consumables:client:meth', source)
end)

----------- / Tools

QBCore.Functions.CreateUseableItem('armor', function(source)
    TriggerClientEvent('consumables:client:UseArmor', source)
end)

QBCore.Functions.CreateUseableItem('heavyarmor', function(source)
    TriggerClientEvent('consumables:client:UseHeavyArmor', source)
end)

QBCore.Commands.Add('resetarmor', 'Resets Vest (Police Only)', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('consumables:client:ResetArmor', source)
    else
        TriggerClientEvent('QBCore:Notify', source, 'For Police Officer Only', 'error')
    end
end)

QBCore.Functions.CreateUseableItem('binoculars', function(source)
    TriggerClientEvent('binoculars:Toggle', source)
end)

QBCore.Functions.CreateUseableItem('parachute', function(source, item)
    TriggerClientEvent('consumables:client:UseParachute', source, item.slot)
end)

QBCore.Commands.Add('resetparachute', 'Resets Parachute', {}, false, function(source)
    TriggerClientEvent('consumables:client:ResetParachute', source)
end)

----------- / Firework

for _, v in pairs(Config.Fireworks.items) do
    QBCore.Functions.CreateUseableItem(v, function(source, item)
        TriggerClientEvent('fireworks:client:UseFirework', source, item.name, 'proj_indep_firework')
    end)
end

----------- / Lockpicking

QBCore.Functions.CreateUseableItem('lockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
end)

QBCore.Functions.CreateUseableItem('advancedlockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
end)

-- Consume events (item removed after successful use)

RegisterNetEvent('consumables:server:consumeEat', function(itemName, slot)
    local src = source
    if not Config.Consumables.eat[itemName] then return end
    if slot and not invRemove(src, itemName, 1, slot) then return end
    applyHunger(src, getReplenish(Config.Consumables.eat[itemName]))
end)

RegisterNetEvent('consumables:server:consumeDrink', function(itemName, slot)
    local src = source
    if not Config.Consumables.drink[itemName] then return end
    if slot and not invRemove(src, itemName, 1, slot) then return end
    applyThirst(src, getReplenish(Config.Consumables.drink[itemName]))
end)

RegisterNetEvent('consumables:server:consumeAlcohol', function(itemName, slot)
    local src = source
    if not Config.Consumables.alcohol[itemName] then return end
    if slot and not invRemove(src, itemName, 1, slot) then return end
    applyThirst(src, getReplenish(Config.Consumables.alcohol[itemName]))
end)

RegisterNetEvent('consumables:server:consumeCustom', function(itemName, slot)
    local src = source
    local data = Config.Consumables.custom[itemName]
    if not data then return end
    if slot and not invRemove(src, itemName, 1, slot) then return end
    if data.replenish and data.replenish.type then
        local rType = string.lower(data.replenish.type)
        local amount = data.replenish.replenish or 0
        if rType == 'hunger' then
            applyHunger(src, amount)
        elseif rType == 'thirst' then
            applyThirst(src, amount)
        end
    end
end)

RegisterNetEvent('consumables:server:AddParachute', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invAdd(source, 'parachute', 1)
end)

RegisterNetEvent('consumables:server:resetArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invAdd(source, 'heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if not invRemove(source, 'heavyarmor', 1) then return end
    TriggerClientEvent('hospital:server:SetArmor', source, 100)
    SetPedArmour(GetPlayerPed(source), 100)
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if not invRemove(source, 'armor', 1) then return end
    TriggerClientEvent('hospital:server:SetArmor', source, 75)
    SetPedArmour(GetPlayerPed(source), 75)
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invRemove(source, 'meth', 1)
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invRemove(source, 'oxy', 1)
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invRemove(source, 'xtcbaggy', 1)
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invRemove(source, 'crack_baggy', 1)
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    invRemove(source, 'cokebaggy', 1)
end)

RegisterNetEvent('consumables:server:removeJoint', function(slot)
    invRemove(source, 'joint', 1, slot)
end)

RegisterNetEvent('consumables:server:removeParachute', function(slot)
    invRemove(source, 'parachute', 1, slot)
end)

RegisterNetEvent('consumables:server:UseFirework', function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local foundItem = nil

    for i = 1, #Config.Fireworks.items do
        if Config.Fireworks.items[i] == item then
            foundItem = Config.Fireworks.items[i]
            break
        end
    end

    if not foundItem then return end
    invRemove(source, foundItem, 1)
end)

-- ox_inventory bridge calls these with absolute hunger/thirst totals
RegisterNetEvent('consumables:server:addThirst', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local thirst = math.min(100, math.max(0, tonumber(amount) or Player.PlayerData.metadata.thirst or 0))
    Player.Functions.SetMetaData('thirst', thirst)
    TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger or 0, thirst)
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local hunger = math.min(100, math.max(0, tonumber(amount) or Player.PlayerData.metadata.hunger or 0))
    Player.Functions.SetMetaData('hunger', hunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, hunger, Player.PlayerData.metadata.thirst or 0)
end)

QBCore.Functions.CreateCallback('consumables:itemdata', function(_, cb, itemName)
    cb(Config.Consumables.custom[itemName])
end)

local function addDrink(drinkName, replenish)
    if Config.Consumables.drink[drinkName] ~= nil then
        return false, 'already added'
    else
        Config.Consumables.drink[drinkName] = replenish
        createItem(drinkName, 'Drink')
        return true, 'success'
    end
end

exports('AddDrink', addDrink)

local function addFood(foodName, replenish)
    if Config.Consumables.eat[foodName] ~= nil then
        return false, 'already added'
    else
        Config.Consumables.eat[foodName] = replenish
        createItem(foodName, 'Eat')
        return true, 'success'
    end
end

exports('AddFood', addFood)

local function addAlcohol(alcoholName, replenish)
    if Config.Consumables.alcohol[alcoholName] ~= nil then
        return false, 'already added'
    else
        Config.Consumables.alcohol[alcoholName] = replenish
        createItem(alcoholName, 'DrinkAlcohol')
        return true, 'success'
    end
end

exports('AddAlcohol', addAlcohol)

local function addCustom(itemName, data)
    if Config.Consumables.custom[itemName] ~= nil then
        return false, 'already added'
    else
        Config.Consumables.custom[itemName] = data
        createItem(itemName, 'Custom')
        return true, 'success'
    end
end

exports('AddCustom', addCustom)
