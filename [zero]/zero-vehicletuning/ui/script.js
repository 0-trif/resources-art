function CreateTuningPart (key, v) {
    v.screen.x = v.screen.x * 100
    v.screen.y = v.screen.y * 100

    var innerPart = `<div class="tuning-part" id="`+v.index+`-bone" style="left: `+v.screen.x+`%; top: `+v.screen.y+`%">
    <div class="part-name">`+v['label']+`</div>
    <div class="part-icon"></div>
    </div>`


    $(`.tuning-parts`).append(innerPart)
}

function SetupTuningParts (parts) {
    $(`.tuning-part`).remove()

    $.each(parts, function (key, value) {
        CreateTuningPart(key, value);
    })
}

function SyncPartLocation (part, coord) {
    coord.x = coord.x * 100
    coord.y = coord.y * 100

    $(`#`+part+`-bone`).css(`left`, ``+coord.x+`%`);
    $(`#`+part+`-bone`).css(`top`, ``+coord.y+`%`);
}

function SetSelectedPart (bone) {
    $(`.tuning-part`).removeClass(`selected`);
    $(`#`+bone+`-bone`).addClass(`selected`);
}

function AddTuningPartMenu(label, icon, key, owned) {
    if (owned) {
        inner = `
        <div class="tuning-logo" id="`+key+`-menu">
        <div class="tuning-logo-icon">
        `+icon+`
        </div>
        <div class="tuning-logo-label">
            `+label+`
        </div>
        <div class="tuning-logo-price">
        Gekocht
        </div>
        </div>
        `
    } else {
        inner = `
        <div class="tuning-logo" id="`+key+`-menu">
        <div class="tuning-logo-icon">
        `+icon+`
        </div>
        <div class="tuning-logo-label">
            `+label+`
        </div>
        </div>
        `
    }
 
    $(`.current-tunings`).append(inner);
}

function setupSubMenu (menu, submenu) {
    $(`.current-tunings`).html(``);

    $.each(menu, function (key, value) {
        if (submenu) {
            key = key + 1;
        }
        AddTuningPartMenu(value.label, value.icon, key, value.owned)
    })

    $(`.tuning-menu`).fadeIn(150);
}

// ui calls
$(() => {


    $(".hide-color").fadeOut(0);
    window.addEventListener('message', event => {
        let action = event.data.action;

        switch(action) {
            case "SetupPars":
                SetupTuningParts(event.data.tunings)
                break;
            case "SyncPartPosition":
                SyncPartLocation(event.data.part, event.data.screen)
                break;
            case "SetSelectedPart":
                SetSelectedPart(event.data.bone)
                break;
            case "LockInTuning":
                $(`.part-name`).css(`color`, `white`);
          //      $(`#`+event.data.bone+``).find(`.part-name`).css(`color`, `rgb(45, 61, 151)`);
                break;
            case "openSubMenu":
                setupSubMenu(event.data.menu, event.data.submenu)
                break;
            case "SetMenuIndexSelected":
                event.data.index = event.data.index
                $(`.tuning-logo`).removeClass('selected-part');
                $(`#`+event.data.index+`-menu`).addClass('selected-part');

                var e = document.getElementById(``+event.data.index+`-menu`);  
                e.scrollIntoView();  
                break;
            case "close":
                $(`.tuning-menu`).fadeOut(150);
                break;
            case "SetAmountString":
                $(`.current-tuning-string`).html(event.data.amount)
                break;
            case "WheelMenu":
                $(`.vehicle-wheel-menu`).fadeIn(150);
                colourMenu = false;
                break;
            case "OpenColours":
                $(`#colours-menu-primary`).fadeIn(150);
                setupCurrentColors(event.data)
                colourMenu = true;
                break;
        }
    });
});


function ChangeWheelsRotation (event) {
    var id = event.currentTarget.id;
    var value = event.currentTarget.value;

    $.post('https://zero-vehicletuning/wheelChambers', JSON.stringify({
        id : id,
        value : value,
    }));
}

function saveWheel() {
    $(`.vehicle-wheel-menu`).fadeOut(150);
    $.post('https://zero-vehicletuning/SaveWheelSettings', JSON.stringify({
    }));
}
function resetWheel() {
    $(`.vehicle-wheel-menu`).fadeOut(150);
    $.post('https://zero-vehicletuning/ResetWheels', JSON.stringify({
    }));
}


openPrimary = function() {
    $(`#colours-menu-secondary`).fadeOut(0);
    $(`#colours-menu-primary`).fadeIn(0);

    document.querySelectorAll(".sec").forEach(element => {
        element.classList.remove('selected-button')
    });
    document.querySelectorAll(".pri").forEach(element => {
        element.classList.add('selected-button')
    });


}
openSecondary = function() {
    $(`#colours-menu-primary`).fadeOut(0);
    $(`#colours-menu-secondary`).fadeIn(0);

    document.querySelectorAll(".pri").forEach(element => {
        element.classList.remove('selected-button')
    });
    document.querySelectorAll(".sec").forEach(element => {
        element.classList.add('selected-button')
    });
}

syncColorPrimary = function() {
    var r = $('.pri-r').val()
    var g = $('.pri-g').val()
    var b = $('.pri-b').val()

    colorPicker.color.rgb = {
        r: r,
        g: g,
        b: b,
    };
}
syncColorPrimaryHex = function() {
    var hex = $('.pri-hex').val()
    colorPicker.color.hexString = hex
}

syncColorSecondary = function() {
    var r = $('.sec-r').val()
    var g = $('.sec-g').val()
    var b = $('.sec-b').val()

    colorPicker2.color.rgb = {
        r: r,
        g: g,
        b: b,
    };
}
syncColorSecondaryHex = function() {
    var hex = $('.sec-hex').val()
    colorPicker2.color.hexString = hex
}

openColorClass = function(bool) {
    $(".primary-main-color").fadeOut(0);
    $(`.`+bool+``).fadeIn(0);

    $(".sub-title-colorid").html(`Basis kleuren (`+bool+`)`)
}

goBack = function() {
    $(".hide-color").fadeOut(0);
    $(".primary-main-color").fadeIn(0);
    $(".sub-title-colorid").html(`Basis kleuren`)
}

setColorSec = function(event) {
    var element = event.currentTarget;

    var r = element.dataset.color_r
    var g = element.dataset.color_g
    var b = element.dataset.color_b

    colorPicker2.color.rgb = {
        r: r,
        g: g,
        b: b,
    };
}

setColorPrimary = function(event) {
    var element = event.currentTarget;

    var r = element.dataset.color_r
    var g = element.dataset.color_g
    var b = element.dataset.color_b

    colorPicker.color.rgb = {
        r: r,
        g: g,
        b: b,
    };
}

changeColourTypeSec = function() {
 
    var element = document.getElementById("colourspinnersec")
    
    element.classList.add('fa-spin-hover')

    setTimeout(function() {
        element.classList.remove('fa-spin-hover')

        $.post('http://zero-vehicletuning/nextSecondaryColourType', JSON.stringify({}), function(name) {
            $("#nameColorTypeSec").html(name);
        });

    }, 500)

}

changeColourTypeMain = function() {
 
    var element = document.getElementById("colourspinnerpre")
    
    element.classList.add('fa-spin-hover')

    setTimeout(function() {
        element.classList.remove('fa-spin-hover')

        $.post('http://zero-vehicletuning/nextPrimaryColourType', JSON.stringify({}), function(name) {
            $("#nameColorTypePre").html(name);
        });

    }, 500)

}


colorChange2 = function(hex) {
    $('.sec-hex').val(hex.hexString)

    $('.sec-r').val(hex.rgb.r)
    $('.sec-g').val(hex.rgb.g)
    $('.sec-b').val(hex.rgb.b)

    $.post('http://zero-vehicletuning/changeSecondaryColor', JSON.stringify({
        r: hex.rgb.r,
        g: hex.rgb.g, 
        b: hex.rgb.b,
    }));
}

colorChange = function(hex) {
    $('.pri-hex').val(hex.hexString)

    $('.pri-r').val(hex.rgb.r)
    $('.pri-g').val(hex.rgb.g)
    $('.pri-b').val(hex.rgb.b)

    $.post('http://zero-vehicletuning/changePrimaryColor', JSON.stringify({
        r: hex.rgb.r,
        g: hex.rgb.g, 
        b: hex.rgb.b,
    }));
}

CancelColourChanges = function () {
    $(`#colours-menu-primary`).fadeOut(150);
    $(`#colours-menu-secondary`).fadeOut(150);

    $.post('http://zero-vehicletuning/ResetVehicleColours', JSON.stringify({
    }));
}
SaveColourChanges = function() {
    $(`#colours-menu-primary`).fadeOut(150);
    $(`#colours-menu-secondary`).fadeOut(150);

    $.post('http://zero-vehicletuning/SaveColourChanges', JSON.stringify({
    }));
}

setupCurrentColors = function(data) {
    if (data.primary) {
        $(`#primaryColorx`).css(`background-color`, `rgb(`+data.primary.r+`, `+data.primary.g+`, `+data.primary.b+`)`)
        colorPicker.color.rgb = {
            r: data.primary.r,
            g: data.primary.g,
            b: data.primary.b,
        };
    }
    if (data.secondary) {
        $(`#secondaryColorx`).css(`background-color`, `rgb(`+data.secondary.r+`, `+data.secondary.g+`, `+data.secondary.b+`)`)
        colorPicker2.color.rgb = {
            r: data.secondary.r,
            g: data.secondary.g,
            b: data.secondary.b,
        };
    }
}