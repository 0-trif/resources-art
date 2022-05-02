exports['zero-core'].object(function(O) {
    Zero = O;
})

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

function randomInterval() {
    var max = config.interval;
    var interval = 1500 + getRandomInt(max);

    return interval
}
