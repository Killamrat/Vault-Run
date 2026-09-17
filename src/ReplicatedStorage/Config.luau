--[[
	Config
	Every tunable number in Vault Run lives here. Nothing else in the game
	should hard-code a balance value. Change a number here, playtest, repeat.
]]

local Config = {}

-- ===== RUN STRUCTURE =====
Config.MaxFloors = 3                 -- deepest floor in the MVP
Config.MaxCrewSize = 4
Config.RunSlotSpacing = 1500         -- studs between simultaneous run instances
Config.RunOrigin = Vector3.new(4000, 0, 0)  -- runs are built far from the hub

-- Per-floor difficulty. Index = floor number.
Config.Floors = {
	[1] = { Rooms = 3, Guards = 1, Traps = 1, Crates = 5,  TierWeights = { Common = 70, Rare = 20, Epic = 3,  Legendary = 0 } },
	[2] = { Rooms = 4, Guards = 3, Traps = 2, Crates = 6,  TierWeights = { Common = 45, Rare = 30, Epic = 12, Legendary = 2 } },
	[3] = { Rooms = 4, Guards = 5, Traps = 4, Crates = 7,  TierWeights = { Common = 20, Rare = 40, Epic = 30, Legendary = 10 } },
}

-- ===== CRATES =====
Config.Tiers = { "Common", "Rare", "Epic", "Legendary" }
Config.TierInfo = {
	Common    = { Color = Color3.fromRGB(150, 150, 150), CrackTime = 2.0, Glow = false },
	Rare      = { Color = Color3.fromRGB(60, 140, 255),  CrackTime = 2.5, Glow = true  },
	Epic      = { Color = Color3.fromRGB(170, 70, 255),  CrackTime = 3.0, Glow = true  },
	Legendary = { Color = Color3.fromRGB(255, 190, 40),  CrackTime = 4.0, Glow = true  },
}
Config.CrateInterruptWindow = 1.5    -- seconds after taking a hit during which a crack fails

-- ===== BACKPACK =====
Config.BackpackBaseSlots = 5
Config.BackpackMaxSlots = 7
Config.BackpackUpgradeCosts = { [6] = 1500, [7] = 4000 }  -- cost to reach slot count

-- ===== PLAYER =====
Config.PlayerMaxHP = 100
Config.DownedBleedoutSeconds = 30
Config.ReviveHoldSeconds = 3
Config.ArmorTiers = {
	[0] = { Name = "None",       DamageMult = 1.00, Cost = 0 },
	[1] = { Name = "Padded Vest", DamageMult = 0.80, Cost = 1200 },
	[2] = { Name = "Plate Vest",  DamageMult = 0.60, Cost = 3500 },
}

-- ===== TOOLS (melee) =====
Config.ToolTiers = {
	[1] = { Name = "Crowbar",    StunSeconds = 2.5, Cooldown = 0.7, Range = 9,  Cost = 0 },
	[2] = { Name = "Stun Baton", StunSeconds = 4.0, Cooldown = 0.6, Range = 10, Cost = 2500 },
}
Config.GuardHitsToRetire = 3

-- ===== GUARDS =====
Config.Guard = {
	WalkSpeed = 13,
	ChaseSpeed = 15,
	SightRange = 32,
	SightAngle = 100,       -- degrees, total cone
	LoseRange = 48,
	AttackRange = 5.5,
	AttackCooldown = 1.0,
	Damage = 20,
	Knockback = 30,
	PatrolPause = 1.5,
	TickRate = 0.2,
}

-- ===== TRAPS =====
Config.Trap = {
	ShoveForce = 82,
	ShoveUp = 42,
	ShoveDamage = 15,
	RearmSeconds = 3,
}

-- ===== VOTE =====
Config.VoteSeconds = 10

-- ===== ECONOMY =====
Config.StartingCash = 0
Config.XPPerFloor = 40
Config.XPPerExtract = 100
Config.XPToLevel = function(level) return 100 + (level - 1) * 60 end
Config.NewPlayerSoftRuns = 3          -- first N runs keep loot on a wipe

-- ===== HUB =====
Config.CrewZones = 3
Config.ShowcaseBooths = 12
Config.ShowcaseSlotsPerBooth = 8
Config.CrewStartCountdown = 5

-- ===== MONETIZATION (Developer Products) =====
-- Create the products on the Roblox website (Creator Dashboard > your experience > Monetization >
-- Developer Products), then paste the numeric IDs here. While an ID is 0, Studio simulates the purchase
-- so the flow can be tested; in a published game a 0 ID simply hides the button.
Config.Monetization = {
	SelfReviveProductId = 0,   -- downed with a crewmate still standing: revive yourself
	SelfRevivePrice = 25,      -- shown on the button (Robux); the real price is set on the website
	SelfRevivesPerRun = 1,
	SaveLootProductId = 0,     -- crew wiped / bled out: keep the loot you were carrying
	SaveLootPrice = 200,       -- deliberately steep: it undoes the core risk, so it should sting
	OfferWindowSeconds = 15,   -- how long the save-loot offer stays open
}

-- ===== DATA =====
Config.DataStoreName = "VaultRun_v1"
Config.AutosaveSeconds = 120
Config.LeaderboardRefreshSeconds = 60

return Config
