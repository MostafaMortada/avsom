return function(floorseed, w, h)

	local map = {} -- The list that contains the actual tile data
	local obs = {} -- Whether a tile is visible or not
	local vis = {} -- Visibility radius when standing on tile
	local stt = {} -- Tile status (cursed, upgraded, etc)
	for r = 1, h do
		map[r] = {}
		obs[r] = {}
		vis[r] = {}
		stt[r] = {}
		for c = 1, w do
			map[r][c] = 1
			obs[r][c] = nil -- yes this line is useless
			vis[r][c] = 0
			stt[r][c] = math.random(-3, 3)
		end
	end

	local COUNT = 1000
	local EXIT_COUNT, EXIT_X, EXIT_Y = 100, 1, 1
	local dx, dy = math.floor(w/2), math.floor(h/2)
	for i = 1, COUNT do
		if i == EXIT_COUNT then
			EXIT_X, EXIT_Y = dx, dy
		end
		local a = math.min(1, math.random(0, 3))
		for _ = 1, math.random(7, 8) do
			map[dy][dx] = 2
			dx = math.max(2, math.min(w-1, dx +  a    * math.random(-1, 1)))
			dy = math.max(2, math.min(h-1, dy + (1-a) * math.random(-1, 1)))
		end
	end

	for r = 2, h-1 do -- Add doors
		for c = 2, w-1 do
			if map[r][c] == 2 then
				if ((map[r-1][c]==1 and map[r+1][c]==1 and map[r][c+1]~=1 and map[r][c-1]~=1)and not(map[r][c-1]==1 and map[r][c+1]==1 and map[r+1][c]~=1 and map[r-1][c]~=1))or(not(map[r-1][c]==1 and map[r+1][c]==1 and map[r][c+1]~=1 and map[r][c-1]~=1)and(map[r][c-1]==1 and map[r][c+1]==1 and map[r+1][c]~=1 and map[r-1][c]~=1)) then
					map[r][c] = math.random(1, 8)==1 and 6 or 2
				end
			end
		end
	end

	map[dy][dx] = 4
	map[EXIT_Y][EXIT_X] = 5

	for r = 1, h do -- Remove outer walls, so the map is only outlined
		for c = 1, w do
			if map[r][c] == 1 then
				local exposed = true
				for i = math.max(1, r-1), math.min(h, r+1) do
					for o = math.max(1, c-1), math.min(w, c+1) do
						if map[i][o]~=1 and map[i][o]~=3 then
							exposed = false
						end
					end
				end
				map[r][c] = exposed and 3 or 1
			end
		end
	end

	for r = 2, h-1 do
		for c = 2, w-1 do
			local surround = 0
			for i = math.max(1, r-1), math.min(h, r+1) do
				for o = math.max(1, c-1), math.min(w, c+1) do
					if map[i][o] == 1 or map[i][o] == 6 or map[i][o] == 3 then
						surround = surround + 1
					end
				end
			end
			vis[r][c] = surround>=5 and 1 or 20

			--[[if map[r][c] == 2 and surround>=5 then -- bro this is ass
				for i = r-1, r+1 do
					for o = c-1, c+1 do
						if map[i][o] == 1 then
							map[i][o] = 3
						end
					end
				end
				map[r][c] = 7
			end]]
		end
	end
	--dx, dy = math.floor(w/2), math.floor(h/2)

	return dx, dy, map, obs, vis, stt
end
