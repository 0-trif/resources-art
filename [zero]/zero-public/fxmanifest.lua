fx_version 'adamant'
games { 'gta5' }

shared_scripts {
    "config.lua"
}

client_scripts {
    "job.lua",
    "driver/client.lua",
    "postal/client.lua",
    "baker/client.lua",
    "scrapyard/client.lua",
}
server_scripts {
    "driver/server.lua",
    "postal/server.lua",
    "baker/server.lua",
    "scrapyard/server.lua",
}
