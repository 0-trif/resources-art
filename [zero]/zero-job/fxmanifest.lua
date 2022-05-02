fx_version 'adamant'
games { 'gta5' }

shared_scripts {
    "shared.lua"
}
client_scripts {
    "main.lua",
    "modules/police/client/*.lua",
    "modules/ambulance/client/*.lua",
  --  "modules/mechanic/client/*.lua",
    "modules/taxi/client/*.lua",
    "modules/kmar/client/*.lua",
}

server_scripts {
    "server.lua",
    "modules/police/server/*.lua",
    "modules/ambulance/server/*.lua",
  --  "modules/mechanic/server/*.lua",
    "modules/taxi/server/*.lua",
}