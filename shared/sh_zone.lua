_SAFEZONE = _SAFEZONE or {}

_SAFEZONE.ExitingTime = 4
_SAFEZONE.SafeZones = {
    {
        Description = 'Lobby of Los Santos',
        Name = 'Los Santos',
        Image = 'lspd.png',
        vehicle = {
            coords = vector3(-114.8243560791, -1605.9400634766, 31.772033691406),
            heading = 320.3176574707
        },
        clothingStore = {
            Pos = vector3(-137.83258056641, -1595.5024414062, 34.243640899658 - 1.02),
            Heading = 310.88244628906,
            Blip = { display = 73, colour = 32, size = 0.6, name = 'STORE_Clothing' },

        },
        safezone = {
            coords = vector3(-120.50500488281, -1587.791015625, 34.218776702881),
            radius = 100.0,
            radiusblip = 100.0
        },
        lobbySelector = {
            Pos = vector3(-120.33229064941, -1574.6842041016, 34.176578521729 - 1.02),
            Heading = 117.94702148438,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
        squadMenu = {
            Pos = vector3(-134.40435791016, -1580.4940185547, 34.207954406738 - 1.02),
            Heading = 232.22766113281,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
        vehicleMenu = {
            Pos = vector3(-123.18510437012, -1591.1706542969, 34.20779800415 - 1.02),
            Heading = 68.537330627441,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
    },
    {
        Description = 'Lobby of Sandy Shore',
        Name = 'Sandy Shore',
        Image = 'sandy_shore.png',
        clothingStore = {
            Pos = vector3(1536.7463378906, 3581.2878417969, 35.491580963135 - 1.02),
            Heading = 209.46199035645,
            Blip = { display = 73, colour = 32, size = 0.6, name = 'STORE_Clothing' },

        },
        safezone = {
            coords = vector3(1549.1363525391, 3566.251953125, 35.36291885376),
            radius = 100.0,
            radiusblip = 100.0
        },
        lobbySelector = {
            Pos = vector3(1549.0236816406, 3516.1254882812, 35.993576049805 - 1.02),
            Heading = 7.2120108604431,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
        squadMenu = {
            Pos = vector3(0.0, 0.0, 0.0),
            Heading = 232.22766113281,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
        vehicleMenu = {
            Pos = vector3(0.0, 0.0, 0.0),
            Heading = 68.537330627441,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },

    },
}


_REDZONE = _REDZONE or {}
_REDZONE.ZoneLocations = {
    { coords = vector3(-239.1249, -327.5558, 30.0188), radius = 100.0 },

}
_REDZONE.ChangeZonesInterval = 20
_REDZONE.Reward = {
    Quantity = 5,
    Items = 'pistol50'
}
