return {
	[0] = { -- Fallback (and also blank template)
		name = "",
		cat = 1, --[[ Category
			0		standard
			1		potion
			2		food
			3		equipment
			4		scroll
			5		wand
		]]
		atk = 0, -- Attack
		def = 0,
		pierce = 1, -- How much defense to apply (in this case 1 takes into account all enemy def, but 0 ignores all defense)
		acc = 0, -- Accuracy (0 - 1)
	},
	[1] = {
		
	}
}