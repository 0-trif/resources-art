OpenMeosSearch = function () {
    $(`#meos-persons`).show();
    AnimateCSS(`#meos-persons`, 'fadeInRight', function() {

    });
}

closePersonSearch = function () {
    AnimateCSS(`#meos-persons`, 'fadeOutRight', function() {
        $(`#meos-persons`).hide();
    });
}

CloseVehicleSearch = function () {
    AnimateCSS(`#meos-vehicle`, 'fadeOutRight', function() {
        $(`#meos-vehicle`).hide();
    });
}

OpenMeosEmployees = function () {

    $.post('https://zero-phone/GetEmployeesMeos', JSON.stringify({}), function(players) {
        $(`#meos-employees`).html(``);
        
        $.each(players, function(k, v){
            var inner = `
            <div class="meos-employee">
            <div class="employee-name">`+v.PlayerData.firstname+` `+v.PlayerData.lastname+`</div>
            <div class="employee-stat">
                <div class="employee-stat-name">Functie:</div>
                <div class="employee-stat-value">`+v.Job.FunctieLabel+`</div>
            </div>
            <div class="employee-stat">
                <div class="employee-stat-name">Roepnummer:</div>
                <div class="employee-stat-value">`+v.MetaData.callid+`</div>
            </div>
            </div>
            `

            $(`#meos-employees`).append(inner);
        })

    });

    $(`#meos-employee`).show();
    AnimateCSS(`#meos-employee`, 'fadeInRight', function() {

    });
}

CloseEmployee = function () {
    AnimateCSS(`#meos-employee`, 'fadeOutRight', function() {
        $(`#meos-employee`).hide();
    });
}

OpenMeosVehicle = function () {
    $(`#meos-vehicle`).show();
    AnimateCSS(`#meos-vehicle`, 'fadeInRight', function() {

    });
}

OpenMeosAlerts = function () {
    $.post('https://zero-phone/GetSOSNotifications', JSON.stringify({
    }), function(result) {
        $(`#meos-search-person-stats`).html(``);

        $.each(result, function(k,v) {
            var inner = `
            <div class="police-alert" onclick="SOSsetLocation(event)" data-x="`+v.location.x+`" data-y="`+v.location.y+`" data-z="`+v.location.z+`">
            <div class="alert-title">Politie melding `+v.title+`</div>
            <div class="alert-message">`+v.message+`</div>
            <div class="alert-location">Locatie instellen.</div>
            </div>
            `

            

            $(`#meos-search-person-stats`).prepend(inner);
        })
    });

    $(`#meos-alerts`).show();
    AnimateCSS(`#meos-alerts`, 'fadeInRight', function() {

    });
}

CloseMeosAlerts = function () {
    AnimateCSS(`#meos-alerts`, 'fadeOutRight', function() {
        $(`#meos-alerts`).hide();
    });
}

MeosSearchPersons = function () {
    var input_ = $(`#person-search`).val();

    $.post('https://zero-phone/SearchPlayersMeos', JSON.stringify({input : input_}), function(data) {
        if (data) {
            SetupFoundPlayers(data)
        }
    });
}

var SearchData = {}
SetupFoundPlayers = function (data) {
    $(`.meos-search-persons`).html(``);
    

    $.each(data, function(k, v){
        SearchData[v.Citizenid] = v.ArchivedData

        var inner = `
        <div class="person-result" onclick="OpenPlayerStats(event, '`+v.Citizenid+`')">
        <div class="person-result-logo">
            `+v.ArchivedData.firstname[0]+`
        </div>
        <div class="person-result-info">
            <div class="person-result-name">`+v.ArchivedData.firstname+` `+v.ArchivedData.lastname+`</div>
            <div class="person-result-nationality">`+v.ArchivedData.nationality+`</div>
        </div>
        </div>
        `

        $(`.meos-search-persons`).append(inner);
    });
}

OpenPlayerStats = function (event, cid) {
    $(`#meos-person-stats`).show();
    
    var data = SearchData[cid]

    last_meos_id = cid;

    $(`#search-phone`).html(data.phone);
    $(`#search-firstname`).html(data.firstname);
    $(`#search-lastname`).html(data.lastname);
    $(`#search-birthdate`).html(data.birthdate);
    $(`#search-nationality`).html(data.nationality);

    $(`#search-job`).html(data.job);
    $(`#search-jobgrade`).html(data.jobgrade);

    $(`#search-appartment`).html(data.appartment);

    AnimateCSS(`#meos-person-stats`, 'fadeInRight', function() {
    });
}

closePersonStats = function () {
    AnimateCSS(`#meos-person-stats`, 'fadeOutRight', function() {
        $(`#meos-person-stats`).hide();
    });
}


OpenReports = function () {
    last_reports = {}
    
    if (last_meos_id) {

        $.post('https://zero-phone/GetPlayerReports', JSON.stringify({
            citizenid : last_meos_id,
        }), function(reports) {
            $(`#reports`).html(``);

            $.each(reports, function(k, v) {
                last_reports[v.index] = v;

                var inner = `
                <div class="report" onclick="SeePlayerReport('`+v.index+`')">
                <div class="report-name">#`+v.title+`</div>
                <div class="report-maker">`+v.creator+`</div>
                </div>       
                `
                $(`#reports`).prepend(inner)
            })
        });

        $(`#meos-reports`).show();
        AnimateCSS(`#meos-reports`, 'fadeInRight', function() {
    
        });
    }
}

EditReport = function () {
    if (last_edit_report) {
        var title = $(`#report-edit-title`).val()
        var text = $(`#report-edit-text`).html()

        $.post('https://zero-phone/EditReportMeos', JSON.stringify({
            index : last_edit_report,
            title : title,
            text : text,
        })); 

        $.post('https://zero-phone/GetPlayerReports', JSON.stringify({
            citizenid : last_meos_id,
        }), function(reports) {
            $(`.reports`).html(``);

            $.each(reports, function(k, v) {
                last_reports[v.index] = v;

                var inner = `
                <div class="report" onclick="SeePlayerReport('`+v.index+`')">
                <div class="report-name">#`+v.title+`</div>
                <div class="report-maker">`+v.creator+`</div>
                </div>       
                `
                $(`.reports`).prepend(inner)
            })
        });

        CloseSeeReport()
        
    }
}

CloseSeeReport = function () {
    AnimateCSS(`#meos-see`, 'fadeOutRight', function() {
        $(`#meos-see`).hide();
    });
}
SeePlayerReport = function (index) {
    if (last_reports[index]) {
        var data = last_reports[index];

        last_edit_report = index;

        $(`#report-edit-title`).val(data.title)
        $(`#report-edit-text`).html(data.text)

        $(`#meos-see`).show();
        AnimateCSS(`#meos-see`, 'fadeInRight', function() {
         
        });
    }
}

closeReports = function () {
    AnimateCSS(`#meos-reports`, 'fadeOutRight', function() {
        $(`#meos-reports`).hide();
    });
}

openCreateReport = function () {
    $(`#meos-create`).show();
    AnimateCSS(`#meos-create`, 'fadeInRight', function() {
     
    });
}

closeCreateReport = function () {
    AnimateCSS(`#meos-create`, 'fadeOutRight', function() {
        $(`#meos-create`).hide();
    });
}

saveReport = function () {
    var title = $(`#report-create-title`).val();
    var text = $(`#report-create-text`).html();

    $.post('https://zero-phone/CreateReport', JSON.stringify({
        citizenid : last_meos_id,
        title : title,
        text : text
    }));

    $.post('https://zero-phone/GetPlayerReports', JSON.stringify({
        citizenid : last_meos_id,
    }), function(reports) {
        $(`.reports`).html(``);

        $.each(reports, function(k, v) {
            last_reports[v.index] = v;

            var inner = `
            <div class="report" onclick="SeePlayerReport('`+v.index+`')">
            <div class="report-name">#`+v.title+`</div>
            <div class="report-maker">`+v.creator+`</div>
            </div>       
            `
            $(`.reports`).prepend(inner)
        })
    });

    closeCreateReport()

    $(`#report-create-title`).val(``);
    $(`#report-create-text`).html(``);
}

searchVehicleMeos = function () {
    var plate = $(`#meos-plate`).val();

    $.post('https://zero-phone/SearchVehicleMeos', JSON.stringify({
        plate : plate,
    }), function (result) {
        $(`#vehicle-search-owner`).html(result.player.firstname + ` ` + result.player.lastname)
        $(`#vehicle-search-plate`).html(result.plate)
        $(`#vehicle-search-model`).html(result.model)
        $(`#vehicle-search-bsn`).html(result.citizenid)

        if (result.mods.colours) {
            if (result.mods.colours.primary) {
                $(`#vehicle-search-color`).css(`background-color`, `rgb(`+result.mods.colours.primary.r+`, `+result.mods.colours.primary.g+`, `+result.mods.colours.primary.b+`)`)
            }
        }
    });
}

OpenDec = function () {
    last_decs = {}
    
    if (last_meos_id) {

        $.post('https://zero-phone/GetPlayerDecs', JSON.stringify({
            citizenid : last_meos_id,
        }), function(reports) {
            $(`#decs`).html(``);

            $.each(reports, function(k, v) {
                last_decs[v.index] = v;

                var inner = `
                <div class="report" onclick="SeePlayerDec('`+v.index+`')">
                <div class="report-name">#`+v.title+`</div>
                <div class="report-maker">`+v.creator+`</div>
                </div>       
                `
                $(`#decs`).prepend(inner)
            })
        });

        $(`#meos-dec`).show();
        AnimateCSS(`#meos-dec`, 'fadeInRight', function() {
    
        });
    }
}

SeePlayerDec = function (index) {
    if (last_decs[index]) {
        var data = last_decs[index];

        last_edit_dec = index;

        $(`#dec-edit-title`).val(data.title)
        $(`#dec-edit-text`).html(data.text)

        $(`#meos-seeDec`).show();
        AnimateCSS(`#meos-seeDec`, 'fadeInRight', function() {
         
        });
    }
}

CloseDec = function () {
    AnimateCSS(`#meos-dec`, 'fadeOutRight', function() {
        $(`#meos-dec`).hide();
    });
}

EditDec = function () {
    if (last_edit_dec) {
        var title = $(`#dec-edit-title`).val()
        var text = $(`#dec-edit-text`).html()

        $.post('https://zero-phone/EditDecMeos', JSON.stringify({
            index : last_edit_dec,
            title : title,
            text : text,
        })); 
        CloseSeeDec()
        
        $.post('https://zero-phone/GetPlayerDecs', JSON.stringify({
            citizenid : last_meos_id,
        }), function(reports) {
            $(`#decs`).html(``);

            $.each(reports, function(k, v) {
                last_decs[v.index] = v;

                var inner = `
                <div class="report" onclick="SeePlayerDec('`+v.index+`')">
                <div class="report-name">#`+v.title+`</div>
                <div class="report-maker">`+v.creator+`</div>
                </div>       
                `
                $(`#decs`).prepend(inner)
            })
        });

    }
}

OpenCreateDec = function () {
    $(`#meos-createDec`).show();
    AnimateCSS(`#meos-createDec`, 'fadeInRight', function() {
     
    });
}

CloseSeeDec = function () {
    AnimateCSS(`#meos-seeDec`, 'fadeOutRight', function() {
        $(`#meos-seeDec`).hide();
    });
}

saveDec = function () {
    var title = $(`#dec-create-title`).val();
    var text = $(`#dec-create-text`).html();

    $.post('https://zero-phone/CreateDec', JSON.stringify({
        citizenid : last_meos_id,
        title : title,
        text : text
    }));

    $.post('https://zero-phone/GetPlayerDecs', JSON.stringify({
        citizenid : last_meos_id,
    }), function(reports) {
        $(`#decs`).html(``);

        $.each(reports, function(k, v) {
            last_decs[v.index] = v;

            var inner = `
            <div class="report" onclick="SeePlayerDec('`+v.index+`')">
            <div class="report-name">#`+v.title+`</div>
            <div class="report-maker">`+v.creator+`</div>
            </div>       
            `
            $(`#decs`).prepend(inner)
        })
    });

    closeCreateDec()

    $(`#report-create-title`).val(``);
    $(`#report-create-text`).html(``);
}

closeCreateDec = function () {
    AnimateCSS(`#meos-createDec`, 'fadeOutRight', function() {
        $(`#meos-createDec`).hide();
    });
}

OpenMeosFines = function () {
    $.post('https://zero-phone/GetPlayerFines', JSON.stringify({
        citizenid : last_meos_id,
    }), function(fines) {
        $(`#fines`).html(``);
        
        var price = 0

        $.each(fines, function(k, v) {
            price = price + parseFloat(v.price);

            var inner = `
            <div class="fine">
            <div class="fine-remove" onclick="removeFine('`+last_meos_id+`', '`+v.index+`')"><i class="fad fa-trash"></i></div>
            <div class="fine-title">`+v.artikel+`</div>
            <div class="fine-creator">`+v.creator+`</div>
            <div class="fine-price">€`+v.price+`</div>
            </div>    
            `

            $(`#fines`).prepend(inner)
        })

        $(`#totalpriceFines`).html(`Openstaande boetes (totaal : €`+price+`)`)
    });

    

    $(`#meos-fines`).show();
    AnimateCSS(`#meos-fines`, 'fadeInRight', function() {
    
    });
}
CloseMeosFines = function () {
    AnimateCSS(`#meos-fines`, 'fadeOutRight', function() {
        $(`#meos-fines`).hide();
    });
}

SearchArtikelOnName = function () {
    var name = $(`#fineName`).val();

    $.post('https://zero-phone/GetPoliceFines', JSON.stringify({
        string : name,
    }), function(fines) {
        $(`.fines-list`).html(``);

        $.each(fines, function(k, v) {
            var inner = `
            <div class="fine" onclick="GiveFineToPlayer('`+v.index+`')">
            <div class="fine-title">`+v.label+`</div>
            <div class="fine-creator">`+v.message+`</div>
            <div class="fine-price">`+v.price+`</div>
            </div>
            `

            $(`.fines-list`).append(inner);
        });
    })
}

GiveFineToPlayer = function (index) {
    if (last_meos_id) {
        $.post('https://zero-phone/GiveFineToPlayer', JSON.stringify({
            citizenid : last_meos_id,
            index : index,
        }))


        CloseCreteFine()

        $.post('https://zero-phone/GetPlayerFines', JSON.stringify({
            citizenid : last_meos_id,
        }), function(fines) {
            $(`#fines`).html(``);
            
            var price = 0
    
            $.each(fines, function(k, v) {
                price = price + parseFloat(v.price);
    
                var inner = `
                <div class="fine">
                <div class="fine-remove" onclick="removeFine('`+last_meos_id+`', '`+v.index+`')"><i class="fad fa-trash"></i></div>
                <div class="fine-title">`+v.artikel+`</div>
                <div class="fine-creator">`+v.creator+`</div>
                <div class="fine-price">€`+v.price+`</div>
                </div>    
                `
    
                $(`#fines`).prepend(inner)
            })
    
            $(`#totalpriceFines`).html(`Openstaande boetes (totaal : €`+price+`)`)
        });
    }
}

OpenCreateFine = function () {

    $.post('https://zero-phone/GetPoliceFines', JSON.stringify({
        string : "",
    }), function(fines) {
        $(`.fines-list`).html(``);

        $.each(fines, function(k, v) {
            var inner = `
            <div class="fine" onclick="GiveFineToPlayer('`+v.index+`')">
            <div class="fine-title">`+v.label+`</div>
            <div class="fine-creator">`+v.message+`</div>
            <div class="fine-price">`+v.price+`</div>
            </div>
            `

            $(`.fines-list`).append(inner);
        });
    })

    $(`#meos-createFine`).show();
    AnimateCSS(`#meos-createFine`, 'fadeInRight', function() {
    
    });
}

CloseCreteFine = function () {
    AnimateCSS(`#meos-createFine`, 'fadeOutRight', function() {
        $(`#meos-createFine`).hide();
    });
}

removeFine = function (cid, fineid) {
    $.post('https://zero-phone/RemoveFineFromPlayer', JSON.stringify({
        citizenid : cid,
        index : fineid,
    }))

    $.post('https://zero-phone/GetPlayerFines', JSON.stringify({
        citizenid : cid,
    }), function(fines) {
        $(`#fines`).html(``);
        
        var price = 0

        $.each(fines, function(k, v) {
            price = price + parseFloat(v.price);

            var inner = `
            <div class="fine">
            <div class="fine-remove" onclick="removeFine('`+last_meos_id+`', '`+v.index+`')"><i class="fad fa-trash"></i></div>
            <div class="fine-title">`+v.artikel+`</div>
            <div class="fine-creator">`+v.creator+`</div>
            <div class="fine-price">€`+v.price+`</div>
            </div>    
            `

            $(`#fines`).prepend(inner)
        })

        $(`#totalpriceFines`).html(`Openstaande boetes (totaal : €`+price+`)`)
    });
}