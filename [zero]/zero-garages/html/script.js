
$(() => {
    window.addEventListener('message', e => {
        let action = e.data.action;

        switch(action) {
            case "toggle":
                if (e.data.job) {
                    $(`.main-container`).fadeIn(150)
                    
                    setupVehicles(e.data.vehicles, false, true)
                    return;
                }
                if (e.data.bool) {
                    $(`.main-container`).fadeIn(150)
                    
                    setupVehicles(e.data.vehicles, e.data.impound)
                } else {
                    $(`.main-container`).fadeOut(150)
                }
                break;
        }
    });
});

setupVehicles = function(vehicles, impound, job) {
    $(`.vehicles`).html(``)

    if (job) {
        $(`.title`).html(`Voertuig pakken`)
    } else {
        if (impound) {
            $(`.title`).html(`Voertuig pakken €5000`)
        } else {
            $(`.title`).html(`Voertuig plaatsen`)
        }
    }

    $.each(vehicles, function(k, v){
        if (job) {
            var inner = `<div onclick="JobVehicle(event, '`+k+`')" class="vehicle"><div class="vehicle-name">`+v.model+` | `+v.reason+`</div></div>`
            $(`.vehicles`).append(inner)
        } else {
            if (impound) {
                var inner = `<div onclick="selectVehicleImpound(event, '`+v.plate+`')" class="vehicle"><div class="vehicle-name">`+v.model+` | `+v.plate+`</div></div>`
                $(`.vehicles`).append(inner)
            } else {
                var inner = `<div onclick="selectVehicle(event, '`+v.plate+`')" class="vehicle"><div class="vehicle-name">`+v.model+` | `+v.plate+`</div></div>`
                $(`.vehicles`).append(inner)
            }
        }
    });
}

selectVehicle = function(event, plate) {
    if (plate) {
        $.post('https://zero-garages/placeVehicle', JSON.stringify({
            plate : plate,
        }));
    }
}

JobVehicle = function(event, index) {
    $.post('https://zero-garages/JobVehicle', JSON.stringify({
        index : index,
    }));
    closeMenu()
}

selectVehicleImpound = function(event, plate) {
    if (plate) {
        $.post('https://zero-garages/impoundVehicle', JSON.stringify({
            plate : plate,
        }));
    }
}

closeMenu = function() {
    $(`.main-container`).fadeOut(150)
    $.post('https://zero-garages/close', JSON.stringify({
    }));
}