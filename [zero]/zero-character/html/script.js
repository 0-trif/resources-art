creation = false;
lastloc = 1;

$(() => {
    window.addEventListener('message', e => {
        let action = e.data.action;

        switch(action) {
            case "up-chars":
                setupCharacters(e.data.characters);
                break;
            case "chars":
                setupCharacters(e.data.characters)
                $(`.character-creation`).show()
                $(`.title-container`).fadeIn(300);
                AnimateCSS(`.character-creation`, 'fadeInLeft', function() {})
                break;
            case "off":
                AnimateCSS(`.character-creation`, 'fadeOutLeft', function() {
                    $(`.character-creation`).hide()
                })
               
                //setupCharacters(e.data.characters)
                break;
            case "spawn":
                $(`.character-spawnselection`).show()
                AnimateCSS(`.character-spawnselection`, 'fadeInLeft', function() {})
                break
            case "appartment":
                $(`.character-appartment`).show()
                $(`.title-container`).fadeOut(300);
                AnimateCSS(`.character-appartment`, 'fadeInLeft', function() {})
                break;
        }
    });

    $(`.spawn`).click(selectionspawn)
});


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


// code for chars
setupCharacters = function (x) {
    for (let index = 1; index <= 5; index++) {
        if (x[index-1]) {
            $(`.characters`).find(`[data-slot=${index}]`).html(`
                <div class="headicon" style="background-image: url(./head-face.png);"></div>
                <div class="character-info">
                    <div class="character-subinfo">`+x[index-1].playerdata.firstname+` `+x[index-1].playerdata.lastname+` (`+x[index-1].playerdata.gender+`)</div>
                    <div class="character-subinfoX">CASH: €`+x[index-1].money.cash+` BANK: €`+x[index-1].money.bank+` NATIONALITEIT: `+x[index-1].playerdata.nationality+`</div>
                </div>
            `)
            $(`.characters`).find(`[data-slot=${index}]`)[0].onclick = function() {
                cancelCreation();
                $.post('https://zero-character/play', JSON.stringify({
                    slot : index,
                }));
            }
            $(`.characters`).find(`[data-slot=${index}]`)[0].onmouseenter = function() {
                $.post('https://zero-character/setSkin', JSON.stringify({
                    slot : index,
                }));
            }
        } else {
            $(`.characters`).find(`[data-slot=${index}]`)[0].onclick = function() {
                if (creation == false) {
                    $(`.character-creation2`).show()

                    lastslot = index;

                    AnimateCSS(`.character-creation2`, 'fadeInRight', function() {})
                    creation = true;
                } else {
                    cancelCreation();
                }
            }
            $(`.characters`).find(`[data-slot=${index}]`)[0].onmouseenter = function() {
                $.post('https://zero-character/setSkin', JSON.stringify({
                }));
            }
            $(`.characters`).find(`[data-slot=${index}]`).html(`
                <div class="headicon" style="background-image: url(./head-face.png);"></div>
                <div class="character-info">Nieuw karakter (`+index+`)!</div>
            `)
        }
    }
}

cancelCreation = function() {
    AnimateCSS(`.character-creation2`, 'fadeOutRight', function() {
        $(`.character-creation2`).hide()
        creation = false;
    })
}

createChar = function() {
    let firstname = $(`#firstname`).val();
    let lastname = $(`#lastname`).val();
    let birthdate = $(`#birthdate`).val();
    let gender = $(`#gender`).val();
    let nationality = $(`#nationality`).val();

    if (firstname && lastname && birthdate && gender && nationality && lastslot) {
        cancelCreation();

        $.post('https://zero-character/create', JSON.stringify({
            firstname : firstname,
            lastname : lastname,
            birthdate : birthdate,
            gender : gender,
            nationality : nationality,
            slot : lastslot,
        }));
    }
}

logout = function() {
    $.post('https://zero-character/logout', JSON.stringify({
    }));
}

playChar = function() {
    $.post('https://zero-character/logout', JSON.stringify({
    }));
}

selectionspawn = function(event) {
    $(`.spawn`).removeClass(`selected-spawn`)
    event.currentTarget.classList.add(`selected-spawn`)
}

setcam = function(index) {
    lastloc = index;
    $.post('https://zero-character/setCam', JSON.stringify({
        index : index,
    }));
}

chooseloc = function() {
    if (lastloc) {
        AnimateCSS(`.character-spawnselection`, 'fadeOutLeft', function() {
            $(`.character-spawnselection`).hide()
            $.post('https://zero-character/chooseLoc', JSON.stringify({
                index : lastloc,
            }));
            $(`.title-container`).fadeOut(300);
        })
    }
}
chooseAppartment = function(index) {
    last_app = index;
    $.post('https://zero-character/setAppartmentCam', JSON.stringify({
        index : index,
    }));
}

chooseAppartmentConfirm = function() {
    if (last_app) {
        $.post('https://zero-character/chooseAppartment', JSON.stringify({
            index : last_app,
        }));

        AnimateCSS(`.character-appartment`, 'fadeOutLeft', function() {
            $(`.character-appartment`).hide()
        })
    }
}