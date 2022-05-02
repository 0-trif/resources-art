fx_version 'adamant'
games { 'gta5' }

ui_page 'ui/index.html'

shared_scripts {
    "source/config.lua"
}

client_scripts {
    "source/client/*.lua",
}
server_scripts {
    "source/server/*.lua",
}
files {
    "ui/script.js",
    "ui/index.html",
    "ui/style.css",
    "ui/images/*.png",
    "ui/images/logos/*.png",
    "ui/apps/*.css",
    "ui/apps_js/*.js",
}