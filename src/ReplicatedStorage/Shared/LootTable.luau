--[[
	LootTable
	What comes out of crates. Two kinds of loot:
	  Haul       - cash value only, sold automatically on extraction
	  Showpiece  - named rare item, goes on your showcase shelf; can be sold later
	Shared by server (rolling) and client (display).
]]

local LootTable = {}

-- Haul: { Name, Tier, MinValue, MaxValue }
LootTable.Haul = {
	Common = {
		{ Name = "Cash Bundle",     Min = 40,   Max = 90 },
		{ Name = "Copper Wire",     Min = 30,   Max = 70 },
		{ Name = "Silver Coins",    Min = 60,   Max = 120 },
	},
	Rare = {
		{ Name = "Cash Brick",      Min = 150,  Max = 260 },
		{ Name = "Silver Bar",      Min = 180,  Max = 300 },
		{ Name = "Sapphire",        Min = 200,  Max = 340 },
	},
	Epic = {
		{ Name = "Gold Bar",        Min = 450,  Max = 700 },
		{ Name = "Ruby Cluster",    Min = 500,  Max = 800 },
		{ Name = "Bearer Bonds",    Min = 550,  Max = 900 },
	},
	Legendary = {
		{ Name = "Gold Ingot Stack", Min = 1400, Max = 2200 },
		{ Name = "Flawless Diamond", Min = 1600, Max = 2600 },
	},
}

-- Showpieces: { Name, Tier, Value } -- Value is the sell price if you choose to sell
LootTable.Showpieces = {
	Common = {
		{ Name = "Brass Vault Key",       Value = 120 },
		{ Name = "Old Security Badge",    Value = 100 },
	},
	Rare = {
		{ Name = "Vintage Pocket Watch", Value = 400 },
		{ Name = "Signed Baseball",      Value = 380 },
	},
	Epic = {
		{ Name = "Golden Revolver",      Value = 1200 },
		{ Name = "Jade Dragon",          Value = 1300 },
	},
	Legendary = {
		{ Name = "The Crown of Ashes",   Value = 4000 },
		{ Name = "Blue Star Sapphire",   Value = 4500 },
	},
}

-- Chance a crate of a given tier yields a showpiece instead of haul
LootTable.ShowpieceChance = { Common = 0.06, Rare = 0.25, Epic = 0.40, Legendary = 0.60 }

-- Returns an item table: { Kind = "Haul"|"Showpiece", Name, Tier, Value }
function LootTable.Roll(tier, rng)
	rng = rng or Random.new()
	local spChance = LootTable.ShowpieceChance[tier] or 0
	if spChance > 0 and rng:NextNumber() < spChance then
		local pool = LootTable.Showpieces[tier]
		local pick = pool[rng:NextInteger(1, #pool)]
		return { Kind = "Showpiece", Name = pick.Name, Tier = tier, Value = pick.Value }
	end
	local pool = LootTable.Haul[tier]
	local pick = pool[rng:NextInteger(1, #pool)]
	return { Kind = "Haul", Name = pick.Name, Tier = tier, Value = rng:NextInteger(pick.Min, pick.Max) }
end

-- Weighted tier pick from a weights table like { Common = 70, Rare = 25, ... }
function LootTable.PickTier(weights, rng)
	rng = rng or Random.new()
	local total = 0
	for _, w in pairs(weights) do total += w end
	local r = rng:NextNumber() * total
	local order = { "Common", "Rare", "Epic", "Legendary" }
	for _, tier in ipairs(order) do
		local w = weights[tier] or 0
		if r < w then return tier end
		r -= w
	end
	return "Common"
end

return LootTable
