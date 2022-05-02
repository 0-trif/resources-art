"use strict";
var Zero = {};
exports['zero-core'].object(function (O) { Zero = O; });
var last_players;
var last_chosen_player;
var Count = function (x) {
    let count = -1;
    for (var index in x) {
        count = count + 1;
    }
    return count;
};
onNet("Zero:Client-Bossmenu:Open", () => {
    var Player = Zero.Functions.GetPlayerData();
    var Job = Player.Job.name;
    var Grade = Player.Job.grade;
    if (Grade == Count(Zero.Config.Jobs[Job].grades)) {
        emitNet("Zero:Server-Bossmenu:Open");
    }
    else {
        Zero.Functions.Notification("Werknemers", "Je bent niet de hoogste rang binnen de " + Zero.Config.Jobs[Job].label + "", "error");
    }
});
onNet("Zero:Client-Bossmenu:SetGrade", (grade) => {
    if (last_chosen_player) {
        emitNet('Zero:Server-Bossmenu:SetGrade', last_chosen_player, grade);
    }
});
onNet("Zero:Client-Bossmenu:SetJobGrade", (lastId) => {
    if (lastId) {
        var Player = Zero.Functions.GetPlayerData();
        var Job = Player.Job.name;
        last_chosen_player = lastId;
        var ui = exports['zero-ui'].element();
        var menu = {};
        for (var index in Zero.Config.Jobs[Job].grades) {
            menu[index] = {
                label: Zero.Config.Jobs[Job].grades[index]['label'],
                subtitle: "Pas rang aan naar " + Zero.Config.Jobs[Job].grades[index]['label'] + "",
                value: parseFloat(index),
                event: 'Zero:Client-Bossmenu:SetGrade',
            };
        }
        menu[Count(menu) + 1] = {
            label: "Ga terug",
            next: false,
            event: 'Zero:Client-Bossmenu:Open',
        };
        ui.set("Rang aanpassen", menu);
    }
});
onNet("Zero:Client-Bossmenu:Fire", (lastId) => {
    emitNet("Zero:Server-Bossmenu:Fire", lastId);
});
onNet("Zero:Client-Bossmenu:SeePlayer", (Id) => {
    var ui = exports['zero-ui'].element();
    var menu = {
        [0]: {
            label: "Ontslaan",
            subtitle: "Pak baan van burger af",
            event: "Zero:Client-Bossmenu:Fire",
            value: last_players[Id].src,
        },
        [1]: {
            label: "Promoveren",
            subtitle: "Geef burger een andere rang",
            event: "Zero:Client-Bossmenu:SetJobGrade",
            value: last_players[Id].src,
            next: true,
        },
        [2]: {
            label: "Ga terug",
            next: false,
            event: "Zero:Client-Bossmenu:Employees",
        }
    };
    ui.set("Burger", menu);
});
onNet("Zero:Client-Bossmenu:Employees", (Players) => {
    var ui = exports['zero-ui'].element();
    if (last_players) {
        var menu = {};
        for (var index in last_players) {
            var Duty = !last_players[index]['duty'] && "Nee" || "Ja";
            menu[index] = {
                label: last_players[index]['name'],
                subtitle: last_players[index]['gradeLabel'] + " <br> In dienst: " + Duty,
                next: true,
                event: "Zero:Client-Bossmenu:SeePlayer",
                value: index,
            };
        }
        menu[Count(menu) + 1] = {
            label: "Ga terug",
            event: "Zero:Client-Bossmenu:Open",
            next: false,
        };
        ui.set('Werknemers', menu);
    }
});
onNet("Zero:Client-Bossmenu:Hire", (nothing, playerId) => {
    emitNet("Zero:Server-Bossmenu:Hire", playerId);
});
onNet("Zero:Client-Bossmenu:DisplayMenu", (Players) => {
    var ui = exports['zero-ui'].element();
    if (Players) {
        var menu = {};
        var Player = Zero.Functions.GetPlayerData();
        var Job = Player.Job.name;
        last_players = Players;
        menu[0] = {
            label: "Werknemers",
            subtitle: "Regel alle werknemers binnen de " + Zero.Config.Jobs[Job].label + "",
            next: true,
            event: "Zero:Client-Bossmenu:Employees",
        };
        menu[1] = {
            label: "Aannemen",
            input: true,
            value: '',
            event: "Zero:Client-Bossmenu:Hire",
            subtitle: "Neem iemand aan bij de " + Zero.Config.Jobs[Job].label + "",
        };
        menu[2] = {
            label: "Sluiten",
        };
        ui.set("Werknemers menu", menu);
    }
});
