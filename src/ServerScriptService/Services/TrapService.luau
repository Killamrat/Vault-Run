--[[
	TrapService
	MVP trap: the Shove Panel. A hazard-striped floor plate that launches whoever steps on it
	into a ragdoll tumble, then re-arms after a few seconds. Traps hurt a little and displace a lot.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Config)
local PlayerService = require(script.Parent.PlayerService)

local TrapService = {}
local T = Config.Trap

local ARMED = Color3.fromRGB(240, 200, 40)
local DISARMED = Color3.fromRGB(90, 80, 40)

function TrapService.SpawnShovePanel(run, position, parent)
	local plate = Instance.new("Part")
	plate.Name = "ShovePanel"
	plate.Size = Vector3.new(7, 0.4, 7)
	plate.Position = position + Vector3.new(0, 0.2, 0)
	plate.Anchored = true
	plate.Color = ARMED
	plate.Material = Enum.Material.Neon
	plate.Parent = parent
	-- hazard stripe ring
	local ring = Instance.new("Part")
	ring.Name = "Ring"; ring.Size = Vector3.new(8, 0.2, 8); ring.Position = position + Vector3.new(0, 0.1, 0); ring.Anchored = true; ring.CanCollide = false
	ring.Color = Color3.fromRGB(30, 30, 30); ring.Material = Enum.Material.SmoothPlastic; ring.Parent = parent
	local armed = true
	plate.Touched:Connect(function(hit)
		if not armed then return end
		local char = hit.Parent
		local player = char and Players:GetPlayerFromCharacter(char)
		if not player then return end
		local s = PlayerService.Get(player)
		if not s or s.Run ~= run or s.Downed then return end
		armed = false
		plate.Color = DISARMED
		plate.Material = Enum.Material.SmoothPlastic
		local root = char:FindFirstChild("HumanoidRootPart")
		local CombatService = require(script.Parent.CombatService)
		if root then
			local dir = root.Position - plate.Position
			dir = Vector3.new(dir.X, 0, dir.Z)
			if dir.Magnitude < 0.5 then dir = root.CFrame.LookVector * -1 end
			CombatService.Knockback(player, dir.Unit, T.ShoveForce, T.ShoveUp, 1.6)
		end
		CombatService.DamagePlayer(player, T.ShoveDamage, nil)
		PlayerService.Notify(player, "SHOVE PANEL!", ARMED)
		task.delay(T.RearmSeconds, function()
			if plate.Parent then armed = true; plate.Color = ARMED; plate.Material = Enum.Material.Neon end
		end)
	end)
	return plate
end

return TrapService
