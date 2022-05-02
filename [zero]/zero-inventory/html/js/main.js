inventory = {}
inventory.functions = {}
inventory.data = {}

inventory.data.slots = 0
inventory.data.keybinds = 6

inventory.data.items = {}
inventory.data.player = {}
inventory.data.other = {}
inventory.data.otherslots = 0

in_inspect = false;


setupItemFunctions = function() {
    $(".item").unbind("click");
    $(".item").unbind("droppable");
    $(".item").unbind("dblclick");
    $(".item").unbind("mouseenter");
    $(".item").unbind("mouseleave");

    $('.item').mouseenter(MouseEnterItem)
    $('.item').mouseleave(MouseLeaveItem)

    $('.item').droppable( {
        drop: handleDropEvent
    });
  //  $('.item').dblclick(handeUseEvent)
    $('.item').click(handleSingleClick)
}

function_valid_amount = function(item, amount) {
    if (inventory.data.items[item].max <= 1) {
        return amount + "x"
    } else {
        return amount + `/` + inventory.data.items[item].max
    }
}
GetDurabilityInner = function(durability) {
    if (durability <= 0) {
        return `<div class="inventory-item-durabilty" style="height: 100%; width: 100%; z-index: 0"><div class="inventory-item-durabilty-inner" style="height: 100%; background: rgba(189, 45, 45, 0.15)"></div></div>`
    }

    return `${durability !== undefined ? `<div class="inventory-item-durabilty"><div class="inventory-item-durabilty-inner" style="width: ${durability}%"></div></div>` : ""}`
}

function_setup_slot = function(index, data, bool) {
    if (bool) {
        return `
        
        <div class="inventory-item-image" style="background-image: url(./images/`+data['item']+`.png);"></div>
        <div class="inventory-item-label">
        <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
        </div>
        <div class="inventory-item-amount">
        <div class="inventory-item-amount-inner">
        `+function_valid_amount(data.item, data.amount)+`
        </div>
        </div>

        <div class="inventory-item-weight">
        <div class="inventory-item-weight-inner">
        `+calculateWeight(data.amount, data.item)+`kg
        </div>
        </div>


        `+GetDurabilityInner(data.datastash.durability)+`
        `
    }
    if (index <= inventory.data.keybinds) {
        var inner = `


        <div class="inventory-item-image" style="background-image: url(./images/`+data['item']+`.png);"></div>
        <div class="inventory-item-label">
        <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
        </div>
        <div class="inventory-item-amount">
        <div class="inventory-item-amount-inner">
        `+function_valid_amount(data.item, data.amount)+`
        </div>
        </div>

        <div class="inventory-item-weight">
        <div class="inventory-item-weight-inner">
        `+calculateWeight(data.amount, data.item)+`kg
        </div>
        </div>


        `+GetDurabilityInner(data.datastash.durability)+`
     
        `
        return inner
    } else {
        return `
        
        <div class="inventory-item-image" style="background-image: url(./images/`+data['item']+`.png);"></div>
        <div class="inventory-item-label">
        <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
        </div>

        <div class="inventory-item-amount">
        <div class="inventory-item-amount-inner">
        `+function_valid_amount(data.item, data.amount)+`
        </div>
        </div>

        <div class="inventory-item-weight">
        <div class="inventory-item-weight-inner">
        `+calculateWeight(data.amount, data.item)+`kg
        </div>
        </div>


        `+GetDurabilityInner(data.datastash.durability)+`
        `
    }


    return ``
}

slotIndex = function(index) {
    if (index <= 6) {
        return `<div class="inventory-keybind">
        <div class="inventory-keybind-inner">`+index+`</div>
        </div>`
    }

    return ``
}

setup_inventory = function() {
    for (let i = 1; i <= inventory.data.slots; i++) {
        var inner = `<div data-inventory="player" data-slot="`+i+`" class="item item-player"></div>`;
        $(`.player-inventory`).find(`.inventory-items-inner`).append(inner)
    }
    // $('.item').droppable( {
    //     drop: handleDropEvent
    // });
    setupItemFunctions()
}

setup_other_inventory = function(slots) {
    $(`.other-inventory`).data(`inventory`, `other`);
    $(`.other-inventory`).find(`.inventory-items-inner`).html(``)
    for (let i = 1; i <= slots; i++) {
        $(`.other-inventory`).find(`.inventory-items-inner`).append(`<div data-inventory="other" data-slot="`+i+`" class="item"></div>`)
    }

    $(`.crafting-search-bar`).hide()

    setupItemFunctions()
  //  $(`.item`).css(`border-radius`, ``+settings.radius+`rem`)
}

setup_shop_slots = function(slots) {
    $(`.other-inventory`).find(`.inventory-items-inner`).html(``)
    for (let i = 1; i <= slots; i++) {
        $(`.other-inventory`).find(`.inventory-items-inner`).append(`<div data-shop="true" data-inventory="other" data-slot="`+i+`" class="item shopitem"></div>`)
    }
  //  $(`.item`).css(`border-radius`, ``+settings.radius+`rem`)
}

refresh_slot_data_other = function(slot) {
    var slot_data = inventory.data.other[slot];
    if (slot_data) {
        if (slot_data.amount <= 0) {
            inventory.data.other[slot] = undefined;
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(``)
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:true});
            return;
        }
        var inner = function_setup_slot(slot,inventory.data.other[slot], true);
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(inner)
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({
            helper: 'clone',
            appendTo: "body",
            scroll: true,
            revertDuration: 0,
            revert: "invalid",
            cancel: ".item-x",
        
            start: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "0.5");
                startedDragging('other');
                draggingElement = event.currentTarget;
                
                dragging = true
            },
        
            stop: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "1");
                stoppedDragging('other')
                draggingElement = undefined;
                dragging = false
            }
        });
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:false});
    } else {
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(``)
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:true});
    }

    calculateOtherWeight();
}
refresh_slot_data_player = function(slot) {

    var slot_data = inventory.data.player[slot];
    if (slot_data) {
        if (slot_data.amount <= 0) {
            inventory.data.player[slot] = undefined;
            $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(slotIndex(slot))
            $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:true});
            return;
        }
        var inner = function_setup_slot(slot,inventory.data.player[slot]);
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(inner)
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({
            helper: 'clone',
            appendTo: "body",
            scroll: true,
            revertDuration: 0,
            revert: "invalid",
            cancel: ".item-x",
        
            start: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "0.5");
                startedDragging('player');
                draggingElement = event.currentTarget;
                dragging = true
            },
        
            stop: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "1");
                stoppedDragging('player')
                draggingElement = undefined;
                dragging = false
            }
        });
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:false});
    } else {
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).html(slotIndex(slot))
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${slot}]`).draggable({disabled:true});
    }
}

setupKeyBinds = function() {
    for (let i = 1; i <= 6; i++) {
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${i}]`).html(slotIndex(i))
    }
}

function_setup_inventory = function() {
    setupKeyBinds()
    $.each(inventory.data.player, function(k, v){
        var inner = function_setup_slot(k,v);
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).html(inner)
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({
            helper: 'clone',
            appendTo: "body",
            scroll: true,
            revertDuration: 0,
            revert: "invalid",
            cancel: ".item-x",
        
            start: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "0.5");
                startedDragging('player');
                draggingElement = event.currentTarget;
                dragging = true
                
            },
        
            stop: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "1");
                stoppedDragging('player')
                draggingElement = undefined;
                dragging = false
            }
        });
        $(`.player-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({disabled:false});
    });
}
function_setup_other_invetory = function() {
    $.each(inventory.data.other, function(k, v){
        var inner = function_setup_slot(k,v, true);
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).html(inner)
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({
            helper: 'clone',
            appendTo: "body",
            scroll: true,
            revertDuration: 0,
            revert: "invalid",
            cancel: ".item-x",
        
            start: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "0.5");
                startedDragging('other');
                draggingElement = event.currentTarget;
                dragging = true
                
            },
        
            stop: function(event, ui) {
                $(this).find(".inventory-item-image").css("opacity", "1");
                stoppedDragging('other')
                draggingElement = undefined;
                dragging = false
            }
        });
        $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({disabled:false});
    });
}



// actions 

$(() => {
    $('#give').droppable( {
        drop: handleGiveEvent
    });
    $('#useItem').droppable( {
        drop: handeUseEvent
    });
    $('#inspect').droppable( {
        drop: handleInspectEvent
    });

    window.addEventListener("message", function(event, cb) {
        let action = event.data.action;

        switch(action) {
            case "toggle":
                toggle_inventory(event.data.data.bool, event.data.data.items)
                break;
            case "items":
                inventory.data.items = event.data.data.items;
                inventory.data.slots = event.data.data.slots;
                inventory.data.maxweight = event.data.data.maxweight;
                setup_inventory()
                break;
            case "sync_items":
                inventory.data.player = setup_items(event.data.data.items);
                calculate_player_bar();
                calculateInventoryWeightMain()
                break;
            case "set_other":
                setup_other_inventory(event.data.data.slots);
                inventory.data.otherslots = event.data.data.slots;

                set_other_inventory_data(event.data.data)
           //     calculate_other_bar(event.data.data.items);
                calculateOtherWeight();
                break;
            case "sync_other":
                inventory.data.other = setup_items(event.data.data.items);
             //   calculate_other_bar(inventory.data.other);
                calculateOtherWeight();
                break;

            case "toggle_hotbar":
                if (event.data.bool) {
                    show_some_kanker_slots()
                } else {
                    hide_some_kanker_slots()
                }
                break;
            case "item_notification":
                item_notification(event.data.data.item, event.data.data.amount, event.data.data.reason)
                break;
            case "create_shop":
                CreateShop(event.data.items, event.data.label, event.data.slots, event.data.event, event.data.extra)
                break;
            case "resync_slot":
                var slot = event.data.data.slot;
                refresh_slot_data_player(slot)
                break;
            case "hud:add":
                addHudComponent(event.data)
                break;
            case "hud:set":
                setHudComponent(event.data)
                break;
            case "hud:clear":
                clearHudComps()
                break;
            case "hud:show":
                showHudComp(event.data.index)
                break;
            case "hud:hide":
                hideHudComp(event.data.index)
                break;
            case "crafting":
                SetupCrafting(event.data)
                break;
            case "background":
                setupBackground(event.data.type, event.data.url)
                break;
            case "usableItem":
                handleUsableItem(event.data)
                break;
            case "UpdateMax":
                inventory.data.maxweight = event.data.data.maxweight;
                calculateInventoryWeightMain();
                break;
        }
        if (cb) {
            cb()
        }
    })

    $(document).on("keydown", (e) => {
        switch(e.keyCode) {
            case 27:
                e.preventDefault();
                if (in_inspect) {
                    closeInspect()
                } else {
                    toggle_inventory(false)
                }
            case 9:
                e.preventDefault();
                if (in_inspect) {
                    closeInspect()
                } else {
                    toggle_inventory(false)
                }
        }
    });
})


// functions

set_other_inventory_data = function(data) {
    $(`.other-inventory`).find(`.inventory-title-name`).html(data.label);
    $(`.other-inventory`).data(`event`, data.event);
    $(`.other-inventory`).data(`extra`, data.extra);

    inventory.data.other = setup_items(data.items);
    function_setup_other_invetory()

}

setup_items = function(items) {
    var _ = {}
    $.each(items, function(k, v){
        if (v) {
            _[parseFloat(v.slot)] = v
        }
    });
    return _
}

calculate_player_bar = function() {
//count = 0
//    $.each(inventory.data.player, function(k, v){
  //      count = count+1
   // });

//    proc = 100 / inventory.data.slots * count

 //   $(`.player-inventory`).find(`.inventory-title-amount-inner`).css(`width`, ``+proc+`%`)
}

calculate_other_bar = function(items) {
    // count = 0
    // $.each(items, function(k, v){
    //     count = count+1
    // });
    // proc = 100 / inventory.data.otherslots * count

    // $(`.other-inventory`).find(`.inventory-title-amount-inner`).css(`width`, ``+proc+`%`)
    // $(`.other-inventory`).find(`.inventory-title-amount-inner`).html(``);
}

toggle_inventory = function(bool, items) {
    if (bool) {
        $(`.item-player`).html(``);
        inventory.data.player = setup_items(items);
        function_setup_inventory()
        $(`.main-inventory-containers`).fadeIn(250);
    } else {
        $(`.main-inventory-containers`).fadeOut(250, function(){
        });
        $.post('http://zero-inventory/ui-closed-inv');
        $(`.inventory-current-item-info`).hide();

        $(`.inventory-edit-settings`).fadeOut(250);
      //  saveSettings()
    }
}


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


// another cancer function made by the one and only trif #kanker manius

show_some_kanker_slots = function() {

    $(`.inventory-hotbar`).find(`.item`).html(``);

    for (let i = 1; i <= 6; i++) {
        $(`.inventory-hotbar`).find(`[data-slot=${i}]`).html(`<div class="inventory-keybind"><div class="inventory-keybind-inner">`+i+`</div></div>`)
    }

    $.each(inventory.data.player, function(k, v){
        var inner = function_setup_slot(k,v);
        $(`.inventory-hotbar`).find(`[data-slot=${k}]`).html(inner)
    });

    $(`.inventory-hotbar`).css(`bottom`, `1vh`)
}

hide_some_kanker_slots = function() {
    $(`.inventory-hotbar`).css(`bottom`, `-12.5vh`)
}

{/* <div class="inventory-midle">
<input oninput="change_dial()" min="1" class="amount" type="number">
<div class="midle-use" style="background-image: url(./hand.png);">
    
</div>
<div class="midle-close">
    Sluiten
</div>
</div> */}

notification = 0

item_notification = function(item, amount, reason) {
    notification = notification + 1

    var inner = `
    <div class="item" style="display: none;" id="note-`+notification+`">

    <div class="inventory-keybind">
    <div class="inventory-keybind-inner">`+reason+`</div>
    </div>

    <div class="inventory-item-image" style="background-image: url(./images/`+item+`.png);"></div>
    <div class="inventory-item-label">
    <div class="inventory-item-label-inner">`+inventory.data.items[item].label+`</div>
    </div>
    <div class="inventory-item-amount">
    <div class="inventory-item-amount-inner">
    `+function_valid_amount(item, amount)+`
    </div>
    </div>
    </div>   
    `
    $(`.inventory-notifications`).append(inner)
    
    $(`#note-`+notification+``).fadeIn(300);
    // AnimateCSS(`#note-`+notification+``, 'fadeInRight', function() {
    // })
    remove_note(notification)
}

remove_note = function(x) {
    setTimeout(function() {
        // AnimateCSS(`#note-`+x+``, 'fadeOutLeft', function() {
        //     $(`#note-`+x+``).remove()
        // })
        $(`#note-`+x+``).fadeOut(300, function() {
            $(`#note-`+x+``).remove()
        });
        
    }, 2000)
}

CreateShop = function (items, label, slots, event, extra) {
    setup_shop_slots(slots)
    $(`.other-inventory`).find(`.inventory-title-name`).html(label);
    $(`.other-inventory`).data(`event`, event);
    $(`.other-inventory`).data(`inventory`, `shop`);
    setupShopItems(items);

    if (extra) {
        $(`.other-inventory`).data(`extra`, extra);
    }
    setupItemFunctions()
}

receive_objective_shop = function(index, data) {
    if (data.item) {
        var inner = `

        <div class="inventory-keybind">
        <div class="inventory-keybind-inner pricetag">€`+data.price.toFixed(2)+`</div>
        </div>
    
        <div class="inventory-item-image" style="background-image: url(./images/`+data.item+`.png);"></div>
        <div class="inventory-item-label">
        <div class="inventory-item-label-inner">`+inventory.data.items[data.item].label+`</div>
        </div>
        <div class="inventory-item-amount">
        <div class="inventory-item-amount-inner">
        *
        </div>
        </div>
        `
        return inner;
    }
}

setupShopItems = function(items) {
    $.each(items, function(k, v){
        k = k + 1;
        
        var innerHTML = receive_objective_shop(k,v)
        if  (innerHTML) {
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).data(`item`, v.item)
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).html(innerHTML);
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({
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
            $(`.other-inventory`).find(`.inventory-items-inner`).find(`[data-slot=${k}]`).draggable({disabled:false});
        }
    });
}

resyncSlot = function (slot) {
    refresh_slot_data_player(slot);
}

handeUseEvent = function(event, ui) {
    var draggable = ui.draggable;
    var fromslot    = parseFloat(draggable.attr('data-slot'));
    
    var amount = parseFloat($(".amount").val())
    var amount = amount > 0 && amount || 1

    if (inventory.data.player[fromslot]) {
        var slot = fromslot;
        postUse(slot)  
    }
}

closeInspect = function () {
    $(`#inspect-button`).css(`opacity`, `0`);
    inspect_data = undefined;
    $(`.item-inspect-container`).fadeOut(150);
    $(`.main-inventory-containers`).fadeIn(150);

    
    in_inspect = false;
}

GetSlotOtherInv = function(item, amount) {
    for (let i = 1; i <= inventory.data.otherslots; i++) {
        if (inventory.data.other[i]) {
            if (inventory.data.other[i]['item'] == item && inventory.data.other[i]['amount'] + amount <= inventory.data.items[item].max) {
                var toslot = i;
                return toslot
            }
        }
    }

    for (let i = 1; i <= inventory.data.otherslots; i++) {
        if (inventory.data.other[i] == undefined) {
            var toslot = i;
            return toslot
        }
    }
}

GetSlotMainInv = function(item, amount) {
    for (let i = 1; i <= inventory.data.slots; i++) {
        if (inventory.data.player[i]) {
            if (inventory.data.player[i]['item'] == item && inventory.data.player[i]['amount'] + amount <= inventory.data.items[item].max) {
                var toslot = i;
                return toslot
            }
        }
    }

    for (let i = 1; i <= inventory.data.slots; i++) {
        if (inventory.data.player[i] == undefined) {
            var toslot = i;
            return toslot
        }
    }
}

clickedOnce = false;

handleSingleClick = function(event) {

   // if (clickedOnce) {return}

    clickedOnce = true;

    var extra      = $(`.other-inventory`).data(`extra`);
    var eventJS      = $(`.other-inventory`).data(`event`);

    if (event.currentTarget.dataset.inventory == "player") {
        if ($(`.other-inventory`).data(`inventory`) !== "other") { return }

        var slot = event.currentTarget.dataset.slot;

        if (inventory.data.player[slot]) {
            var item = inventory.data.player[slot]['item'];

            var amount = parseFloat($(".amount").val())
            amount = amount > 0 && amount || 1
            amount = amount <= inventory.data.player[slot]['amount'] && amount || inventory.data.player[slot]['amount']
    
            if (item) {
                var toslot = GetSlotOtherInv(item, amount);
                var free = inventory.data.other[toslot];
    
                if (toslot) {
                    if (free) {
                        inventory.data.player[slot].amount =  inventory.data.player[slot].amount - amount;
                        inventory.data.other[toslot].amount = inventory.data.other[toslot].amount + amount
        
                        refresh_slot_data_player(slot)
                        refresh_slot_data_other(toslot)
                    } else {
                        inventory.data.player[slot].amount =  inventory.data.player[slot].amount - amount;
                        inventory.data.other[toslot] = copy_table_index(inventory.data.player[slot], {
                            ['amount'] : amount,
                            ['slot'] : toslot,
                        })
                        refresh_slot_data_player(slot)
                        refresh_slot_data_other(toslot)
                    }
        
                    $.post('http://zero-inventory/ui-drag-inv', JSON.stringify({
                        frominv : "player",
                        fromslot : slot,
                        toinv : "other",
                        toslot : toslot,
                        event : eventJS,
                        extra : extra,
                        amount : amount,
                    }));
                    $(`.inventory-current-item-info`).hide();

                    clickedOnce = false;
                }
            }
        } else {
            clickedOnce = false
        }
    } else if (event.currentTarget.dataset.inventory == "other") {
        var slot = event.currentTarget.dataset.slot;
        var shopitem = event.currentTarget.dataset.shop;

        if (shopitem == undefined) {
            if (inventory.data.other[slot]) {
                var item = inventory.data.other[slot]['item'];
    
                var amount = parseFloat($(".amount").val())
                amount = amount > 0 && amount || 1
                amount = amount <= inventory.data.other[slot]['amount'] && amount || inventory.data.other[slot]['amount']
        
                if (item) {
                    var toslot = GetSlotMainInv(item, amount);
                    var free = inventory.data.player[toslot];
        
                
                    if (toslot) {
                        if (free) {
                            inventory.data.other[slot].amount =  inventory.data.other[slot].amount - amount;
                            inventory.data.player[toslot].amount = inventory.data.player[toslot].amount + amount
            
                            refresh_slot_data_player(toslot)
                            refresh_slot_data_other(slot)
                        } else {
                            inventory.data.other[slot].amount =  inventory.data.other[slot].amount - amount;
                            inventory.data.player[toslot] = copy_table_index(inventory.data.other[slot], {
                                ['amount'] : amount,
                                ['slot'] : toslot,
                            })
                            refresh_slot_data_player(toslot)
                            refresh_slot_data_other(slot)
                        }
                
                        $.post('http://zero-inventory/ui-drag-inv', JSON.stringify({
                            frominv : "other",
                            fromslot : slot,
                            toinv : "player",
                            toslot : toslot,
                            event : eventJS,
                            extra : extra,
                            amount : amount,
                        }));
                        $(`.inventory-current-item-info`).hide();
                        clickedOnce = false;
                    }
                }
            }
        } else {
            var item = $(event.currentTarget).data(`item`);   

            var amount = parseFloat($(".amount").val())
            amount = amount > 0 && amount || 1
            amount = amount <= inventory.data.items[item].max && amount || inventory.data.items[item].max
            
            var toslot = GetSlotMainInv(item, amount);
            var free = inventory.data.player[toslot];
            
            if (toslot) {
                $.post('http://zero-inventory/ui-drag-inv', JSON.stringify({
                    frominv : "other",
                    fromslot : slot,
                    toinv : "player",
                    toslot : toslot,
                    event : eventJS,
                    extra : extra,
                    amount : amount,
                }));
              
                $(`.inventory-current-item-info`).hide();
                clickedOnce = false;
            }
        }
    }



    //     if (inventory.data.player[slot]) {
    //         if (inventory.data.items[inventory.data.player[slot].item].type == "weapon") {
    //             $(`#inspect-button`).css(`opacity`, `1`);
    //             inspect_data = inventory.data.player[slot];
    //             inspect_data_slot = slot;
    //         } else {
    //             $(`#inspect-button`).css(`opacity`, `0`);
    //             inspect_data = undefined;
    //         }
    //     } else {
    //         $(`#inspect-button`).css(`opacity`, `0`);
    //         inspect_data = undefined;
    //     }
    // }
}

handleInspectEvent = function (event, ui) {
    var draggable = ui.draggable;
    var fromslot    = parseFloat(draggable.attr('data-slot'));
    inspect_data = inventory.data.player[fromslot];

    if (inspect_data) {
        $(`.main-inventory-containers`).fadeOut(150);

        $(`.inspect-item-name`).html(inventory.data.items[inspect_data.item].label);
        $(`.inspect-item-serie`).html(`Serienummer: ` + inspect_data.datastash.weaponid);
        $(`.inspect-item-ammo`).html(`Ammo: ` + inspect_data.datastash.ammo);

        $(`.durability-inner`).css(`width`, ``+inspect_data.datastash.durability+`%`);
        $(`.durability-inner`).html(``+parseFloat(inspect_data.datastash.durability).toFixed()+`%`)

        $(`.inspect-weapon-image`).html(`<img src="./images/displays/`+inspect_data.item+`.png" alt="">`)

    //    setupComponents(inspect_data)

        $(`.item-inspect-container`).fadeIn(150);

        in_inspect = true;
    }
}

postUse = function(slot) {
    $.post('http://zero-inventory/ui-drag-use', JSON.stringify({slot : slot}));
}

handleGiveEvent = function(event, ui) {
    var draggable = ui.draggable;
    var fromslot    = parseFloat(draggable.attr('data-slot'));
    
    var amount = parseFloat($(".amount").val())
    var amount = amount > 0 && amount || 1

    $.post('http://zero-inventory/GiveItemEvent', JSON.stringify({
        slot : fromslot,
        amount : amount,
    }));
}

addHudComponent = function(data) {
    var inner = `
    <div class="hotbar-hud-item">
        <div class="hotbar-hud-bar" id="`+data.index+`">
            <div class="hud-bar-inner" style="background-color: `+data.colour+`;">0%</div>
        </div>
        <div class="hud-item-label">`+data.title+`</div>
    </div>
    `

    $(`.hotbar-hud`).append(inner);
}

setHudComponent = function(data) {
    $(`#`+data.index+``).find(`.hud-bar-inner`).css(`width`, ``+data.perc+`%`);
    $(`#`+data.index+``).find(`.hud-bar-inner`).html(``+data.perc+`%`)
}

clearHudComps = function() {
    $(`.hotbar-hud`).html(``);
}

GetValidAttachments = function (index) {
    $.post('http://zero-inventory/ReceiveAttachments', JSON.stringify({item : inspect_data.item, attachment : index}), function(parts) {
        $.each(parts, function(k, v){
            $(`#`+index+`-dropdown`).append('<li data-type="'+index+'" id="'+k+'">'+v+'</li>')
        })
    });
}

setupComponents = function() {
    $(`.top-weapon-attachments`).html(``)
    if (inspect_data.datastash.attachments) {
        $.each(inspect_data.datastash.attachments, function(k, v){
       
            var inner = `
            <div class="inspect-attachment">
                <div class="inspect-attachment-img" style="background-image: url(./images/`+k+`.png);"></div>
                <div class="dropdown">
                    <div class="select">
                      <span>Component index: `+v.index+`</span>
                    </div>
                    <input type="hidden" name="gender">
                    <ul class="dropdown-menu" id="`+k+`-dropdown">
                     
                    </ul>
                  </div>
            </div>
            `
           
            $(`.top-weapon-attachments`).append(inner)
            GetValidAttachments(k)
        })

        setTimeout(function() {
            $('.dropdown').click(function () {
                $(this).attr('tabindex', 1).focus();
                $(this).toggleClass('active');
                $(this).find('.dropdown-menu').slideToggle(300);
            });
            $('.dropdown').focusout(function () {
                $(this).removeClass('active');
                $(this).find('.dropdown-menu').slideUp(300);
            });
            $('.dropdown .dropdown-menu li').click(function () {
                $(this).parents('.dropdown').find('span').text($(this).text());
                $(this).parents('.dropdown').find('input').attr('value', $(this).attr('id'));

                $.post('http://zero-inventory/selectedAttachment', JSON.stringify({
                    data : inspect_data,
                    slot : inspect_data_slot,
                    comp : $(this).attr('id'),
                    type : $(this).data(`type`)
                }));
            });
        }, 1500)
    }
}



setupBackground = function(type, url) {
    $(`.`+type+`-inventory`).css(`background-image`, `url(`+url+`)`)
}

showHudComp = function(index) {
    $(`#`+index+``).parent().fadeIn(150)
}

hideHudComp = function(index) {
    $(`#`+index+``).parent().fadeOut(150)
}

startedDragging = function(x) {
    if (x == "player") {
        $(`.midle-use`).show();
    } else if (x == "other") {
        $(`.midle-use`).hide();
    }
}
stoppedDragging = function(x) {
    $(`.midle-use`).hide();
}

MouseLeaveItem = function (event) {
    $(`.inventory-current-item-info`).hide();
}

jQuery.fn.getCoord = function()
{
  var elem = $(this);
  var x = elem.offset().left;
  var y = elem.offset().top;

  return {
      "x" : x,
      "y" : y
  };

};

MouseEnterItem = function (event) {
    if (event.currentTarget.dataset.inventory) {
        if (event.currentTarget.dataset.inventory == "player") {
            var slot = event.currentTarget.dataset.slot;
            var data = inventory.data.player[slot];

            if (data) {
                var coord = $(event.currentTarget).getCoord();

                coord.x = coord.x + 250.0;

                setInfoData(data);

                $(`.inventory-current-item-info`).css(`left`, ``+coord.x+`px`)
                $(`.inventory-current-item-info`).css(`top`, ``+coord.y+`px`)

                $(`.inventory-current-item-info`).show();
            }
        } else {
            var slot = event.currentTarget.dataset.slot;
            var data = inventory.data.other[slot];

            if (data) {

                setInfoData(data);

                var coord = $(event.currentTarget).getCoord();

                coord.x = coord.x + 250.0;

                $(`.inventory-current-item-info`).css(`left`, ``+coord.x+`px`)
                $(`.inventory-current-item-info`).css(`top`, ``+coord.y+`px`)

                $(`.inventory-current-item-info`).show();
            }
        }
    }
}


function calculateWeight(amount, item) {
    var weight = inventory.data.items[item]['weight'];

    weight = weight * amount;
    weight = weight + 0.0

    return weight.toFixed(2);
}

function setInfoData(data) {
    $(`.item-info-name`).html(inventory.data.items[data.item]['label']);
    $(`.metainfo`).html(``);

    if (inventory.data.items[data.item]['type']) {
        if (inventory.data.items[data.item]['type'] == 'weapon') {
            $(`.metainfo`).html(`
            <div class="item-info-set">Serienummer: `+data.datastash.weaponid+`</div>
            <div class="item-info-set">Ammo: `+data.datastash.ammo+`</div>
            `)
            $(`#bottom-info`).html(`Hoeveelheid: `+data.amount+`x | Weight: `+calculateWeight(data.amount, data.item)+`kg | Kwaliteit: `+data.datastash.durability.toFixed(2)+`%`)
        } else if (inventory.data.items[data.item]['type'] == 'personal') {
            $(`.metainfo`).html(`
            <div class="item-info-set">Voornaam: `+data.datastash.PlayerData.firstname+`</div>
            <div class="item-info-set">Achternaam: `+data.datastash.PlayerData.lastname+`</div>
            <div class="item-info-set">BSN: `+data.datastash.PlayerData.Citizenid+`</div>
            <div class="item-info-set">Geboortedatum: `+data.datastash.PlayerData.birthdate+`</div>
            <div class="item-info-set">Gender: `+data.datastash.PlayerData.gender+`</div>
            <div class="item-info-set">Nationaliteit: `+data.datastash.PlayerData.nationality+`</div>
            `)
            $(`#bottom-info`).html(`Hoeveelheid: `+data.amount+`x | Weight: `+calculateWeight(data.amount, data.item)+`kg`)
        } else if (inventory.data.items[data.item]['type'] == "message") {
            $(`.metainfo`).html(`
            <div class="item-info-set">`+data.datastash.message+`</div>
            `)
            $(`#bottom-info`).html(`Hoeveelheid: `+data.amount+`x | Weight: `+calculateWeight(data.amount, data.item)+`kg`)
        } else {
            $(`#bottom-info`).html(`Hoeveelheid: `+data.amount+`x | Weight: `+calculateWeight(data.amount, data.item)+`kg`)
        }
    } else {
        $(`#bottom-info`).html(`Hoeveelheid: `+data.amount+`x | Weight: `+calculateWeight(data.amount, data.item)+`kg`)
    }
}

function calculateInventoryWeightMain() {
    var amount = 0;

    $.each(inventory.data.player, function(k, v){
        if (v) {
            var weightamount = inventory.data.items[v.item]['weight'];
            var itemamount = v.amount
            var weight = weightamount * itemamount;
    
            amount = amount + weight;
        }
    });


    var proc = 100 / inventory.data.maxweight * amount

    $(`.player-inventory`).find(`.inventory-title-amount-inner`).css(`width`, ``+proc+`%`)
    $(`#player-weight`).html(amount.toFixed(2) + `/`+inventory.data.maxweight+`kg`)
}

function calculateOtherWeight() {
    var amount = 0;

    $.each(inventory.data.other, function(k, v){
        if (v) {
            var weightamount = inventory.data.items[v.item]['weight'];
            var itemamount = v.amount
            var weight = weightamount * itemamount;
    
            amount = amount + weight;
        }
    });


    $(`#other-weight`).html(amount.toFixed(2) + `kg`)
}

function handleUsableItem(data) {
    if (data.bool) {
        $(`.inventory-use-display`).fadeIn(150)
        $(`#usable`).find(`.inventory-item-image`).css(`background-image`, `url(./images/`+data.item+`.png)`)
        $(`#usable`).find(`.inventory-item-label-inner`).html(inventory.data.items[data.item]['label'])
    } else {
        $(`.inventory-use-display`).fadeOut(150)
    }
}