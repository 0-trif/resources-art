Shared = {}

Shared.Config = {}



Shared.Config.Doors = {
	{ -- MRPD ENTRANCE
		textCoords = {x = 434.88586425781, y = -981.93579101563, z = 30.689582824707, heading = 268.08740234375},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = -1547307588,
				objYaw = 90.0,
				objCoords = vector3(434.7444, -983.0781, 30.8153)
			},

			{
				objName = -1547307588,
				objYaw = -90.0,
				objCoords = vector3(434.7444, -980.7556, 30.8153)
			}
		}
	},
	{ -- MRPD NORTH ENTRANCE
		textCoords = {x = 456.96389770508, y = -972.29541015625, z = 30.710138320923, heading = 85.067192077637},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = -1547307588,
				objYaw = 180.0,
				objCoords = vector3(458.2087, -972.2543, 30.8153)
			},

			{
				objName = -1547307588,
				objYaw = 0.0,
				objCoords = vector3(455.8862, -972.2543, 30.8153)
			}
		}
	},
	{ -- MRPD NORTH ENTRANCE
		textCoords = {x = 441.90179443359, y = -998.80975341797, z = 30.726669311523, heading = 345.41473388672},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = -1547307588,
				objYaw = 0.0,
				objCoords = vector3(440.7392, -998.7462, 30.8153)
			},

			{
				objName = -1547307588,
				objYaw = 180.0,
				objCoords = vector3(443.0618, -998.7462, 30.8153)
			}
		}
	},
	{
		textCoords = {x = 464.20907592773, y = -975.37542724609, z = 26.373973846436, heading = 86.123352050781},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		objName = 1830360419,
		objYaw = -90.0,
		objCoords = vector3(464.1591, -974.6656, 26.3707),
	},
	{
		textCoords = {x = 464.14373779297, y = -996.59045410156, z = 26.373975753784, heading = 90.870788574219},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		objName = 1830360419,
		objYaw = 90.0,
		objCoords = vector3(464.1566, -997.5093, 26.3707),
	},

	{ -- garage back doors
		textCoords = {x = 468.56314086914, y = -1014.3216552734, z = 26.425777435303, heading = 83.44359588623},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = -692649124,
				objYaw = 0.0,
				objCoords = vector3(467.3686, -1014.406, 26.48382)
			},

			{
				objName = -692649124,
				objYaw = 180.0,
				objCoords = vector3(469.7743, -1014.406, 26.48382)
			}
		},
	},

	{ -- prison gate
		textCoords = {x = 1844.7409667969, y = 2608.2797851563, z = 45.587856292725, heading = 81.322731018066},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5.0,
		objName = 741314661,
		objYaw = 90.0,
		objCoords = vector3(1844.99, 2604.81, 44.63),
	},
	{ -- prison gate
		textCoords = {x = 1817.84765625, y = 2608.3801269531, z = 45.59513092041, heading = 89.169548034668},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5.0,
		objName = 741314661,
		objYaw = 90.0,
		objCoords = vector3(1818.53, 2604.81, 44.63),
	},
	{ -- prison gate
		textCoords = {x = 1831.3121337891, y = 2594.1945800781, z = 46.014320373535, heading = 266.05645751953},
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		objName = -684929024,
		objYaw = 90.0,
		objCoords = vector3(1831.12, 2594.64, 46.09),
	},


	-- mrpd prison cells
	{ 
		textCoords = vector3(477.9126, -1012.189, 26.48005),
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		objName = -53345114,
		objYaw = 0.0,
		objCoords = vector3(477.9126, -1012.189, 26.48005),
	},
	{ 
		textCoords = vector3(480.9128, -1012.189, 26.48005),
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		objName = -53345114,
		objYaw = 0.0,
		objCoords = vector3(480.9128, -1012.189, 26.48005),
	},
	{ 
		textCoords = vector3(483.9127, -1012.189, 26.48005),
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		objName = -53345114,
		objYaw = 0.0,
		objCoords = vector3(483.9127, -1012.189, 26.48005),
	},
	{ 
		textCoords = vector3(486.9131, -1012.189, 26.48005),
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		objName = -53345114,
		objYaw = 0.0,
		objCoords = vector3(486.9131, -1012.189, 26.48005),
	},
	{ 
		textCoords = vector3(484.1764, -1007.734, 26.48005),
		authorizedJobs = {'police', 'kmar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		objName = -53345114,
		objYaw = 180.0,
		objCoords = vector3(484.1764, -1007.734, 26.48005),
	},
}
