
$(function() {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "OpenDispatch": {
                $(`.dispatch-alert`).show();
                $(`.dispatch-members`).show();
                break;
            };
            case "DispatchPlayers": {
                SetupDispatchUsers(event.data.vehicles, event.data.players)
                break;
            };
            case "createAlert": {
                CreateAlert(event.data.data);
                break
            }
        }
    });

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                Close()
                break;
            case 77:
                Close()
                break;
        }
    });
})


Close = function () {
    $(`.dispatch-alert`).hide();
    $(`.dispatch-members`).hide();
    $.post('https://zero-dispatch/close')
}

SetupDispatchUsers = function(vehicles, players) {
    $(`#police`).find(`.dispatch-members-players`).html(``)
    $(`#ambulance`).find(`.dispatch-members-players`).html(``)
    $(`#mechanic`).find(`.dispatch-members-players`).html(``)
    $(`#kmar`).find(`.dispatch-members-players`).html(``)
    
    $.each(vehicles, function(job, plate) {
        $.each(plate, function(k, v) {
            inner = undefined
            $.each(v, function(key, value) {
                if (value) {
                    inner = inner !== undefined && inner || ``+value.icon+` `
                    inner = inner + ` `+value.name+` <br> `
                }
            })

            $(`#`+job+``).find(`.dispatch-members-players`).append(`
                <div class="dispatch-player">
                `+inner+`
                </div>
            `)
        })
    })


    $.each(players, function(job, arr) {   
        $.each(arr, function(k, v) {
            if (v) {
                var inner = `<i class="fa-solid fa-person-walking"></i>  `+v.name+``

                $(`#`+job+``).find(`.dispatch-members-players`).append(`
                    <div class="dispatch-player">
                    `+inner+`
                    </div>
                `)
            }
       })
    })
}

CreateTitles = function (titles) {
    var inner = ``;
    $.each(titles, function(k, v) {
        inner = inner + ` <div class="dispatch-title" style="background-color: `+v.color+`;">`+v.name+`</div>` 
    })

    return inner
}

CreateInfo = function(info) {
    var inner = ``

    $.each(info, function(k, v) {
        inner = inner + ` <div class="dispatch-info-part">`+v.icon+` `+v.text+`</div>` 
    })

    return inner
}


alertid = 0

SetLocation = function(event) {
    var x = event.currentTarget.dataset.x
    var y = event.currentTarget.dataset.y
    var z = event.currentTarget.dataset.z

    $.post('https://zero-dispatch/loc', JSON.stringify({
        x : x,
        y : y,
        z : z,
    }))
}
CreateAlert = function(data) {
    var titles = CreateTitles(data.taggs);
    var info = CreateInfo(data.info);

    alertid = alertid + 1

    var inner = `
    <div id="`+alertid+`-alert" class="dispatch-alert `+data.type+`">
    <div class="dispatch-titles">${titles}<div class="dispatch-text-title">`+data.title+`</div>
    </div>

    <i class="fas fa-location-dot" onclick="SetLocation(event)" data-x="`+data.location.x+`" data-y="`+data.location.y+`" data-z="`+data.location.z+`"></i>

    <div class="dispatch-info">
    ${info}
    </div>
    </div>
    `

    $(`.displatch-notifications`).prepend(inner)
    $(`#`+alertid+`-alert`).css(`right`, `-50vh`);
    $(`#`+alertid+`-alert`).animate({right: `2vh`}, 400)

    removeAlert(alertid)
}

removeAlert = function(id) {
    setTimeout(function() {
        $(`#`+id+`-alert`).fadeOut(300);
    }, 5000)
}