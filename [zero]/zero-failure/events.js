onNet("Zero:Client-BaseEvents:VehicleCrashed", function(vehicle, prev_speed, new_speed, prev_health, health, prev_engine, engine) {
    let speedDamage = (prev_speed - new_speed) * 4;
    let engineDamage = (prev_speed - new_speed) * 50
    let bodyDifferance = (prev_health - health);

    engineDamage = engineDamage <= config.maxEngineHit && engineDamage || config.maxEngineHit;

    let new_engine_health = engine - engineDamage >= 0 && engine - engineDamage || 0;
    SetVehicleEngineHealth(vehicle, new_engine_health);


    console.log(speedDamage > config.speedStall , bodyDifferance > config.damageStall , engineDamage > config.engineStall)
    if (speedDamage > config.speedStall || bodyDifferance > config.damageStall || engineDamage > config.engineStall) {
       Zero.Functions.Notification('Voertuig', 'Je engine is vastgelopen', 'error');

        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleUndriveable(vehicle, true)

        var random = randomInterval()
    
        setTimeout(() => {
            SetVehicleEngineOn(vehicle, true, true, false)
            SetVehicleUndriveable(vehicle, false)

            if (new_engine_health == 0) {
                Zero.Functions.Notification('Voertuig', 'Engine werkt niet meer', 'error')
                SetVehicleUndriveable(vehicle, true)
            }
        }, random);
    }
})  