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
var bool = undefined;
var busy = false;
function Delay(ms) {
    return new Promise((res) => {
        setTimeout(res, ms);
    });
}
RegisterNuiCallbackType('done');
on('__cfx_nui:done', (data) => {
    SetNuiFocus(false, false);
    bool = true;
});
exports("start", (title, timer, cb) => __awaiter(void 0, void 0, void 0, function* () {
    bool = undefined;
    if (busy) {
        return;
    }
    SendNUIMessage({
        action: "show",
        data: {
            time: timer,
            title: title,
        },
    });
    busy = true;
    while (bool == undefined) {
        yield Delay(1);
    }
    busy = false;
    return bool;
}));
