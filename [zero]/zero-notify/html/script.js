notifications = 0

window.addEventListener('message', function (event) {
    let item = event.data;
    if (item.action == "notification") {
        createNotification(item.data.title, item.data.message, item.data.type, item.data.time);
    } else if (item.action == "moneyNote") {
        createMoneyNotification(item.data.bool, item.data.amount)
    }
});

createNotification = function(titlename, messagename, type, time) {
    var notification = document.createElement("div")
	
    notification.classList.add("notification")
    notification.classList.add(type)

    notification.id = notifications+1
    notifications   = notifications+1
    
    var title = document.createElement('div')
    title.innerHTML = '<div class="notification-title '+type+'-title">'+titlename+'</div>'

    notification.append(title)

    var message = document.createElement("div")
    message.innerHTML = '<div class="notification-text-container">'+messagename+'</div>';
    notification.append(message)

    var main = document.getElementById("container")
    main.append(notification)

    notification.style.position = 'relative'
    notification.style.right = '-120%'

    $("#"+notification.id+"").animate({left: 0}, function(){
        setTimeout(function(){
            $("#"+notification.id+"").fadeOut(250)
            setTimeout(function() {
                notification.parentElement.removeChild(notification)
            }, 250)
        }, time)
    })
}


createMoneyNotification = function(bool, amount) {
    type = "error"
    symbol = "-"
    if (bool) {
        type = "success"
        symbol = "+"
    }

    var notification = document.createElement("div")
    notification.classList.add("money-notification")
    notification.classList.add(type)

    notification.id = notifications+1
    notifications   = notifications+1

    var inner = `
    <div class="money-symbol">`+symbol+`</div>
    <div class="money-amount">`+amount+`</div>
    `
    notification.innerHTML = inner;


    var main = document.getElementById("container")
    main.append(notification)

    notification.style.position = 'relative'
    notification.style.right = '-120%'

    $("#"+notification.id+"").animate({left: 0}, function(){
        setTimeout(function(){
            $("#"+notification.id+"").animate({top: '-120%'}, function(){
                notification.parentElement.removeChild(notification)
            });
        }, 4000)
    })
}
