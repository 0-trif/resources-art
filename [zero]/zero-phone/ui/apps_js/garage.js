SetupPlayerVehicles = function (vehicles) {
    $(`.garages-app-container`).html(``)
    $.each(vehicles, function(k, v){
        var inner = `
        <div class="vehicle-container">
        <div class="vehicle-icon"><i class="fad fa-car-alt"></i></div>
        <div class="vehicle-info">
            <div class="vehicle-name">`+v.label+`</div>
            <div class="vehicle-plate">`+v.plate+`</div>
        </div>
        <div class="vehicle-specs-button" data-plate="`+v.plate+`" data-price="`+v.price+`" data-name="`+v.label+`" data-fuel="`+v.fuel+`" data-garage="`+v.location+`" onclick="showSubGarage(event)"><i class="fad fa-align-right"></i></div>
        </div>
        `
        $(`.garages-app-container`).append(inner)
    });
}


showSubGarage = function (event) {
    $(`#garages-info`).show();

    if (event.currentTarget) {
        $(`#vehicle-garage-fuel`).html(event.currentTarget.dataset.fuel)
        $(`#vehicle-garage-price`).html(event.currentTarget.dataset.price)
        $(`#vehicle-garage-plate`).html(event.currentTarget.dataset.plate)
        $(`#vehicle-garage-name`).html(event.currentTarget.dataset.name)
        $(`#vehicle-garage-garage`).html(event.currentTarget.dataset.garage)
    }

    AnimateCSS(`#garages-info`, 'fadeInRight', function() {
    });
}

closeSubGarage = function () {
    AnimateCSS(`#garages-info`, 'fadeOutRight', function() {
        $(`#garages-info`).hide();
    });
}