config = {}

config.appartments = {
	['blokkenpark'] = {
		['label'] = "Blokkenpark appartments",
		['location'] = {x = 68.62, y = -958.89, z = 29.80, h = 160.00},
		['transition'] = {
			[1] = {x = 131.78, y = -1021.66, z = 60.49, h = 190.00},
			[2] = {x = 38.10, y = -975.36, z = 53.92, h = 297.29},
		},
		['entry'] = {
			[1] = {x = 68.62, y = -958.89, z = 29.80, h = 160.00},
			[2] = {x = 55.43, y = -915.01, z = 30.00, h = 72.00},
			[3] = {x = 104.92, y = -933.09, z = 29.81, h = 252.00},
		},
		['interior'] = "classicmotel_shell",
		['garage'] = {x = 39.89, y = -882.48, z = 30.27, h = 160.38, size = 50},
	},
	['richards_majestic'] = {
		['label'] = "Richards tower",
		['location'] = {x = -936.16, y = -379.12, z = 38.96, h = 190.00},
		['transition'] = {
			[1] = {x = -940.92, y = -657.76, z = 134.67, h = 190.00},
			[2] = {x = -982.06, y = -419.72, z = 60.53, h = 116.00},
		},
		['entry'] = {
			[1] = {x = -936.16, y = -379.12, z = 38.96, h = 190.00},
		},
		['interior'] = "classicmotel_shell",
		['garage'] = {x = -894.95, y = -340.34, z = 33.52, h = 209.83, size = 20},
	},
	['eclipse_tower'] = {
		['label'] = "Eclipse tower",
		['location'] = {x = -774.02, y = 312.43, z = 85.69, h = 190.00},
		['transition'] = {
			[1] = {x = -743.07, y = 61.00, z = 175.32, h = 19.00},
			[2] = {x = -837.34, y = 266.32, z = 150.84, h = 316.24},
		},
		['entry'] = {
			[1] = {x = -774.02, y = 312.43, z = 85.69, h = 190.00},
		},
		['interior'] = "classicmotel_shell",
		['garage'] = {x = -792.82, y = 329.29, z = 85.70, h = 148.00 , size = 15},
	},
	['callisto_tower'] = {
		['label'] = "Callisto tower",
		['location'] = {x = 350.59, y = -9.72, z = 91.68, h = 190.00},
		['transition'] = {
			[1] = {x = 281.24, y = 87.95, z = 126.69, h = 190.00},
			[2] = {x = 377.10, y = 1.14, z = 115.95, h = 116.00},
		},
		['entry'] = {
			[1] = {x = 350.59, y = -9.72, z = 91.68, h = 190.00},
		},
		['interior'] = "classicmotel_shell",
		['garage'] = {x = 363.255, y = -79.01, z = 67.33, h = 246.07, size = 10},
	},
	['arcadius_tower'] = {
		['label'] = "Arcadius tower",
		['location'] = {x = -115.72, y = -603.22, z = 36.28, h = 190.00},
		['transition'] = {
			[1] = {x = -130.94, y = -310.52, z = 163.31, h = 190.00},
			[2] = {x = -27.17, y = -541.26, z = 106.59, h = 109.00},
		},
		['entry'] = {
			[1] = {x = -115.72, y = -603.22, z = 36.28, h = 190.00},
		},
		['interior'] = "classicmotel_shell",
		['garage'] = {x = -156.45559692383, y = -599.31286621094, z = 32.424514770508, h = 141.40733337402, size = 50.0}
	},
}
exports("locations", function(cb)
	cb(config.appartments)
end)

config.interiors = {
	['classicmotel_shell'] = {
		['exit'] = {x = 0.04, y = -3.448, z = -1.337, h = 1.183},
		['stash'] = {x = 4.35, y = 0.0645, z = -1.337, h = 1.183},
		['clothing'] = {x = 2.93, y = 2.81, z = -1.33, h = 175.93},
	}
}

config.render = {}

config.render.min = 30
config.render.visible = true


config.vars = {}
config.vars.inside = false
