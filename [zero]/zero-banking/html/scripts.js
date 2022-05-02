$(function() {
  window.addEventListener("message", function(event, cb) {
    let action = event.data.action;

    switch(action) {
      case "OpenBank": {
        $(`.banking-main-container`).show();
        break;
      };
      case "UpdateMoney": {
        UpdateMoney(event.data.money);
        break;
      }
      case "history": {
        CreateHistoryTab(event.data.title, event.data.subtitle, event.data.amount, event.data.bool, event.data.time);
        break;
      };
      case "UpdateSafe": {
        UpdateCurrentSafe(event.data.data, event.data.money)
        break;
      }
    }
});

  $(document).on("keydown", (e) => {
      switch(e.keyCode) {
          case 27:
              Close();
              break;
          case 77:
              Close();
              break;
      }
  });
})

function Close() {

  $.post('https://zero-banking/close');

  $(`.banking-main-container`).hide();
  $(`.private-safe-container`).hide();
}

function TransferMoney(event) {
  var Target = $(event.currentTarget);

  var bsn = $(`#bsn`).val();
  var InputAmount = $(`#transferInput`).val();

  let amount = parseFloat(InputAmount);
  if (amount > 0 && bsn !== undefined) {
    $.post('https://zero-banking/event', JSON.stringify({
        type: "transfer",
        bsn: bsn,
        amount: amount,
    }));

    $(`#transferInput`).val(0);
  }
}

function RemoveMoney(event) {
  var Target = $(event.currentTarget);
  var InputAmount = Target.parent().find(`input`).val();

  let amount = parseFloat(InputAmount);
  if (amount > 0) {
   
    $.post('https://zero-banking/event', JSON.stringify({
        type: "remove",
        amount: amount,
    }));

    Target.parent().find(`input`).val(0);
  }
}

function PostMoney(event) {
  var Target = $(event.currentTarget);
  var InputAmount = Target.parent().find(`input`).val();

  let amount = parseFloat(InputAmount);
  if (amount > 0) {
    $.post('https://zero-banking/event', JSON.stringify({
      type: "add",
      amount: amount,
    }));

    Target.parent().find(`input`).val(0);
  }
}

function UpdateMoney(money) {
  $(`.bank-amount-inner`).html(money.bank);
  $(`.cash-amount-inner`).html(money.cash);
}


function sign(bool) {
  if (bool) {
    return `+`
  } else {
    return `-`
  }
}

function CreateHistoryTab(title, subtitle, amount, bool, time) {
  var inner = `
  <div class="history-tab">
  <div class="history-name">`+title+`</div>
  <div class="history-subname">`+subtitle+`</div>
  <div class="history-time">`+time+`</div>

  <div class="history-amount ${!bool && `negative` || `positive`}"> `+sign(bool)+` €`+amount+`</div>
  </div>
  `

  $(`.history-container`).prepend(inner);
}

function UpdateCurrentSafe(data, money) {
  LastId = data.id;

  $(`#safeid`).html(data.id);
  $(`#safetype`).html(data.type);
  $(`#safeamount`).html(data.amount);

  $(`#cashmoney`).html(`Contant: ` + money.cash);
  $(`#blackmoney`).html(`Zwartgeld: ` + money.black);

  $(`.private-safe-container`).show();
}

function RemoveMoneySafe() {
  var amount = $(`#safeAmount`).val();
  if (LastId) {
    $.post('https://zero-banking/SafeEvent', JSON.stringify({
      type: "remove",
      amount: amount,
      id:LastId,
    }));
  }
}

function AddMoneySafe() {
  var amount = $(`#safeAmount`).val();
  if (LastId) {
    $.post('https://zero-banking/SafeEvent', JSON.stringify({
      type: "add",
      amount: amount,
      id:LastId,
    }));
  }
}