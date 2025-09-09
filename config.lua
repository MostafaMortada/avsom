-- Any changes made to this file only apply after restarting the game

return {
	input = "getch_bash", -- Only one option right now
	generator = "drunky", -- Algorithms in `/src/gen/`
	tileset = "default", -- Tilesets in `/tilesets/`

	key = { -- Keymap
		h = "LEFT",
		j = "DOWN",
		k = "UP",
		l = "RIGHT",

		y = "UP LEFT",
		u = "UP RIGHT",
		b = "DOWN LEFT",
		n = "DOWN RIGHT",

		["4"] = "LEFT",
		["2"] = "DOWN",
		["8"] = "UP",
		["6"] = "RIGHT",

		["7"] = "UP LEFT",
		["9"] = "UP RIGHT",
		["1"] = "DOWN LEFT",
		["3"] = "DOWN RIGHT",

		q = "DRINK",
		e = "EAT",
		z = "ZAP",
		a = "EQUIP",
		r = "READ",
		c = "CAST",

		i = "INVENTORY",
		d = "DROP",
		D = "THROW",
		g = "TAKE",

		["."] = "INTERACT",
		o = "DOOR",

		["/"] = "UPGRADE MENU",

		["-"] = "INSPECT",

		["\27"] = "SYS: ESCAPE",
		C = "SYS: CLEAR SCREEN",
		Q = "SYS: QUIT GAME",
	}
}
