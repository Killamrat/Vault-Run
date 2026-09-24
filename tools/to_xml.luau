local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local function convertDir(dir)
	for _, f in fs.readDir(dir) do
		local p = dir .. "/" .. f
		if fs.isDir(p) then
			convertDir(p)
		elseif f:match("%.rbxm$") then
			local model = roblox.deserializeModel(fs.readFile(p))
			local root = model[1]
			local out = dir .. "/" .. root.Name .. ".rbxmx"
			fs.writeFile(out, roblox.serializeModel(model, true))
			print(out)
		end
	end
end
convertDir("rooms")
