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

		C = "SYS: CLEAR SCREEN",
		Q = "SYS: QUIT GAME",
	}
}
