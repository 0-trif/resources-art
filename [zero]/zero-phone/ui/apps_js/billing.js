SetupBilling = function () {
    $.post('https://zero-phone/GetPlayerFines', JSON.stringify({
        citizenid : "",
    }), function(fines) {
        $(`#billing-fines`).html(``);

        $.each(fines, function(k, v) {
      
            var inner = `
            <div class="fine">
            <div class="fine-title">`+v.artikel+`</div>
            <div class="fine-creator">`+v.creator+`</div>
            <div class="fine-price">€`+v.price+`</div>
            <div class="fine-pay-bill" onclick="PayBill('`+v.index+`')">
            <i class="fad fa-receipt"></i>
            </div>
            </div>    
            `

            $(`#billing-fines`).prepend(inner)
        })
    });
}

PayBill = function(index) {
    $.post('https://zero-phone/PayBill', JSON.stringify({
        index : index,
    }));
    
    setTimeout(function () {
        $.post('https://zero-phone/GetPlayerFines', JSON.stringify({
            citizenid : "",
        }), function(fines) {
            $(`#billing-fines`).html(``);
    
            $.each(fines, function(k, v) {
          
                var inner = `
                <div class="fine">
                <div class="fine-title">`+v.artikel+`</div>
                <div class="fine-creator">`+v.creator+`</div>
                <div class="fine-price">€`+v.price+`</div>
                <div class="fine-pay-bill" onclick="PayBill('`+v.index+`')">
                <i class="fad fa-receipt"></i>
                </div>
                </div>    
                `
    
                $(`#billing-fines`).prepend(inner)
            })
        });
    }, 250)
}