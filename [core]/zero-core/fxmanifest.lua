fx_version 'adamant'
game 'gta5'
description 'ORIGINAL Zero FRAMEWORK'

author 'Trif#0270'

version '0.1'

shared_scripts {
    "shared/coreConfig.lua",
    "shared/sharedConfig.lua",
}

client_scripts {
    "client/object.lua",
    "client/events.lua",
    "client/functions.lua",
    "client/playerClass.lua",
    "client/commands.lua",
    "client/loops.lua",
}
server_scripts {
    "server/object.lua",
    "server/events.lua",
    "server/functions.lua",
    "server/sync.lua",
    "server/player.lua",
    "server/commands.lua",
}
