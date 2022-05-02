SetupCrafting = function(data) {
    if (data) {
        $(`.crafting-search-bar`).hide()
        $(`.other-inventory`).find(`.inventory-title-name`).html(`Crafting`);
        $(`.other-inventory`).data(`event`, data.data.event);
        $(`.other-inventory`).find(`.inventory-items-inner`).html(``)


        if (data.data.skill !== undefined) {
            var perc = 100 / data.data.maxskill * data.data.skill;
            $(`.other-inventory`).find(`.inventory-title-amount-inner`).css(`width`, ``+perc+`%`)
            $(`#other-weight`).html(``+data.data.skill+`/`+data.data.nextxp+`` + ` Craft skill`)
        }

        SetupCraftingItems(data.data.items);
    }
}

setupRecipe = function(x) {
    var xdoc = ""
    $.each(x, function(k, v){
        var inner = `
        <div class="crafting-data-item">
        <div class="cr_img" style="background-image: url(./images/`+v.item+`.png);"></div>
        <div class="cr_name">Item name: `+inventory.data.items[v.item].label+`</div>
        <div class="cr_amount">Hoeveelheid: `+v.amount+`</div>
        </div>
        `

        xdoc = xdoc + inner;
    });
    return xdoc;
}

GetCraftingItemInner = function(index, data) {
    var index = index + 1;

    if (data.unlocked) {
        let inner = `
        <div class="crafting-item">
        <div class="item" data-slot="`+index+`">
            <div class="inventory-item-image" style="background-image: url(./images/`+data.item+`.png);"></div>
            <div class="inventory-item-label">
                <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
            </div>
            <div class="inventory-item-amount">
                <div class="inventory-item-amount-inner">
                    1/`+inventory.data.items[data.item].max+`
                </div>
            </div>
        </div>

        <div class="crafting-item-data">
            <div class="crafting-data-title">`+inventory.data.items[data.item].label+` Recipe</div>
         
            <div class="crafting-data-items">
                `+setupRecipe(data.recipe)+`
            </div>
        </div>
        </div>
        `
        return inner;
    } else { 
        let inner = `
        <div class="crafting-item">
        <div class="cr_unknown"><i class="fas fa-question"></i></div>
        <div class="item" data-slot="`+index+`">
            <div class="inventory-item-image" style="background-image: url(./images/`+data.item+`.png);"></div>
            <div class="inventory-item-label">
                <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
            </div>
            <div class="inventory-item-amount">
                <div class="inventory-item-amount-inner">
                    1/`+inventory.data.items[data.item].max+`
                </div>
            </div>
        </div>

        <div class="crafting-item-data">
            <div class="crafting-data-title">`+inventory.data.items[data.item].label+` Recipe</div>
         
            <div class="crafting-data-items">
                `+setupRecipe(data.recipe)+`
             
            </div>
        </div>
        </div>
        `
        return inner;
    }
}

SetupCraftingItems = function(items) {
    $.each(items, function(k, v){
        var inner = GetCraftingItemInner(k, v)
        $(`.other-inventory`).find(`.inventory-items-inner`).append(inner)
    })

    $(`.other-inventory`).find(`.inventory-items-inner`).find(`.crafting-item`).find(`.item`).draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-x",
    
        start: function(event, ui) {
            $(this).find(".inventory-item-image").css("opacity", "0.5");
    
            draggingElement = event.currentTarget;
            dragging = true
        },
    
        stop: function(event, ui) {
            $(this).find(".inventory-item-image").css("opacity", "1");

            draggingElement = undefined;
            dragging = false
        }
    });
}