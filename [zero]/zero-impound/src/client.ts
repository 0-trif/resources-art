var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

var charge_vehicle:any
var charges:any

function Delay(ms:number) { 
    return new Promise((res) => {
        setTimeout(res, ms)
    })
};

onNet("Zero:Client-Impound:OpenChargeMenu", (vehicle:any) => {
    let ui = exports['zero-ui'].element();

    var menu:any = {}

    menu[-1] = {
        label : "Sluiten",
        subtitle : "Sluit menu",
    }

    charge_vehicle = vehicle;

    for (var index in config.charges) {
        menu[index] = {
            label : config.charges[index].title,
            subtitle : config.charges[index].label,
            event : "Zero:Client-Impound:ChargeVehicle",
            next : true,
            value : index,
        }
    }

    ui.set("Beslagname", menu)
})

onNet("Zero:Client-Impound:ChargeVehicle", (index:number) => {
    let charge = config.charges[index];

    if (charge_vehicle) {
        let plate = GetVehicleNumberPlateText(charge_vehicle);
        let pos:any = GetEntityCoords(charge_vehicle);

        let loc = {
            x : pos[0],
            y : pos[1],
            z : pos[2],
            h : GetEntityHeading(charge_vehicle),
        }

        emitNet('Zero:Server-Impound:ChargeVehicle', plate, charge, loc);

        DeleteVehicle(charge_vehicle);
    };
})

function GetCharges() {
    Zero.Functions.TriggerCallback('Zero:Server-Impound:GetCharge', function(result:any) {
        charges = result;
    });
}

onNet("Zero:Client-Impound:OpenMenu", async () => {
    let ui = exports['zero-ui'].element();
    let PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    let menu:any = {};

    GetCharges();

    while (charges == undefined) {
        await Delay(10);
    }

    menu[0] = {
        label : "Suiten",
    }

    for (let index in PlayerVehicles) {
        if (PlayerVehicles[index].location == "police-impound") {
            let data = charges[PlayerVehicles[index].plate] !== undefined && charges[PlayerVehicles[index].plate] || {
                plate : PlayerVehicles[index].plate,
                charge : {title : "Onbekend", label : "Onbekende reden voor beslagname"},
                officer : 'Onbekend',
            };

            let Price = exports['zero-dealership'].GetVehicleData(PlayerVehicles[index]['model']).price;
            Price = Price / 100 * config.percentage;
            
            menu[PlayerVehicles[index].plate] = {
                label : PlayerVehicles[index].plate,
                subtitle : "Koop "+PlayerVehicles[index].model+" terug voor "+Price+" EUR <br><br> Aanklacht: "+data.charge.label+" <br> Agent: "+data.officer+"",
                event : "Zero:Client-Impound:BuyBack",
                value : PlayerVehicles[index].plate,
            }
        }
    }

    ui.set("Beslagname", menu)
});

onNet("Zero:Client-Impound:BuyBack", (plate:any) => {
    let PlayerVehicles = Zero.Functions.GetPlayerVehicles()
    let Money:any = Zero.Functions.GetPlayerData().Money
    let Price = exports['zero-dealership'].GetVehicleData(PlayerVehicles[plate]['model']).price;

    Price = Price / 100 * config.percentage;

    if (Money.cash >= Price || Money.bank >= Price) {
        if (PlayerVehicles[plate]) {
            Zero.Functions.SpawnVehicle({
                model : PlayerVehicles[plate]['model'],
                location : {x : PlayerVehicles[plate].coord.x, y : PlayerVehicles[plate].coord.y, z : PlayerVehicles[plate].coord.z, h : PlayerVehicles[plate].coord.h},
                teleport : false,
                network : true,
            }, function(vehicle:any) {
                Zero.Functions.SetVehicleProperties(vehicle, PlayerVehicles[plate]['mods'])
                SetVehicleNumberPlateText(vehicle, plate)
                exports['LegacyFuel'].SetFuel(vehicle, PlayerVehicles[plate]['fuel'])
    
                TriggerServerEvent("vehiclekeys:server:SetVehicleOwner", plate)
                TriggerServerEvent("Zero:Server-Garages:ParkVehicle", plate, '*', PlayerVehicles[plate]['fuel'])
                emitNet("Zero:Server-Impound:BuyImpound", plate, Price);
            })

            Zero.Functions.Notification("Beslagname", "Voertuig terug gekocht uit beslagname", "success")
        }
    } else {
        Zero.Functions.Notification("Beslagname", "Je hebt niet genoeg geld", "error")
    }
})