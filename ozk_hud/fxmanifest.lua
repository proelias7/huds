dependency "anticheat" client_script "@anticheat/client.lua" fx_version 'bodacious'
game 'gta5'

author 'proelias7'
description 'HUD OZARK CITY'
version '1.0.0'

client_scripts {
    '@vrp/lib/utils.lua',
    'client/main.lua',
	'locales/languages.lua',
    'client/vehicle.lua'
}
server_scripts {
    '@vrp/lib/utils.lua',
    'serve/main.lua'
}

ui_page 'nui/index.html'
ui_page_preload 'yes'

file {
	'nui/*',
    'nui/assets/css/*.css',
    'nui/assets/js/*.js',
    'nui/assets/img/*',
	'nui/assets/fonts/*',
}




