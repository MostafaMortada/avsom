return {
	[1] = "\27[7m ", -- solid wall
	[2] = "\27[2m.", -- floor
	[3] = "\27[2m ", -- outside void
	[4] = "\27[36;1m<", -- stair up
	[5] = "\27[36;1m>", -- stair down
	--[6] = "\27[33;7m+", -- door
	[6] = "\27[m#", -- door (closed)
	[7] = "\27[m|", -- door (opened)
	[8] = "\27[2m=", -- pathway (may be useful for a nethack-like level generator)

	[51] = "$", -- $$$ MONEY $$$
	[52] = "~", -- water fountain
}
