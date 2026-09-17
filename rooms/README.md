# rooms/

One `.rbxmx` file per room. Rojo syncs this folder into `ServerStorage.Rooms`,
and `VaultBuilder` shuffles them into floors at runtime.

**Read `../docs/ROOM_SPEC.md` before adding anything here.**

## Adding a room

1. Build it in Studio as a `Model` under `ServerStorage.Rooms`, at the world origin.
2. Set the `Length` attribute and the `PrimaryPart` (a part named `Origin`).
3. Run `require(game.ServerStorage.ValidateRooms).Run()` until it passes clean.
4. Right-click the Model → **Save to File** → save here as `<RoomName>.rbxmx`.
5. Commit. One room per file; one room per commit where practical.

`.rbxmx`, not `.rbxm` — the XML variant is text, so git can version and review
it. The binary one can't be diffed.

## Naming

PascalCase, descriptive of the shape or the fiction, no spaces:
`PillarCorridor`, `BoilerRoom`, `SplitLevel`. The name never appears in the UI,
so it's for us — but it should say what the room *is*.

## Current library

The eleven grey-box rooms currently live in the place file and are exported here
as part of the Rojo migration. All eleven pass validation as of 2026-09-17.

| Room | Length | Crates | Guards | Traps | Notes |
| --- | --- | --- | --- | --- | --- |
| PillarCorridor | 50 | 4 | 3 | 2 | |
| ServerHall | 60 | 5 | 4 | 2 | Rack aisles |
| Catwalk | 60 | 4 | 3 | 2 | Raised walk over a pit |
| Storage | 50 | 5 | 3 | 2 | Stacked crate cover |
| Zigzag | 56 | 4 | 4 | 2 | Staggered baffles, tight sightlines |
| Crossroads | 50 | 5 | 3 | 2 | Central block, paths around |
| BoilerRoom | 60 | 5 | 4 | 2 | Strongest silhouette — first art-pass candidate |
| Offices | 50 | 5 | 3 | 2 | Low desks, partitions |
| SplitLevel | 60 | 5 | 3 | 2 | Raised half + ramps |
| Antechamber | 44 | 5 | 4 | 2 | Open, column ring |
| ElevatorRoom | 30 | 2 | 1 | 0 | `Terminal = true`, always last on a floor |
