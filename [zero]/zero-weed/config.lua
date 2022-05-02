Config = {}
Config.Location = vector3(3768.42,4477.26,7.39)

Config.LingLing = {x = -138.47, y = -1659.18, z = 36.51, h = 230.00, model = "csb_hao"}
Config.Daggoe = {x = -138.47, y = -1659.18, z = 36.51, h = 230.00, model = "a_c_poodle"}

Config.MaxEntitys = 10
Config.Model = "prop_weed_02"
Config.Split = 3

Config.MailText = function(amount, name)
    return "Ghello "..name..", <br><br> Voor het ophalen van jou pakketje kan je bij de volgende locatie terecht! <br><br> Bestelling: "..amount.."x onbekende inhoud. <br> <br> Ons bedrijf is niet verantwoordelijk voor verlies van de pakketjes bij het ophalen."
end

Config.PickUpLocations = {
    {x = -1186.23, y = -2152.67, z = 13.22, h = 313.06},
    {x = -641.05, y = -1220.17, z = 11.50, h = 337.94},
    {x = -60.35, y = -1225.00, z = 28.75, h = 330.94},
    {x = 484.55, y = -843.82, z = 25.18, h = 292.94},
    {x = 309.62, y = -1927.34, z = 24.76, h = 136.07},
}


Config.WeedPrice = 10