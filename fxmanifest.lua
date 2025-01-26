fx_version 'adamant'
game 'gta5'

name 'sx-core'
version '0.2.1'
description 'Sacha | Development - Full core'
author 'sacha-development'
lua54 'yes'
resource_type2 'gametype' { name = 'sxGroup' }
resource_type 'map' { gameTypes = { ['LDO:PVP'] = true } }

map 'cfx/map.lua'
escrow_ignore { 
    'shared/*.lua',

 }
shared_scripts {
    '@ox_lib/init.lua',
    "cfx/sh_mapmanager.lua",
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
    'web/assets/**/*.webp',
    'web/assets/**/**/*.webp',
    'web/assets/images/clothing/*.png',
    'web/assets/**/*.svg',
    'web/assets/**/**/*.svg',
    'web/assets/**/*.webp',
    'web/assets/**/**/*.webp',
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
    "cfx/s_gamemode.lua",
    "cfx/s_mapmanager.lua",
    "cfx/s_sessionmanager.lua",
    'shared/sv_*.lua',
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
    'client/sprites/init.lua',
    "client/modules/handler/module_handler.lua",
    "client/modules/handler/position_handler.lua",
    "client/modules/module/native_ui.lua",
    "client/modules/module/*.lua",
    'client/security/*.lua',
    'client/class/*.lua',
    'client/utils/*.lua',
    'client/data/*.lua',
    'client/handler/*.lua',

    "client/addons/**/*.lua",

}

files {
    'files/meta/weaponsnowball.meta',
	'files/meta/weapons.meta',
	'files/meta/weaponrailgun.meta',
	'files/meta/weapons_spacerangers.meta',
	'files/meta/weapons_doubleaction.meta',
	'files/meta/weaponflaregun.meta',
	'files/meta/loadouts.meta',
	'files/meta/weaponarchetypes.meta',
	'files/meta/weaponanimations.meta',
	'files/meta/weaponanimations2.meta',
	'files/meta/pedpersonality.meta',
	'files/meta/pedpersonality2.meta',
	'files/meta/weapons2.meta',
	'files/meta/explosion.ymt',
	'files/meta/recul/weaponautoshotgun.meta',
	'files/meta/recul/weaponbullpuprifle.meta',
	'files/meta/recul/weaponcombatpdw.meta',
	'files/meta/recul/weaponcompactrifle.meta',
	'files/meta/recul/weapondbshotgun.meta',
	'files/meta/recul/weaponfirework.meta',
	'files/meta/recul/weapongusenberg.meta',
	'files/meta/recul/weaponheavypistol.meta',
	'files/meta/recul/weaponheavyshotgun.meta',
	'files/meta/recul/weaponmachinepistol.meta',
	'files/meta/recul/weaponmarksmanpistol.meta',
	'files/meta/recul/weaponmarksmanrifle.meta',
	'files/meta/recul/weaponminismg.meta',
	'files/meta/recul/weaponmusket.meta',
	'files/meta/recul/weaponrevolver.meta',
	'files/meta/recul/weapons_assaultrifle_mk2.meta',
	'files/meta/recul/weapons_bullpuprifle_mk2.meta',
	'files/meta/recul/weapons_carbinerifle_mk2.meta',
	'files/meta/recul/weapons_combatmg_mk2.meta',
	'files/meta/recul/weapons_heavysniper_mk2.meta',
	'files/meta/recul/weapons_marksmanrifle_mk2.meta',
	'files/meta/recul/weapons_pumpshotgun_mk2.meta',
	'files/meta/recul/weapons_revolver_mk2.meta',
	'files/meta/recul/weapons_smg_mk2.meta',
	'files/meta/recul/weapons_snspistol_mk2.meta',
	'files/meta/recul/weapons_specialcarbine_mk2.meta',
	'files/meta/recul/weaponsnspistol.meta',
	'files/meta/recul/weaponspecialcarbine.meta',
	'files/meta/recul/weaponvintagepistol.meta',
	'files/meta/recul/weapon_combatshotgun.meta',
	'files/meta/recul/weapon_militaryrifle.meta',
	'files/meta/melee/weaponknuckle.meta',
	'files/meta/melee/weaponswitchblade.meta',
	'files/meta/melee/weaponbottle.meta',
	'files/meta/melee/weaponpoolcue.meta',
}
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weaponsnowball.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weapons_doubleaction.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weaponflaregun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weaponrailgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weapons_spacerangers.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/weapons_pistol_mk2.meta'
data_file 'WEAPON_METADATA_FILE' 'files/meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'files/meta/weaponanimations.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'files/meta/weaponanimations2.meta'
data_file 'LOADOUTS_FILE' 'files/meta/loadouts.meta'
data_file 'PED_PERSONALITY_FILE' 'files/meta/pedpersonality.meta'
data_file 'PED_PERSONALITY_FILE' 'files/meta/pedpersonality2.meta'
data_file 'EXPLOSION_INFO_FILE' 'files/meta/explosion.ymt'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponautoshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponbullpuprifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponcombatpdw.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponcompactrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapondbshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponfirework.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapongusenberg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponheavyshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponmarksmanpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponmarksmanrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponminismg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponmusket.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_assaultrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_bullpuprifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_carbinerifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_combatmg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_heavysniper_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_marksmanrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_pumpshotgun_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_smg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapons_specialcarbine_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponspecialcarbine.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapon_combatshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/recul/weapon_militaryrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/melee/weaponknuckle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/melee/weaponswitchblade.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/melee/weaponbottle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'files/meta/melee/weaponpoolcue.meta'