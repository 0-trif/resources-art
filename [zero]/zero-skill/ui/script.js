
valid = function(key) {
    const bar = $(`#bar-inner`);
    var width = parseFloat(bar.css(`width`).replace('px', ''));

    const point = $(`#bar-select`);

    var pwidth_start = parseFloat(point.css(`left`).replace('px', ''));
    var pwidth_end = parseFloat(point.css(`left`).replace('px', '')) + parseFloat(point.css(`width`).replace('px', ''));

    if (width >= pwidth_start && width <= pwidth_end) {
        if (key == currentKey) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

const keys = [
    1,
    2,
    3,
    4,
    5
]

function setupSkill (name, time) {
    $(`.skill-title`).html(name);

    randomLeft = Math.random() * 90;
    randomLeft = randomLeft >= 20 && randomLeft || 20
    randomLeft = randomLeft <= 80 && randomLeft || 80

    randomWidth = Math.random() * 5;
    randomWidth = randomWidth >= 2 && randomWidth || 2
    randomWidth = randomWidth <= 5 && randomWidth || 5

    var key = keys[Math.floor(Math.random()*keys.length)];

    currentKey = key;

    $(`#bar-select`).html(key)
    $(`#bar-select`).css(`left`, ``+randomLeft+`%`);
    $(`#bar-select`).css(`width`, ``+randomWidth+`vh`);

    bool = false;

    $(`.main-container`).show();

    $(".skill-bar-inner").stop().css({"width": 0}).animate({
        width: '100%'
      }, {
        duration: parseInt(time),
        complete: function() {
            $(`.main-container`).hide(function() {
                $.post('https://zero-skill/done', JSON.stringify({
                    valid : bool,
                }));
            });
        }
    });
}   


$(() => {
    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 49:
                e.preventDefault();
                var val = valid(1)
                bool = val

                if (!bool) {
                    cancelBar();
                } else {
                    Finished();
                }
                break;
            case 50:
                e.preventDefault();
                var val = valid(2)
                bool = val

                
                if (!bool) {
                    cancelBar();
                } else {
                    Finished();
                }
                break;
            case 51:
                e.preventDefault();
                var val = valid(3)
                bool = val
                
                if (!bool) {
                    cancelBar();
                } else {
                    Finished();
                }
                break;
            case 52:
                e.preventDefault();
                var val = valid(4)
                bool = val

                
                if (!bool) {
                    cancelBar();
                } else {
                    Finished();
                }
                break;
            case 53:
                e.preventDefault();
                var val = valid(5)
                bool = val

                if (!bool) {
                    cancelBar();
                } else {
                    Finished();
                }
                break;
                
        }
    });

    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "show":
                setupSkill(event.data.data.title, event.data.data.time);
       
        }
    })
})

function Finished() {
    $(".skill-bar-inner").stop().css({"width": 0}).animate({
        width: '100%'
      }, {
        duration: parseInt(0),
        complete: function() {
            $(`.main-container`).hide(function() {
                $.post('https://zero-skill/done', JSON.stringify({
                    valid : true,
                }));
            });
        }
    });
}

function cancelBar() {
    $(".skill-bar-inner").stop().css({}).animate({
        width: '0%'
      }, {
        duration: parseInt(0),
        complete: function() {
            $(`.main-container`).hide(function() {
                $.post('https://zero-skill/done', JSON.stringify({
                    valid : false,
                }));
            });
        }
    });
    
}