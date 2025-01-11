fx_version 'adamant'
game 'gta5'

name 'sx-core'
version '0.2.1'
description 'Sacha | Development - Full core'
author 'sacha-development'
lua54 'yes'

escrow_ignore { 
    'shared/*.lua',

 }
shared_scripts {
    '@ox_lib/init.lua',
    'lib/*.lua',
    'static/messages/orcus.lua',
    'static/messages/main.lua',
    'static/messages/translation/*.lua',

    'shared/sh_*.lua',
    'module.lua'
}


files {
    'files/MINIMAP_LOADER.gfx',
    'web/assets/**/*.png',
    'web/assets/images/clothing/*.png',
    'web/assets/**/*.svg',
    'web/assets/**/**/*.svg',
    'web/build/index.html',
	'web/build/**/*',
    'client/loadscreen/*',
    'client/loadscreen/*.mp3',
    'assets/*.png'
}
ui_page 'web/build/index.html'
loadscreen 'client/loadscreen/index.html'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/sv_*.lua',
    'server/utils/utils.lua',
    'server/utils/**/*.lua',
    'server/class/**/*.lua',
    'server/handler/**/*.lua',
    'server/data/*.lua',
    "server/addons/**/*.lua",
}

client_scripts {
    'client/pmenu.lua',
    'client/commands.lua',
    'client/sprites/init.lua',
    "client/modules/handler/module_handler.lua",
    "client/modules/handler/position_handler.lua",
    "client/modules/module/native_ui.lua",
    "client/modules/module/*.lua",
    'client/class/*.lua',
    'client/utils/*.lua',
    'client/data/*.lua',
    'client/handler/*.lua',
    'client/security/*.lua',
    "client/addons/**/*.lua",

}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_props_gardenpack.ytyp'


