"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var Zero = {};
exports['zero-core'].object(function (O) { Zero = O; });
// loading charges
let ChargedVehicles = {};
const AddCharge = function (plate, charge, officer) {
    Zero.Functions.ExecuteSQL(false, "DELETE FROM `vehicle-charges` WHERE `plate` = ?", [plate]);
    Zero.Functions.ExecuteSQL(false, "INSERT INTO `vehicle-charges` (`plate`, `charge`, `officer`) VALUES (?, ?, ?)", [
        plate,
        JSON.stringify(charge),
        officer,
    ]);
    ChargedVehicles[plate] = {
        plate: plate,
        charge: charge,
        officer: officer,
    };
};
Zero.Functions.CreateCallback('Zero:Server-Impound:GetCharge', function (source, cb, plate) {
    cb(ChargedVehicles);
});
onNet("Zero:Server-Impound:ChargeVehicle", (plate, charge, loc) => {
    let src = source;
    let Player = Zero.Functions.Player(src);
    if (Player.Job.name == "police" || Player.Job.name == "kmar") {
        if (plate && charge) {
            Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", [
                plate,
            ], function (result) {
                if (result[0]) {
                    let Citizenid = result[0]['citizenid'];
                    let Owner = Zero.Functions.PlayerByCitizenid(Citizenid);
                    if (Owner) {
                        Owner.Functions.SetVehicleLocation(plate, "police-impound", 100, loc);
                        Player.Functions.Notification("Beslagname", "Voertuig in beslag genomen");
                    }
                    else {
                        let location = 'police-impound';
                        Zero.Functions.ExecuteSQL(true, "UPDATE `citizen_vehicles` SET `location` = ?, `coord` = ? WHERE `plate` = ?", [
                            location,
                            JSON.stringify(loc),
                            plate,
                        ]);
                        Player.Functions.Notification("Beslagname", "Voertuig in beslag genomen");
                    }
                    ;
                    AddCharge(plate, charge, Player.PlayerData.firstname);
                }
                else {
                    Player.Functions.Notification("Beslagname", "Dit voertuig heeft geen eigenaar", "error");
                }
            });
        }
    }
});
onNet("Zero:Server-Impound:BuyImpound", (plate, Price) => {
    if (ChargedVehicles[plate]) {
        let src = source;
        let Player = Zero.Functions.Player(src);
        Player.Functions.ValidRemove(Price, "Voertuig terug gekocht uit politie beslagname", function (bool) {
            if (bool) {
                ChargedVehicles[plate] = undefined;
                Zero.Functions.ExecuteSQL(false, "DELETE FROM `vehicle-charges` WHERE `plate` = ?", [plate]);
            }
        });
    }
});
function Waiter(ms) {
    return new Promise((res) => { setTimeout(res, ms); });
}
;
const load = function () {
    return __awaiter(this, void 0, void 0, function* () {
        yield Waiter(5000);
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `vehicle-charges`", function (vehicles) {
            for (var index in vehicles) {
                ChargedVehicles[vehicles[index].plate] = {
                    plate: vehicles[index].plate,
                    charge: JSON.parse(vehicles[index].charge),
                    officer: vehicles[index].officer,
                };
            }
            ;
        });
    });
};
load();
