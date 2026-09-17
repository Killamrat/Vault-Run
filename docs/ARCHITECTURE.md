# Vault Run — Architecture

*How the game is wired. Last updated 2026-09-17.*

## Principles

1. **The server decides everything that matters.** Loot, cash, health, votes,
   purchases. The client draws and asks; it never asserts.
2. **One config file.** Every tunable number lives in `ReplicatedStorage.Config`.
   Nothing else hard-codes a balance value.
3. **Rooms are data, not code.** A room is geometry plus markers. All behaviour
   lives in services.
4. **Services do one job each** and talk through a small set of named remotes.

## Tree

```
ReplicatedStorage
├─ Config                 every tunable number
├─ Remotes                RemoteEvents / Functions, named by purpose
├─ Shared/LootTable       what comes out of crates (server rolls, client displays)
└─ Assets

ServerScriptService
├─ Main                   boots services in dependency order
└─ Services
   ├─ DataService         DataStore load/save, session profiles, autosave
   ├─ PlayerService       per-player runtime state, HP, backpack, tools
   ├─ VaultBuilder        assembles a floor from the room library
   ├─ RunManager          owns a run's life: start, floors, settle, cleanup
   ├─ CrewService         hub crew pads and the start countdown
   ├─ CrateService        crate cracking, interruption, loot rolls, pickups
   ├─ GuardService        security bot state machine + ragdoll stun
   ├─ TrapService         shove panels
   ├─ CombatService       damage, knockback, downed / revive / bleed-out
   ├─ VoteService         the elevator vote
   ├─ ShopService         cash upgrades
   ├─ ShowcaseService     hub booths, showpiece display
   ├─ LeaderboardService  weekly OrderedDataStore board
   ├─ MonetizationService Developer Product receipts
   └─ DebugService        Studio-only test commands

ServerStorage
├─ Rooms                  the room library (synced from rooms/)
├─ Tools                  melee tool templates
└─ ValidateRooms          the room contract checker

StarterPlayer/StarterPlayerScripts/Client
└─ ClientMain             builds every screen at runtime, wires remotes

Workspace
├─ Hub                    spawn, crew pads, shop board, leaderboard, showcase
└─ Runs                   live vault instances, one folder per crew
```

## How a run works

1. Players stand on a crew pad; `CrewService` counts down and calls
   `RunManager.StartRun`.
2. `RunManager` claims a slot far from the hub (`Config.RunOrigin` + slot
   spacing), so several crews can run at once in one server.
3. `VaultBuilder.Build` shuffles rooms from the library, chains them along +z
   using each room's `Length`, and returns the marker lists.
4. `RunManager` populates the floor: crates by tier weight, guards on their
   room's patrol spots, traps, and wires the elevator prompt.
5. The crew plays. `CombatService` owns health and downed state;
   `RunManager.OnPlayerDowned` ends the run when nobody is left standing.
6. At the elevator, `VoteService` opens a vote. Deeper rebuilds the floor one
   level down; Extract settles the run.
7. `settle()` pays out or takes the loot, fires the results screen, returns the
   player to the hub, and refreshes their showcase.

## Difficulty

Floor depth is the only dial. `Config.Floors[n]` sets room count, guard count,
trap count, crate count and the rarity weights. Because depth is chosen by the
crew, the game self-balances: cautious players farm floor 2, bold players gamble
on floor 3.

## Data

`DataService` wraps DataStore with retries and session profiles. A failed load
hands out a **temporary, unsaveable** profile rather than risking an empty save
overwriting a real one. Autosave every `Config.AutosaveSeconds`, plus on leave
and on server shutdown.

## Monetization

Two Developer Products, both server-validated through `ProcessReceipt`:

- **Self-Revive** — only while downed with a crewmate standing, once per run.
- **Save My Loot** — on a wipe or bleed-out, a timed offer listing exactly what
  would be lost.

Product IDs live in `Config.Monetization`. While an ID is `0`, Studio simulates
the purchase for testing and the live game hides the button rather than charging
for something that cannot be delivered.

## Known weak points

- **Guard pathing** is straight-line with a stuck-hop fallback. Real pathfinding
  is the fix; it has not been needed yet at current room complexity.
- **Runs live in one server.** If servers get crowded, runs move to reserved
  servers. Not needed at current scale.
- **No onboarding run yet.** The design calls for a Practice Vault; not built.
