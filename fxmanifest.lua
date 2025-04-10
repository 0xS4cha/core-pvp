fx_version 'adamant'
game 'gta5'

name 'sx-core'
version '0.2.1'
description 'Sacha | Development - Full core'
author 'sacha-development'
lua54 'yes'
resource_type2 'gametype' { name = 'sxGroup' }
resource_type 'map' { gameTypes = { ['sxDevelopment'] = true } }

map 'cfx/map.lua'
escrow_ignore {
    'shared/*.lua',

}
shared_scripts {
    '@ox_lib/init.lua',
    "cfx/sh_mapmanager.lua",
    'lib/*.lua',
    'shared/Modules/Translation.lua',
    'translation/*.lua',
    'shared/Enums/*.lua',
    'shared/Classes/*.lua',
    'shared/Modules/Rpc.lua',
    'shared/Modules/Config.lua',
    'shared/Modules/Effects.lua',
    'shared/Modules/Events.lua',
    'shared/Modules/Interacts.lua',
    'shared/Modules/Json.lua',
    'shared/Modules/Permissions.lua',
    'shared/Modules/Pmenu.lua',
    'shared/Modules/Security.lua',
    'shared/Modules/Games.lua',
}

files {
    'web/assets/**/*.webp',
    'web/assets/**/**/*.webp',
    'web/assets/**/*.svg',
    'web/assets/**/**/*.svg',
    'web/assets/**/*.png',
    'web/assets/**/**/*.png',
    'web/build/index.html',
    'web/build/**/*',
    'client/loadscreen/*',
    'client/loadscreen/*.mp4',
    'client/loadscreen/*.mp3',

}

ui_page 'web/build/index.html'
loadscreen 'client/loadscreen/index.html'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "cfx/s_gamemode.lua",
    "cfx/s_mapmanager.lua",
    "cfx/s_sessionmanager.lua",
    'shared/Secret/*.lua',
    'server/utils/utils.lua',
    'server/utils/**/*.lua',
    'server/class/**/*.lua',
    'server/handler/**/*.lua',
    'server/data/*.lua',
    "server/addons/**/*.lua",
}

client_scripts {
    "cfx/c_gamemode.lua",
    "cfx/c_mapmanager.lua",
    "cfx/c_sessionmanager.lua",
    "cfx/c_spawnmanager.lua",
    "cfx/c_mapmanager.lua",
    'client/pmenu.lua',
    'client/commands.lua',
    "client/modules/handler/module_handler.lua",
    "client/modules/handler/position_handler.lua",
    "client/modules/module/native_ui.lua",
    "client/modules/module/*.lua",
    'client/security/*.lua',
    'client/class/*.lua',
    'client/utils/*.lua',
    'client/data/*.lua',
    "client/addons/**/*.lua",
}

files {
    'files/lua/*.lua'
}
