var Zero:any = {};
exports['zero-core'].object(function(O: any) {Zero = O})

onNet("Zero:Server-Laundering:Trade", () => {
    var src = source;
    var Player = Zero.Functions.Player(src);
    var BlackMoney = Player.Money.black

    if (BlackMoney > 0) {
        let TradeOffer = (BlackMoney/100*config.Percentage);

        Player.Functions.RemoveMoney("black", BlackMoney, "Zwartgeld inruilen voor cash (witwas)");
        Player.Functions.GiveMoney("cash", TradeOffer, "Cash ontvangen voor witwassen van zwartgeld");
    } else {
        Zero.Functions.Notification("Witwassen", "Je hebt geen zwargeld", "error", 8000);
    }
});