dealership = {}

buyscreen = false;

$(function() {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "showmenu": {
                dealership.setup(event.data.vehicles)
                break;
            };
            case "setupclasses": {
                dealership.classes(event.data.classes)
                break;
            };
            case "currentClass": {
                $(`#vehicle-menu-subtitle`).html(`Class: `+event.data.label+``)
                break;
            };
            case "displayText": {
                dealership.text(event.data.text)
                break;
            };
        }
    });

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27: {
                dealership.close()
                break;
            }
            case 77: {
                dealership.close()
                break;
            }
            case 13: {
                dealership.buy()
                break;
            }
        }
    });
})

dealership.close = function() {
    if (buyscreen) {
        $(`.vehicle-buy-screen`).fadeOut(150);
        buyscreen = false;
    } else {
        $.post('https://zero-dealership/close');
        $(`body`).fadeOut(150);
    }
}

dealership.buy = function() {
    if (selected_model) {
        $(`.vehicle-buy-screen`).fadeIn(150);
        buyscreen = true;

        $.post('https://zero-dealership/buyScreen', JSON.stringify({
            model : selected_model
        }), function(data) {
            dealership.buyscreen(data)
        });
    }
}

dealership.testdive = function () {
    if (selected_model) {
        $.post('https://zero-dealership/close');
        $(`body`).fadeOut(150);

        $.post('https://zero-dealership/testdrive', JSON.stringify({
            model : selected_model
        }));
    }
}

dealership.setup = function (vehicles) {
    $(`.vehicles-list`).html(``);

 
    $.each(vehicles, function(k,v) {

        var inner = `
        <div class="vehicle" onclick="dealership.vehicle('`+k+`')">
        <div class="vehicle-label">`+v.label+`</div>
        <div class="vehicle-price">€`+v.price+`</div>
        <div class="vehicle-speed"><i class="fas fa-burn"></i>`+v.speed+`KM/U</div>
        </div>
        `
        $(`.vehicles-list`).append(inner);
    })

    $(`body`).fadeIn(150);
    
}

dealership.classes = function(classes) {
    $(`.vehicle-class-right`).html(``);

    $.each(classes, function(k,v) {
        var inner = `
            <div class="class" onclick="dealership.class('`+k+`')">`+v.label+`</div>
        `
        $(`.vehicle-class-right`).append(inner);
    })

}

dealership.class = function(index) {
    $.post('https://zero-dealership/class', JSON.stringify({class : index}), function(vehicles) {
        $(`.vehicles-list`).html(``);

        $.each(vehicles, function(k,v) {
            var inner = `
            <div class="vehicle" onclick="dealership.vehicle('`+k+`')">
            <div class="vehicle-label">`+v.label+`</div>
            <div class="vehicle-price">€`+v.price+`</div>
            <div class="vehicle-speed"><i class="fas fa-burn"></i>`+v.speed+`KM/U</div>
            </div>
            `
            $(`.vehicles-list`).append(inner);
        })
    });
}

dealership.text = function(txt) {
    if (txt == "") {
        $(`.display-text`).hide();
    } else {
        $(`.display-text`).show();
        $(`.text`).html(txt);
    }
}

dealership.vehicle = function(model) {
    $.post('https://zero-dealership/vehicle', JSON.stringify({model : model}));
    selected_model = model;
}

dealership.buyscreen = function(data) {
    $(`.vehicle-buy-price`).html(`€` + data.price)
    $(`.vehicle-buy-speed`).html(`<i class="fas fa-burn"></i>` + data.speed)
}

dealership.confirmBuy = function() {
    $(`.vehicle-buy-screen`).fadeOut(150);
    buyscreen = false;

    $.post('https://zero-dealership/buy');

    dealership.close()
    
}