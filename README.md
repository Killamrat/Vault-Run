# Vault-Run
Jake and Cam's Vault Run — a co-op heist game for Roblox. 1–4 players.

A crew of up to four breaks into an underground vault, cracks loot crates, dodges traps and security bots, and reaches an elevator — where they vote: **extract** with the loot, or go **one floor deeper** where the crates are rarer and the guards are meaner. Wipe, and the vault keeps everything you were carrying.

**Place:** `Vault Run` (placeId 127491286648527)

This repo is the shared brain between two humans and two AI agents. Game code lives in Roblox Studio (Cam's place); this repo holds design truth and the validation/build workflow.

**Team:** Jake (levels, art direction — agent: Airis/Hermes) · Cam (code, systems — agent: Claude Project)

## Who does what

| Area | Owner | Paths |
| --- | --- | --- |
| Direction, balance, monetization, publishing | **Cam** | `Config` values, Roblox dashboard |
| Level design, room content, art direction | **Jake + Airis** | `rooms/`, art assets |
| Gameplay code and systems | **Claude** (Cam's agent) | `src/`, `tools/` |

The split is drawn so two people can work at once without touching the same files. Anything inside a room is Jake's call. Anything in `src/` or any value in `Config` needs a conversation first — those are load-bearing for code that already exists, and a well-meant change breaks the game silently rather than loudly.

## Repo layout

```
docs/                 Specs and architecture notes
  GDD.md              Design doc (source of truth for intent)
  PROJECT_STATE.md    Living build state
  DIVERGENCES.md      Doc-vs-build conflicts + rulings
  decisions/          One dated file per big decision
  ROOM_SPEC.md        The level design contract. Read this before building a room.
  ARCHITECTURE.md     How the game is wired together.
  WORKFLOW.md         Day-to-day: branches, commits, review.
levels/               Room tile technical contract and room docs
  ROOM_KIT_SPEC.md    Technical contract for room tiles
  rooms/              Per-room design docs
rooms/                Room models, one .rbxmx file per room. Jake's territory.
src/                  All gameplay code, synced into Studio by Rojo.
tools/                Validator and helper scripts.
playtests/            Dated session logs
CAM_PROMPT.md         Onboarding prompt for Cam's agent
```

**Protocol:** update docs after every session; pull before every session; write for an agent with zero chat context.

## Building a room

Read `docs/ROOM_SPEC.md` first — it has the exact shell dimensions, the marker system, the art direction and the performance budget. Then, in Studio:

```lua
require(game.ServerStorage.ValidateRooms).Run()
```

Errors block a merge. Warnings are judgement calls. The validator caught a real blocked-doorway bug in `SplitLevel` on its first run, so it earns its keep.

## What is NOT in this repo

The `.rbxl` place file. Roblox places are large binaries that git cannot diff, and committing them causes exactly the conflicts this repo exists to prevent. The place is built **from** this repo via Rojo, never the other way round.

