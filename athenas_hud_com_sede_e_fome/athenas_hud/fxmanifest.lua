dependency "vrp" fx_version 'bodacious'
game 'gta5'

author 'proelias7'
description 'HUD ATHENAS'
version '1.0.2'

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

ui_page 'client/html/index.html'
ui_page_preload 'yes'

file {
	'client/html/index.html',
    'client/html/assets/css/*.css',
    'client/html/assets/js/*.js',
    'client/html/assets/img/*',
	'client/html/assets/fonts/*',
	
}




