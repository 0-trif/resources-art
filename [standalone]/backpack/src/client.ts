var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

onNet(
    "ac:weapons",
    () => {
        let ped = PlayerPedId();
        let data = GetCurrentPedWeapon(ped, true);

        let holding = data[0];
        let model = data[1];

        if (holding) {
            emitNet("ac:weaponCheck", model)
        }
})

