window.addEventListener('message', function (event) {
    let item = event.data;

    if (item.action == "show") {
        var element = document.getElementById(item.index);
        if (element) {
            $(element).fadeIn(250);
            if (item.status) {
                $(element).removeClass('unlocked');
                $(element).addClass('locked');
                $(element).css({"border-left": "rgb(11, 131, 7) solid 0.3vh !important"});
                inner = `<div class="text">`+item.text+`</div>`;
            } else {
                $(element).removeClass('locked');
                $(element).addClass('unlocked');
                $(element).css({"border-left": "rgb(158, 23, 23) solid 0.3vh !important"});
                inner = `<div class="text">`+item.text+`</div>`;
            }

            item.x = item.x * 100
            item.y = item.y * 100


            element.style.left = ``+item.x+`%`
            element.style.top = ``+item.y+`%`
            
            element.innerHTML = inner;
        } else {
            if (item.status) {
                var inner = `<div id="`+item.index+`" class="lock locked" style="top: 50px;"><i class="fas fa-lock"></i><div class="text">`+item.text+`</div></div>`;
                $(`#body`).append(inner);
            } else {
                var inner = `<div id="`+item.index+`" class="lock unlocked" style="top: 50px;"><i class="fas fa-unlock"></i><div class="text">`+item.text+`</div></div>`;
                $(`#body`).append(inner);
            }
        }
    } else if (item.action == 'hide') {
        var element = document.getElementById(item.index);
        $(element).fadeOut(250);
    }
});
