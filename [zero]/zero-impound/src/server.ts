var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

// loading charges
let ChargedVehicles:any = {}


const AddCharge = function(plate:string, charge:any, officer:string) {
    Zero.Functions.ExecuteSQL(false, "DELETE FROM `vehicle-charges` WHERE `plate` = ?", [plate]);
    Zero.Functions.ExecuteSQL(false, "INSERT INTO `vehicle-charges` (`plate`, `charge`, `officer`) VALUES (?, ?, ?)", [
        plate,
        JSON.stringify(charge),
        officer,
    ])

    ChargedVehicles[plate] = {
        plate : plate,
        charge : charge,
        officer : officer,
    };
};

Zero.Functions.CreateCallback('Zero:Server-Impound:GetCharge', function(source:number, cb:any, plate:any) {
    cb(ChargedVehicles)
});

onNet("Zero:Server-Impound:ChargeVehicle", (plate:any, charge:any, loc:any) => {
    let src = source;
    let Player = Zero.Functions.Player(src);

    if (Player.Job.name == "police" || Player.Job.name == "kmar") {
        if (plate && charge) {
            Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", [
                plate,
            ], function(result:any) {
                if (result[0]) {
                    let Citizenid = result[0]['citizenid'];
                    let Owner = Zero.Functions.PlayerByCitizenid(Citizenid);

                    if (Owner) {
                        Owner.Functions.SetVehicleLocation(plate, "police-impound", 100, loc);

                        Player.Functions.Notification("Beslagname", "Voertuig in beslag genomen");
                    } else {
                        let location = 'police-impound';

                        Zero.Functions.ExecuteSQL(true, "UPDATE `citizen_vehicles` SET `location` = ?, `coord` = ? WHERE `plate` = ?", [
                            location,
                            JSON.stringify(loc),
                            plate,
                        ]);
                        Player.Functions.Notification("Beslagname", "Voertuig in beslag genomen");
                    };

                    AddCharge(plate, charge, Player.PlayerData.firstname)
                } else {
                    Player.Functions.Notification("Beslagname", "Dit voertuig heeft geen eigenaar", "error")
                }
            })
        }
    }
})

onNet("Zero:Server-Impound:BuyImpound", (plate:string, Price:number) => {
    if (ChargedVehicles[plate]) {
        let src = source;
        let Player = Zero.Functions.Player(src);

        Player.Functions.ValidRemove(Price, "Voertuig terug gekocht uit politie beslagname", function(bool:boolean) {
            if (bool) {
                ChargedVehicles[plate] = undefined;
                Zero.Functions.ExecuteSQL(false, "DELETE FROM `vehicle-charges` WHERE `plate` = ?", [plate]);
            }
        })
    }
})

function Waiter(ms:number) { 
    return new Promise((res) => { setTimeout(res, ms) })
};

const load = async function() {
    await Waiter(5000);

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `vehicle-charges`", function(vehicles:any) {
        for (var index in vehicles) {
            ChargedVehicles[vehicles[index].plate] = {
                plate : vehicles[index].plate,
                charge : JSON.parse(vehicles[index].charge),
                officer : vehicles[index].officer,
            };
        };
    })
}
load();