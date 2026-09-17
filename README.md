# Vault-Run
Jake and Cam Vault Run...
# Vault Run

A co-op heist game for Roblox. A crew of up to four breaks into an underground
vault, cracks loot crates, dodges traps and security bots, and reaches an
elevator — where they vote: **extract** with the loot, or go **one floor deeper**
where the crates are rarer and the guards are meaner. Wipe, and the vault keeps
everything you were carrying.

**Place:** `Vault Run` (placeId 127491286648527)

---

## Who does what

| Area | Owner | Paths |
| --- | --- | --- |
| Direction, balance, monetization, publishing | **Cam** | `Config` values, Roblox dashboard |
| Level design, room content, art direction | **Jake + Airis** | `rooms/`, art assets |
| Gameplay code and systems | **Claude** (Cam's agent) | `src/`, `tools/` |

The split is drawn so two people can work at once without touching the same
files. Anything inside a room is Jake's call. Anything in `src/` or any value in
`Config` needs a conversation first — those are load-bearing for code that
already exists, and a well-meant change breaks the game silently rather than
loudly.

---

## Repo layout

```
docs/          Specs and architecture notes
  ROOM_SPEC.md     The level design contract. Read this before building a room.
  ARCHITECTURE.md  How the game is wired together.
  WORKFLOW.md      Day-to-day: branches, commits, review.
rooms/         Room models, one .rbxmx file per room. Jake's territory.
src/           All gameplay code, synced into Studio by Rojo.
tools/         Validator and helper scripts.
```

## Building a room

Read `docs/ROOM_SPEC.md` first — it has the exact shell dimensions, the marker
system, the art direction and the performance budget. Then, in Studio:

```lua
require(game.ServerStorage.ValidateRooms).Run()
```

Errors block a merge. Warnings are judgement calls. The validator caught a real
blocked-doorway bug in `SplitLevel` on its first run, so it earns its keep.

## What is NOT in this repo

The `.rbxl` place file. Roblox places are large binaries that git cannot diff,
and committing them causes exactly the conflicts this repo exists to prevent.
The place is built **from** this repo via Rojo, never the other way round.
