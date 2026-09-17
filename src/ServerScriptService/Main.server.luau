--[[
	Main (server boot)
	Requires every service and calls Init() in dependency order. This is the only
	server Script; everything else is a ModuleScript under Services.
]]

local Services = script.Parent.Services

local order = {
	"DataService",
	"ShowcaseService",
	"PlayerService",
	"CombatService",
	"GuardService",
	"CrateService",
	"VoteService",
	"RunManager",
	"CrewService",
	"ShopService",
	"LeaderboardService",
	"MonetizationService",
	"DebugService",
}

for _, name in ipairs(order) do
	local ok, err = pcall(function()
		local mod = require(Services[name])
		if type(mod.Init) == "function" then mod.Init() end
	end)
	if ok then
		print("[VaultRun] " .. name .. " ready")
	else
		warn("[VaultRun] " .. name .. " FAILED: " .. tostring(err))
	end
end

print("[VaultRun] server booted")
