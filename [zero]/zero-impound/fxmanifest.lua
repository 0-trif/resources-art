fx_version 'cerulean'
game 'gta5'

client_scripts {
    "config.lua",
    "main.lua",
    "output/config.js",
    "output/client.js", 
}

server_scripts {
    "output/server.js",
}

ui_page('ui/index.html')

files {
    'ui/fonts/*',
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
}
