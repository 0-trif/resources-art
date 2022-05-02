var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

var camera:any 
var TransitionCam:any
var skill:any

function Delay(ms:number) {
    return new Promise((res) => {
        setTimeout(res, ms)
    })
}

function CreateVehicles() {
    TriggerEvent("Zero:Client-Yacht:Alert");

    for (var index in config.vehicles) {
        Zero.Functions.SpawnVehicle({
            model : config.vehicles[index].model,
            location : {x : config.vehicles[index].x, y : config.vehicles[index].y, z : config.vehicles[index].z, h : config.vehicles[index].h},
            teleport : false,
            network : true,
        }, function(vehicle:any) {
            SetEntityAsMissionEntity(vehicle, true, true);
            SetVehicleEngineOn(vehicle, true, true, false);

            let plate = GetVehicleNumberPlateText(vehicle);
            TriggerServerEvent("vehiclekeys:server:WhiteListVehicle", plate);
        });
    }
}

function SetPosition(point:number) {
    let coord = config.MissionSpawns[point];

    if (coord) {
        let PlayerPed = PlayerPedId();
        SetEntityCoords(PlayerPed, coord.x, coord.y, coord.z, false, false, false, false);
        SetEntityHeading(PlayerPed, coord.h)

        if (point == 1) {
            CreateVehicles();
        };
    }
}

function WalkForward(spot:number) {
    let PlayerPed = PlayerPedId();
    let coord:any = GetEntityCoords(PlayerPed);

    if (config.animations[spot]) {
        ExecuteCommand(config.animations[spot])
    };
}

onNet("Zero:Client-Yacht:Open", async () => {
    Zero.Functions.TriggerCallback('yacht:cops', async function(result:any) {
        if (!result) {
            TriggerEvent("Zero:Client-Yacht:Menu", false);
            Zero.Functions.Notification("Heist", "Er is niet genoeg politie in dienst", "error")
            return;
        };

        Zero.Functions.TriggerCallback('yacht:ongoing', async function(result:any) {
            if (!result) {
                DoScreenFadeOut(150);
    
                while (!IsScreenFadedOut()) {
                    await Delay(1);
                }
                
                camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true);
                SetCamActive(camera, true);
                RenderScriptCams(true, true, 0, true, true);
                SetCamCoord(camera, config.mainCam.x, config.mainCam.y, config.mainCam.z);
                PointCamAtCoord(camera, config.YachtRender.x, config.YachtRender.y, config.YachtRender.z);
            
                // disabling the weather sync
                TriggerEvent("Zero-weathersync:client:DisableSync");
            
                SendNUIMessage({
                    action : "display",
                })
                
                SetNuiFocus(true, true);
            
                await Delay(1000);
            
                DoScreenFadeIn(150);
            } else {
                TriggerEvent("Zero:Client-Yacht:Menu", false);
                Zero.Functions.Notification("Yacht heist", "Deze heist is al bezig..", "error")
            }
        });
    });
})

RegisterNuiCallbackType('CloseMission')
on('__cfx_nui:CloseMission', async (data:any) => {
    SetNuiFocus(false, false)
    emitNet("Zero:Server-Yacht:LeaveMission");

    DoScreenFadeOut(150);

    while (!IsScreenFadedOut()) {
        await Delay(1);
    }

    DestroyAllCams(true);
    RenderScriptCams(false, false, 3, false, false)
    TriggerEvent("Zero-weathersync:client:EnableSync");

    await Delay(1000);

    DoScreenFadeIn(150);

    TriggerEvent("Zero:Client-Yacht:Menu", false);
});

// SRC -> CL EVENTS

onNet("Zero:Server-Yacht:ResyncMembers", (members:any) => {
    SendNUIMessage({
        action : "members",
        members : members,
    });
})

onNet("Zero:Server-Yacht:Code", (code:number) => {
    config.code = code
})

onNet("Zero:Client-Yacht:Search", async (index:number) => {
    ExecuteCommand("e mechanic3")
    
    Zero.Functions.Progressbar("search_x", "Bezig met zoeken..", 60000, false, true, {
        disableMovement : true,
        disableCarMovement : true,
        disableMouse : false,
        disableCombat : true,
    }, {
    }, {}, {}, function() {
        ExecuteCommand('e c')
        emitNet("Zero:Server-Yacht:Search", index)
    }
    , function() {
        ExecuteCommand('e c')
    });
});

onNet("Zero:Server-Yacht:StartMission", async (members:any) => {
    let serverId = GetPlayerServerId(PlayerId());

    SendNUIMessage({
        action : "hide",
    });

    DoScreenFadeOut(150);

    while (!IsScreenFadedOut()) {
        await Delay(1);
    }

    if (members[serverId]) {
        SetPosition(members[serverId].point);
    }
    //SetNuiFocus(false, false)
    TriggerEvent("Zero-weathersync:client:EnableSync");

    await Delay(1000);

    TransitionCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true);
    SetCamActive(TransitionCam, true);
    RenderScriptCams(true, true, 5000, true, true);
    SetCamCoord(TransitionCam, config.SpawnCam.x, config.SpawnCam.y, config.SpawnCam.z);
    PointCamAtCoord(TransitionCam, config.MissionSpawns[1].x, config.MissionSpawns[1].y, config.MissionSpawns[1].z);
    SetCamActiveWithInterp(TransitionCam, camera, 5000, 1, 0);

    DoScreenFadeIn(150);
    
    // cam transitions
    await Delay(5000) 
    WalkForward(members[serverId].point);
    await Delay(5000) 
    RenderScriptCams(false, true, 5000, false, false)
    DestroyAllCams(true)
    await Delay(5000) 
    SetNuiFocus(false, false)

    // start mission in LUA code (handles the loops)
    TriggerEvent("Zero:Client-Yacht:Menu", false);
    TriggerEvent("Zero:Client-Yacht:Mission", true)
})

onNet("Zero:Client-Yacht:SearchSafe", (code:number) => {
    if (config.code == code) {
        let failure = exports['zero-skill'].skill(1500);
        ExecuteCommand("e mechanic3");

        if (failure) {
            Zero.Functions.Progressbar("search_y", "Kluis openen..", 60000 * 5, false, true, {
                disableMovement : true,
                disableCarMovement : true,
                disableMouse : false,
                disableCombat : true,
            }, {
            }, {}, {}, function() {
                ExecuteCommand('e c')
                emitNet("Zero:Server-Yacht:SearchedSafe", code);
            }, function() {
                ExecuteCommand('e c')
            });
        };
    } else {
        Zero.Functions.Notification('Kluis', 'Kluis combinatie is onjuist', 'error', '8000');
    }
})

// NUI EVENTS;

RegisterNuiCallbackType('JoinMission')
on('__cfx_nui:JoinMission', async (data:any) => {
    emitNet("Zero:Server-Yacht:EnterMission")
});

RegisterNuiCallbackType('LeaveMission')
on('__cfx_nui:LeaveMission', async (data:any) => {
    emitNet("Zero:Server-Yacht:LeaveMission");
});

RegisterNuiCallbackType('StartMission')
on('__cfx_nui:StartMission', async (data:any) => {
    emitNet("Zero:Server-Yacht:StartMission");
});


