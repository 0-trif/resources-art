
$(() => {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "interaction":
                if (event.data.bool) {
                    $(`.interaction-inner`).html(event.data.text)
                    $(`.main-interaction-container`).show();
                    $(`.main-interaction-container`).animate({left: `1vh`}, 100)
                } else {
                    $(`.main-interaction-container`).animate({left: `-20vh`}, 100)
                }
                break;
            case "text":
                $(`.interaction-inner`).html(event.data.text)
                break;
        }
     })
})
