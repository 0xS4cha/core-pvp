_SAFEZONE = _SAFEZONE or {}

_SAFEZONE.ExitingTime = 4
_SAFEZONE.SafeZones = {
    {
        Description = 'Lobby of Los Santos',
        Name = 'Los Santos',
        Image = 'lspd.png',
        vehicle = {
            coords = vector3(397.50283813477, -373.13510131836, 46.807842254639),
            heading = 204.55288696289
        },
        clothingStore = {
            Pos = vector3(381.67391967773, -367.69674682617, 46.830966949463 - 1.02),
            Heading = 337.4089050293,
            Blip = { display = 73, colour = 32, size = 0.6, name = 'STORE_Clothing' },

        },
        safezone = {
            coords = vector3(389.69708251953, -355.88461303711, 48.024364471436),
            radius = 100.0,
            radiusblip = 100.0
        },
        lobbySelector = {
            Pos = vector3(407.61431884766, -357.76815795898, 46.852043151855 - 1.02),
            Heading = 92.950416564941,
            Blip = { display = 459, colour = 32, size = 0.6, name = 'STORE_LobbySelector' },
        },
        squadMenu = {
            Pos = vector3(407.09765625, -349.62802124023, 46.866138458252 - 1.02),
            Heading = 138.7335357666,
            Blip = { display = 378, colour = 32, size = 0.6, name = 'SquandAndCrew' },
        },
        vehicleMenu = {
            Pos = vector3(397.20834350586, -344.94378662109, 46.861000061035 - 1.02),
            Heading = 144.76686096191,
            Blip = { display = 225, colour = 32, size = 0.6, name = 'GaragePNJ' },
        },
        chestMenu = {
            Pos = vector3(389.15240478516, -369.53848266602, 46.843032836914 - 1.02),
            Heading = 6.7340703010559,
            Blip = { display = 850, colour = 32, size = 0.6, name = 'chestMenu' },
        },
        shopMenu = {
            Pos = vector3(375.40411376953, -363.00637817383, 46.815231323242 - 1.02),
            Heading = 271.91918945312,
            Blip = { display = 52, colour = 32, size = 0.6, name = 'shopMenu' },
        },
    },
}


_REDZONE = _REDZONE or {}
_REDZONE.ZoneLocations = {
    { coords = vector3(-239.1249, -327.5558, 30.0188), radius = 100.0 },

}
_REDZONE.ChangeZonesInterval = 20
_REDZONE.Reward = {
    [1] = {{item = 'weapon_pistol50', count = 1}}
}
