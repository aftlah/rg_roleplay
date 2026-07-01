local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while not Config.Discord.isEnabled do
        Wait(1000)
    end

    if not Config.Discord.applicationId or Config.Discord.applicationId == '' or Config.Discord.applicationId == 'ISI_APPLICATION_ID_DISCORD' then
        print('^1[qb-smallresources]^7 Discord Rich Presence: isi Config.Discord.applicationId di config.lua')
        return
    end

    SetDiscordAppId(Config.Discord.applicationId)
    SetDiscordRichPresenceAsset(Config.Discord.iconLarge)
    SetDiscordRichPresenceAssetText(Config.Discord.iconLargeHoverText)

    if Config.Discord.iconSmall and Config.Discord.iconSmall ~= '' then
        SetDiscordRichPresenceAssetSmall(Config.Discord.iconSmall)
        SetDiscordRichPresenceAssetSmallText(Config.Discord.iconSmallHoverText)
    end

    if Config.Discord.buttons and type(Config.Discord.buttons) == 'table' then
        for i, v in pairs(Config.Discord.buttons) do
            if i <= 2 and v.text and v.url then
                SetDiscordRichPresenceAction(i - 1, v.text, v.url)
            end
        end
    end

    while Config.Discord.isEnabled do
        if Config.Discord.showPlayerCount then
            QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
                SetRichPresence(('Players %s/%s'):format(result, Config.Discord.maxPlayers))
            end)
        else
            SetRichPresence(Config.Discord.iconLargeHoverText or 'RG Roleplay')
        end

        Wait(Config.Discord.updateRate)
    end
end)
