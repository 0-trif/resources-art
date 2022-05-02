$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "display": {
                $(`body`).show();
                break;
            };
            case "members": {
                SetupMembers(event.data.members);
                break;
            };
            case "hide": {
                $(`body`).hide();
                break;
            }
        }
    })
})

function GetRole (leader) {
    if (leader) {
        return `Crew leader`;
    } else {
        return `Crew member`;
    }
}

function SetupMembers (members) {
    $(`.crew-members`).html(``);
    
    $.each(members, function(playerId, playerData) {
        if (playerData) {
            let inner = `
            <div class="member">
            <div class="member-data">
                <div class="member-name">`+playerData['PlayerName']+`</div>
                <div class="member-phone">`+GetRole(playerData.GroupLeader)+`</div>
            </div>
            <div class="member-icon">`+playerData['PlayerName'][0]+`</div>
            </div>
            ` 
    
            $(`.crew-members`).append(inner);
        }
    });
}

function CloseMission () {
    $(`body`).hide();
    $.post('https://zero-yacht/CloseMission');
}

function JoinMission() {
    $.post('https://zero-yacht/JoinMission');
}

function LeaveMission() {
    $.post('https://zero-yacht/LeaveMission');
}

function StartMission () {
    $.post('https://zero-yacht/StartMission');
}