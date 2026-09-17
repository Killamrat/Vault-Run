# PROJECT STATE — Vault Run
> Owned and updated by Cam's agent after every working session. Airis pulls before every session.

**Current version:** 0.1.2 — adds Self-Revive (25 R$) and Save My Loot (75 R$) developer products with a Studio simulation mode (Sept 16). Previously 0.1.1: guard damage 25→18, backpack 5 base / 7 max, showpieces drop from Common crates (6%), UI v2 (stats card, floor banner, Upgrades and How-to-play buttons, clearer results), Studio-only DebugCmd attribute on Workspace for testing.

**Current phase:** Phase 1→3 compressed: the MVP exists as a grey-box. Now: Cam's review and first real playtests.

**Current objective:** Find out whether "one more floor?" is fun with 2–4 real people. Then tune, not build.

## Completed
- Discovery, research, concept, GDD
- Studio MCP connection
- Hub: spawn, 3 crew pads, upgrades board, weekly leaderboard, 12 showcase booths
- 10 hand-built rooms + elevator room; VaultBuilder shuffles them into floors
- Runs, crews, 3 floors, crates (4 tiers), haul + showpieces, backpack with drop/pickup
- Guards (patrol/chase/attack/stun/retire), shove-panel trap, melee tools, custom HP, downed/revive/bleed-out, crew wipe
- Elevator vote (majority, tie extracts, bottom floor extract-only)
- Results screen, rookie protection for the first 3 runs, invite button
- DataStore saving with autosave and safe-fail; weekly OrderedDataStore leaderboard
- Runtime-built UI: HUD, backpack, crew chips, vote, results, shop, downed overlay

## In progress
- Cam's second review. First review verified: guards tumble on hit, extraction pays out (best haul $471 on record).

## Next task
- Cam playtests solo with a mouse (swing at a guard, buy an upgrade), then a 2–4 player test via Studio's Test → Local Server. Log what felt wrong.
- Then: tune guard damage/stun, add the practice-vault onboarding run, first art pass.

## Known bugs
- Guard chase uses straight-line movement; can snag on obstacles (it hops when stuck, but pathfinding is the real fix)
- Guards standing in the elevator room can catch a crew during the vote — intentional tension for now, watch it in playtests
- Verified by scripted input only: swing hit detection, revive, multi-player vote tallies, showpiece display. Cam's playtest confirms these

## Explorer architecture
ReplicatedStorage (Config, Remotes, Shared.LootTable), ServerScriptService (Main + 12 Services), ServerStorage (Rooms, Tools), StarterPlayerScripts.Client.ClientMain, Workspace (Hub, Runs). 19 scripts total.

## Important decisions
- Underground mega-vault setting, stylized-realistic art
- Simple melee tools; guards ragdoll; no guns
- Crew wipe loses all carried loot (to be tuned by data)
- Server-authoritative everything; the client only asks
- Runs are instanced inside one server for the prototype and MVP; reserved servers only if load demands
- No wait timers anywhere; no pay-to-keep-loot *(see DIVERGENCES.md — v0.1.2 dev products conflict)*

## Features we cut
Guns, trading, rebirth/prestige, multiple vault themes at launch, procedurally generated geometry, PvP invasion (deferred, not dead), physics-driven combat

## MVP status
14 of 14 MVP features built in grey-box; ~10 verified by scripted playtest, the rest await a human test. No art, no sound, no practice run yet.

## Long-term vision
Vault Run → Crew Heist (day/night prep-and-heist structure, hideouts, vehicles) → Bounty Board (open city)
