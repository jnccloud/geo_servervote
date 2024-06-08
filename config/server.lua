return {
    framework = 'qbox',
    identifier = 'discord',
    moneytype = 'cash',
    tracky = {
        serverId = '123456',
        serverKey = 'xxxxxxxxxxxxxxxxx',
        endpoints = {
            vote = 'https://trackyserver.com/server/%s',
            status = 'https://api.trackyserver.com/vote/?action=status&key=%s&%sid=%s',
            claim = 'https://api.trackyserver.com/vote/?action=claim&key=%s&%sid=%s'
        }
    },

    rewards = {
        daily = 2500,
        bonus = {
            -- [days] = bonus_money_amount_to_give
            [5] = 5000,
            [10] = 10000,
            [20] = 20000,
            [30] = 30000,
            [40] = 40000,
            [50] = 50000,
            [60] = 60000,
            [70] = 70000,
            [80] = 80000,
            [90] = 90000,
            [100] = 100000,
        }
    }
}
