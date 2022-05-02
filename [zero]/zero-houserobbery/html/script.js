Reset = function() {
    $(`#code`).val(``);
}

Confirm = function() {
    var code = $(`#code`).val();
    $.post('http://zero-houserobbery/applyCode', JSON.stringify({
        code : code
    }));

    Reset()
    $(`.code-container`).hide();
    $.post('http://zero-houserobbery/closed')
}

add = function(x) {
    var code = $(`#code`).val();
    code = code + x;
    var code = $(`#code`).val(code);
}


$(() => {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "open":
                $(`.code-container`).show();
                break;
        }
    })

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                e.preventDefault();
                $(`.code-container`).hide();
                $.post('http://zero-houserobbery/closed')
                break;
            case 9:
                e.preventDefault();
                $(`.code-container`).hide();
                $.post('http://zero-houserobbery/closed')
                break;
        }
    });
})