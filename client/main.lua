RegisterNetEvent('geo_servervote:client:claim', function(reward)
    local claim = lib.alertDialog({
        header = locale('info.server_rewards'),
        content = locale('info.confirm_reward', reward),
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