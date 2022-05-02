
    
    // $(`.notification-icon`).css(`background-image`, `url(`+icon+`)`)
    // $(`.notification-title`).html(title)
    // $(`.notification-submessage`).html(subtitle)

    // $(`.phone-container-notification`).fadeIn(500)

    // if (phone_toggled == false) {
    //     $(`.phone-main-container`).animate({bottom: `-40%`}, 500)
    // }

    // if (time) {
    //     setTimeout(function () {
    //         disableNotification()
    //     }, time)
    // }

    // <div class="notification-calling-buttons">
    //         <div class="calling-button in-call" onclick="hideCalling()" style="background-color: rgb(209, 174, 58); display: none;"><i class="fas fa-eye-slash"></i></div>
    //         <div class="calling-button in-call" onclick="CancelCurrentCall()" style="background-color: rgba(165, 36, 36, 1); display: none;"><i class="fad fa-phone-slash"></i></div>

    //         <div class="calling-button being-called" onclick="DenyCall()" style="background-color: rgba(165, 36, 36, 1); display: none;"><i class="fad fa-phone-slash"></i></div>
    //         <div class="calling-button being-called" onclick="AcceptCall()" style="background-color: rgba(38, 145, 38, 1); display: none;"><i class="fad fa-phone-volume"></i></div>

    //         <div class="calling-button calling-person" onclick="cancelCalling()" style="background-color: rgba(165, 36, 36, 1); display: none;"><i class="fad fa-phone-slash"></i></div>
    //         <div class="calling-button" style="background-color: rgba(38, 145, 38, 1); display: none;"><i class="fad fa-phone-volume"></i></div>
    //     </div>

    
enableNotification = function (index, icon, title, subtitle, time) {
    var notification_container = `
    <div class="phone-container-notification" id="`+index+`">
    <div class="notification-icon" style="background-image: url(`+icon+`);"></div>
    <div class="notification-info">
        <div class="notification-title">`+title+`</div>
        <div class="notification-submessage">
            `+subtitle+`
        </div>
        <div class="notification-time-stamp">Nu</div>
    </div>
    </div>
    `
    $(`.notifications-doc`).prepend(notification_container);

    if (phone_toggled == false) {
        $(`.phone-main-container`).animate({bottom: `-40%`}, 500)
    }


    $("#"+index+"").animate({top: '0%'}, function(){
        setTimeout(function(){
            $("#"+index+"").animate({top: '-120%'}, function(){
                $("#"+index+"").remove();
                $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : index}));
            });
        }, time)
    });
}

disableNotification = function() {
    $(`.phone-container-notification`).fadeOut(500, function () { notification_enabled = false })
    if (phone_toggled == false) {
        $(`.phone-main-container`).animate({bottom: `-110%`}, 500)
    }
}

$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "enableNotification":
                if (event.data.ignoreApp == last_app) {
                    $.post('https://zero-phone/removeNotificationIndex', JSON.stringify({index : event.data.index}));
                    return;
                }  
                enableNotification(event.data.index, event.data.icon, event.data.title, event.data.subtitle, event.data.time)
                break;
            case "disableNotification":
                disableNotification()
                break;
            case "fadeIn":
                $(`.calling-button`).fadeOut(0)
                $(`.`+event.data.type+``).fadeIn(0)
                break;
            case "updateCallTime":
                UpdateCallTimer(event.data.time)
                break;

            case "calling:trigger":
                BeingCalled(event.data.number);
                break;
            case "calling:accepted":
                CallAccepted(event.data.number)
                break;
            case "calling:denied":
                currentCallDenied(event.data.number)
                break;
            case "calling:hangup":
                currentCallHangup(event.data.number)
                break;
            case "calling:cancelled":
                cancelledByCaller();
                break;
        }
    })
})
