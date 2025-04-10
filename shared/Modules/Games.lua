_GAMES = {
    [1] = {
        name = 'Freeroam',
        matchmaking = false,
        instance = {
            [1] = {
                name = 'Friendly',
                instanceId = 10,
                coords = vector3(131.17597961426, -987.96600341797, 29.347478866577),
                settings = {
                    pvp = false,
                    option = true,
                    props = true,
                    canRespawn = true,
                },
                image = 'Image-Friendly',
            },
            [2] = {
                name = 'No rules',
                instanceId = 12,
                coords = vector3(131.17597961426, -987.96600341797, 29.347478866577),
                settings = {
                    pvp = true,
                    option = true,
                    props = true,
                    canRespawn = true,
                },
                image = 'Image-Armes'
            }
        },
        image = 'Image-Freeroam'
    },
    [2] = {
        name = 'Gunfight',
        matchmaking = true,
        image = 'Image-Gunfight',
        instanceLimit = {100, 200}
    },
    [3] = {
        name = 'Drop',
        matchmaking = true,
        image = 'Image-Drop',
        instanceLimit = {100, 200},
        blips = true,
        vehicle = {
            'sultan',
            'sultanrs',
        },
    },
    [4] = {
        name = 'Course poursuite',
        matchmaking = true,
        image = 'Image-Course-Poursuite',
        instanceLimit = {100, 200},
        blips = false,
        distanceLimit = 1500,
        time = {
            limit = 5 * 60 * 10000
        },
        vehicle = {
            'sultan',
            'sultanrs',
        },
    },
}
