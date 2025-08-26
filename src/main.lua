
local C = require("config")

local TILE = require("tilesets." .. C.tileset)
local TILENAMES = require("src.tilenames")
local GENERATE_FLOOR = require("src.gen." .. C.generator)
local getch = require("src." .. C.input)

local function term_dim() -- Get terminal dimensions
	local handle = io.popen("tput cols; tput lines")
	local w = tonumber(handle:read())
	local h = tonumber(handle:read())
	handle:close()
	return w, h
end

local function check_term_dim()
	local w, h = term_dim()
	local a
	while w<80 or h<24 do
		a=0
		w, h = term_dim()
		--os.execute("clear")
		io.write("\27[2J\27[1;1HSet terminal dimensions to 80x24.\nCurrent: ", w, "x", h, " ")
	end
	if a then
		os.execute("clear")
	end
end

check_term_dim()

require("src.title") -- Display title screen

local MAP_WIDTH, MAP_HEIGHT = 140, 44

math.randomseed(os.time())
local seed = math.random(0, 9999999999)

local wrl = {}
local floor = 1

local player = {
	x = 0, y = 0,


	exp = 0,
	lvl = 1,
	upt = 10,	-- upgrade points

	maxhp=20,
	hp=20,

	atk = 0,
	def = 0,
	rng = 0,
	mna = 0,
}

local inv = {}
for i = 1, 26 do
	inv[i] = {id=0, n=0}
end
inv[1] = {id=1, n=23}
local equip = {[1]=1}

local flavor = "Welcome!"

while true do
	wrl[floor] = wrl[floor] or {}
	player.x, player.y, wrl[floor].map, wrl[floor].shade = GENERATE_FLOOR(0, 140, 44)
	local map, shade = wrl[floor].map, wrl[floor].shade

	-- player in the center of the camera
	local sx = math.max(0, math.min(MAP_WIDTH -70, player.x-35))
	local sy = math.max(0, math.min(MAP_HEIGHT-22, player.y-11))


	local key = ""

	os.execute("clear")
	while true do

		do -- this block just does lighting
			local surround_wall = 0
			for r = player.y-1, player.y+1 do
				for c = player.x-1, player.x+1 do
					surround_wall = surround_wall==-1 and -1 or surround_wall + (map[r][c]==1 and 1 or 0)
					surround_wall = map[r][c]==6 and -1 or surround_wall
				end
			end
			local vis_range = surround_wall>=C.light.wall_count and C.light.radius_hallway or surround_wall==-1 and C.light.radius_door or C.light.radius_open
			for r = math.max(1, player.y-vis_range), math.min(MAP_HEIGHT, player.y+vis_range) do
				for c = math.max(1, player.x-vis_range), math.min(MAP_WIDTH, player.x+vis_range) do
					shade[r][c] = C.light.turns
				end
			end
		end

		--os.execute("clear")
		--io.write("\27[1;1HCROAGE\n")
		io.write("\27[2;1H")
		--[[for r = 1+sy, 22+sy do
			for c = 1+sx, 70+sx do
				--io.write(("#. <>+"):sub(map[r][c], map[r][c]))
				io.write("\27[0m")
				if shade[r][c]>0 then
					if shade[r][c] ~= C.light.turns then -- tiles outside of the player's direct view are dimmed
						io.write("\27[2m")
					end
					io.write(TILE[map[r][c] ])
				else
					io.write" "
				end
				if key~="" then
					shade[r][c] = math.max(0, shade[r][c]-1)
				end
			end
			io.write("\n")
		end]]

		-- lighting system disabled :P
		for r = 1+sy, 22+sy do
			for c = 1+sx, 70+sx do
				--io.write(("#. <>+"):sub(map[r][c], map[r][c]))
				io.write("\27[0m")
				io.write(TILE[map[r][c] ])
			end
			io.write("\n")
		end

		-- Draw stats on the side of the screen
		io.write("\27[0m\27[2;71H LVL ",player.lvl)
		io.write("\27[3;71H EXP ",player.exp)
		io.write("\27[4;71H UPT ",player.upt)
		io.write("\27[6;71H ATK ",player.atk)
		io.write("\27[7;71H DEF ",player.def)
		io.write("\27[8;71H RNG ",player.rng)
		io.write("\27[9;71H MNA ",player.mna)
		io.write("\27[1;69HHP ",player.hp,"/",player.maxhp)
		io.write("\27[1;2HSeed:",seed)
		io.write("\27[1;20HFloor ",floor)

		io.write("\27[23;1HPos: ",player.x," , ",player.y," ")
		--io.write("\27[24;1H",flavor, (" "):rep(80-flavor:len()))
		io.write("\27[24;1HStanding on ",TILENAMES[map[player.y][player.x]], (" "):rep(67-TILENAMES[map[player.y][player.x]]:len()))

		io.write("\27[", player.y-sy+1, ";", player.x-sx, "H\27[0;1m@\27[D")

		key = getch()
		check_term_dim()

		local act = C.key[key]

		if act and key~="" then
			-- the following 4 lines scroll the camera when the player approaches the edge of the screen
			if player.x-sx<=10 then sx = sx - 10 end
			if player.x-sx>=60 then sx = sx + 10 end
			if player.y-sy<=5 then sy = sy - 7 end
			if player.y-sy>=15 then sy = sy + 7 end

			-- clamping
			sx = math.max(0, math.min(MAP_WIDTH -70, sx))
			sy = math.max(0, math.min(MAP_HEIGHT-22, sy))

			sx = math.max(0, math.min(MAP_WIDTH -70, player.x-35))
			sy = math.max(0, math.min(MAP_HEIGHT-22, player.y-11))

			local prev_px, prev_py = player.x, player.y

			-- Move player
			player.x = math.max(0, math.min(MAP_WIDTH , player.x + ((act=="RIGHT" or act=="UP RIGHT" or act=="DOWN RIGHT") and 1 or (act=="LEFT" or act=="UP LEFT" or act=="DOWN LEFT") and -1 or 0)))
			player.y = math.max(0, math.min(MAP_HEIGHT, player.y + ((act=="DOWN" or act=="DOWN LEFT" or act=="DOWN RIGHT") and 1 or (act=="UP" or act=="UP LEFT" or act=="UP RIGHT") and -1 or 0)))
			--player.x = math.max(0, math.min(MAP_WIDTH , player.x + (act=="RIGHT" and 1 or act=="LEFT" and -1 or 0)))
			--player.y = math.max(0, math.min(MAP_HEIGHT, player.y + (act=="DOWN" and 1 or act=="UP" and -1 or 0)))

			if map[player.y][player.x] == 1 then -- Collision
				player.x, player.y = prev_px, prev_py
			end

		end
	end
end
