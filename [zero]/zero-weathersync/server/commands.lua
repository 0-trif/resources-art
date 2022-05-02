Zero.Commands.Add("blackout", "Toggle blackout (Admin Only)", {}, false, function(source, args)
    ToggleBlackout()
end, 1)

Zero.Commands.Add("clock", "Set exact time (Admin Only)", {}, false, function(source, args)
    if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
        SetExactTime(args[1], args[2])
    end
end, 1)

Zero.Commands.Add("time", "Set time (Admin Only)", {{name="time", help='value of time'}}, true, function(source, args)
    for _, v in pairs(AvailableTimeTypes) do
        if args[1]:upper() == v then
            SetTime(args[1])
            return
        end
    end
end, 1)

Zero.Commands.Add("weather", "Set weather (Admin Only)", {{name="weather", help='value of weather type'}}, false, function(source, args)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, 1)
