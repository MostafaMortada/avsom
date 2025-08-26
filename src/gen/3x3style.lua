-- dont use this TvT

return function()
	local map
	for r = 1, 22 do
		map[r] = {}
		for c = 1, 70 do
			map[r][c] = 1
		end
	end

	for i = 0, 1 do
		for o = 0, 3 do
			local cr, cc = i*11, cy*14
			local _ = math.random(1, 11)
			for r = cr+_, math.min(i*11+11, cr+_+math.random(3, 11))
				for c = cc+math.random(1, 11), cc+math.random(1, 14)

		end
	end
end
