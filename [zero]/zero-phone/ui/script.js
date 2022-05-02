phone_toggled = false
last_app = "xxx"

$(() => {
    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                closeAllSubs();
        }
    });

    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "hotbar":
                SetupHotbar(event.data.apps);
                break;
            case "apps":
                SetupApps(event.data.apps);
                break;
            case "togglePhone":
                TogglePhone(event.data.bool);
                break;
            case "PlayerData":
                SetupUserData(event.data.playerdata);
                break;
            case "PhoneData":
                SetupPhoneData(event.data.phonedata);
                break;
            case "paypal-activity":
                PayPalActivity(event.data.data);
                break;
            case "PayPalContacts":
                PayPalContacts(event.data.PayPalContacts)
                break;
            case "contacts":
                SetupContacts(event.data.contacts)
                break;
            case "addMessage":
                AddWhatsappMessage(event.data.index, event.data.data)
                break
            case "Chats":
                SetupChats(event.data.chats)
                break;
            case "PlayerVehicles":
                SetupPlayerVehicles(event.data.vehicles)
                break;
            case "mail":
                SetupMail(event.data)
                break;
            case "time":
                $(`.title-element-time`).html(event.data.time)
                break;
        }
    });

    var inputs = document.querySelectorAll(`input`)

    $.each(inputs, function(k, v){
        v.oninput = function() {
            $.post('https://zero-phone/toggleAllControls', JSON.stringify({}));
        }
    })

});

cancelInputs = function () {
    $.post('https://zero-phone/toggleAllControls', JSON.stringify({}));
}

SetupHotbar = function (apps) {
    $(`.phone-content-bottom`).html(``);
    
    $.each(apps, function(k, v){
        if (v.font_icon) {
            var innerApp = `
            <div class="phone-app" onclick="OpenApp('`+v.app+`')">
            <div class="phone-app-background" style="background: `+v.background_color+`; color: `+v.app_color+`">`+v.font_icon+`</div>
            </div>
            `
        } else {
            var innerApp = `
            <div class="phone-app" onclick="OpenApp('`+v.app+`')">
            <div class="phone-app-background" style="background-image: url(`+v.icon+`);"></div>
            </div>
            `
        }

        $(`.phone-content-bottom`).append(innerApp)
    });
}

SetupApps = function (apps) {
    $(`.phone-container-apps`).html(``);
    
    $.each(apps, function(k, v){
        if (v.font_icon) {
            var innerApp = `
            <div class="phone-app" onclick="OpenApp('`+v.app+`')">
            <div class="phone-app-background" style="background: `+v.background_color+`; color: `+v.app_color+`">`+v.font_icon+`</div>
            <div class="phone-app-name">`+v.name+`</div>
            </div>
            `
        } else {
            var innerApp = `
            <div class="phone-app" onclick="OpenApp('`+v.app+`')">
            <div class="phone-app-background" style="background-image: url(`+v.icon+`);"></div>
            <div class="phone-app-name">`+v.name+`</div>
            </div>
            `
        }

        $(`.phone-container-apps`).append(innerApp)
    });
}

TogglePhone = function (bool) {
    phone_toggled = bool;
    $.post('https://zero-phone/IsInCall', JSON.stringify({bool : bool}), function(call) {
        if (call) {
            if (bool) {
                $(`.phone-main-container`).animate({bottom: `5vh`}, 500)
            } else {
                $(`.phone-main-container`).animate({bottom: `-40%`}, 500)
            }
        } else {
            if (bool) {
                $(`.phone-main-container`).animate({bottom: `5vh`}, 500)
            } else {
                $(`.phone-main-container`).animate({bottom: `-110%`}, 500)
                closeAllSubs()
                last_app = "" 
            }
        }
    });
}

OpenApp = function(app) {
   // $(`#`+app+``).animate({top: `0vh`}, 500)
    $(`#`+app+``).css(`top`, `0vh`);
    $(`#`+app+``).css(`display`, `none`);

    last_app = app;

    if (app == "services") {
        ServicesAppSync()
    } else if (app == "bills") {
        SetupBilling()
    };

    $(`#`+app+``).fadeIn(150);
}

SetupUserData = function(PlayerData) {
    $(`.roleplay_name`).html(``+PlayerData.PlayerData.firstname+` `+PlayerData.PlayerData.lastname+``)

    var first = PlayerData.PlayerData.firstname.charAt(0)
    var last = PlayerData.PlayerData.lastname.charAt(0)
    var full = first + `` + last

    $(`.rp_initials`).html(full)
    $(`.bank-saldo`).html(``+PlayerData.Money.bank+`,- EUR`)

    $(`.serives-myjob-name`).html(`Mijn baan: `+PlayerData.Job.label+``)

}

// no code

function AnimateCSS(element, animationName, callback) {
    const node = document.querySelector(element)
    if (node == null) {
        return;
    }
    node.classList.add('animated', animationName)

    function handleAnimationEnd() {
        node.classList.remove('animated', animationName)
        node.removeEventListener('animationend', handleAnimationEnd);

        if (typeof callback === 'function') callback()
    }

    node.addEventListener('animationend', handleAnimationEnd)
}


toggleAirplaneMode = function() {
    $.post('https://zero-phone/airplaneMode', JSON.stringify({}, function() {

    }));
}

SetupPhoneData = function(PhoneData) {
    if (PhoneData.Settings.airplanemode) {
        $(`#airplanemode`).addClass(`setting-enabled`)
    } else {
        $(`#airplanemode`).removeClass(`setting-enabled`)
    }

    if (PhoneData.Settings.background !== undefined) {
        $(`.background-image`).css(`background-image`, `url(`+PhoneData.Settings.background+`)`)
        $(`#background-input`).val(PhoneData.Settings.background);
    }

    if (PhoneData.PhoneData) {
        $(`#email-input`).val(PhoneData.PhoneData.email);
    }


    if (PhoneData.Whatsapp) {
        if (PhoneData.Whatsapp.pf) {
            $(`.contact-mycard-pf`).html(``)
            $(`.contact-mycard-pf`).css(`background-image`, `url(`+PhoneData.Whatsapp.pf+`)`)

            $(`.my-pf`).html(``)
            $(`.my-pf`).css(`background-image`, `url(`+PhoneData.Whatsapp.pf+`)`)
        } else {
            $(`.contact-mycard-pf`).html(PhoneData.Whatsapp.firstname[0])
            $(`.contact-mycard-pf`).css(`background-image`, `url()`)

            $(`.my-pf`).html(PhoneData.Whatsapp.firstname[0])
            $(`.my-pf`).css(`background-image`, `url()`)
        }

        if (PhoneData.Whatsapp.background) {
            $(`.chat-messages`).css(`background-image`, `url(`+PhoneData.Whatsapp.background+`)`)
        }

        $(`#wh-setting-pf`).val(PhoneData.Whatsapp.pf)
        $(`#wh-setting-background`).val(PhoneData.Whatsapp.background)

        $(`#whatsapp-setting-name`).html(PhoneData.Whatsapp.firstname + ' ' + PhoneData.Whatsapp.lastname)
    }
    $(`.phone-number-change`).html(PhoneData.Number);

    if (PhoneData.PayPal) {
        $(`#paypal-tag`).val(PhoneData.PayPal.tag)
        $(`#paypal-name`).val(PhoneData.PayPal.nickname)
        $(`#paypal-img`).val(PhoneData.PayPal.pf)


        $(`.paypal-acc-img`).css(`background-image`, `url(`+PhoneData.PayPal.pf+`)`)
    }
}

openBackgroundChange = function() {
    $(`#settings-background`).show();
    AnimateCSS(`#settings-background`, 'fadeInRight', function() {

    });
}

changeBackground = function() {
    var url = $(`#background-input`).val();
    $(`.background-image`).css(`background-image`, `url(`+url+`)`)
}

closeBackground = function() {
    var url = $(`#background-input`).val();
    
    $.post('https://zero-phone/backgroundImage', JSON.stringify({image : url}));

    AnimateCSS(`#settings-background`, 'fadeOutRight', function() {
        $(`#settings-background`).hide();
    });
}

closeAllSubs = function () {
    if (last_app) {
        //$(`#`+last_app+``).animate({top: `-100%`}, 500)
        $(`#`+last_app+``).fadeOut(150, function() {
            $(`#`+last_app+``).css(`top`, `-100vh`);
            $(`#`+last_app+``).css(`display`, `none`);
        });

        last_app = ""
    }
}

openDataPage = function () {
    $(`#settings-data`).show();
    AnimateCSS(`#settings-data`, 'fadeInRight', function() {

    });
}

closeDataPage = function () {
    var url = $(`#email-input`).val();

    $.post('https://zero-phone/dataPage', JSON.stringify({email : url}));

    AnimateCSS(`#settings-data`, 'fadeOutRight', function() {
        $(`#settings-data`).hide();
    });
}

PayPalActivity = function(data) {
    var inner = `
    <div class="history-bank">
    <div class="history-icon">
    <div class="icon-logo" style="background-image: url(`+data.icon+`);"></div>
    </div>
    <div class="history-information">
        <div class="history-title">`+data.title+`</div>
        <div class="history-subtitle">`+data.subtitle+`</div>
    </div>
    <div class="history-amount">`+data.amount+`</div>
    </div>
    `

    $(`.paypal-history`).prepend(inner);
}

openAccountPaypal = function() {
    $(`#paypal-account`).show();
    AnimateCSS(`#paypal-account`, 'fadeInRight', function() {

    });
}

PayPalCloseAccount = function() {
    AnimateCSS(`#paypal-account`, 'fadeOutRight', function() {
        $(`#paypal-account`).hide();
    });
}

savePayPal = function() {
    var nickname = $(`#paypal-name`).val();
    var pf = $(`#paypal-img`).val();
    var tag = $(`#paypal-tag`).val();
    
    $.post('https://zero-phone/PayPalSettings', JSON.stringify({
        nickname :nickname,
        pf:pf,
        tag:tag,
    }));
}

PayPalTransferPage = function() {
    $(`.paypal-info-foundtarget`).html(``)
    $(`#paypal-transfer-tag`).val(``);
    $(`#paypal-transfer-reason`).val(``);
    $(`#paypal-transfer-amount`).val(``);
    $(`#sendMoneyTargetImg`).css(`background-image`, `url(https://raceyaya.com/public/images/paypal.png)`)

    var element = document.getElementById(`send-money-confirm`)
    element.onclick = SendMoney

    $(`#paypal-transfer`).show();
    AnimateCSS(`#paypal-transfer`, 'fadeInRight', function() {

    });
}
PayPalCloseTransfer = function() {
    AnimateCSS(`#paypal-transfer`, 'fadeOutRight', function() {
        $(`#paypal-transfer`).hide();
    });
}

SendMoney = function() {
    var accounttag = $(`#paypal-transfer-tag`).val();

    $.post('https://zero-phone/GetPayPalAccount', JSON.stringify({
        tag : accounttag,
    }), function(result) {
        if (result) {
            $(`.paypal-info-foundtarget`).html(``)

            $(`#sendMoneyTargetImg`).css(`background-image`, `url(`+result.pf+`)`)

            var amount = parseFloat($(`#paypal-transfer-amount`).val())

            if (amount) {
                $(`#send-money-confirm`).html(`Bevestigen`);

                var element = document.getElementById(`send-money-confirm`)
                element.onclick = ConfirmPaypalSend
            } else {
                $(`.paypal-info-foundtarget`).html(`Ongeldige hoeveelheid.`)
            }
            
        } else {
            $(`.paypal-info-foundtarget`).html(`We kunnen dit account niet vinden.`)
            $(`#sendMoneyTargetImg`).css(`background-image`, `url(https://raceyaya.com/public/images/paypal.png)`)

            $(`#send-money-confirm`).html(`Geld versturen`);
            var element = document.getElementById(`send-money-confirm`)
            element.onclick = SendMoney
        }
    });
}

ConfirmPaypalSend = function() {
    var accounttag = $(`#paypal-transfer-tag`).val();
    var amount = parseFloat($(`#paypal-transfer-amount`).val())
    var reason = $(`#paypal-transfer-reason`).val()

    $.post('https://zero-phone/TransferMoney', JSON.stringify({
        tag : accounttag,
        amount : amount,
        reason : reason,
    }));

    $(`.paypal-info-foundtarget`).html(``)
    $(`#paypal-transfer-tag`).val(``);
    $(`#paypal-transfer-reason`).val(``);
    $(`#paypal-transfer-amount`).val(``);
    $(`#sendMoneyTargetImg`).css(`background-image`, `url(https://raceyaya.com/public/images/paypal.png)`)


    $(`#send-money-confirm`).html(`Geld versturen`);
    var element = document.getElementById(`send-money-confirm`)
    element.onclick = SendMoney
}

PayPalContacts = function(Contacs) {
    $(`.paypal-recent`).html(``);

    $.each(Contacs, function(k, v){
        var inner = `
        <div class="paypal-contact" onclick="PrepareMoneyTransfer(event, '`+v.tag+`')">
        <div class="paypal-contact-icon">
            <div class="icon-logo" style="background-image: url(`+v.pf+`);"></div>
        </div>
        <div class="paypal-contact-name">`+v.nickname+`</div>
        </div>  
        `
        $(`.paypal-recent`).prepend(inner)
    });
}

PrepareMoneyTransfer = function(event, tag) {
    PayPalTransferPage()
    $(`#paypal-transfer-tag`).val(tag);
}

closeMyCard = function(){
    AnimateCSS(`#contacts-mycard`, 'fadeOutRight', function() {
        $(`#contacts-mycard`).hide();
    });
}

displayMyCard = function () {
    $(`#contacts-mycard`).show();
    AnimateCSS(`#contacts-mycard`, 'fadeInRight', function() {

    });
}

closeAddContact = function () {
    AnimateCSS(`#contacts-add`, 'fadeOutRight', function() {
        $(`#contacts-add`).hide();
    });
}

openAddContact = function () {
    $(`#contacts-add`).show();
    AnimateCSS(`#contacts-add`, 'fadeInRight', function() {

    });
}

addContact = function() {
    closeAddContact()

    var number = $(`#add-number`).val();
    var firstname = $(`#add-firstname`).val();
    var lastname = $(`#add-lastname`).val();

    $.post('https://zero-phone/addContact', JSON.stringify({
        number : number,
        firstname : firstname,
        lastname : lastname,
    }));
}



SetupSubContacts = function(v) {
    var inner = `
    <div class="contact">
        <div class="contact-icon" style="background-image: url();"></div>
        <div class="contact-name">`+v.firstname+` `+v.lastname+`</div>
    </div> 
    `

    return
}
SetupContacts = function (contacts) {
    $(`.contacts-contact-list`).html(``)

    $.each(contacts, function(k, v){
        var inner = `
        <div class="contacts-cat">
        <div class="cat-title">`+k+`</div>
        <div class="cat-contacts" id="contacts-`+k+`">
        
        </div>
        </div>
        `

        $(`.contacts-contact-list`).append(inner)

        $.each(v, function(x, y){
            var inner = `
            <div class="contact" onclick="openContact(event, '`+y.number+`', '`+y.firstname+`', '`+y.lastname+`', '`+y.pf+`')">
            `+getIcon(y)+`
            <div class="contact-name">`+y.firstname+` `+y.lastname+`</div>
            </div> 
            `

            $(`#contacts-`+k+``).append(inner)
        });
    });
}

getIcon = function(v) {
    if (v.pf) {
        return `<div class="contact-icon" style="background-image: url(`+v.pf+`);"></div>`
    } else {
        return `<div class="contact-icon" style="background-color: rgb(72, 139, 66)">`+v.firstname[0]+`</div>`
    }
}

openContact = function(event, number, firstname, lastname, img) {
    $(`#contact-number-card`).html(number)
    $(`#contact-firstname-card`).val(firstname)
    $(`#contact-lastname-card`).val(lastname)

    if (img !== "undefined") {
        $(`.contact-mycard-pf2`).html(``);
        $(`.contact-mycard-pf2`).css(`background-image`, `url(`+img+`)`)
    } else {
        $(`.contact-mycard-pf2`).css(`background-image`, `url()`)
        $(`.contact-mycard-pf2`).html(firstname[0])
    }

    last_number = number;

    openContactCard();
}

closeContactCard = function () {
    AnimateCSS(`#contacts-contactCard`, 'fadeOutRight', function() {
        $(`#contacts-contactCard`).hide();
    });
}

openContactCard = function () {
    $(`#contacts-contactCard`).show();
    AnimateCSS(`#contacts-contactCard`, 'fadeInRight', function() {

    });
}

DeleteContact = function () {
    if (last_number) {
        $.post('https://zero-phone/removeContact', JSON.stringify({
            number : last_number,
        }));
        closeContactCard()
    }
}

EditContact = function () {
    if (last_number) {
        var firstname = $(`#contact-firstname-card`).val();
        var lastname = $(`#contact-lastname-card`).val();

        $.post('https://zero-phone/editContact', JSON.stringify({
            number : last_number,
            firstname : firstname, 
            lastname : lastname,
        }));
        closeContactCard()
    }
}

closeChat = function() {
    AnimateCSS(`#whatsapp-chat`, 'fadeOutRight', function() {
        $(`#whatsapp-chat`).hide();
    });
}

OpenWhatsapp = function () {
    closeAllSubs();
    OpenApp(`whatsapp`)

    setTimeout(() => {
        OpenChat(last_number)
    }, 200);
}

OpenChat = function (number) {
    $.post('https://zero-phone/GetContact', JSON.stringify({
        number : number,
    }), function(result) {
        if (result) {
            $(`.current-chat-icon`).html(result.name[0])

            if (result.pf) {
                $(`.current-chat-icon`).html(``);
                $(`.current-chat-icon`).css(`background-image`, `url(`+result.pf+`)`)
            } else {
                $(`.current-chat-icon`).html(result.name[0])
            }

            $(`.current-chat-name`).html(result.name)

            $(`.chat-messages`).html(``)

            last_opened_chat = result.number;

            SetupChatHistory(last_opened_chat, result.history.history)

            DisplayChat()
        }
    });
}

DisplayChat = function () {
    $(`#whatsapp-chat`).show();
    AnimateCSS(`#whatsapp-chat`, 'fadeInRight', function() {

    });
}

SendWhatsappMessage = function () {
    var message = $(`#whatsapp-input`).val();
    if (message !== "") {
        if (last_opened_chat) {
            $.post('https://zero-phone/SendMessage', JSON.stringify({
                number : last_opened_chat,
                message : message,
            }));
            $(`#whatsapp-input`).val(``)
        }
    }
}

SetupChatHistory = function (number, history) {
 
    $.each(history, function(k, v){
        if (v.sender == number) {
            inner = `
            <div class="left-message">
            <div class="message">
            <div class="message-title-w-left">`+v.senderName+`</div>
            ${v.img !== undefined ? `<div class="message-img" onclick="view_picture('`+v.img+`')" style="background-image: url(`+v.img+`)"></div>` : ""}
            <div class="message-text">`+v.message+`</div>
            </div>
            </div>
            `
        } else {
            inner = `
            <div class="right-message">
            <div class="message">
            <div class="message-title-w-right">`+v.senderName+`</div>
            ${v.img !== undefined ? `<div class="message-img" onclick="view_picture('`+v.img+`')" style="background-image: url(`+v.img+`)"></div>` : ""}
            <div class="message-text">`+v.message+`</div>
            </div>
            </div>
            `
        }
        $(`.chat-messages`).append(inner)
    });


    setTimeout(function() {
        var element = document.getElementById('chat-messages');
        element.scrollTop = element.scrollHeight;
    }, 100)
}



AddWhatsappMessage = function (number , data) {
    if (number == last_opened_chat) {
        if (data.sender == number) {
            inner = `
            <div class="left-message">
            <div class="message">
            <div class="message-title-w-left">`+data.senderName+`</div>

            ${data.img !== undefined ? `<div class="message-img" onclick="view_picture('`+data.img+`')" style="background-image: url(`+data.img+`)"></div>` : ""}

            <div class="message-text">`+data.message+`</div>
            </div>
            </div>
            `
        } else {
            inner = `
            <div class="right-message">
            <div class="message">
            <div class="message-title-w-right">`+data.senderName+`</div>
            ${data.img !== undefined ? `<div class="message-img" onclick="view_picture('`+data.img+`')" style="background-image: url(`+data.img+`)"></div>` : ""}
            <div class="message-text">`+data.message+`</div>
            </div>
            </div>
            `
        }
        $(`.chat-messages`).append(inner)

        var element = document.getElementById('chat-messages');
        element.scrollTop = element.scrollHeight;
    }
}

SetupChats = function(chats) {
    $(`.whatsapp-current-chats`).html(``);
    $.each(chats, function(k, v){
        if (v.whatsapp.pf) {
            var inner = `
            <div class="whatsapp-conversation" onclick="OpenChat('`+v.number+`')">
            <div class="conversation-icon" style="background-image: url(`+v.whatsapp.pf+`)"></div>
            <div class="conversation-info">
                <div class="info-title">`+v.whatsapp.firstname+` `+v.whatsapp.lastname+`</div>
                <div class="info-subtitle">`+v.last_message+`</div>
            </div>
            </div>
            `
        } else {
            var inner = `
            <div class="whatsapp-conversation" onclick="OpenChat('`+v.number+`')">
            <div class="conversation-icon" style="background-image: url()">`+v.whatsapp.firstname[0]+`</div>
            <div class="conversation-info">
                <div class="info-title">`+v.whatsapp.firstname+` `+v.whatsapp.lastname+`</div>
                <div class="info-subtitle">`+v.last_message+`</div>
            </div>
            </div>
            `  
        }
    

        $(`.whatsapp-current-chats`).prepend(inner)
    });
}

OpenChats = function (event) {
    $(`.whatsapp-bottom-option`).removeClass("select-whatsapp");
    event.currentTarget.classList.add("select-whatsapp")

    closeHistory()
    closeSettings()
}

OpenHistoryCalls = function(event) {
    $(`.whatsapp-bottom-option`).removeClass("select-whatsapp");
    event.currentTarget.classList.add("select-whatsapp")
    closeSettings()

    $(`#whatsapp-history`).show();
    $(`#whatsapp-history`).css(`left`, `0vh`)
}

OpenWhatsappSettings = function (event) {
    $(`.whatsapp-bottom-option`).removeClass("select-whatsapp");
    event.currentTarget.classList.add("select-whatsapp")
    closeHistory()

    $(`#whatsapp-settings`).show();
    $(`#whatsapp-settings`).css(`left`, `0vh`)
}

closeHistory = function () {
    console.log('close')
    $(`#whatsapp-history`).hide();
    $(`#whatsapp-history`).css(`left`, `100%`) 
}

closeSettings = function () {
    $(`#whatsapp-settings`).hide();
    $(`#whatsapp-settings`).css(`left`, `100%`)
}

SaveWhatsappSettings = function () {
    var pf = $(`#wh-setting-pf`).val()
    var background = $(`#wh-setting-background`).val()

    $.post('https://zero-phone/SetWhatsappSettings', JSON.stringify({
        pf : pf,
        background : background,
    }));
}

view_picture = function(url) {
    $(`.iphone-view-image`).css(`background-image`, `url(`+url+`)`)
    $(`.iphone-view-image`).fadeIn(250);
}
close_view_img = function() {
    $(`.iphone-view-image`).fadeOut(250);
}

ServicesAppSync = function () {
    $.post('https://zero-phone/GetActiveServices', JSON.stringify({
    }), function(result) {
        $(`.lawyer-current-option`).html(``)

        $.each(result, function(k, v){
            var inner = `
            <div class="current-action-border">
                <div class="current-action-title">Beschikbare `+k+`</div>
                <div class="current-action-laywers" id="active-`+k+`">    
                </div>
            </div>
            `

            $(`.lawyer-current-option`).append(inner)


            $.each(v, function(x, y){
                var inner = `
                <div class="active-lawyer">
                <div class="lawyer-icon">`+y.PlayerData.firstname[0]+`</div>
                <div class="lawyer-info">
                    <div class="lawyer-name">`+y.PlayerData.firstname+` `+y.PlayerData.lastname+`</div>
                    <div class="lawyer-number">`+y.PlayerData.number+`</div>
                </div>

                <div class="notification-calls">
                    <i style="color: green;" onclick="callCurrentChat('`+y.PlayerData.number+`')" class="fas fa-phone"></i>
                </div>
                </div>
                `
                $(`#active-`+k+``).append(inner)
            });
        });
    });
}

SetupMail = function (data) {

    var inner = `
    <div class="mail-item" onclick="openMail(event)" data-name="`+data.name+`" data-title="`+data.title+`" data-x="`+data.location.x+`" data-y="`+data.location.y+`" data-z="`+data.location.z+`" data-text="`+data.text+`">
    <div class="mail-icon" style="background-image: url(`+data.icon+`)">

    </div>
    <div class="mail-data">
        <div class="main-data">`+data.name+`</div>
        <div class="sub-data">`+data.title+`</div>
    </div>
    </div>
    `

    $(`.mail-inbox`).prepend(inner)
}

openMail = function(event) {
    $(`#sender-mail`).html(`Sender: `+event.currentTarget.dataset.name+``)
    $(`.mail-display-title`).html(event.currentTarget.dataset.title)
    $(`.mail-display-text`).html(event.currentTarget.dataset.text)


    if (event.currentTarget.dataset.x !== undefined) {
        $(`.mail-button-location`)[0].dataset.x = event.currentTarget.dataset.x
        $(`.mail-button-location`)[0].dataset.y = event.currentTarget.dataset.y
        $(`.mail-button-location`)[0].dataset.z = event.currentTarget.dataset.z

        $(`.mail-button-location`).fadeIn(150);
    } else {
        $(`.mail-button-location`).fadeOut(150);
    }

    $(`#mail-read`).show();
    AnimateCSS(`#mail-read`, 'fadeInRight', function() {
 
    });
}


SetupLocationMail = function (event) {
    SOSsetLocation(event);
}

closeMail = function(event) {
    AnimateCSS(`#mail-read`, 'fadeOutRight', function() {
        $(`#mail-read`).hide();
    });
}

CallPerson = function() {
    if (last_number) {
        callCurrentChat(last_number)
    }
}

addHistoryCall = function(number, type, color) {
    $.post('https://zero-phone/GetContact', JSON.stringify({
        number : number,
    }), function(result) {
        var inner = `
        <div class="whatsapp-history-call">
        <div class="history-call-type" style="color: `+color+`">`+type+`</div>
        <div class="history-call-icon" style="background-image: url(`+result.pf+`);"></div>
        <div class="history-call-number">Telefoon: `+number+`</div>
        <div class="history-call-name">`+result.name+`</div>
        <div class="notification-calls">
            <i style="color: green;" onclick="callCurrentChat('`+number+`')" class="fas fa-phone"></i>
        </div>
        </div>
        `
        $(`.whatsapp-history-border`).prepend(inner);
    });
}

callThisNummer = function() {
    var number = $(`#call-history-input`).val();
    if (number !== undefined && number !== "") {
        callCurrentChat(number)
    }
}

toggleDuty = function() {
    $.post('https://zero-phone/toggleDuty')
    ServicesAppSync()
}

shownExtra = false
toggleExtraSends = function() {
    if (shownExtra) {
        $(`.extra-send-options`).fadeOut(150);
        shownExtra = false;
    } else {
        $(`.extra-send-options`).fadeIn(150);
        shownExtra = true;
    }
}

SendWhatsappIMG = function() {
    var message = $(`#whatsapp-input`).val();

    if (message !== "") {
        if (last_opened_chat) {
            $.post('https://zero-phone/SendMessage', JSON.stringify({
                number : last_opened_chat,
                message : "Image.png",
                image : message,
            }));
            $(`#whatsapp-input`).val(``)

            $(`.extra-send-options`).fadeOut(150);
            shownExtra = false;
        }
    }
}