calling_someone = false;

// callCurrentChat = function () {
//     if (last_opened_chat) {
//         $.post('https://zero-phone/startCall', JSON.stringify({ number : last_opened_chat }));
//     }
// }

// cancelCalling = function() {
//     disableNotification();
//     $.post('https://zero-phone/cancelCalling', JSON.stringify({  }));
// }

// DenyCall = function () {
//     $.post('https://zero-phone/denyCall', JSON.stringify({}));
// }

// AcceptCall = function() {
//     $.post('https://zero-phone/acceptCall', JSON.stringify({}));
// }

// CancelCurrentCall = function () {
//     $.post('https://zero-phone/CancelCurrentCall', JSON.stringify({}));
// }

// hideCalling = function () {
//     $(`.phone-in-call-button`).fadeIn(250);
//     $(`.phone-container-notification`).fadeOut(150);
// }

// showCalling = function () {
//     $(`.phone-in-call-button`).fadeOut(250);
//     $(`.phone-container-notification`).fadeIn(150);
// }

callCurrentChat = function(x) {
    if (calling_someone) {return};

    calling_someone = true;

    if (x) {
        last_opened_chat = x;
        last_called = x
    }
    last_called = last_opened_chat

    $.post('https://zero-phone/GetContact', JSON.stringify({
        number : last_opened_chat,
    }), function(result) {
        var notification_call = `
        <div class="phone-container-notification call-notification-index" id="call-started">
        <div class="notification-calls" style="display: none;">
      
        </div>
        <div class="notification-icon" style="background-image: url(`+result.pf+`);"></div>
        <div class="notification-info">
            <div class="notification-title">`+result.name+`</div>
            <div class="notification-submessage">
                Aan het bellen..
            </div>
            <div class="notification-time-stamp">Nu</div>
        </div>
        </div>
        `

        $(`.notifications-doc`).prepend(notification_call);

        last_call_pf = result.pf
        last_call_name = result.name
        
        $("#call-started").animate({top: '0%'}, function(){
            setTimeout(function() {
                $.post('https://zero-phone/StartPhoneCall', JSON.stringify({
                    number : last_opened_chat,
                }), function(valid) {
                    if (valid) {
                        $(`#call-started`).find(`.notification-calls`).css(`display`, `flex`)
                        $(`#call-started`).find(`.notification-calls`).html(`<i style="color: red;" onclick="CancelCalling()" class="fad fas fa-phone-slash"></i>`)
                        $(`#call-started`).find(`.notification-info`).find(`.notification-submessage`).html(`Overgaan bij speler..`);
                    } else {
                        $(`#call-started`).find(`.notification-info`).find(`.notification-submessage`).html(`Speler niet bereikbaar`);

                        setTimeout(function(){
                            $("#call-started").animate({top: '-120%'}, function(){
                                $("#call-started").remove();
                                $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : "call"}));
                                calling_someone = false;
                            });
                        }, 2000)
                    }
                });
            }, 2000)
        });
    });
}

BeingCalled = function(number) {
    $.post('https://zero-phone/GetContact', JSON.stringify({
        number : number,
    }), function(result) {
        current_caller = number;
        var notification_call = `
        <div class="phone-container-notification call-notification-index" id="call-beingcalled">
        <div class="notification-calls">
            <i style="color: green;" onclick="acceptCall()" class="fas fa-phone"></i>
            <i style="color: red;" onclick="denyCall()" class="fad fa-phone-slash"></i>
        </div>
        <div class="notification-icon" style="background-image: url(`+result.pf+`);"></div>
        <div class="notification-info">
            <div class="notification-title">`+result.name+`</div>
            <div class="notification-submessage">
                Gesprek gestart..
            </div>
            <div class="notification-time-stamp">Nu</div>

        </div>
        </div>
        `

        if (phone_toggled == false) {
            $(`.phone-main-container`).animate({bottom: `-40%`}, 500)
        }

        last_call_pf = result.pf
        last_call_name = result.name

        $(`.notifications-doc`).prepend(notification_call);

        $("#call-beingcalled").animate({top: '0%'}, function(){
            
        });
    });
}


denyCall = function() {
    if (current_caller) {
        denyCallNum = current_caller;
        current_caller = undefined;
    
        $(`#call-beingcalled`).find(`.notification-info`).find(`.notification-submessage`).html(`Gesprek geweigerd..`);
        
    
        setTimeout(function(){
            $("#call-beingcalled").animate({top: '-120%'}, function(){
                $("#call-beingcalled").remove();
            
                $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : "call"}));
                $.post('https://zero-phone/DenyCaller', JSON.stringify({
                    number : denyCallNum,
                }));
                addHistoryCall(denyCallNum, "Afgewezen", "red")
            });
        }, 2000)
    }
}

currentCallDenied = function() {
    $(`#call-started`).find(`.notification-info`).find(`.notification-submessage`).html(`Gesprek is geweiegerd..`);
    $(`#call-started`).find(`.notification-calls`).css(`display`, `none`)

    addHistoryCall(last_called, "Afgewezen", "red")

    setTimeout(function(){
        $("#call-started").animate({top: '-120%'}, function(){
            $("#call-started").remove();
            $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : "call"}));
            calling_someone = false;
        });
    }, 2000)
}

acceptCall = function() {
    if (current_caller) {
        $.post('https://zero-phone/AcceptCaller', JSON.stringify({
            number : current_caller,
        }));
    }
}

CancelCalling = function() {
    $.post('https://zero-phone/CancelCallingPerson', JSON.stringify({
        number : last_opened_chat,
    }));
    addHistoryCall(last_opened_chat, "Geannuleerd", "red")
}

cancelCurrentCall = function() {
    if (ongoing_call_number) {
        $.post('https://zero-phone/CancelOngoingCall', JSON.stringify({
            number : ongoing_call_number,
        }));
    }
}

CallAccepted = function(number) {
    ongoing_call_number = number;

    addHistoryCall(ongoing_call_number, "Verbonden", "green")

    $(`.call-notification-index`).html(`
        <div class="notification-calls">
            <i style="color: red;" onclick="cancelCurrentCall()" class="fad fas fa-phone-slash"></i>
        </div>
        <div class="notification-icon" style="background-image: url(`+last_call_pf+`);"></div>
        <div class="notification-info">
            <div class="notification-title">`+last_call_name+`</div>
            <div class="notification-submessage">
                00:00 - Verbonden
            </div>
            <div class="notification-time-stamp">Nu</div>
        </div>
    `)
    
}

currentCallHangup = function() {
    $(`.call-notification-index`).find(`.notification-info`).find(`.notification-submessage`).html(`Verbinding verbroken..`);
    $(`.call-notification-index`).find(`.notification-calls`).remove()

    $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : "call"}));

    setTimeout(function() {
        $(".call-notification-index").animate({top: '-120%'}, function(){
            $(".call-notification-index").remove();
            $.post('https://zero-phone/RemoveAllCallStatuses', JSON.stringify({}));
            calling_someone = false
        });
    }, 2000)
}

cancelledByCaller = function() {
    $(`.call-notification-index`).find(`.notification-info`).find(`.notification-submessage`).html(`Gesprek geannuleerd..`);
    $(`.call-notification-index`).find(`.notification-calls`).remove()

    setTimeout(function() {
        $(".call-notification-index").animate({top: '-120%'}, function(){
            $(".call-notification-index").remove();
            $.post('https://zero-phone/RemoveAllCallStatuses', JSON.stringify({}));
            calling_someone = false

            $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : "call"}));
        });
    }, 2000)
}

UpdateCallTimer = function(time) {
    $(`.call-notification-index`).find(`.notification-info`).find(`.notification-submessage`).html(time);
}