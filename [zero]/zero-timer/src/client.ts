var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

var bool:any = undefined;
var busy:any = false;

function Delay(ms:number) { 
    return new Promise((res) => {
        setTimeout(res, ms)
    })
}

RegisterNuiCallbackType('done')
on('__cfx_nui:done', (data:any) => {
    SetNuiFocus(false, false)
    bool = true;
});

exports("start", async (title:string, timer:number, cb:any) => {
    bool = undefined;
    
    if (busy) {
        return
    }

    SendNUIMessage({
        action: "show",
        data: {
            time:timer,
            title:title,
        },
    })

    busy = true;
    while (bool == undefined) {
        await Delay(1);
    }
    busy = false;
    return bool
});