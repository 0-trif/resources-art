fx_version 'adamant'
games { 'gta5' }

client_scripts {
    "client/*.lua",
    "crafting/cr_client.lua",
    "crafting/cr_ui.lua",
}
server_scripts {
    "server/*.lua",
    "crafting/cr_server.lua",
}
shared_scripts {
    "data/*.lua",
    "crafting/cr_config.lua",
}

ui_page 'html/index.html'
files {
    "html/fonts/*",
    "html/js/*.js",
    "html/index.html",
    "html/style/*.css",
    "html/hand.png",
    "html/images/*.png",
    "html/images/displays/*.png",
}