fx_version 'cerulean'
game 'gta5'

shared_scripts {
    "output/tsconfig.js",
}

client_scripts {
    "output/client.js",
    "main.lua",
}

server_scripts {
    "output/server.js",
}


ui_page('ui/index.html')

files {
    'ui/fonts/*',
    'ui/index.html',
    'ui/script.js',
    'ui/all.js',
    'ui/style.css',
}
