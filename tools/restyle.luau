-- Restyle Vault Run rooms: applies a named style kit to every .rbxm in rooms/
-- Usage: lune run tools/restyle.luau <StyleName>
-- Outputs to rooms/styled/<StyleName>/<RoomName>.rbxm
-- Touches ONLY Geometry + Lights. Markers, Origin, attributes untouched.

local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local process = require("@lune/process")

local Color3 = roblox.Color3
local Enum = roblox.Enum

local styleName = process.args[1]

-- ============ STYLE KITS ============
local STYLES = {
	-- GTA-heist mood: dark polished vault, steel, moody blue-white light,
	-- gold strictly reserved for the elevator (reward color discipline).
	HeistNoir = {
		floor    = { mat = Enum.Material.Slate,        color = Color3.fromRGB(48, 50, 56) },
		ceiling  = { mat = Enum.Material.Concrete,     color = Color3.fromRGB(38, 40, 46) },
		wall     = { mat = Enum.Material.Concrete,     color = Color3.fromRGB(62, 66, 76) },
		pillar   = { mat = Enum.Material.Metal,        color = Color3.fromRGB(82, 88, 100) },
		frame    = { mat = Enum.Material.Metal,        color = Color3.fromRGB(120, 128, 142) },
		prop     = { mat = Enum.Material.Metal,        color = Color3.fromRGB(70, 76, 88) },
		light    = { color = Color3.fromRGB(190, 215, 255), brightness = 0.9, range = 18 },
		-- elevator room keeps warm gold = reward
		elevatorFrame = { mat = Enum.Material.Metal,   color = Color3.fromRGB(212, 175, 55) },
		elevatorLight = { color = Color3.fromRGB(255, 225, 160), brightness = 1.1, range = 20 },
	},
	-- Kids-playing-heist: the vault as a bright toy playset. Bold plastic,
	-- sunny warm light, primary colors — still readable, yellow still avoided
	-- on decor so hazard-yellow keeps meaning danger.
	ToyVault = {
		floor    = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(235, 225, 205) },
		ceiling  = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(245, 245, 250) },
		wall     = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(120, 175, 230) },
		pillar   = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(215, 80, 75) },
		frame    = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(90, 140, 95) },
		prop     = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(160, 120, 190) },
		light    = { color = Color3.fromRGB(255, 244, 214), brightness = 1.2, range = 20 },
		elevatorFrame = { mat = Enum.Material.SmoothPlastic, color = Color3.fromRGB(240, 195, 70) },
		elevatorLight = { color = Color3.fromRGB(255, 235, 180), brightness = 1.3, range = 22 },
	},
}

local style = STYLES[styleName]
if not style then
	local names = {}
	for k in STYLES do table.insert(names, k) end
	print("Unknown style '" .. tostring(styleName) .. "'. Available: " .. table.concat(names, ", "))
	process.exit(1)
end

-- ============ ROLE DETECTION ============
local function roleOf(part)
	local n = part.Name
	if n:find("Frame") then return "frame" end
	if n:find("Floor") or n:find("Ramp") or n:find("Stair") or n:find("Step") then return "floor" end
	if n:find("Ceiling") or n:find("Roof") then return "ceiling" end
	if n:find("Wall") or n:find("Front") or n:find("Back") or n:find("Divider") then return "wall" end
	if n:find("Pillar") or n:find("Column") or n:find("Support") or n:find("Beam") then return "pillar" end
	if n:find("Platform") or n:find("Catwalk") or n:find("Ledge") or n:find("Mezzanine") then return "floor" end
	if n:find("Rail") then return "frame" end
	return "prop"
end

local function apply(part, kit)
	part.Material = kit.mat
	part.Color = kit.color
end

-- ============ MAIN ============
local outDir = "rooms/styled/" .. styleName
if not fs.isDir("rooms/styled") then fs.writeDir("rooms/styled") end
if not fs.isDir(outDir) then fs.writeDir(outDir) end

local report = {}
for _, file in fs.readDir("rooms") do
	if file:match("%.rbxm$") or file:match("%.rbxmx$") then
		local model = roblox.deserializeModel(fs.readFile("rooms/" .. file))
		local root = model[1]
		local isElevator = root.Name:lower():find("elevator") ~= nil
		local geoCount, lightCount = 0, 0

		local geo = root:FindFirstChild("Geometry")
		if geo then
			for _, part in geo:GetDescendants() do
				if part:IsA("BasePart") then
					local role = roleOf(part)
					local kit = style[role]
					if isElevator and role == "frame" then kit = style.elevatorFrame end
					apply(part, kit)
					geoCount += 1
				end
			end
		end

		local lights = root:FindFirstChild("Lights")
		if lights then
			local lkit = isElevator and style.elevatorLight or style.light
			for _, inst in lights:GetDescendants() do
				if inst:IsA("BasePart") then
					inst.Color = lkit.color
					inst.Material = Enum.Material.Neon
					lightCount += 1
				elseif inst:IsA("PointLight") then
					inst.Color = lkit.color
					inst.Brightness = lkit.brightness
					inst.Range = lkit.range
				end
			end
		end

		local out = outDir .. "/" .. root.Name .. ".rbxm"
		fs.writeFile(out, roblox.serializeModel(model))
		table.insert(report, string.format("%-16s geo:%2d lights:%d -> %s", root.Name, geoCount, lightCount, out))
	end
end

print("Style: " .. styleName)
for _, line in report do print(line) end
print("== " .. #report .. " rooms restyled ==")
