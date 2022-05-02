var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

var bool:any = undefined;

function Delay(ms:number) { 
    return new Promise((res) => {
        setTimeout(res, ms)
    })
}



RegisterNuiCallbackType('done')
on('__cfx_nui:done', (data:any) => {
    let valid = data.valid;

    SetNuiFocus(false, false)

    bool = valid;
});

exports("skill", async (title:string, timer:number, cb:any) => {
    bool = undefined;
    
    SendNUIMessage({
        action: "show",
        data: {
            time:timer,
            title:title,
        },
    })

    SetNuiFocus(true, true)

    while (bool == undefined) {
        await Delay(1);
    }

    return bool
});