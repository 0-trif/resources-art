"use strict";
var Zero = {};
exports['zero-core'].object(function (O) { Zero = O; });
var Count = function (x) {
    let count = -1;
    for (var index in x) {
        count = count + 1;
    }
    return count;
};
onNet("Zero:Server-Bossmenu:Open", () => {
    var src = source;
    var Player = Zero.Functions.Player(src);
    var Job = Player.Job.name;
    var Grade = Player.Job.grade;
    var FoundPlayers = {};
    if (Grade == Count(Zero.Config.Jobs[Job].grades)) {
        var Players = Zero.Functions.GetPlayersByJob(Job, false);
        for (let index in Players) {
            FoundPlayers[index] = {
                src: Players[index].User.Source,
                name: Players[index].PlayerData.firstname + " " + Players[index].PlayerData.lastname,
                gradeLabel: Zero.Config.Jobs[Job]['grades'][Players[index].Job.grade]['label'],
                duty: Players[index].Job.duty,
                inventory: Players[index].Functions.Inventory().inventory,
            };
        }
        emitNet("Zero:Client-Bossmenu:DisplayMenu", src, FoundPlayers);
    }
});
onNet("Zero:Server-Bossmenu:SetGrade", (playerId, Grade) => {
    var src = source;
    playerId = parseFloat(playerId);
    Grade = parseFloat(Grade);
    var Player = Zero.Functions.Player(src);
    var Target = Zero.Functions.Player(playerId);
    if ((Player.Job.name == Target.Job.name) && Player.Job.grade >= Target.Job.grade) {
        Target.Functions.SetJob(Player.Job.name, Grade);
        Target.Functions.Notification('Baan', 'Je baan rang is aangepast naar ' + Zero.Config.Jobs[Player.Job.name].grades[Grade].label + '', 'success');
        Player.Functions.Notification('Baan', 'Baan is aangepast', 'success');
    }
});
onNet("Zero:Server-Bossmenu:Hire", (playerId) => {
    var src = source;
    playerId = parseFloat(playerId);
    var Player = Zero.Functions.Player(src);
    var Target = Zero.Functions.Player(playerId);
    var Grade = Player.Job.grade;
    if (Grade == Count(Zero.Config.Jobs[Player.Job.name].grades)) {
        Target.Functions.SetJob(Player.Job.name, 0);
        Target.Functions.Notification('Baan', 'Je bent aangenomen als ' + Zero.Config.Jobs[Player.Job.name].grades[Grade].label + ' | ' + Zero.Config.Jobs[Player.Job.name].label + '', 'success');
        Player.Functions.Notification('Baan', 'Burger is aangenomen', 'success');
    }
});
onNet("Zero:Server-Bossmenu:Fire", (playerId) => {
    var src = source;
    playerId = parseFloat(playerId);
    var Player = Zero.Functions.Player(src);
    var Target = Zero.Functions.Player(playerId);
    if ((Player.Job.name == Target.Job.name) && Player.Job.grade >= Target.Job.grade) {
        Target.Functions.SetJob("unemployed", 0);
        Target.Functions.Notification('Baan', 'Je bent ontslagen van je huidige baan', 'error');
        Player.Functions.Notification('Baan', 'Burger is ontslagen', 'success');
    }
});
