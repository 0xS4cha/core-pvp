_CONFIG = _CONFIG or {}
_CONFIG.Debug  = true
_CONFIG.DefaultPos = vector3(389.69708251953, -355.88461303711, 48.024364471436)
_CONFIG.ServerName = 'LDO PVP'
_CONFIG.Lobby = vector3(389.69708251953, -355.88461303711, 48.024364471436)
_CONFIG.LobbyRadius = 100.0
_CONFIG.RGBA = {
    LINE = {RED = 30, GREEN = 77, BLUE = 138, ALPHA = 255},  -- Line color above each option (default nopixel-green)
    STYLE = {RED = 0, GREEN = 0, BLUE = 0, ALPHA = 180},  -- Background color of each option (default black semi-transparent)
    WAYPOINT = {RED = 30, GREEN = 77, BLUE = 138, ALPHA = 255}  -- Waypoint color on the map (default nopixel-green)
}

_CONFIG.RefreshBanList = 30
_CONFIG.SLOTMAX = 255
_CONFIG.DISCORD = {
    WHITELIST = {
        ['1276612208746430554'] = true
    },
    LINK = 'https://discord.gg/LDO-PVP'
}
_CONFIG.MAXMONEYLOOT = 8000
_CONFIG.ISINWAITING = true
_CONFIG.RESPAWNTIME = 45 -- SECONDS
_CONFIG.STEALTIME = 1 -- SECONDS  (15 NORMALEMENT)
_CONFIG.REVIVETIME = 1 -- SECONDS
_CONFIG.LOGO_LINK = 'https://sacha-dev.fr/ldo_logo.PNG'
_CONFIG.TIME = 12 --DEFAULT TIME
_CONFIG.WEATHER = 'EXTRASUNNY' -- DEFAULT WEATHER
_CONFIG.CrewPermission = { -- default
    ['recruit'] = false,
    ['kick'] = false,
    ['chest'] = false
}