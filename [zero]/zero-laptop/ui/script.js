let Packets = {};
GlobalCoins = 0;
OpenedPacket = undefined;


toggleConfirmButton = function(bool) {
    if (bool) {
        $(`.buy-packet-button`).html(`Bevestigen!`);
    } else {
        $(`.buy-packet-button`).html(`Pakket kopen`);
    }
}

BuyPackage = function() {
    var inner = $(`.buy-packet-button`).html();
    if (inner == `Pakket kopen`) {
        toggleConfirmButton(true);
    } else {
        if (GlobalCoins) {
            if (Packets[OpenedPacket]) {
                if (Packets[OpenedPacket].price <= GlobalCoins) {
                    toggleConfirmButton(false);

                    $.post('http://zero-laptop/ui-buyVehiclePack', JSON.stringify({
                        id : OpenedPacket,
                    }));
                }
            }
        }
    }
}

$(() => {

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                closeAllSubs();
        }
    });

    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "open": {
                $(`.border-laptop`).fadeIn(100);
                break;
            };
            case "SetupApps": {
                SetupApps(event.data.apps);
                break;
            };
            case "SetupPackets": {
                SetupPackets(event.data.packets);
                break;
            }
            case "Coins": {
                GlobalCoins = event.data.amount;
                $(`.Zero-coins`).html(`${event.data.amount} <i class="fas fa-coins"></i>`)
                break;
            }
        }
    });
});

const closeAllSubs = function() {
    $(`.border-laptop`).fadeOut(100);
    $.post('http://zero-laptop/ui-closed');
}


const openApp = function (event) {
    var id = event.currentTarget.id
    if (id) {
        $(`#app-`+id+``).show();
        $(`.in-app-frame`).show();
    }
}

const closeApps = function () {
    $(`.in-app-frame`).hide();
}

function ShowVehicles() {
    $(`.webstore-cats`).css(`top`, `0vh`);
}
function closeVehicles () {
    $(`.webstore-cats`).css(`top`, `100%`);
}

function closeInspect() {
    $(`.vehicle-inspect-area`).css(`top`, `100%`);
}

function openPacket(event) {
    toggleConfirmButton(false);

    var id = $(event.currentTarget).parent().data(`id`);

    OpenedPacket = id;

    if (!Packets[id]) { return }

    $(`.inspect-title`).html(`${Packets[id].label}`)
    $(`.big-image`).css(`background-image`, `url(${Packets[id].images[0]})`);
    $(`.price-tag`).html(`${Packets[id].price} <i class="fas fa-coins"></i>`);
    $(`.small-images`).html(``);
    $(`.small-vehicle-info`).html(`${Packets[id].info}`);

    $.each(Packets[id].images, function(k, v) {
        $(`.small-images`).append(`<div class="small-image" style="background-image: url(${v});" onmouseenter="EnteredImage(event)"></div>`)
    })

    $(`.vehicle-inspect-area`).css(`top`, `0vh`);
}

function EnteredImage(event) {
    var X = $(event.currentTarget);
    var imageUrl = X.css(`background-image`);
    $(`.big-image`).css(`background-image`, imageUrl)
}

function SetupApps(apps) {
    $(`.apps`).html(``);
    
    $.each(apps, function (k, v) {
        var inner = `
        <div class="app" onclick="openApp(event)" id="${v.id}">
        <div class="app-icon" style="background-image: url(${v.icon});"></div>
        <div class="app-name">${v.label}</div>
        </div>
        `
        
        $(`.apps`).append(inner);
    })
}

function SetupPackets(packets) {
    $(`.vehicles`).html(``);
    
    $.each(packets, function (k, v) {
        Packets[k] = v;

        var inner = `
        <div class="vehicle" data-id="${k}" style="background-image: url(${v.images[0]});">
        <div class="package-name">${v.label}</div>
        <div class="vehicle-button" onclick="openPacket(event)"><i class="fas fa-caret-up"></i> <div class="vehicle-button-text">Bekijk paket</div></div>
        </div>
        `
        
        $(`.vehicles`).append(inner);
    })
}