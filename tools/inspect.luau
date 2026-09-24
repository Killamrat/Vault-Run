-- Inspect a .rbxm room file: dump hierarchy, part properties
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local process = require("@lune/process")

local path = process.args[1]
local model = roblox.deserializeModel(fs.readFile(path))

local function dump(inst, depth)
	local pad = string.rep("  ", depth)
	local info = pad .. inst.ClassName .. " '" .. inst.Name .. "'"
	if inst:IsA("BasePart") then
		local s, c = inst.Size, inst.Color
		info ..= string.format(" size=(%.1f,%.1f,%.1f) mat=%s color=(%d,%d,%d) T=%.1f anch=%s",
			s.X, s.Y, s.Z, tostring(inst.Material), math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5),
			inst.Transparency, tostring(inst.Anchored))
	end
	print(info)
	for _, ch in inst:GetChildren() do
		dump(ch, depth + 1)
	end
end

for _, root in model do
	print("== ROOT ==")
	print("Attributes:")
	for k, v in root:GetAttributes() do
		print("  " .. k .. " = " .. tostring(v))
	end
	if root.PrimaryPart then
		print("PrimaryPart: " .. root.PrimaryPart.Name)
	end
	dump(root, 0)
end
