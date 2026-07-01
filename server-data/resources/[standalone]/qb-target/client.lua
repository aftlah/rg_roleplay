local qtarget = exports.qtarget

local forwarded = {
    'AddBoxZone',
    'AddCircleZone',
    'AddPolyZone',
    'AddTargetBone',
    'AddTargetEntity',
    'RemoveZone',
    'RemoveTargetEntity',
    'AddTargetModel',
    'RemoveTargetModel',
    'Ped',
    'RemovePed',
    'Vehicle',
    'RemoveVehicle',
    'Object',
    'RemoveObject',
}

for i = 1, #forwarded do
    local name = forwarded[i]
    exports(name, function(...)
        return qtarget[name](qtarget, ...)
    end)
end

local function spawnSinglePed(v)
    local model = v.model
    if type(model) == 'string' then model = joaat(model) end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local c = v.coords
    local z = c.z - (v.minusOne and 1.0 or 0.0)
    local ped = CreatePed(0, model, c.x, c.y, z, c.w or 0.0, v.networked or false, true)

    if v.freeze then FreezeEntityPosition(ped, true) end
    if v.invincible then SetEntityInvincible(ped, true) end
    if v.blockevents then SetBlockingOfNonTemporaryEvents(ped, true) end

    if v.animDict and v.anim then
        RequestAnimDict(v.animDict)
        while not HasAnimDictLoaded(v.animDict) do Wait(0) end
        TaskPlayAnim(ped, v.animDict, v.anim, 8.0, 0, -1, v.flag or 1, 0, false, false, false)
    end

    if v.scenario then
        TaskStartScenarioInPlace(ped, v.scenario, 0, true)
    end

    if v.weapon and v.weapon.name then
        local weapon = type(v.weapon.name) == 'string' and joaat(v.weapon.name) or v.weapon.name
        GiveWeaponToPed(ped, weapon, v.weapon.ammo or 0, v.weapon.hidden == true, true)
    end

    if v.target then
        if v.target.useModel then
            qtarget:AddTargetModel(model, v.target)
        else
            qtarget:AddTargetEntity(ped, v.target)
        end
    end

    if v.action then v.action(v) end
    SetModelAsNoLongerNeeded(model)
    return ped
end

exports('SpawnPed', function(data)
    local key, value = next(data)
    if type(value) == 'table' and type(key) == 'number' then
        for _, v in pairs(data) do
            spawnSinglePed(v)
        end
    else
        spawnSinglePed(data)
    end
end)

exports('AllowTargeting', function(state)
    exports.ox_target:disableTargeting(not state)
end)
