openMyAlerts = function () {
    $(`.sos-app-notifications`).html(``);
    $.post('https://zero-phone/GetSOSNotifications', JSON.stringify({
    }), function(result) {

        $.each(result, function(k,v) {
            var inner = `
            <div class="police-alert" onclick="SOSsetLocation(event)" data-x="`+v.location.x+`" data-y="`+v.location.y+`" data-z="`+v.location.z+`">
            <div class="alert-title">`+v.title+`</div>
            <div class="alert-message">`+v.message+`</div>
            <div class="alert-location">Locatie instellen.</div>
            </div>
            `

            $(`.sos-app-notifications`).prepend(inner);
        })
    });

    $(`#sos-alerts`).show();
    AnimateCSS(`#sos-alerts`, 'fadeInRight', function() {
     
    });
}

refreshAlerts = function() {
    $.post('https://zero-phone/GetSOSNotifications', JSON.stringify({
    }), function(result) {
        $(`.sos-app-notifications`).html(``);

        $.each(result, function(k,v) {
            var inner = `
            <div class="police-alert" onclick="SOSsetLocation(event)" data-x="`+v.location.x+`" data-y="`+v.location.y+`" data-z="`+v.location.z+`">
            <div class="alert-title">`+v.title+`</div>
            <div class="alert-message">`+v.message+`</div>
            <div class="alert-location">Locatie instellen.</div>
            </div>
            `

            $(`.sos-app-notifications`).prepend(inner);
        })
    });
}

CloseMyAlerts = function () {
    AnimateCSS(`#sos-alerts`, 'fadeOutRight', function() {
        $(`#sos-alerts`).hide();
    });
}

SOSsetLocation = function (event) {
    var x = event.currentTarget.dataset.x
    var y = event.currentTarget.dataset.y
    var z = event.currentTarget.dataset.z

    $.post('https://zero-phone/SOSsetLocation', JSON.stringify({
        x : x,
        y : y,
        z : z
    }));
}
sendSOSmessage = function () {
    var title = $(`#sos-title`).val();
    var message = $(`#sos-message`).html();
    var job = $(`#sos-job`).val();

    $.post('https://zero-phone/SendSOSmessage', JSON.stringify({
        title : title,
        message : message,
        job : job
    }));

    $(`#sos-title`).val(``);
    $(`#sos-message`).html(``);
}