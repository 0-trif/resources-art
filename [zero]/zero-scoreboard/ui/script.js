
$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "sync":
                SyncPlayers(event.data.counts, event.data.players)
                break;
            case "show": 
                $(`.scoreboard-border`).show();
                break;
            case "hide": 
                $(`.scoreboard-border`).hide();
                break;
        }
    })
})


function SyncPlayers(x, players) {
    $(`#players`).html(players + `/128`);

    $.each(x, function(k, v) {
        $(`#`+k+``).html(``+v.duty+` In-dienst `+v.offduty+` Uit-dienst`)
    })
}