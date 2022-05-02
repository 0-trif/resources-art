function changeBackGround(event) {
    var type = event.currentTarget.id;
    var value = event.currentTarget.value;

    $.post('https://zero-settings/setBackground', JSON.stringify({
        type: type,
        value: value,
    }));
}

function removeKeybind(key) {
    $.post('https://zero-settings/AddKeybind', JSON.stringify({
        key: key,
        command : undefined,
    }));
}

function addKeybind(event) {
    var key = $(`#key`).val();
    var command = $(`#command`).val();

    if (key && command) {
        $.post('https://zero-settings/AddKeybind', JSON.stringify({
            key: key,
            command : command
        }));
    }
}

setupSettings = function(settings) {
    if (settings.background) {
        $(`#player`).val(settings.background.player);
        $(`#other`).val(settings.background.other);
    }
    if (settings.keybinds) {
        $(`.settings-keybinds-active`).html(``);

        $.each(settings.keybinds, function(k, v){
            var inner = `
            <div class="active-keybind" onclick="removeKeybind('`+k+`')">
            <div class="key">`+k+`</div>
            <div class="action">`+v+`</div>
            </div>
            `
            $(`.settings-keybinds-active`).append(inner);
        });
    }

    $(`.sub-title`).html(``+settings.rpname+` (playerid: `+settings.id+`) - `+settings.name+``)
}

$(() => {
    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                e.preventDefault();
                $.post('https://zero-settings/close', JSON.stringify({}));
                break;
            case 9:
                e.preventDefault(); 
                $.post('https://zero-settings/close', JSON.stringify({}));
                break;
                
        }
    });

    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "show":
                if (event.data.bool) {
                    $(`.settings-main-container`).fadeIn(150)
                    setupSettings(event.data.settings)
                } else {
                    $(`.settings-main-container`).fadeOut(150)
                }
                break;
       
        }
    })
})
