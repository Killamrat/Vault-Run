# Vault Run — Room Spec v1.0

*The level design contract. Geometry numbers here are measured from the eleven
shipping rooms, not estimated. Last updated 2026-09-17.*

---

## 1. What the rooms are for

Vault Run is a co-op heist game for up to four players. A crew drops into an
underground vault, works through a sequence of rooms cracking loot crates while
dodging traps and fighting security bots, and reaches an elevator. There the crew
votes: **extract** with the loot, or go **one floor deeper** where crates are
rarer and guards meaner. Wipe, and the vault keeps everything you were carrying.

A floor is built at runtime by shuffling 3–5 rooms from the library and chaining
them end to end, always capped by the elevator room.

> **Every room must work in any order, at any depth, from either difficulty.**
> A room that only makes sense as the opener is a broken room.

Target: 5–10 minute runs, on phones as much as PC. The tension level design
serves is simple — *can we clear one more room before somebody gets dropped?*

---

## 2. The room shell (hard contract)

These numbers are not stylistic. Rooms butt directly against one another with no
connector geometry, so a shell that deviates leaves a visible seam or a wall the
crew cannot walk through.

| Property | Value | Why |
| --- | --- | --- |
| Interior width | 40 studs, x = −20 … +20 | Side walls at x = ±20.5, one stud thick |
| Interior height | 16 studs, y = 0 … 16 | Floor top at y 0, ceiling underside at y 16 |
| Length | 30–80 studs along +z | Your choice per room. Shipping rooms run 30–60 |
| Doorway gap | x = −5 … +5, y = 0 … 12 | At **both** z = 0 and z = Length. Must stay clear |
| Model attribute | `Length` (number) | The builder chains rooms with this. Wrong value = overlapping rooms |
| PrimaryPart | Part named `Origin` | At local (0,0,0), centre of the entrance doorway. Anchored, invisible, no collision |
| Direction of travel | +z | Crew always enters at z = 0, leaves at z = Length |
| Anchoring | Every part anchored | Rooms are cloned into position at runtime; unanchored parts fall out of the world |

```
PLAN (looking down)                 SECTION (through a doorway)

   exit  z = Length                    ceiling ── y 16
   ███████     ███████                 ██████████████████
   █                 █                 ███        ███
   █                 █                        ▲
   █   interior      █  40 wide             12 studs
   █                 █                    door height
   █                 █                        ▼
   ███████     ███████                 ██████████████████
   entrance z = 0                      floor ──── y 0
          ▲
      10 wide gap
      ● Origin (0,0,0)
```

### Hard failures

A blocked doorway, a missing `Length`, a `PrimaryPart` that is not `Origin`, or
an unanchored part will break the floor the room lands on. The validator catches
all four.

### Terminal rooms

One room today — `ElevatorRoom` — sets the boolean attribute `Terminal = true`
and deliberately seals its far wall. Unless you are building a replacement
elevator room, do not set it.

---

## 3. Markers

Rooms do not contain crates, guards or traps. They contain **markers**, and the
server decides at runtime how many to use based on the floor's difficulty.
Floor 1 places one guard; floor 3 places five. Give the game more options than it
needs and let it choose.

Every room carries four folders, even if one is empty. Each holds anchored,
invisible, non-collidable parts — position is the only thing read. Roughly
2 × 1 × 2 studs is the convention.

| Folder | Aim for | Notes |
| --- | --- | --- |
| `CrateSpots` | 4–6 | Where loot crates can appear, on the floor. Spread them so the crew splits up: one in plain sight, one behind cover, one that costs a detour. |
| `GuardSpots` | 3–4 | Spawn points **and** patrol waypoints — a guard patrols between all spots in its room, so three spots make a triangle route. Place them where a patrol crosses the path to a crate. |
| `TrapSpots` | 2 | Shove panels: 7 × 7 floor plates that launch whoever steps on them. Best on the obvious fast line, so hurrying is punished and looking is rewarded. |
| `PlayerSpawns` | exactly 4 | Near z = 5, ~4 studs apart. Only used if the room lands first on a floor, but every room needs them. |

> Markers must sit inside the room and on a surface a player can stand on. A
> crate spot floating over a pit spawns an unreachable crate; a guard spot inside
> a wall spawns a bot that never finds anyone. The validator range-checks
> positions but cannot tell whether a surface exists underneath.

---

## 4. What makes a good room

The contract gets a room to load. This is what makes it worth playing. The
shipping eleven are competent grey-box shapes and nothing more — there is a lot
of headroom, and this is where a real level designer beats a script.

**Give the crew a decision, not a corridor.** The best rooms present a visible
trade: the rare crate is past the trap, or up on the ledge that costs ten seconds
while a guard patrols below. Ten seconds matters because the crew is always
weighing whether to push deeper. A room that is a path with loot on it adds
length but no tension.

**Design for a crew that splits, and a solo player who can't.** Four players fan
out — reward that; two crates far apart beat two side by side. But a solo player
has nobody to revive them, so a room must never *require* two people. Every crate
reachable alone.

**Sightlines are the difficulty dial.** Guards notice players within 32 studs in
a roughly 100° cone. Long open rooms let you see the bot coming and plan. Tight
staggered rooms mean you turn a corner into one. Both are good; mixing them
across the library keeps a shuffled floor from feeling samey.

**Vertical space is under-used.** Sixteen studs of headroom is a lot and the
current rooms barely touch it. Catwalks, ledges, a mezzanine reached by a ramp —
anything that makes the crew choose a level. Keep the exit reachable from
wherever you send them: that is exactly the bug that shipped in `SplitLevel`,
whose raised platform ran into the doorway with a rail across the middle of it.

| Do | Don't |
| --- | --- |
| Cover to break line of sight behind | Dead ends with nothing in them |
| At least one crate that costs a real detour | Gaps a player can fall into and not climb out of |
| A readable silhouette — shape clear in two seconds | Jumps a phone player can't reliably make |
| Lanes wide enough for four bodies and a ragdolling guard | Loot that needs two people to reach |
| Something memorable enough to name it by | Anything that reads as a puzzle (later phase, own rules) |

---

## 5. Art direction

**Stylized-realistic**: clean geometry, believable materials, bold readable
silhouettes. Not cartoon proportions, not photoreal. Should photograph well for a
thumbnail and run on a five-year-old phone.

| Element | Treatment |
| --- | --- |
| Vault structure | Cold greys, concrete and steel. Blue-white light |
| Hazards (traps, guards) | Hazard yellow — means *danger*, reserved for it |
| Loot and the elevator | Warm gold — means *reward*, reserved for it |
| Rarity ladder | Grey → blue → purple → gold, fixed, never repurposed |
| Lighting | Ceiling strips roughly every 16 studs; legible without a flashlight |

The colour discipline is the important part. A player must be able to tell at a
glance what will hurt them and what will pay them, on a small screen, while being
chased. If a decorative prop is yellow, that discipline is gone.

---

## 6. Performance budget

Three to five rooms load at once, plus guards, crates, traps and up to four
players, and a meaningful share of the audience is on phones.

- **Target ≤ 80 parts per room; hard ceiling 120.** The shipping eleven run 22–48.
- **Union or mesh repeated detail** rather than stacking dozens of small parts.
- **Lights are expensive.** 3–4 point lights per room; lean on emissive surfaces.
- **No scripts inside rooms.** All behaviour lives in the services. A room is
  geometry and markers, nothing else.
- **No transparency stacking.** Overlapping transparent parts kill phone framerate.

---

## 7. Workflow

1. Build in Studio as a `Model` under `ServerStorage.Rooms`, at the world origin.
2. Set the `Length` attribute and the `PrimaryPart`.
3. Run the validator until it passes clean.
4. Right-click the Model → **Save to File** → `rooms/<RoomName>.rbxmx`.
5. Commit. One room per file, one room per commit where practical.

**Naming:** PascalCase, descriptive, no spaces — `PillarCorridor`, `BoilerRoom`.

**Format:** `.rbxmx`, not `.rbxm`. XML is text, so git can version and review it.

**Commit messages:** `room: add Vent Crawl (52 long, 5 crates, vertical)` —
prefix, name, and the three facts that matter for review. Fixes:
`room: fix Catwalk exit blocked by railing`.

---

## 8. Validator

Lives at `tools/ValidateRooms.luau` in the repo and `ServerStorage.ValidateRooms`
in the place. In Studio, open the Command Bar (View → Command Bar):

```lua
-- check everything
require(game.ServerStorage.ValidateRooms).Run()

-- check one room while building it
require(game.ServerStorage.ValidateRooms).Check(game.ServerStorage.Rooms.MyRoom)
```

Errors block a merge. Warnings are judgement calls — a 90-part room is fine if it
is the showpiece on floor 3, and the validator will still mention it.

Library state as of 2026-09-17:

```
PASS PillarCorridor  37 parts | c4 g3 t2 s4
PASS ServerHall      43 parts | c5 g4 t2 s4
PASS Catwalk         36 parts | c4 g3 t2 s4
PASS Storage         38 parts | c5 g3 t2 s4
PASS Zigzag          35 parts | c4 g4 t2 s4
PASS Crossroads      32 parts | c5 g3 t2 s4
PASS BoilerRoom      36 parts | c5 g4 t2 s4
PASS Offices         48 parts | c5 g3 t2 s4
PASS SplitLevel      37 parts | c5 g3 t2 s4
PASS Antechamber     37 parts | c5 g4 t2 s4
PASS ElevatorRoom    22 parts | c2 g1 t0 s4  [terminal]
== 11 passed, 0 failed ==
```

---

## 9. Changes that need a conversation first

Anything in `src/`, any value in `Config` (guard damage, prices, floor
difficulty, drop odds), the shell dimensions in section 2, or the marker folder
names. These are load-bearing for code that already exists — a well-meant change
breaks the game silently rather than loudly.

Everything inside a room is yours. Build whatever passes.

If the contract is wrong for what you are trying to build, say so and it gets
changed properly, in both the code and this document.
