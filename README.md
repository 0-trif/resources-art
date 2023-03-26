# resources-artemis

server cfg:

set sv_enforceGameBuild 2189

ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure basic-gamemode
ensure hardcap
ensure rconlog

ensure zero-loading

start [core]
start [zero]
start [standalone]
start [voice]
