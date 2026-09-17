# Rojo migration

Moving Vault Run's code out of the place file and into this repo, safely.

## Why this is sequenced

Rojo makes Studio match the filesystem. A path listed in `default.project.json`
is **owned** by Rojo — and anything in that path inside Studio that has no
corresponding file **gets deleted**.

So if we pointed Rojo at `Services/` while only 2 of 15 services had been
exported, Rojo would delete the other 13 from the place. Same for `rooms/`:
mapping that folder before the `.rbxmx` files exist would wipe all eleven rooms.

The rule: **a path only enters `default.project.json` after every file under it
has been exported.**

## Before the first connect

1. **Publish the place** (Alt+P). Roblox keeps version history; that is the
   rollback if anything goes wrong.
2. **File → Save As** a local `.rbxl` copy somewhere outside the repo. Belt and
   braces. The `.gitignore` keeps it out of git deliberately.

## Stages

| Stage | Adds to project.json | Status |
| --- | --- | --- |
| 1 | `ServerStorage.ValidateRooms` | **current** — one file, proves the pipeline |
| 2 | `ReplicatedStorage.Config`, `ReplicatedStorage.Shared` | files exported, not yet mapped |
| 3 | `ServerScriptService.Main` + `Services` | 5 of 15 services exported |
| 4 | `StarterPlayerScripts.Client` | ClientMain not yet exported |
| 5 | `ServerStorage.Rooms` ← `rooms/` | needs all 11 rooms saved as `.rbxmx` |

Stage 1 is safe because `ValidateRooms` exists identically in both places, so the
first sync changes nothing. That is exactly what we want from a first sync: a
no-op that proves the connection works.

## Export status

Exported and byte-verified against the place:

- `src/ReplicatedStorage/Config.luau`
- `src/ReplicatedStorage/Shared/LootTable.luau`
- `src/ServerScriptService/Main.server.luau`
- `src/ServerScriptService/Services/TrapService.luau`
- `src/ServerScriptService/Services/VoteService.luau`

Still in the place only:

- Services: DataService, PlayerService, VaultBuilder, CombatService,
  GuardService, CrateService, RunManager, CrewService, ShopService,
  LeaderboardService, ShowcaseService, DebugService, MonetizationService
- `ClientMain` (42 KB, the largest single file)
- All 11 rooms

## The rule once a path is managed

Once a path is in `default.project.json`, **the file is the source of truth.**
Editing that script inside Studio is pointless — the next sync overwrites it.
Edit the file; Studio updates live.

Until a path is managed, the opposite holds: the place is authoritative, and the
copy in this repo is a backup that can drift.
