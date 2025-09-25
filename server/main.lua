local config = require 'config.server'

--- Notifies a player with a title and message.
--- @param source number The player's source ID.
--- @param title string The title of the notification.
--- @param message string The message of the notification.
--- @param type string (optional) The type of the notification.
local function notify(source, title, message, type)
    lib.notify(source, {
        title = title,
        description = message,
        type = type,
        duration = 10000
    })
end

--- Builds a URL using the specified endpoint and identifier.
--- @param endpoint string The endpoint to use in the URL.
--- @param identifier? string The identifier (steam/discord) to include in the URL.
local function buildUrl(endpoint, identifier)
    if endpoint == 'vote' then return config.tracky.endpoints[endpoint]:format(config.tracky.serverKey) end
    if endpoint == 'vote_url_client' then return config.tracky.endpoints.vote:format(config.tracky.serverId) end
    return config.tracky.endpoints[endpoint]:format(config.tracky.serverKey, config.identifier, identifier)
end

--- Retrieves the player associated with the given source.
--- @param source number The source of the player.
local function getPlayer(source)
    local license = GetPlayerIdentifierByType(source, 'license'):gsub("license:", "")
    local license2 = GetPlayerIdentifierByType(source, 'license2'):gsub("license2:", "")
    local identifier = GetPlayerIdentifierByType(source, config.identifier) or false

    if identifier then identifier = identifier:gsub(("%s:"):format(config.identifier), "") end

    return identifier, license2 or license
end

--- Calculates the reward for a given license.
--- @param license string The license for which to calculate the reward.
--- @return number The calculated reward.
local function calculateReward(license)
    local rewardAmount = config.rewards.daily
    local votes = tonumber(MySQL.scalar.await('SELECT count(*) FROM geo_servervote WHERE license = ?', {license}))
    if config.rewards.bonus[votes] then rewardAmount = rewardAmount + config.rewards.bonus[votes] end
    return rewardAmount
end

--- Inserts a vote into the database for bonus tracking.
--- @param identifier string The identifier of the player who initiated the vote.
--- @param license string The license of the player who initiated the vote.
--- @param amount number The amount of the reward for the vote.
local function insertVote(identifier, license, amount)
    MySQL.execute('INSERT INTO geo_servervote (identifier, license, amount) VALUES (?, ?, ?)', {identifier, license, amount})
end

-- This function is used to make an API call to TrackyServer's API.
-- @param type The type of API call.
-- @param source The source of the API call.
-- @param identifier The identifier for the API call.
-- @param cb The callback function to be executed after the API call.
local function api(type, source, identifier, cb)
    local url = buildUrl(type, identifier)
    PerformHttpRequest(url, function(responseCode, responseBody, _, _)
        if responseCode ~= 200 then
            notify(source, locale("error.api"), locale("error.api_try_later"), 'error')
            return
        end

        if not tonumber(responseBody) then
            notify(source, locale("error.api"), locale('error.api_contact_owner'), 'error')
            return
        end

        if not tonumber(responseBody) then print(locale('error.api_fault')) return end

        cb(tonumber(responseBody))
    end)
end

--- Checks the vote for a given source.
--- @param source number The source of the vote.
local function checkVote(source)
    local identifier, license = getPlayer(source)
    api('status', source, identifier, function(result)
        if result == 0 then
            notify(source, locale('error.vote_not_found'), locale('info.open_browser'), 'error')
            TriggerClientEvent('geo_servervote:client:getUrl', source, buildUrl('vote_url_client'))
        elseif result == 1 then
            TriggerClientEvent('geo_servervote:client:claim', source, calculateReward(license))
            notify(source, locale('success.vote_found'), locale('success.vote_success'), 'success')
        else
            notify(source, locale('success.vote_found'), locale('error.vote_already_claimed'), 'error')
        end
    end)
end

--- Gives a reward to a player.
--- @param source number The player's source ID.
--- @param reward any The amount to give.
local function giveReward(source, reward)
    if config.framework == 'qbox' then
        local player = exports.qbx_core:GetPlayer(source)
        player.Functions.AddMoney(config.moneytype, reward, 'geo_servervote_reward')
    end
end

lib.addCommand('vote', {    help = locale('info.checkvote_help', config.identifier:gsub("^%l", string.upper)),
}, function(source)
	notify(source, locale('info.server_voting'), locale('info.checking_vote'), 'info')
    checkVote(source)
end)

RegisterNetEvent('geo_servervote:server:claim', function()
    local src = source
    local identifier, license = getPlayer(src)
    local reward = calculateReward(license)

    api('claim', src, identifier, function(result)
        if result == 0 then
            notify(src, locale('error.vote_not_found'), locale('error.try_again'), 'error')
            return
        elseif result == 1 then
            giveReward(src, reward)
            insertVote(identifier, license, reward)
            notify(src, locale('success.vote_found'), locale('success.vote_success'), 'success')
        else
            notify(src, locale('success.vote_found'), locale('error.vote_already_claimed'), 'error')
            return
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if config.tracky.serverKey == 'xxxxxxxxxxxxxxxxx' then
        print('$ ^1ERROR: ^7Please configure your server key in the config file.')
        return
    end
    if config.tracky.serverId == '123456' then
        print('$ ^1ERROR: ^7Please configure your server ID in the config file.')
        return
    end

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `geo_servervote` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
            `license` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
            `amount` VARCHAR(11) NOT NULL COLLATE 'utf8mb4_unicode_ci',
            `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
            PRIMARY KEY (`id`) USING BTREE,
            INDEX `license` (`license`) USING BTREE,
            INDEX `identifier` (`identifier`) USING BTREE
        ) COLLATE='utf8mb4_unicode_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
    ]], function(response)
        print([[
                                                                                      ^3 #
^4  ####   ###    ###        ^0   ####   ###   # ##   ## ##   ###   # ## ^3  ## ##   ###   #####   ###
^4 #   #  #   #  #   #       ^0  #      #   #  ##      # #   #   #  ##   ^3   # #   #   #    #    #   #
^4 #   #  #####  #   #       ^0   ###   #####  #       # #   #####  #    ^3   # #   #   #    #    #####
^4  ####  #      #   #       ^0      #  #      #        #    #      #    ^3    #    #   #    #    #
     ^4#   ###    ###  ######^0  ####    ###   #        #     ###   #    ^3    #     ###      ##   ###
  ^4###
    ]])
        if response['warningStatus'] == 0 then
            print('$ Created database table `geo_servervote`... Have fun!')
        end
        print('$ Made with <3 by Castar & Geo City Roleplay - https://discord.gg/geocityrp')
    end)
end)

