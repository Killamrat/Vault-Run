--[[
	VoteService
	The elevator vote. Any crew member calls the elevator; everyone in the run votes
	Extract or Deeper within Config.VoteSeconds. Majority wins, a tie extracts, and on the
	bottom floor only Extract is offered.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Config)
local Remotes = ReplicatedStorage.Remotes
local PlayerService = require(script.Parent.PlayerService)

local VoteService = {}

local function crewSummary(run)
	local list = {}
	for _, p in ipairs(run.Players) do
		local s = PlayerService.Get(p)
		table.insert(list, { UserId = p.UserId, Name = p.DisplayName, Value = PlayerService.CarryValue(p), Downed = s and s.Downed or false })
	end
	return list
end

local function tally(vote)
	local e, d = 0, 0
	for _, choice in pairs(vote.Votes) do
		if choice == "Deeper" then d += 1 else e += 1 end
	end
	return e, d
end

local function broadcast(run, payload)
	for _, p in ipairs(run.Players) do Remotes.VoteUpdate:FireClient(p, payload) end
end

local function resolve(run, vote)
	if run.Vote ~= vote or run.State ~= "Active" then return end
	local e, d = tally(vote)
	local result = (vote.CanDeeper and d > e) and "Deeper" or "Extract"
	broadcast(run, { Extract = e, Deeper = d, Result = result })
	task.wait(2)
	if run.Vote ~= vote or run.State ~= "Active" then return end
	run.Vote = nil
	local RunManager = require(script.Parent.RunManager)
	if result == "Deeper" then
		RunManager.GoDeeper(run)
	else
		RunManager.EndRun(run, true, "extract")
	end
end

function VoteService.Open(run, byPlayer)
	if run.State ~= "Active" or run.Vote then return end
	local vote = { Votes = {}, CanDeeper = run.Floor < Config.MaxFloors, OpenedAt = os.clock() }
	run.Vote = vote
	local payload = { Seconds = Config.VoteSeconds, CanDeeper = vote.CanDeeper, Floor = run.Floor, MaxFloors = Config.MaxFloors, Crew = crewSummary(run), CalledBy = byPlayer and byPlayer.DisplayName or "" }
	for _, p in ipairs(run.Players) do Remotes.VoteOpen:FireClient(p, payload) end
	task.delay(Config.VoteSeconds, function() resolve(run, vote) end)
end

local function onCast(player, choice)
	local s = PlayerService.Get(player)
	local run = s and s.Run
	if not run or not run.Vote then return end
	if choice ~= "Extract" and choice ~= "Deeper" then return end
	if choice == "Deeper" and not run.Vote.CanDeeper then choice = "Extract" end
	run.Vote.Votes[player] = choice
	local e, d = tally(run.Vote)
	broadcast(run, { Extract = e, Deeper = d })
	if e + d >= #run.Players then
		task.spawn(resolve, run, run.Vote)
	end
end

function VoteService.Init()
	Remotes.CastVote.OnServerEvent:Connect(onCast)
end

return VoteService
