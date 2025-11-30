fx_version 'cerulean'
game 'gta5'
--https://byp4ssnet.tebex.io/
name 'byp4ss.net'
author 'bp'
description 'Admin tag system (Owner/Developer/Admin) for QBCore & Qbox'
version '1.0.0'

lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}
