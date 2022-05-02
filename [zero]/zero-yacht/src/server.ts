var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

let mission:any = {
    ongoing : false,
    players : {},
}

function count (x:any) {
    let y = 0

    for (var index in x) {
        if (x[index]) {
            y = y + 1;
        } else {
            x[index] = undefined;
        }
    }

    return y;
}

onNet("Zero:Server-Yacht:EnterMission", () => {
    let src = source;
    let Player = Zero.Functions.Player(src);

    if (!mission.ongoing) {
        if (count(mission.players) <= config.max) {
            if (mission.players[src]) {return}

            mission.players[src] = {
                PlayerName : Player.PlayerData.firstname + ' ' + Player.PlayerData.lastname,
                SrvId : Player.User.Source,
                GroupLeader : (count(mission.players) == 0 && true || false),
            };

            for (let index in mission.players) {
                emitNet("Zero:Server-Yacht:ResyncMembers", index, mission.players);
            };
        } else {
            Player.Functions.Notification('HEIST', 'Deze heist zit momenteel al vol', 'error');
        }
    } else {
        Player.Functions.Notification('HEIST', 'Deze heist is momenteel al bezig', 'error');
    }
})

onNet("Zero:Server-Yacht:LeaveMission", () => {
    let src = source;
    let Player = Zero.Functions.Player(src);

    if (!mission.ongoing) {
        if (mission.players[src]) {
            mission.players[src] = undefined;

            for (let index in mission.players) {
                emitNet("Zero:Server-Yacht:ResyncMembers", index, mission.players);
            };
            emitNet("Zero:Server-Yacht:ResyncMembers", src, {});
        };
    } else {
        if (mission.players[src]) {
    
            mission.players[src] = undefined;
   
            if (count(mission.players) <= 0) {
                mission.ongoing = false;

                for (var index in config.stashes) {
                    config.stashes[index].searched = false;
                    config.stashes[index].code = undefined;
                };


                Zero.Functions.Notification(-1, "Yacht heist", "Yacht heist is afgelopen", "warning")
            }
        };
    }
})

function setupPattern () {
    let point = 0

    for (var index in mission.players) {
        if (mission.players[index]) {
            point = point + 1

            mission.players[index].point = point;
        }
    }
}

function setupStashes() {
    var random = Math.floor(Math.random() * config.stashes.length);

    config.code = (Math.floor(Math.random() * 10000) + 10000).toString().substring(1);

    for (var index in config.stashes) {
        config.stashes[index].searched = false;
        config.stashes[index].code = undefined;
    }

    if (config.stashes[random]) {
        config.stashes[random].code = true;
    } else {
        config.stashes[1].code = true;
    }
}

onNet("Zero:Server-Yacht:StartMission", () => {
    let src = source;
    let Player = Zero.Functions.Player(src);

    if (!mission.ongoing) {
        if (mission.players[src]) {
            if (mission.players[src].GroupLeader) {
                
                setupPattern();
                setupStashes();

                for (var index in mission.players) {
                    TriggerClientEvent("Zero:Client-Yacht:Stashes", index, config.stashes);
                    emitNet("Zero:Server-Yacht:StartMission", index, mission.players);
                    emitNet("Zero:Server-Yacht:Code", index, config.code);
                };

                mission.ongoing = true;
            } else {
                Player.Functions.Notification("HEIST", "Alleen de groep leider kan de missie starten", "error")
            }
        } else {
            Player.Functions.Notification('HEIST', 'Je moet eerst meedoen met de missie', 'error');
        };
    } else {
        Player.Functions.Notification('HEIST', 'Deze heist is momenteel al bezig', 'error');
    }
})

onNet("Zero:Server-Yacht:Search", (index:number) => {
    let src = source;
    let Player = Zero.Functions.Player(src);
    let Inv = Player.Functions.Inventory();

    index = index - 1;

    if (config.stashes[index]) {
        if (!config.stashes[index].searched) {
            if (config.stashes[index].code) {
                Inv.functions.add({
                    item : "stickynote",
                    amount : 1,
                    datastash : {
                        message : "Kluis code: <br> "+config.code+"",
                    },
                });
            } else {
                Player.Functions.GiveMoney("black", 25000, "Gestolen van de yacht (ov stash)")
            };
            config.stashes[index].searched = true;

            for (var x in mission.players) {
                TriggerClientEvent("Zero:Client-Yacht:Stashes", x, config.stashes);
            };
        } else {
            Zero.Functions.Notification("Stash", "Deze stash is al leeg..", "error")
        }
    }
})

onNet("Zero:Server-Yacht:SearchedSafe", (code:number) => {
    let src = source;
    let Player = Zero.Functions.Player(src);
    let Inv = Player.Functions.Inventory();
    // give safe items and reset code to nill;

    if (config.code == code && config.code !== '') {
        var randomItem = Math.floor(Math.random() * config.items.length);

        Inv.functions.add({
            item : config.items[randomItem],
            amount : 1,
        })

        Player.Functions.GiveMoney("black", Math.random() * 20000, "Gestolen van de yacht (ov stash)")

        config.code = '';
    }
})

onNet("playerDropped", () => {
    let src = source;
    
    if (!mission.ongoing) {
        if (mission.players[src]) {
            mission.players[src] = undefined;

            for (let index in mission.players) {
                emitNet("Zero:Server-Yacht:ResyncMembers", index, mission.players);
            };
            emitNet("Zero:Server-Yacht:ResyncMembers", src, {});
        };
    } else {
        if (mission.players[src]) {
    
            mission.players[src] = undefined;
   
            if (count(mission.players) <= 0) {
                mission.ongoing = false;

                for (var index in config.stashes) {
                    config.stashes[index].searched = false;
                    config.stashes[index].code = undefined;
                };

                Zero.Functions.Notification(-1, "Yacht heist", "Yacht heist is afgelopen", "warning")
            }
        };
    }
})

Zero.Functions.CreateCallback('yacht:ongoing', function(source:number, cb:any) {
    cb(mission.ongoing)
});

Zero.Functions.CreateCallback('yacht:cops', function(source:number, cb:any) {
    let Players = Zero.Functions.GetPlayersByJob("police", true)
    let cops = count(Players);

    if (cops >= config.cops) {
        cb(true);
    } else {
        cb(false);
    }
});