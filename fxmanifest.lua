fx_version 'cerulean'
game 'gta5'

description 'geo_servervote'
author 'Castar (Discord cstr1)'
version '1.0.0'

ox_lib 'locale'

shared_scripts {
	'@ox_lib/init.lua',
}

client_scripts {
	'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

files {
	'locales/*.json',
	'config/server.lua',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'