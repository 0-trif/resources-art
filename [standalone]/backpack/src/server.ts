var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})




function WhiteListedWeapon(weapon:any) {
    for (index in config.WhiteListedWeapons) {
        if (config.WhiteListedWeapons[index] == weapon) {
            return true;
        }
    }
    return false;
}

onNet("ac:weaponCheck", (weapon:number) => {
    let _src = source;
    let Player = Zero.Functions.Player(_src);
    let Inventory = Player.Functions.Inventory();
    var bool = false;

    var inventory = exports['zero-inventory'].getConfig();

    if (weapon !== 0 && !WhiteListedWeapon(weapon)) {
        for (var i in Inventory.inventory) {
            var item = Inventory.inventory[i].item;
    
            if (inventory.config.items[item].type == "weapon") {
                var model = inventory.config.weapons[item]['objectivemodel'];
    
                if (model == weapon) {
                    bool = true;
                }
            }
        }
    
        if (!bool) {
            Zero.Functions.Ban(_src, "perm", "Weapon cheating :: ac", _src)
        }
    }
})

for (var index in config.fakeEvents) {
    let event = config.fakeEvents[index];

    onNet(event, (data:any) => {
        let _src = source;
        Zero.Functions.Ban(_src, "perm", "Event triggering {"+event+"} :: ac", _src);
    })
}

let events:any = {};

onNet("eventTrigger", (resource:string, eventName:string, __data:any, eventSource:number) => {
    let _src = source;
    events[_src] = events[_src] !== undefined && events[_src] || {};


    if (eventName.search(config.ResourceString) !== -1) {
        if (!events[_src][eventName]) {
            events[_src][eventName] = events[_src][eventName] !== undefined && events[_src][eventName] + 1 || 1;
    
            setTimeout(function() {
                if (events[_src][eventName] >= 10) {
                    Zero.Functions.Ban(_src, "perm", "Event spamming {"+eventName+": count "+events[_src][eventName]+"} :: ac", _src);
                }
                events[_src][eventName] = undefined;
            }, 300)
        } else {
            events[_src][eventName] = events[_src][eventName] !== undefined && events[_src][eventName] + 1 || 1;
        }
    }
})



