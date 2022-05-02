Zero = {['Functions'] : {}, ['Vars'] : {}, ['Labels'] : {}}

Zero.Labels['face'] = "Gezicht."
Zero.Labels['face-adjust'] = "Gezicht (extra)."
Zero.Labels['extra'] = "Extra's."
Zero.Labels['clothing'] = "Kleding."
Zero.Labels['saved'] = "Opgeslagen."
Zero.Labels['job'] = "Baan outfits."
Zero.Labels['settings'] = "Geavanceerd."
Zero.Labels['tattoos'] = "Tatoeages."

$(function()  {
    $(`.menu-option`).click(Zero.Functions.ToggleMenu)

    $(`.menu-skin-slider`).html(`<div class="button" data-index="main" data-type="left"><i class="fas fa-chevron-left"></i></div>
    <input class="input-main" oninput="Zero.Functions.ChangeValue(event, 'main')" value="0" min="-1" max="1" type="number"><div class="input-current-amount"></div></input>
    <div class="button" data-type="right"><i class="fas fa-chevron-right"></i></div>`)

    $(`.menu-skin-slider-other`).html(`<div class="button" data-type="left"><i class="fas fa-chevron-left"></i></div>
    <input class="input-other" oninput="Zero.Functions.ChangeValue(event, 'other')" value="0" min="-1" max="1" type="number"><div class="input-current-amount"></div></input>
    <div class="button" data-type="right"><i class="fas fa-chevron-right"></i></div>`)

    $(`.button`).click(Zero.Functions.Button)

    $(`#face`).show();
})

Zero.Functions.ToggleMenu = function(event) {
    var menu = event.currentTarget.dataset.menu;

    $(`.menu-option-selected`).removeClass(`menu-option-selected`);
    $(event.currentTarget).addClass(`menu-option-selected`);

    $(`.clothing-menu-current-title`).html(Zero.Labels[menu]);
    $(`.menu`).hide();
    

    $(`#`+menu+``).show();
}

Zero.Functions.Button = function(event) {
    if ($(event.currentTarget).parent().parent().data(`index`) !== undefined) {
        var slider = $(event.currentTarget).parent().find(`input`);
        var menuClass = $(event.currentTarget).parent().parent().parent().attr(`id`)
        var currentInput = parseFloat(slider.val());

        var type = $(event.currentTarget).data(`type`)
    
        var classC = slider.hasClass(`input-main`)
        if (classC) {
            button_index = "main";
        } else {
            button_index = "other"
        }

        var variation = $(event.currentTarget).parent().parent().data(`index`);

        var max = slider.attr(`max`);

        if (type == "right") {
            currentInput = currentInput + 1;

            if (currentInput > max) {
                currentInput = max;
            }
        } else {
            currentInput = currentInput - 1;
            if (menuClass !== "face-adjust") {
                if (currentInput < -1) {
                    currentInput = -1;
                }
            } else {
                if (currentInput < -20) {
                    currentInput = -20;
                }
            }
        }

        $.post('https://zero-clothing_new/SetVariation', JSON.stringify({
            value : currentInput,
            variation : variation,
            index : button_index,
        }));


        slider.val(currentInput)
    } else {
        if ($(event.currentTarget).parent().data(`index`) == "model") {
            var type = $(event.currentTarget).data(`type`)

            if (type == "left") {
                $.post('https://zero-clothing_new/model-left', JSON.stringify({}), function(model) {
                    $(`.current-model`).html(model)
                });
            } else {
                $.post('https://zero-clothing_new/model-right', JSON.stringify({}), function(model) {
                    $(`.current-model`).html(model)
                });
            }
        }
    }
}

// actions

$(function() {
    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "open": {
                $(`.clothing-save-container`).hide();
                Zero.Functions.Open(event.data.outfits);
                $.post('https://zero-clothing_new/OpenedSettings')
                break;
            };
            case "close": {
                Zero.Functions.Close()
                break;
            };
            case "setupMaxValues": {
                Zero.Functions.Update(event.data.values)
                break;
            };
            case "outfits": {
                Zero.Functions.Outfits(event.data.outfits)
                break;
            }
            case "SettingsClasses": {
                Zero.Functions.SettingsClasses(event.data.classes)
                break;
            };
            case "enableTattoo": {
                $(`#tattoo-option`).show();
                break;
            }
            case "disableTattoo": {
                $(`#tattoo-option`).hide();
                break;
            };
            case "SetupTattooList": {
                SetupTattooList(event.data.list);
                break;
            };
            case "SyncSelectedTattoos": {
                SyncSelectedTats(event.data.tats);
                break;
            }
        }
    });

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                Zero.Functions.Exit();
                break;
            case 77:
                Zero.Functions.Exit();
                break;
            case 39:
                $.post('https://zero-clothing_new/rightRotate')
                break;
            case 37:
                $.post('https://zero-clothing_new/leftRotate')
                break;
        }
    });
})

Zero.Functions.Open = function (outfits) {
    $(`.clothing-menu-container`).fadeIn(150);
    $(`.clothing-cams`).fadeIn(150);

    if (outfits !== undefined) {
        Zero.Functions.JobOutfits(outfits)
    }
}
Zero.Functions.Close = function (bool) {
    $(`.clothing-menu-container`).fadeOut(150);
    $(`.clothing-cams`).fadeOut(150);

    if (bool) {
        var label = $(`#save-input`).val();
        $.post('https://zero-clothing_new/close', JSON.stringify({
            bool : true,
            label : label,
        }));
        $(`#save-input`).val(``);
    } else {
        $.post('https://zero-clothing_new/close', JSON.stringify({
            bool : false,
        }));
        $(`#save-input`).val(``);
    }
}
Zero.Functions.Exit = function() {
    $(`.clothing-save-container`).fadeIn(500);
}
Zero.Functions.CloseSave = function() {
    $(`.clothing-save-container`).fadeOut(500);
}
Zero.Functions.SetModel = function (model) {
    $.post('https://zero-clothing_new/SetPedModel', JSON.stringify({
        model : model,
    }));
}
Zero.Functions.Update = function(values) {
    $.each(values, function(k, v) {
        var option = $(`.menu`).find(`[data-index=`+k+`]`); 

        var current = v.current

        var fixedcurrent = current.toFixed(0)

        if (v.main) {
            option.find(`.menu-skin-option-current`).html(``+fixedcurrent+`/`+v.main+``);
        }

        option.find(`.input-main`).val(fixedcurrent);
        option.find(`.input-other`).val(v.otherCurrent);

        if (v.main) {
            option.find(`.input-main`).attr(`max`, v.main);
            option.find(`.input-other`).attr(`max`, v.other);
        }
    })
}

Zero.Functions.ChangeValue = function(event) {
    var slider = $(event.currentTarget);
    var currentInput = slider.val();

    var classC = slider.hasClass(`input-main`)
    if (classC) {
        button_index = "main";
    } else {
        button_index = "other"
    }

    var variation = $(event.currentTarget).parent().parent().data(`index`);
    var menuclass = $(event.currentTarget).parent().parent().parent().id;


    var max = slider.attr(`max`);


    if (currentInput > max) {
        currentInput = max;
    }

    if (currentInput < -1) {
        currentInput = -1;
    }

    $.post('https://zero-clothing_new/SetVariation', JSON.stringify({
        value : currentInput,
        variation : variation,
        index : button_index,
    }));

    if (currentInput == undefined) {
        currentInput = 0
    }

    slider.val(currentInput)
}

Zero.Functions.Outfits = function(outfits) {
    $(`#saved`).html(``);

    $.each(outfits, function(k, v) {
        var innerOutfit = `
        <div class="saved-skin-item">
        <div class="saved-skin-item-label"><div class="label-inner">`+v.label+`</div></div>
        <div class="saved-skin-buttons">
        <div class="confirm-button" onclick="Zero.Functions.SelectOutfit('`+v.index+`')">Kies outfit</div>
        <div class="cancel-button" onclick="Zero.Functions.DeleteOutfit('`+v.index+`')">Verwijderen</div>
        </div>
        </div>
        `;


        $(`#saved`).append(innerOutfit)
    })
}

Zero.Functions.SelectOutfit = function(outfitId) {
    $.post('https://zero-clothing_new/SelectOwnedOutfit', JSON.stringify({
        index : outfitId
    }));
}
Zero.Functions.DeleteOutfit = function(outfitId) {
    $.post('https://zero-clothing_new/DeleteOutfit', JSON.stringify({
        index : outfitId
    }));
}

Zero.Functions.JobOutfits = function (outfits) {
    $(`#job`).html(``);

    
    $.each(outfits, function(k, v) {
        var innerOutfit = `
        <div class="saved-skin-item">
        <div class="saved-skin-item-label"><div class="label-inner">`+v.label+`</div></div>
        <div class="saved-skin-buttons">
        <div class="confirm-button" onclick="Zero.Functions.SelectOutfitJob('`+k+`')">Kies outfit</div>
        </div>
        </div>
        `;


        $(`#job`).append(innerOutfit)
    })
}

Zero.Functions.SelectOutfitJob = function(index) {
    $.post('https://zero-clothing_new/SelectJobOutfit', JSON.stringify({
        index : index
    }));
}


toggleClassItem = function (event) {
    var target = $(event.currentTarget);

    if (target.hasClass(`true`)) {
        target.removeClass(`true`)
        target.addClass(`false`)
    } else {
        target.removeClass(`false`)
        target.addClass(`true`)
    }
}

GetSkinCode = function () {
    var items = document.getElementsByClassName(`skin-item`)
    var found = {}

    $.each(items, function (k, v) {
        var element = $(v);

        if (element.hasClass(`true`)) {
            var index = element.data(`index`);
            found[index] = true;
        }
    })

    $.post('https://zero-clothing_new/GetSkinCode', JSON.stringify({
        elements : found,
    }), function(skincode) {
        $(`#getskincode`).val(skincode);
    })
}

acceptSkinCode = function () {
    var code = $(`#skincode`).val();

    if (code !== undefined && code !== "") {
        $.post('https://zero-clothing_new/SkinCodeApply', JSON.stringify({
            code : code,
        }))
    }
}

Zero.Functions.SettingsClasses = function(classes) {
    $(`.skin-code-items`).html(``);

    $.each(classes, function(k,v) {
        var inner = `<div data-index="`+k+`" onclick="toggleClassItem(event)" class="skin-item false">`+k+`</div>`;
        $(`.skin-code-items`).append(inner)
    })
}

setCam = function(index) {
    $.post('https://zero-clothing_new/setCam', JSON.stringify({
        index : index,
    }))
}

// tatoolist


// function runs one time only at start of script'

function CreateDLClist(dlc, list) {
    var _ = ``;

    $.each(list, function (k, v) {
        _ = _ + `<div class="dlc-tattoo" id="`+dlc+`-`+v+`" onclick="ApplySkinTattoo('`+dlc+`' ,'`+v+`')">`+v+`</div>`
    });

    return _;
}


function ApplySkinTattoo(dlc, name) {
    $.post('https://zero-clothing_new/ApplyTattoo', JSON.stringify({
        dlc : dlc,
        index : name,
    }))
}

function SetupTattooList (list) {
    $.each(list, function (k, v) {
        var inner = `
        <div class="tattoo-dlc-listing">
            <div class="tattoo-dlc-name">`+v.dlcLabel+`</div>
            <div class="tattoo-dlc-list">
                `+CreateDLClist(v.dlcLabel, v.dlcList)+`
            </div>
        </div>
        `
        $(`#tattoos`).append(inner);
    })
}

function SyncSelectedTats(tats) {
    $(`.dlc-tattoo`).removeClass(`selected-tattoo`);

    $.each(tats, function(dlc, dlc_tats) {
        $.each(dlc_tats, function(k, v) {
            let dlc_string_tat = dlc + `-` + k;

            $(`#`+dlc_string_tat+``).addClass(`selected-tattoo`);
        })
    })
}