change_dial = function() {
    value = $(`.amount`).val()
    if (value == "" || value == undefined) {
        return
    }
    
    value = value >= 1 && value || 1
    $(`.amount`).val(value)
}


// dropping

copy_table_index = function(indexes, diff) {
    var i = {};
    $.each(indexes, function(k, v){
        i[k] = v;
    });
    
    $.each(diff, function(k, v){
        i[k] = v;
    });
    return i
}

handleDropEvent = function(event, ui) {
    var draggable = ui.draggable;
    var droppable = ui.droppable;

    var amount = parseFloat($(".amount").val())
    amount = amount > 0 && amount || 1

    var fromslot    = parseFloat(draggable.attr('data-slot'));
    var frominv     = draggable.attr('data-inventory');

    var toslot     = parseFloat(event.target.dataset.slot)
    var toinv      = event.target.dataset.inventory

    var extra      = $(`.other-inventory`).data(`extra`);
    var eventJS      = $(`.other-inventory`).data(`event`);

    if (frominv == "player" && toinv == frominv) {
        let from_slot_data = inventory.data.player[fromslot];
        let to_slot_data   = inventory.data.player[toslot];

        if (from_slot_data) {
            amount = amount <= from_slot_data.amount && amount || from_slot_data.amount

            
            if (to_slot_data) {
                if (from_slot_data.item == to_slot_data.item) {
                    if (inventory.data.items[from_slot_data.item].max > 1) {
                        if (to_slot_data.amount + amount > inventory.data.items[from_slot_data.item].max) {
                            NEW_To = copy_table_index(inventory.data.player[fromslot], {
                                ['slot'] : toslot,
                            })
                            NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                                ['slot'] : fromslot,
                            })

                            inventory.data.player[fromslot] = NEW_Fr
                            inventory.data.player[toslot] = NEW_To

                            refresh_slot_data_player(fromslot)
                            refresh_slot_data_player(toslot)
                        } else {
                            inventory.data.player[fromslot].amount =  inventory.data.player[fromslot].amount - amount;
                            inventory.data.player[toslot].amount = inventory.data.player[toslot].amount + amount

                            refresh_slot_data_player(fromslot)
                            refresh_slot_data_player(toslot)
                        }
                    } else {
                        NEW_To = copy_table_index(inventory.data.player[fromslot], {
                            ['slot'] : toslot,
                        })
                        NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                            ['slot'] : fromslot,
                        })
                        
                        inventory.data.player[fromslot] = NEW_Fr
                        inventory.data.player[toslot] = NEW_To

                        refresh_slot_data_player(fromslot)
                        refresh_slot_data_player(toslot)
                    }
                } else {
                    NEW_To = copy_table_index(inventory.data.player[fromslot], {
                        ['slot'] : toslot,
                    })
                    NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                        ['slot'] : fromslot,
                    })
                    
                    inventory.data.player[fromslot] = NEW_Fr
                    inventory.data.player[toslot] = NEW_To

                    refresh_slot_data_player(fromslot)
                    refresh_slot_data_player(toslot)
                }
            } else {      
                inventory.data.player[fromslot].amount = inventory.data.player[fromslot].amount-amount
                inventory.data.player[toslot] = copy_table_index(inventory.data.player[fromslot], {
                    ['amount'] : amount,
                    ['slot'] : toslot,
                })

                refresh_slot_data_player(fromslot)
                refresh_slot_data_player(toslot)
            }
        }
    } else if (frominv == "other" && toinv == "player") {
        let from_slot_data = inventory.data.other[fromslot];
        let to_slot_data   = inventory.data.player[toslot];

        if (from_slot_data) {
            amount = amount <= from_slot_data.amount && amount || from_slot_data.amount
            
            if (to_slot_data) {
                if (from_slot_data.item == to_slot_data.item) {
                    if (inventory.data.items[from_slot_data.item].max > 1) {
                        if (to_slot_data.amount + amount > inventory.data.items[from_slot_data.item].max) {
                            NEW_To = copy_table_index(inventory.data.other[fromslot], {
                                ['slot'] : toslot,
                            })
                            NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                                ['slot'] : fromslot,
                            })

                            inventory.data.other[fromslot] = NEW_Fr
                            inventory.data.player[toslot] = NEW_To

                            refresh_slot_data_other(fromslot)
                            refresh_slot_data_player(toslot)
                        } else {
                            inventory.data.other[fromslot].amount =  inventory.data.other[fromslot].amount - amount;
                            inventory.data.player[toslot].amount = inventory.data.player[toslot].amount + amount

                            refresh_slot_data_other(fromslot)
                            refresh_slot_data_player(toslot)
                        }
                    } else {
                        NEW_To = copy_table_index(inventory.data.other[fromslot], {
                            ['slot'] : toslot,
                        })
                        NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                            ['slot'] : fromslot,
                        })

                        inventory.data.other[fromslot] = NEW_Fr
                        inventory.data.player[toslot] = NEW_To

                        refresh_slot_data_other(fromslot)
                        refresh_slot_data_player(toslot)
                    }
                } else {
                    NEW_To = copy_table_index(inventory.data.other[fromslot], {
                        ['slot'] : toslot,
                    })
                    NEW_Fr = copy_table_index(inventory.data.player[toslot], {
                        ['slot'] : fromslot,
                    })

                    inventory.data.other[fromslot] = NEW_Fr
                    inventory.data.player[toslot] = NEW_To

                    refresh_slot_data_other(fromslot)
                    refresh_slot_data_player(toslot)
                }
            } else {      
                inventory.data.other[fromslot].amount = inventory.data.other[fromslot].amount-amount
                inventory.data.player[toslot] = copy_table_index(inventory.data.other[fromslot], {
                    ['amount'] : amount,
                    ['slot'] : toslot,
                })
                refresh_slot_data_other(fromslot)
                refresh_slot_data_player(toslot)
            }
        }
    } else if (toinv == "other" && frominv == "player") {
        let from_slot_data = inventory.data.player[fromslot];
        let to_slot_data   = inventory.data.other[toslot];

        if (from_slot_data) {
            amount = amount <= from_slot_data.amount && amount || from_slot_data.amount
            
            if (to_slot_data) {
                if (from_slot_data.item == to_slot_data.item) {
                    if (inventory.data.items[from_slot_data.item].max > 1) {
                        if (to_slot_data.amount + amount > inventory.data.items[from_slot_data.item].max) {
                            NEW_To = copy_table_index(inventory.data.player[fromslot], {
                                ['slot'] : toslot,
                            })
                            NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                                ['slot'] : fromslot,
                            })

                            inventory.data.player[fromslot] = NEW_Fr
                            inventory.data.other[toslot] = NEW_To

                            refresh_slot_data_other(toslot)
                            refresh_slot_data_player(fromslot)
                        } else {
                            inventory.data.player[fromslot].amount =  inventory.data.player[fromslot].amount - amount;
                            inventory.data.other[toslot].amount = inventory.data.other[toslot].amount + amount

                            refresh_slot_data_other(toslot)
                            refresh_slot_data_player(fromslot)
                        }
                    } else {
                        NEW_To = copy_table_index(inventory.data.player[fromslot], {
                            ['slot'] : toslot,
                        })
                        NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                            ['slot'] : fromslot,
                        })

                        inventory.data.player[fromslot] = NEW_Fr
                        inventory.data.other[toslot] = NEW_To

                        refresh_slot_data_other(toslot)
                        refresh_slot_data_player(fromslot)
                    }
                } else {
                    NEW_To = copy_table_index(inventory.data.player[fromslot], {
                        ['slot'] : toslot,
                    })
                    NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                        ['slot'] : fromslot,
                    })

                    inventory.data.player[fromslot] = NEW_Fr
                    inventory.data.other[toslot] = NEW_To

                    refresh_slot_data_other(toslot)
                    refresh_slot_data_player(fromslot)
                }
            } else {      
                inventory.data.player[fromslot].amount = inventory.data.player[fromslot].amount-amount
                inventory.data.other[toslot] = copy_table_index(inventory.data.player[fromslot], {
                    ['amount'] : amount,
                    ['slot'] : toslot,
                })
                refresh_slot_data_other(toslot)
                refresh_slot_data_player(fromslot)
            }
        }
    } else if (frominv == "other" && toinv == "other") {
        let from_slot_data = inventory.data.other[fromslot];
        let to_slot_data   = inventory.data.other[toslot];

        if (from_slot_data) {
            amount = amount <= from_slot_data.amount && amount || from_slot_data.amount
            
            if (to_slot_data) {
                if (from_slot_data.item == to_slot_data.item) {
                    if (inventory.data.items[from_slot_data.item].max > 1) {
                        if (to_slot_data.amount + amount > inventory.data.items[from_slot_data.item].max) {
                            NEW_To = copy_table_index(inventory.data.other[fromslot], {
                                ['slot'] : toslot,
                            })
                            NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                                ['slot'] : fromslot,
                            })

                            inventory.data.other[fromslot] = NEW_Fr
                            inventory.data.other[toslot] = NEW_To

                            refresh_slot_data_other(fromslot)
                            refresh_slot_data_other(toslot)
                        } else {
                            inventory.data.other[fromslot].amount =  inventory.data.other[fromslot].amount - amount;
                            inventory.data.other[toslot].amount = inventory.data.other[toslot].amount + amount

                            refresh_slot_data_other(fromslot)
                            refresh_slot_data_other(toslot)
                        }
                    } else {
                        NEW_To = copy_table_index(inventory.data.other[fromslot], {
                            ['slot'] : toslot,
                        })
                        NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                            ['slot'] : fromslot,
                        })
                        
                        inventory.data.other[fromslot] = NEW_Fr
                        inventory.data.other[toslot] = NEW_To

                        refresh_slot_data_other(fromslot)
                        refresh_slot_data_other(toslot)
                    }
                } else {
                    NEW_To = copy_table_index(inventory.data.other[fromslot], {
                        ['slot'] : toslot,
                    })
                    NEW_Fr = copy_table_index(inventory.data.other[toslot], {
                        ['slot'] : fromslot,
                    })
                    
                    inventory.data.other[fromslot] = NEW_Fr
                    inventory.data.other[toslot] = NEW_To

                    refresh_slot_data_other(fromslot)
                    refresh_slot_data_other(toslot)
                }
            } else {      
                inventory.data.other[fromslot].amount = inventory.data.other[fromslot].amount-amount
                inventory.data.other[toslot] = copy_table_index(inventory.data.other[fromslot], {
                    ['amount'] : amount,
                    ['slot'] : toslot,
                })

                refresh_slot_data_other(fromslot)
                refresh_slot_data_other(toslot)
            }
        }
    }

    $.post('http://zero-inventory/ui-drag-inv', JSON.stringify({
        frominv : frominv,
        fromslot : fromslot,
        toinv : toinv,
        toslot : toslot,
        event : eventJS,
        extra : extra,
        amount : amount,
    }));
}
