twitter = {}
twitter['send_toggle'] = false
twitter['search_toggle'] = false

twitter_send_message_disp = function() {
    if (twitter['send_toggle']) {
        twitter['send_toggle'] = false
        $(`.twitter-send-message`).fadeOut(0);
    } else {
        $(`.twitter-search-message`).fadeOut(0);
        $(`.twitter-send-message`).fadeIn(0);
        twitter['send_toggle'] = true
        twitter['search_toggle'] = false
    }
}

twitter_search_disp = function() {
    if (twitter['search_toggle']) {
        twitter['search_toggle'] = false
        $(`.twitter-search-message`).fadeOut(0);
    } else {
        $(`.twitter-send-message`).fadeOut(0);
        $(`.twitter-search-message`).fadeIn(0);
        twitter['search_toggle'] = true
        twitter['send_toggle'] = false
    }
}

open_settings = function() {
    $(`#twitter_settings`).show()
    $(`#twitter_settings`).css(`left`, `0vh`)

    if (twitter_accounts && twitter_myid) {
        $(`#twitter_pic`).val(twitter_accounts[twitter_myid].avatar);
        $(`#twitter_nickname`).val(twitter_accounts[twitter_myid].nickname);
    }
}
cancel_settings = function() {
    $(`#twitter_settings`).hide()
    $(`#twitter_settings`).css(`left`, `100%`)
}

twitter_accounts = "";
twitter_myid = "";
twitter_messages = "";


save_twitter_settings = function() {
    var profilepic = $(`#twitter_pic`).val();
    var nick = $(`#twitter_nickname`).val();
    $.post('http://zero-phone/setTwitterSettings', JSON.stringify({
        nick : nick,
        pic : profilepic,
    }))
}

send_twitter_img = function() {
    var message = $(`.twitter-span`).html();
    $.post('http://zero-phone/sendTwitterMessage', JSON.stringify({
        message : message,
        type : "img",
    }))
    twitter_send_message_disp();
}

send_twitter_message = function() {
    var message = $(`.twitter-span`).html();

    $.post('http://zero-phone/sendTwitterMessage', JSON.stringify({
        message : message,
        type : "msg",
    }))
    twitter_send_message_disp();
}

getUserName = function(v) {
    if (v.verified == true) {
        return ``+v.name+`  <div class="verified-icon" style="background-image: url(https://th.bing.com/th/id/R.920f42a6efede49e6a327ba8b1a2e8bd?rik=eY4MvmFa9DwbUQ&pid=ImgRaw&r=0);"></div>`;
    } else {
        return v.name
    }
}

syncMessagesTwitter = function(msg) {

    if (msg == undefined) {
        msg = twitter_messages;
    }
    
    twitter_messages = msg;
    $(`.twitter-messages-container`).html(``); 
    $.each(msg, function(k, v){
        if (v.type == "msg") {
            var messageInner = `
            <div class="twitter-message">
            <div class="twitter-message-inner-main">
                <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                <div class="twitter-message-inner">
                    <div class="twitter-message-name">
                        <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                        <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                        <div class="twitter-message-time"></div>
                    </div>
                    <div class="twitter-message-content">`+v.message+`</div>
                </div>
            </div>
            <div class="twitter-bottom-options">
                <div class="twitter-options-inner">
                    <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                    <i class="far fa-heart"></i>
                    <i class="fas fa-download"></i>
                </div>
            </div>
            </div>
            `
        } else if (v.type == "img") {
            var messageInner = `
            <div class="twitter-message">
            <div class="twitter-message-inner-main">
                <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                <div class="twitter-message-inner">
                    <div class="twitter-message-name">
                        <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                        <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                        <div class="twitter-message-time"></div>
                    </div>
                    <div class="twitter-message-img" onclick="view_picture('`+v.message+`')" style="background-image: url(`+v.message+`);"></div>
                </div>
            </div>
            <div class="twitter-bottom-options">
                <div class="twitter-options-inner">
                    <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                    <i class="far fa-heart"></i>
                    <i class="fas fa-download"></i>
                </div>
            </div>
            </div>
            `
        }
        $(`.twitter-messages-container`).append(messageInner);

    });
}

sync_on_name = function() {
    $.post('http://zero-phone/SortOnName', JSON.stringify({
    }), function(msg) {
        $(`.twitter-messages-container`).html(``); 
        $.each(msg, function(k, v){
            if (v.type == "msg") {
                var messageInner = `
                <div class="twitter-message">
                <div class="twitter-message-inner-main">
                    <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                    <div class="twitter-message-inner">
                        <div class="twitter-message-name">
                            <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                            <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                            <div class="twitter-message-time"></div>
                        </div>
                        <div class="twitter-message-content">`+v.message+`</div>
                    </div>
                </div>
                <div class="twitter-bottom-options">
                    <div class="twitter-options-inner">
                        <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                        <i class="far fa-heart"></i>
                        <i class="fas fa-download"></i>
                    </div>
                </div>
                </div>
                `
            } else if (v.type == "img") {
                var messageInner = `
                <div class="twitter-message">
                <div class="twitter-message-inner-main">
                    <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                    <div class="twitter-message-inner">
                        <div class="twitter-message-name">
                            <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                            <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                            <div class="twitter-message-time"></div>
                        </div>
                        <div class="twitter-message-img" onclick="view_picture('`+v.message+`')" style="background-image: url(`+v.message+`);"></div>
                    </div>
                </div>
                <div class="twitter-bottom-options">
                    <div class="twitter-options-inner">
                        <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                        <i class="far fa-heart"></i>
                        <i class="fas fa-download"></i>
                    </div>
                </div>
                </div>
                `
            }
            $(`.twitter-messages-container`).append(messageInner);
    
        });
    })
}

search_on_input_twt = function() {
    var val = $(`.twitter_input`).val();

    if (val == undefined || val == "") {
        syncMessagesTwitter(twitter_messages)
        return;
    }

    $.post('http://zero-phone/sortTwitterMessages', JSON.stringify({
        x : val,
    }), function(msg) {
        $(`.twitter-messages-container`).html(``); 
        $.each(msg, function(k, v){
            if (v.type == "msg") {
                var messageInner = `
                <div class="twitter-message">
                <div class="twitter-message-inner-main">
                    <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                    <div class="twitter-message-inner">
                        <div class="twitter-message-name">
                            <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                            <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                            <div class="twitter-message-time"></div>
                        </div>
                        <div class="twitter-message-content">`+v.message+`</div>
                    </div>
                </div>
                <div class="twitter-bottom-options">
                    <div class="twitter-options-inner">
                        <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                        <i class="far fa-heart"></i>
                        <i class="fas fa-download"></i>
                    </div>
                </div>
                </div>
                `
            } else if (v.type == "img") {
                var messageInner = `
                <div class="twitter-message">
                <div class="twitter-message-inner-main">
                    <div class="twitter-message-logo" style="background-image: url(`+v.avatar+`);"></div>
                    <div class="twitter-message-inner">
                        <div class="twitter-message-name">
                            <div class="twitter-message-main-name">`+getUserName(v)+`</div>
                            <div class="twitter-message-sub-name">@`+v.nickname+`</div>
                            <div class="twitter-message-time"></div>
                        </div>
                        <div class="twitter-message-img" onclick="view_picture('`+v.message+`')" style="background-image: url(`+v.message+`);"></div>
                    </div>
                </div>
                <div class="twitter-bottom-options">
                    <div class="twitter-options-inner">
                        <i onclick="twitter_reply('`+v.nickname+`')" class="far fa-comment-alt"></i>
                        <i class="far fa-heart"></i>
                        <i class="fas fa-download"></i>
                    </div>
                </div>
                </div>
                `
            }
            $(`.twitter-messages-container`).append(messageInner);
    
        });
    })
}

twitter_reply = function(nickname) {
    if ( twitter['send_toggle'] == false) {
        twitter_send_message_disp();
    }
    $(`.twitter-span`).html(`@`+nickname+``)
}

setupMySettings = function (name , avatar, rpname) {
    $(`.twitter-top-main-name`).html(rpname)
    $(`.twitter-top-sub-name`).html(name)
    $(`#sendmessagename`).html(name)
    $(`#sendmessagelogo`).css(`background-image`, `url(`+avatar+`)`)
    $(`.twitter-top-logo`).css(`background-image`, `url(`+avatar+`)`)

    $(`#twitter_pic`).val(avatar);
    $(`#twitter_nickname`).val(name);
}

$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        if (action == "twitterSettings") {
            setupMySettings(event.data.name, event.data.avatar, event.data.rpname)
        } else if (action == "updateMessages") {
            syncMessagesTwitter(event.data.messages)
        }
    }); 
});