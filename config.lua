-- Any changes made to this file only apply after restarting the game

return {
	input = "getch_bash", -- Only one option right now
	generator = "drunky", -- Algorithms in `/src/gen/`
	tileset = "default", -- Tilesets in `/tilesets/`

	light = {
		wall_count = 5, -- Minimum amount of surrounding walls to be considered a hallway

		radius_open = 3,
		radius_hallway = 1,
		radius_door = 6,

		turns = 50, -- How many turns it takes until a tile is no longer visible
	},

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

		["/"] = "UPGRADE_MENU"
	}
}
