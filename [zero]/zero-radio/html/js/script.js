$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            ZeroR.SlideUp()
        }

        if (event.data.type == "close") {
            ZeroR.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://zero-radio/escape', JSON.stringify({}));
            ZeroR.SlideDown()
        } else if (data.which == 13) { // Escape key
            $.post('http://zero-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

ZeroR = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://zero-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://zero-radio/leaveRadio');
});

ZeroR.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

ZeroR.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}