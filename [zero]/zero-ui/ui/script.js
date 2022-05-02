
values = {}


$(function() {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "SetupMenu": {
                SetupMenu(event.data.title, event.data.menu)
                break;
            };
            case "ShowInput": {
                ShowInput();
                break;
            };
            case "timer": {
                showTimer(event.data.title, event.data.perc);
                break;
            }
        }
    });

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                close();
                break;
            case 77:
                close();
                break;
        }
    });
})

GetIcon = function(next) {
    var inner = ``

    if (next !== undefined) {
        if (next) {
            return `<i class="fa-solid fa-chevron-right"></i>`
        } else {
            return `<i class="fa-solid fa-chevron-left"></i>`
        }
    } else {
        return ``
    }

    return inner
}

close = function() {
    $(`.menu-items`).html(``);
    $(`.ui-menu-maintitle`).html(``);

    $(`.ui-input-container`).hide();

    $.post('https://zero-ui/close', JSON.stringify({

    }));
}

LaunchEvent = function (event, x, y) {
    var z = $(event.currentTarget).parent().find(`input`).val();
    $.post('https://zero-ui/event_', JSON.stringify({
        event : x,
        value : values[y],
        extra : z,
    }));
}

CreateMenuInner = function (v, k) {
    values[k] = v.value;

    if (v.input) {
        inner = `
        <div class="ui-menu-item">
                <div class="ui-menu-title">`+v.label+`</div>
                <input type="text" id="`+v.label+`-input">
                <div class="button-input" onclick="LaunchEvent(event, '`+v.event+`', '${k}')"><i class="fa-solid fa-check"></i></div>
                <div class="ui-button-info">
                    `+GetIcon(v.next)+`
                </div>
        </div>
        `
    } else {
        inner = `
        <div class="ui-menu-item" onclick="LaunchEvent(event, '`+v.event+`', '${k}')">
                <div class="ui-menu-title">`+v.label+`</div>
                ${v.subtitle !== undefined && `<div class="ui-menu-subtitle">`+v.subtitle+`</div>` || ``}
                <div class="ui-button-info">
                    `+GetIcon(v.next)+`
                </div>
        </div>
        `
    }

    return inner
}
SetupMenu = function(title, menu) {
    $(`.menu-items`).html(``);
    $(`.ui-menu-maintitle`).html(title);

    $.each(menu, function(k, v) {
        var inner = CreateMenuInner(v, k);
        $(`.menu-items`).append(inner);
    });
}

ShowInput = function() {
    $(`.ui-input-container`).show();
}

Complete = function() {
    var inp = $(`#inputCode`).val();
    $.post('https://zero-ui/input', JSON.stringify({
        code: inp
    }));
    $(`.ui-input-container`).hide();
}

showTimer = function(title, perc) {
    if (perc == 0) {
        $(`.ui-timer`).fadeOut(150);
        return;
    } else {
        $(`.ui-timer`).fadeIn(150);
        $(`.ui-timer-title`).html(title);
        $(`.ui-timer-bar-inner`).css(`width`, ``+perc+`%`);
    }
}