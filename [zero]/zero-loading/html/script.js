Loading = {}

Loading.Stop = function() {

    $(`.loading-bar-inner`).css(`width`, `100%`);
    $(`.server-sub-name`).html(`[ 100% ]: Laadscherm sluiten..`)

    setTimeout(() => {
        $(`.stop-fade`).hide(500);
        $(`.start-fade`).show(500);
    
        $(`.start-fade`).css(`transition`, `1s`)
        setTimeout(() => {
            $(`.start-fade`).css(`opacity`, `0`);
            $(`.start-fade`).css(`transform`, `scale(11.0)`);
    
            $(`.background`).css(`animation`, `unset`);
        
    
            $(`.background`).fadeOut(1000);
            $(`.screen-fade-in`).fadeOut(3000);
    
        }, 3000);
    }, 3000);
}

Loading.Start = function() {
    $(`.background`).fadeIn(1);
    $(`.screen-fade-in`).fadeIn(1);

    $(`.stop-fade`).show(500);
    $(`.start-fade`).hide(500);
}


$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;


        switch(action) {
            case "hide": {
                setTimeout(function() {
                    Loading.Stop();
                }, 3000)
                break;
            };
        }
    });

});


// CFX loading code POGGERSSS

var count = 0;
var thisCount = 0;


const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
        document.querySelector('.server-sub-name').innerHTML = [data.type][data.order - 1] || 'Gegevens opvragen..';
    },

    initFunctionInvoking(data) {
        document.querySelector('.loading-bar-inner').style.left = '0%';
        document.querySelector('.loading-bar-inner').style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        count = data.count;

     //   document.querySelector('.letni h3').innerHTML += "\u{1f358}";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector('.loading-bar-inner').style.left = '0%';
        document.querySelector('.loading-bar-inner').style.width = ((thisCount / count) * 100) + '%';
    },

    onLogLine(data) {
        document.querySelector('.server-sub-name').innerHTML = data.message + "";
    }
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});
