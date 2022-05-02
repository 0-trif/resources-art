function ShowTimer (name, time) {
    $(`.skill-title`).html(name + ` `+time+``);

    bool = false;

    $(`.main-container`).show();

    $(".skill-bar-inner").stop().css({"width": `100%`}).animate({
        width: '0%'
      }, {
        duration: time,
        easing : false,
        specialEasing: {
            width: "linear",
            height: "easeOutBounce"
          },
        start: function() {
            oldp = $(".skill-bar-inner").css(`width`);
        },
        complete: function() {
            $(`.main-container`).hide(function() {
                $.post('https://zero-timer/done', JSON.stringify({
                    valid : bool,
                }));
            });
        },
        step: function( now, fx ) {
            if (oldp) {
                x = time / 100 * now;
                x = parseInt(x) / 1000;

                $(`.skill-title`).html(name + ` `+x+``);
            }
        }
    });
}   


$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "show":
                ShowTimer(event.data.data.title, event.data.data.time);
       
        }
    })
})

