"use strict";
var Zero = {};
exports['zero-core'].object(function (O) { Zero = O; });
onNet("weapons", () => {
    let ped = PlayerPedId();
    let data = GetCurrentPedWeapon(ped, true);
    let holding = data[0];
    let model = data[1];
    if (holding) {
        emitNet("weaponCheck", model);
    }
});
