--- Formats a reward object into a human-readable description.
--- @param reward table The reward object containing money and/or items.
--- @return string The formatted reward description.
local function formatReward(reward)
    local parts = {}
    
    -- Add money part if present
    if reward.money and reward.money > 0 then
        table.insert(parts, "$" .. reward.money)
    end
    
    -- Add items part if present
    if reward.items and #reward.items > 0 then
        local itemParts = {}
        for _, item in pairs(reward.items) do
            if item.name and item.amount then
                table.insert(itemParts, item.amount .. "x " .. item.name)
            end
        end
        if #itemParts > 0 then
            table.insert(parts, table.concat(itemParts, ", "))
        end
    end
    
    -- If no rewards, return default message
    if #parts == 0 then
        return "No rewards"
    end
    
    return table.concat(parts, " + ")
end

RegisterNetEvent('geo_servervote:client:claim', function(reward)
    local rewardText = formatReward(reward)
    local claim = lib.alertDialog({
        header = locale('info.server_rewards'),
        content = locale('info.confirm_reward', rewardText),
        centered = true,
        cancel = true
    })

    if claim == 'confirm' then
        TriggerServerEvent('geo_servervote:server:claim')
    end
end)

RegisterNetEvent('geo_servervote:client:getUrl', function(url)
    lib.setClipboard(url)
end)