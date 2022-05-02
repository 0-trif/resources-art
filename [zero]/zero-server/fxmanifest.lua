fx_version 'adamant'
games { 'gta5' }

shared_scripts {
    "config.lua"
}

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

ui_page 'html/index.html'
files {
    "html/*.js",
    "html/index.html",
    "html/*.css",
    "html/*.png",
    "html/fonts/*.otf",
}