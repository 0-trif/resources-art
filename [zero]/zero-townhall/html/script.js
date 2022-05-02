$(() => {
    window.addEventListener('message', function(event) {
        let action = event.data.action;

        switch(action) {
            case "open":
                openTownHall(event.data);
                break;
        }
    })
});

function openTownHall(data) {
    $(`.main-container-townhall`).fadeIn(150);

    $(`#playername`).html(`Voornaam: ` + data.PlayerData.firstname);

    $.each(data.Jobs, function(k, v){
        if (k == data.Job.name) {
            $(`#playerjob`).html(`Baan: ` + v.label);
            $(`#playersalary`).html(`Salaris: `+v.offduty+`€`);
        }
    });

    $(`#jobs`).html(``);
    $.each(data.Jobs, function(k, v){
        if (v.whitelisted == false) {
            var inner = `
            <div class="job">
            <div class="playername">`+v.label+`</div>
            <div class="normaltext">Salaris: `+v.offduty+`€</div>
            <div class="setjobbutton" onclick = "selectNewJob('`+k+`')">Baan kiezen</div>
            </div>
            `
            $(`#jobs`).append(inner);
        }
    })

    $(`.char-firstname`).html(`Voornaam: ` + data.PlayerData.firstname)
    $(`.char-lastname`).html(`Achternaam: ` + data.PlayerData.lastname)
    $(`.char-nationality`).html(`Nationaliteit: ` + data.PlayerData.nationality)
    $(`.char-birth`).html(`Geboortedatum: ` + data.PlayerData.birthdate)
    $(`.char-app`).html(`Appartement: ` + data.MetaData.appartment)

    $(`.char-idcard-name`).html(data.PlayerData.firstname + " " + data.PlayerData.lastname)
    $(`.char-idcard-gender`).html(data.PlayerData.nationality)
    $(`.char-idcard-birth`).html(data.PlayerData.birthdate)

    if (data.Mugshot) {
        $(`.idcard-image`).css(`background-image`, `url(https://nui-img/${data.Mugshot}/${data.Mugshot})`)
    }
    
}
function closeTownHall() {
    $(`.main-container-townhall`).fadeOut(150);
    $.post('https://zero-townhall/close', JSON.stringify({}));
}

function selectNewJob(job) {
    $.post('https://zero-townhall/newJob', JSON.stringify({
        job : job,
    }));
}

function requestCard(card) {
    $.post('https://zero-townhall/requestCard', JSON.stringify({
        card : card,
    }));
}