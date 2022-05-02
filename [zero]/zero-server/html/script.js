admin = {}

$(() => {
    $(`.option`).click(admin.choose)

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                $(`#body`).hide();
                $.post('https://zero-server/close', JSON.stringify({}));
        }
    });
    
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "open":
                $(`#body`).show();
                break;
            case "close": 
                $(`#body`).hide();
                break;
            case "players":
                SetupPlayers(event.data.players)
                break;
        }
    })
});

SetupPlayers = function (players) {
    $(`.players`).html(``);

    $.each(players, function(key, val) {
        if (val) {
            var inner = ` <div class="player" data-id="`+val['id']+`" onclick="admin.openPlayer(event)">[`+val['id']+`] `+val['name']+`</div>`
            $(`.players`).append(inner);
        }
    })

    admin.log('Server player list has been updated for admin menu')
}

admin.log = function(txt) {
    $(`.menu-log`).prepend(`<div class="log-item">`+txt+`</div>`)
}

admin.choose = function (event) {
    var target = event.currentTarget;
    var type  = target.dataset.type;

    if (type == "players") {
        $.post('https://zero-server/playersList');
    }

    $(`.opt`).hide();
    $(`.`+type+``).show();

    $(`.menu-title`).html(`admin menu >- `+type+``)
}

admin.openPlayer = function (event) {
    serverid = event.currentTarget.dataset.id;

    $(`.chosenplayer`).data(`id`, serverid);

    $(`.opt`).hide();
    $(`.chosenplayer`).show();
}

admin.post = function (x, type, extra1, extra2) {
    admin.log('Used admin menu option : ('+type+')')

    $.post('https://zero-server/option', JSON.stringify({
        class : x,
        option : type,
        extra1 : extra1,
        extra2 : extra2,
    }));

    $(`input`).val(``)
}



admin.ban = function(reason, time, id) {
    admin.log('Used admin menu option : (ban)')

    $.post('https://zero-server/banPlayer', JSON.stringify({
        id : id,
        reason : reason,
        time : time,
    }));

}

admin.kick = function(reason, id) {
    admin.log('Used admin menu option : (kick)')
    
    $.post('https://zero-server/kickPlayer', JSON.stringify({
        id : id,
        reason : reason,
    }));
}