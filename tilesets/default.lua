return {
	--[1] = "█", -- wall
	[1] = "\27[7m ",
	[2] = "\27[2m.", -- floor
	[3] = " ", -- outside void
	[4] = "\27[1m<", -- stair up
	[5] = "\27[1m>", -- stair down
	--[6] = "\27[43;93m+", -- door
	[6] = "\27[43m+",

	[7] = "$",
	[8] = "~",

	--[100] = "\27[0m▒", -- wall but dim
}
--[[return {
	[1] = "\27[0;7m ", -- wall
	[2] = "\27[0;2m.", -- floor
	[3] = "\27[0m ", -- outside void
	[4] = "\27[0;1m<", -- stair up
	[5] = "\27[0;1m>", -- stair down
	[6] = "\27[0;43;93m+", -- door
}
]]
