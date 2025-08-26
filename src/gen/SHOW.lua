local TILE = {
	[1] = "\27[0;7m ", -- wall
	[2] = "\27[0;2m.", -- floor
	[3] = "\27[0m ", -- outside void
	[4] = "\27[0;1m<", -- stair up
	[5] = "\27[0;1m>", -- stair down
	[6] = "\27[0;43;93m+", -- door
}

local name, w, h = "drunky", 140, 44
--io.write "NAME   " name = tonumber(io.read()) or name
--io.write "WIDTH  " w    = tonumber(io.read()) or w
--io.write "HEIGHT " h    = tonumber(io.read()) or h
while true do
os.execute("clear")
local a = require(name)
local _, _, map = a(0, w, h)
for r = 1, h do
	for c = 1, w do
		--io.write(("#. <>+"):sub(map[r][c], map[r][c]))
		io.write(TILE[map[r][c]])
	end
	io.write("\n")
end
io.read()
end
os.execute("clear")


