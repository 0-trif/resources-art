window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.action == "ShowScreen") {
        var element = document.getElementById(event.data.id);

        if (element) {
            item.x = item.x * 100
            item.y = item.y * 100


            element.style.left = ``+item.x+`%`
            element.style.top = ``+item.y+`%`
        } else {
            var index = `<div id="${item.id}" class="eye-dot"></div>`
            $(".center-eye-dots").append(index);
        }
    } else if (item.action == "toggle") {
        if (item.data.bool) {
            $(`.eye-dot`).fadeOut(150);
            $(`.center-eye-body`).show();
            SetupEyeFunctions(item.data.actions)
        } else {
            $(`.eye-dot`).fadeIn(150);
            $(`.center-eye-body`).hide();
            $(`.center-eye-options`).html(``);
        }
    } else if (item.action == "RemoveScreen") {
        $(`#${item.id}`).remove();
    }
});

function SetupEyeFunctions (actions) {
    $(`.center-eye-options`).html(``);
    $.each(actions, function (k, v) {
 
        var inner = `<div class="eye-option" onclick="DoAction('${k}')"><i class="fas fa-circle"></i>${v.label}</div>`;
        $(`.center-eye-options`).append(inner);
    });
}

function DoAction (index) {
    $.post('https://zero-eye/action', JSON.stringify({
        index : index,
    }));
}