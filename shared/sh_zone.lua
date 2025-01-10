_SAFEZONE = _SAFEZONE or {}

_SAFEZONE.ExitingTime = 4
_SAFEZONE.SafeZones = {
    {
        Description = 'Lobby of Los Santos',
        Name = 'Los Santos',
        Image = 'lspd.png',
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
        }
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
        }
    },
}


_REDZONE = _REDZONE or {}
_REDZONE.ZoneLocations = {
    { coords = vector3(-239.1249, -327.5558, 30.0188), radius = 100.0 },
    { coords = vector3(-271.2544, -615.5464, 33.4774), radius = 100.0 },
    { coords = vector3(4472.5586, -4477.0278, 4.2151), radius = 100.0 },
    { coords = vector3(747.4862, -1723.4449, 28.9309), radius = 100.0 },
    { coords = vector3(393.3860, -1524.5248, 29.1247), radius = 100.0 },
}
_REDZONE.ChangeZonesInterval = 20
_REDZONE.Reward = {
    Quantity = 5,
    Items = 'pistol50'
}
