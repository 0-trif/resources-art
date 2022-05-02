"use strict";
var Zero = {};
exports['zero-core'].object(function (O) { Zero = O; });
onNet("Zero:Client-Laundering:Trade", () => {
    emitNet("Zero:Server-Laundering:Trade");
});
onNet("Zero:Client-Laundering:Open", () => {
    let ped = PlayerPedId();
    let PlayerData = Zero.Functions.GetPlayerData();
    let BlackMoney = PlayerData.Money.black;
    if (BlackMoney > 0) {
        let UI = exports['zero-ui'].element();
        let menu = {
            [1]: {
                label: "Witwassen",
                subtitle: "Ruil " + BlackMoney + " zwartgeld om voor " + (BlackMoney / 100 * config.Percentage) + " cash",
                event: "Zero:Client-Laundering:Trade",
            },
            [2]: {
                label: "Sluiten",
            }
        };
        UI.set("Witwassen", menu);
    }
    else {
        Zero.Functions.Notification('Witwassen', 'Je hebt geen zwartgeld', 'error', 8000);
    }
});
