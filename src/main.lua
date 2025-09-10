local C = require("config")
local ERR = require("src.error_messages")
local TILE = require("tilesets." .. C.tileset)
local TILE_NAMES = require("src.tile_names")
local TILE_PROP = require("src.tile_properties")
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

local function ask_direction(str)
	io.write("\27[24;1H                                                                               ")
	io.write("\27[24;1HEnter a direction for action: ", str)
	local k, a
	repeat
		k = getch()
		a = C.key[k]
	until a == "UP" or a == "LEFT" or a == "DOWN" or a == "RIGHT"
	or a == "UP LEFT" or a == "UP RIGHT" or a == "DOWN LEFT" or a == "DOWN RIGHT"
	or a == "SYS: ESCAPE"

	return a
end

check_term_dim()

local function title(tw, th)
	tw, th = 2*math.floor(tw/2), 2*math.floor(th/2)
	local logo = [[
          __       __
      (__/  ~-(O)-~  \__)

S A N C T U A R Y   O F   T H E
      L U N A R   R U N E
       __             __
      (  \__~-(O)-~__/  )]]

	os.execute("clear")
	io.write("\27[0;1m\27[2;", tw/2-14, "H", logo:gsub("\n", "\n" .. (" "):rep(tw/2-14)).."")
	io.write("\27[0m\27[12;1H    By Mostafa Tarek Mortada\n\n\n    Press enter to begin game\n    Options and configuration in `config.lua`\n\n")
	io.read()
end

title(term_dim())

local MAP_WIDTH, MAP_HEIGHT = 140, 44

math.randomseed(os.time())
local seed = math.random(0, 9999999999)

local wrl = {}
local floor = 1

local turn = 0

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
for i = 1, 26 do -- a-z
	inv[i] = {id=0, n=0}
end
inv[1] = {id=1, n=23}
local equip = {[1]=1}

local S = " "
local CLEAR_STR = "\27[1;1H" .. S:rep(79) .. "\27[24;1H" .. S:rep(79) .. "\27[2;71H" .. (S:rep(9).."\27[9D\27[B"):rep(22)

while true do
	local floorseed = seed * 1000 + floor
	wrl[floor] = wrl[floor] or {}
	if not wrl[floor].a then
		wrl[floor].px, wrl[floor].py, wrl[floor].map, wrl[floor].shade, wrl[floor].radius, wrl[floor].stt = GENERATE_FLOOR(floorseed, MAP_WIDTH, MAP_HEIGHT)
		wrl[floor].a = 0
	end
	local map, shade, vis_radius, stt = wrl[floor].map, wrl[floor].shade, wrl[floor].radius, wrl[floor].stt
	player.x, player.y = wrl[floor].px, wrl[floor].py

	-- player in the center of the camera
	local sx = math.max(0, math.min(MAP_WIDTH -70, player.x-35))
	local sy = math.max(0, math.min(MAP_HEIGHT-22, player.y-11))

	local key = ""

	os.execute("clear")
	while true do -- MAIN GAME LOOP & LOGIC

		sx = math.max(0, math.min(MAP_WIDTH -70, player.x-35))
		sy = math.max(0, math.min(MAP_HEIGHT-22, player.y-11))

		do -- Raycaster to reveal tiles in player's radius
			for i = 0, math.pi * 2, math.pi/180 * 4.5 do
				local rx, ry, ix, iy = player.x, player.y, math.cos(i), math.sin(i)
				local c
				repeat
					rx = rx + ix
					ry = ry + iy
					c = map[math.floor(ry+.5)][math.floor(rx+.5)]
					shade[math.floor(ry+.5)][math.floor(rx+.5)] = 0
				until c == 1 or c == 6 or math.sqrt((player.y - ry)^2 + (player.x - rx)^2)>=(vis_radius[player.y][player.x]-1)
			end
		end

		io.write("\27[2;1H")
		for r = 1+sy, 22+sy do
			for c = 1+sx, 70+sx do
				io.write("\27[0m")
				if shade[r][c] then
					io.write(TILE[map[r][c] ] or ERR.glyph_nil)
				else
					io.write(" ")
				end
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
		io.write("\27[1;1H Seed:",seed)
		io.write("\27[1;20HFloor ",floor)
		io.write("\27[1;40HTurn ",turn)

		--io.write("\27[23;1HPos: ",player.x," , ",player.y," ")
		--io.write("\27[24;1H",flavor, (" "):rep(80-flavor:len()))
		io.write("\27[24;1HStanding on ",TILE_NAMES[map[player.y][player.x]] or ERR.tilename_nil, (" "):rep(67-(TILE_NAMES[map[player.y][player.x]] or ERR.tilename_nil):len()))

		io.write("\27[", player.y-sy+1, ";", player.x-sx, "H\27[0;1m@\27[1;1H")

		key = getch()
		check_term_dim()
		wrl[floor].px, wrl[floor].py = player.x, player.y

		local act = C.key[key]

		if act and key~="" then
			if act == "UP" or act == "DOWN" or act == "LEFT" or act == "RIGHT"
			or act == "UP LEFT" or act == "DOWN LEFT" or act == "UP RIGHT" or act == "DOWN RIGHT" then
				turn = turn + 1
			end

			local prev_px, prev_py = player.x, player.y

			-- Move player
			player.x = math.max(0, math.min(MAP_WIDTH , player.x + ((act=="RIGHT" or act=="UP RIGHT" or act=="DOWN RIGHT") and 1 or (act=="LEFT" or act=="UP LEFT" or act=="DOWN LEFT") and -1 or 0)))
			player.y = math.max(0, math.min(MAP_HEIGHT, player.y + ((act=="DOWN" or act=="DOWN LEFT" or act=="DOWN RIGHT") and 1 or (act=="UP" or act=="UP LEFT" or act=="UP RIGHT") and -1 or 0)))

			if act == "INTERACT" then
				local t = map[player.y][player.x]
				if t == 5 then
					floor = floor + 1
					break
				elseif t == 4 and floor ~= 1 then
					floor = floor - 1
					break
				end
			end

			if act == "DOOR" then
				local dir = ask_direction("Open/close door")
				if dir ~= "SYS: ESCAPE" then
					local ix, iy = 0, 0
					ix = (dir=="LEFT" or dir=="UP LEFT" or dir=="DOWN LEFT") and -1 or (dir=="RIGHT" or dir=="UP RIGHT" or dir == "DOWN RIGHT") and 1 or 0
					iy = (dir=="UP" or dir=="UP LEFT" or dir=="UP RIGHT") and -1 or (dir=="DOWN" or dir=="DOWN LEFT" or dir == "DOWN RIGHT") and 1 or 0

					if map[player.y+iy][player.x+ix] == 6 then map[player.y+iy][player.x+ix] = 7
					elseif map[player.y+iy][player.x+ix] == 7 then map[player.y+iy][player.x+ix] = 6 end
				end
			end

-- 			if map[player.y][player.x] == 1 or map[player.y][player.x] == 3 or map[player.y][player.x] == 6 then -- Collision
-- 				player.x, player.y = prev_px, prev_py
-- 			end

			if TILE_PROP[map[player.y][player.x]].wall then -- Collision
				player.x, player.y = prev_px, prev_py
			end

			if act == "UPGRADE MENU" then -- UPGRADE MENU
				os.execute("clear")
				local i,sel,entryname = 1, 1, {[1]="atk",[2]="def",[3]="rng",[4]="mna"}
				repeat
					io.write("\27[2;1H\27[0;7m Upgrade your stats \n\27[0mYou have \27[32m", player.upt, "\27[0m upgrade points (UPT)  ")
					io.write("\27[4;72HUPT ",player.upt," ")
					io.write("\27[6;70H1.ATK ",player.atk)
					io.write("\27[7;70H2.DEF ",player.def)
					io.write("\27[8;70H3.RNG ",player.rng)
					io.write("\27[9;70H4.MNA ",player.mna)
					for o = 1, 4 do
						io.write("\27[",o+5,";68H ")
					end
					io.write("\27[",sel+5,";68H>\27[H")
					i = getch()
					local tmp = tonumber(i)
					if tmp==nil then
					elseif tmp>4 then
					else
						sel = tmp
					end
					if i == "P" and player.upt > 0 then
						player[entryname[sel]] = player[entryname[sel]] + 1
						player.upt = player.upt - 1
					end
				until C.key[i] == "UPGRADE MENU" or i == "\27"
				os.execute("clear")
			end

			if act == "INSPECT" then
				local i, x, y = "", player.x, player.y
				io.write("\27[0;1m")
				repeat
					io.write("\27[2;1H")
					for r = 1+sy, 22+sy do
						for c = 1+sx, 70+sx do
							io.write("\27[0m")
							if shade[r][c] then
								io.write(TILE[map[r][c] ] or ERR.glyph_nil)
							else
								io.write(" ")
							end
						end
						io.write("\n")
					end

					if shade[y][x] then
						io.write("\27[24;1HHighlighted:",TILE_NAMES[map[y][x]] or ERR.tilename_nil, (" "):rep(67-(TILE_NAMES[map[y][x]] or ERR.tilename_nil):len()))
					else
						io.write("\27[24;1HHighlighted:                                                                   ")
					end

					io.write("\27[0;33;1m")
					io.write("\27[", y-sy, ";", x-sx-1, "H\\ /")
					io.write("\27[", y-sy+1, ";", x-sx-1, "H|")
					io.write("\27[", y-sy+1, ";", x-sx+1, "H|")
					io.write("\27[", y-sy+2, ";", x-sx-1, "H/ \\\27[1;1H")
					io.write("\27[0m")
					i = getch()
					local a = C.key[i]
					x = math.max(1, math.min(MAP_WIDTH , x + ((a=="RIGHT" or a=="UP RIGHT" or a=="DOWN RIGHT") and 1 or (a=="LEFT" or a=="UP LEFT" or a=="DOWN LEFT") and -1 or 0)))
					y = math.max(1, math.min(MAP_HEIGHT, y + ((a=="DOWN" or a=="DOWN LEFT" or a=="DOWN RIGHT") and 1 or (a=="UP" or a=="UP LEFT" or a=="UP RIGHT") and -1 or 0)))
				until C.key[i] == "SYS: ESCAPE"
				os.execute("clear")
			end

			if act == "SYS: CLEAR SCREEN" then
				os.execute("clear")
			end

			if act == "SYS: QUIT GAME" then
				io.write("\27[H\27[0;41;1m Are you sure you want to quit? y/n \27[0m")
				local o = ""
				repeat
					o = string.lower(getch())
				until o=="y" or o=="n" or o=="\27"
				os.execute("clear")
				if o=="y" then
					os.exit()
				end
			end
		end

		if key == "~" then -- !!! THIS IS FOR DEBUGGING PURPOSES ONLY !!! (remind me to remove this later)
			io.write("\27[0m\27[2;1H")
			for r = 1+sy, 22+sy do
				for c = 1+sx, 70+sx do
					io.write(("CBA0123"):sub(stt[r][c]+4, stt[r][c]+4))
				end
				io.write("\n")
			end
			io.write("\27[1;1H")
			io.read()
		end

	end
end
