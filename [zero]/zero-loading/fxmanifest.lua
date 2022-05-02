fx_version "cerulean"
games { 'rdr3', 'gta5' }


loadscreen 'html/index.html'

client_scripts {
    "init.lua",
}

ui_page 'html/index.html'

files {
    "html/index.html",
    "html/style.css",
    "html/script.js",
    "html/fonts/*",
}

loadscreen_manual_shutdown "yes"

