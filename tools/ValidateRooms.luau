--[[
	ValidateRooms
	Checks every room in ServerStorage.Rooms against the Vault Run room contract
	(docs/ROOM_SPEC.md) and prints a pass/fail report.

	HOW TO RUN
	  Open Studio, click the Command Bar (View > Command Bar) and paste:
	      require(game.ServerStorage.ValidateRooms).Run()
	  To check a single room while you're building it:
	      require(game.ServerStorage.ValidateRooms).Check(game.ServerStorage.Rooms.MyRoom)

	ERRORS break the game. WARNINGS are worth a look but won't crash anything.
]]

local V = {}

-- Contract constants. These mirror Config/VaultBuilder; do not change them casually.
local SPEC = {
	InteriorWidth = 40,      -- x from -20 to +20
	InteriorHeight = 16,     -- y from 0 to 16
	DoorWidth = 10,          -- x from -5 to +5
	DoorHeight = 12,         -- y from 0 to 12
	MinLength = 30,
	MaxLength = 80,
	MaxParts = 120,          -- per room, performance budget
	MarkerFolders = { "CrateSpots", "GuardSpots", "TrapSpots", "PlayerSpawns" },
	BoundsTolerance = 1.5,   -- studs a part may poke past the shell before we complain
}

local function aabb(part)
	-- Axis-aligned bounds of a (possibly rotated) part, in room-local space
	local cf, size = part.CFrame, part.Size
	local x = 0.5 * (math.abs(cf.RightVector.X * size.X) + math.abs(cf.UpVector.X * size.Y) + math.abs(cf.LookVector.X * size.Z))
	local y = 0.5 * (math.abs(cf.RightVector.Y * size.X) + math.abs(cf.UpVector.Y * size.Y) + math.abs(cf.LookVector.Y * size.Z))
	local z = 0.5 * (math.abs(cf.RightVector.Z * size.X) + math.abs(cf.UpVector.Z * size.Y) + math.abs(cf.LookVector.Z * size.Z))
	local p = cf.Position
	return { minX = p.X - x, maxX = p.X + x, minY = p.Y - y, maxY = p.Y + y, minZ = p.Z - z, maxZ = p.Z + z }
end

local function overlaps(b, minX, maxX, minY, maxY, minZ, maxZ)
	return b.maxX > minX and b.minX < maxX
		and b.maxY > minY and b.minY < maxY
		and b.maxZ > minZ and b.minZ < maxZ
end

-- Returns { ok = bool, errors = {string}, warnings = {string}, info = {string} }
function V.Check(room)
	local E, W, I = {}, {}, {}
	local function err(s) table.insert(E, s) end
	local function warn(s) table.insert(W, s) end

	if not room or not room:IsA("Model") then
		return { ok = false, errors = { "Not a Model." }, warnings = {}, info = {} }
	end

	-- 1. Length attribute
	local length = room:GetAttribute("Length")
	if type(length) ~= "number" then
		err("Missing the 'Length' number attribute. Set it to the room's depth in studs (the Z size).")
		length = nil
	elseif length < SPEC.MinLength or length > SPEC.MaxLength then
		warn(string.format("Length is %d. Rooms usually run %d-%d studs; very long rooms stretch a floor out.", length, SPEC.MinLength, SPEC.MaxLength))
	end

	-- 2. Origin / PrimaryPart
	local origin = room:FindFirstChild("Origin")
	if not origin then
		err("No part named 'Origin'. Add a small anchored, non-collidable, invisible part named Origin at the centre of the entrance doorway.")
	elseif room.PrimaryPart ~= origin then
		err("PrimaryPart is not set to Origin. Select the Model and set PrimaryPart to the Origin part.")
	else
		local p = room:GetPivot().Position
		local o = origin.Position
		local d = (o - p).Magnitude
		if d > 0.1 then
			err(string.format("Origin is %.1f studs from the model pivot. The pivot must sit exactly on Origin.", d))
		end
		if origin.CanCollide then warn("Origin should have CanCollide off.") end
		if origin.Transparency < 1 then warn("Origin should be fully transparent.") end
	end

	-- 3. Marker folders
	local counts = {}
	for _, name in ipairs(SPEC.MarkerFolders) do
		local f = room:FindFirstChild(name)
		if not f or not f:IsA("Folder") then
			err("Missing folder '" .. name .. "'. Every room needs all four marker folders, even if one is empty.")
			counts[name] = 0
		else
			local n = 0
			for _, m in ipairs(f:GetChildren()) do
				if m:IsA("BasePart") then
					n += 1
					if m.CanCollide then warn(name .. "." .. m.Name .. " has CanCollide on; markers must not be solid.") end
					if m.Transparency < 1 then warn(name .. "." .. m.Name .. " is visible; markers must be transparent.") end
					if not m.Anchored then err(name .. "." .. m.Name .. " is not anchored.") end
				else
					warn(name .. " contains a " .. m.ClassName .. " ('" .. m.Name .. "'); only Parts are read as markers.")
				end
			end
			counts[name] = n
		end
	end
	if counts.PlayerSpawns and counts.PlayerSpawns > 0 and counts.PlayerSpawns < 4 then
		warn(string.format("Only %d PlayerSpawns. A crew can be 4; spawns are reused but they'll overlap.", counts.PlayerSpawns))
	end
	if counts.CrateSpots == 0 then warn("No CrateSpots. This room will never contain loot.") end

	-- 4. Geometry: anchoring, bounds, doorway clearance
	-- A "Terminal" room ends a floor and has no exit door (only the elevator room today).
	local isTerminal = room:GetAttribute("Terminal") == true
	local partCount, unanchored = 0, 0
	local halfW = SPEC.InteriorWidth / 2
	local doorHalf = SPEC.DoorWidth / 2
	local blockedFront, blockedBack, outOfBounds = {}, {}, {}
	local tol = SPEC.BoundsTolerance

	for _, d in ipairs(room:GetDescendants()) do
		if d:IsA("BasePart") then
			partCount += 1
			if not d.Anchored then unanchored += 1 end
			local isMarker = d.Parent and table.find(SPEC.MarkerFolders, d.Parent.Name) ~= nil
			if not isMarker and d.Name ~= "Origin" then
				local b = aabb(d)
				-- doorway clearance: nothing solid inside the entrance/exit gap
				if d.CanCollide then
					if overlaps(b, -doorHalf + 0.2, doorHalf - 0.2, 0.2, SPEC.DoorHeight - 0.2, -0.4, 0.4) then
						table.insert(blockedFront, d.Name)
					end
					-- a Terminal room (the elevator room) deliberately seals its far wall
					if length and not isTerminal and overlaps(b, -doorHalf + 0.2, doorHalf - 0.2, 0.2, SPEC.DoorHeight - 0.2, length - 0.4, length + 0.4) then
						table.insert(blockedBack, d.Name)
					end
				end
				-- shell bounds
				if length then
					if b.minX < -halfW - 1 - tol or b.maxX > halfW + 1 + tol
						or b.minZ < -1 - tol or b.maxZ > length + 1 + tol
						or b.maxY > SPEC.InteriorHeight + 1 + tol then
						if #outOfBounds < 6 then table.insert(outOfBounds, d.Name) end
					end
				end
			end
		end
	end

	if unanchored > 0 then
		err(unanchored .. " part(s) are not anchored. Every part in a room must be anchored or it will fall through the world.")
	end
	if #blockedFront > 0 then
		err("The entrance doorway (z=0) is blocked by: " .. table.concat(blockedFront, ", ") .. ". Keep a 10 x 12 gap clear at x=-5..5, y=0..12.")
	end
	if #blockedBack > 0 then
		err("The exit doorway (z=Length) is blocked by: " .. table.concat(blockedBack, ", ") .. ". Keep a 10 x 12 gap clear.")
	end
	if #outOfBounds > 0 then
		warn("Parts poking outside the room shell: " .. table.concat(outOfBounds, ", ") .. ". Rooms butt directly against each other, so overhang collides with the next room.")
	end
	if partCount > SPEC.MaxParts then
		warn(string.format("%d parts (budget %d). Several rooms load at once on a floor; heavy rooms cost phone framerate.", partCount, SPEC.MaxParts))
	end

	-- 5. Markers must sit inside the room and near the floor
	for _, name in ipairs(SPEC.MarkerFolders) do
		local f = room:FindFirstChild(name)
		if f then
			for _, m in ipairs(f:GetChildren()) do
				if m:IsA("BasePart") and length then
					local p = m.Position
					if p.X < -halfW or p.X > halfW or p.Z < 0 or p.Z > length then
						err(string.format("%s.%s is outside the room (%.0f, %.0f, %.0f).", name, m.Name, p.X, p.Y, p.Z))
					elseif p.Y < -8 or p.Y > SPEC.InteriorHeight then
						warn(string.format("%s.%s sits at y=%.0f; markers belong on a walkable surface.", name, m.Name, p.Y))
					end
				end
			end
		end
	end

	table.insert(I, string.format("%d parts | crates %d, guards %d, traps %d, spawns %d",
		partCount, counts.CrateSpots or 0, counts.GuardSpots or 0, counts.TrapSpots or 0, counts.PlayerSpawns or 0))

	return { ok = #E == 0, errors = E, warnings = W, info = I }
end

function V.Run(folder)
	folder = folder or game:GetService("ServerStorage"):FindFirstChild("Rooms")
	if not folder then warn("No ServerStorage.Rooms folder found.") return end
	local pass, fail = 0, 0
	print("===== VAULT RUN ROOM VALIDATION =====")
	for _, room in ipairs(folder:GetChildren()) do
		local r = V.Check(room)
		local head = (r.ok and "PASS  " or "FAIL  ") .. room.Name
		if r.ok then pass += 1; print(head .. "   " .. (r.info[1] or "")) else fail += 1; warn(head) end
		for _, e in ipairs(r.errors) do warn("   ERROR   " .. e) end
		for _, w in ipairs(r.warnings) do print("   warning  " .. w) end
	end
	print(string.format("===== %d passed, %d failed =====", pass, fail))
	return fail == 0
end

return V
