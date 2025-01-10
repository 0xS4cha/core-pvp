_MANAGER = _MANAGER or {}

_MANAGER.ZONE = {}
_MANAGER.ZONE.LIST = {
    ['ALL'] = {
        'TERMINA', 'ELYSIAN', 'AIRP', 'BANNING', 'DELSOL', 'RANCHO', 'STRAW', 'CYPRE', 'SANAND',                                                               -- South LS
        'MURRI', 'LMESA', 'SKID', 'LEGSQU', 'TEXTI', 'PBOX', 'KOREAT', 'DOWNT',                                                                                -- Central LS
        'MIRR', 'EAST_V', 'DTVINE', 'ALTA', 'HAWICK', 'BURTON', 'ROCKF', 'MOVIE', 'DELPE', 'MORN', 'RICHM', 'GOLF',
        'WVINE', 'DTVINE', 'HORS', 'LACT', 'LDAM',                                                                                                             -- North LS
        'BEACH', 'VESP', 'VCANA', 'DELBE', 'PBLUFF',                                                                                                           -- LS Beach
        'EBURO', 'PALHIGH', 'NOOSE', 'TATAMO',                                                                                                                 -- Eastern Valley
        'BANHAMC', 'BANHAMCA', 'CHU', 'TONGVAH',                                                                                                               -- Coastal Beaches
        'CHIL', 'GREATC', 'RGLEN', 'TONGVAV',                                                                                                                  -- North LS Hills
        'PALMPOW', 'WINDF', 'RTRACK', 'JAIL', 'HARMO', 'DESRT', 'SANDY', 'ZQ_UAR', 'HUMLAB', 'SANCHIA', 'GRAPES', 'ALAMO',
        'SLAB', 'CALAFAB',                                                                                                                                     -- Grand Senora Desert
        'MTGORDO', 'ELGORL', 'BRADP', 'BRADT', 'MTCHIL', 'GALFISH',                                                                                            -- Northern Mountains
        'LAGO', 'ARMYB', 'NCHU', 'CANNY', 'MTJOSE', 'CCREAK',                                                                                                  -- Zancudo
        'CMSW', 'PALCOV', 'OCEANA', 'PALFOR', 'PALETO', 'PROCOB'                                                                                               -- Paleto
    },
    ['LosSantos'] = {                                                                                                                                          -- Zones spécifiques à Los Santos
        'TERMINA', 'ELYSIAN', 'AIRP', 'BANNING', 'DELSOL', 'RANCHO', 'STRAW', 'CYPRE', 'SANAND',                                                               -- South LS
        'MURRI', 'LMESA', 'SKID', 'LEGSQU', 'TEXTI', 'PBOX', 'KOREAT', 'DOWNT',                                                                                -- Central LS
        'MIRR', 'EAST_V', 'DTVINE', 'ALTA', 'HAWICK', 'BURTON', 'ROCKF', 'MOVIE', 'DELPE', 'MORN', 'RICHM', 'GOLF',
        'WVINE', 'DTVINE', 'HORS', 'LACT', 'LDAM',                                                                                                             -- North LS
        'BEACH', 'VESP', 'VCANA', 'DELBE', 'PBLUFF',                                                                                                           -- LS Beach
        'EBURO', 'PALHIGH', 'NOOSE', 'TATAMO',                                                                                                                 -- Eastern Valley
        'BANHAMC', 'BANHAMCA', 'CHU', 'TONGVAH',                                                                                                               -- Coastal Beaches
        'CHIL', 'GREATC', 'RGLEN', 'TONGVAV'                                                                                                                   -- North LS Hills
    },
    ['SandyShores'] = {                                                                                                                                        -- Zones autour de Sandy Shores
        'PALMPOW', 'WINDF', 'RTRACK', 'JAIL', 'HARMO', 'DESRT', 'SANDY', 'ZQ_UAR', 'HUMLAB', 'SANCHIA', 'GRAPES', 'ALAMO',
        'SLAB', 'CALAFAB'
    },
    ['Paleto'] = {                                                  -- Zones autour de Paleto Bay
        'MTGORDO', 'ELGORL', 'BRADP', 'BRADT', 'MTCHIL', 'GALFISH', -- Northern Mountains
        'LAGO', 'ARMYB', 'NCHU', 'CANNY', 'MTJOSE', 'CCREAK',       -- Zancudo
        'CMSW', 'PALCOV', 'OCEANA', 'PALFOR', 'PALETO', 'PROCOB'
    }
}

_MANAGER.WEATHER = {}

_MANAGER.WEATHER.ZONE = _MANAGER.ZONE.LIST
_MANAGER.WEATHER.CURRENT = {}
_MANAGER.WEATHER.REFRESH = 1000 * 60 * 3
_MANAGER.WEATHER.RERESH_ZONE = 5000
_MANAGER.WEATHER.DEFAULT = 'CLEAR'
_MANAGER.WEATHER.Types = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'BLIZZARD' }

_MANAGER.WEATHER.ZONEWEATHER = {
    ['LosSantos'] = {
        Label = 'Los Santos',
        ZoneList = _MANAGER.ZONE.LIST['LosSantos'],
        WhitelistWeather = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'BLIZZARD' }
    },
    ['SandyShores'] = {
        Label = 'Sandy Shores',
        ZoneList = _MANAGER.ZONE.LIST['SandyShores'],
        WhitelistWeather = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'BLIZZARD' }
    },
    ['Paleto'] = {
        Label = 'Paleto Bay',
        ZoneList = _MANAGER.ZONE.LIST['Paleto'],
        WhitelistWeather = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'BLIZZARD' }
    }
}


_MANAGER.DOORS = {}
_MANAGER.DOORS.LIST = {}
_MANAGER.DOORS.SAVE_STATE = false
_MANAGER.DOORS.SYNC_DOORS = 1000 * 60 * 5
_MANAGER.DOORS.ADMIN = { -- DONT TUCH
    UsePin = false,
    UseJob = false,
    Locked = true,
    String_Job = '',
    creator_data = {jobs = {}, pin = nil, label = nil, doors = {}, DefaultLockStatus = true, distance = 2.0}
}


