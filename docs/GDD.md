# VAULT RUN — Design Document
**v0.3 · Co-op push-your-luck heist roguelite for Roblox · 1–4 players · Sessions 8–15 min**

> Source of truth for design intent. Where the live build differs, see `DIVERGENCES.md`.

## Overview

### Core Fantasy
You and up to three friends are a crew of cartoon burglars cracking a procedurally generated mega-vault. Every floor deeper multiplies your take — but one tripped alarm and the run collapses. The tension isn't "can you win," it's "do you bank now or push one more floor."

### Pillars
1. **Greed is the boss.** No combat depth needed — the antagonist is the players' own greed. Every system should ask "bank or push?"
2. **Runs end loud.** Failure should be funny and spectacular (dye packs, klaxons, cartoon police pile-ups), never a quiet fizzle.
3. **Friends make it worse (better).** Co-op should add chaos, not safety. Shared alarm meter, split loot decisions, one player's greed dooms everyone.
4. **Readable in 3 seconds.** A new player watching a TikTok clip should instantly get it: sneak, grab, escape or get caught.

### Elevator Pitch
Deep Rock Galactic's "one more dig" tension × Mario Party betrayal energy, compressed into a 10-minute Roblox session with hats.

## The Core Loop (one floor ≈ 90–120 seconds)
1. **BREACH (10s)** — Crew drops into a new floor via elevator shaft. 5-second scout window where guard patrol routes are briefly highlighted.
2. **GRAB (60–90s)** — Loot spawns as physical bags players must carry (slows movement 15% per bag). Guards patrol. Cameras sweep. Every grabbed bag ticks the floor's Heat meter up.
3. **DECIDE (at elevator)** — All players vote at the elevator: BANK (end run, keep everything) or PUSH (next floor, loot multiplier +0.5×). Vote must be unanimous to bank — one greedy player forces everyone deeper. 15-second timer; no vote = push.
4. Repeat until bank, bust, or Floor 10 (the Mythic Vault, hard ceiling).

### The Alarm (run-ender)
Shared crew-wide meter, 0–100. Rises from: camera spots (+15), guard line-of-sight 2s (+25), failed lockpick QTE (+10), dropped loot bag noise (+5). Decays 1/sec while nobody is detected. At 100: **VAULT LOCKDOWN** — 45-second frantic escape sequence. Reach the elevator with whatever you carry or lose everything. Carried bags during lockdown escape are kept at 50% value.

### Death/Downs
No player death. Guards tackle and 'cuff' you — teammate must uncuff (4s channel). If ALL players cuffed simultaneously → instant bust, run ends, funny police-van cutscene. Solo players get one auto-escape per run.

### Why unanimous banking?
Playtest hypothesis: majority-vote banking kills the fun — the tension IS the argument at the elevator. Unanimous-to-bank means one maniac drags the whole crew deeper, which generates the clips and screaming we want. Needs validation (see Open Questions).

## Floor Progression (procedural, 10 floor cap)
- **Floors 1–2: THE LOBBY** — Tutorial-grade. Sleepy guards, slow cameras, loot = cash bags (1× base). Layout: office cubicles, break rooms. Almost impossible to bust here on purpose.
- **Floors 3–4: THE DEPOSITS** — Laser grids appear (crouch-under timing). Loot = jewelry (1.5× base) + first Gadget crates. Guards get flashlights. First floor where lockdown escape actually threatens.
- **Floors 5–6: THE ARCHIVE** — Dark floors, limited vision cone. Loot = art & artifacts (2× base, bulky: 25% slow per bag instead of 15%). Introduces the Curator — a mini-boss guard who never stops patrolling and can't be distracted.
- **Floors 7–8: THE FORGE** — Environmental hazards: steam vents on timers, molten gold channels (instant cuff if touched). Loot = gold bars (3× base). Camera density doubles. Alarm decay disabled — heat only goes up.
- **Floors 9–10: THE MYTHIC VAULT** — Near-dark, one giant open room, the Vault Keeper (unique guard, scripted patrol that adapts to loot taken). Loot = artifacts (5× base) + guaranteed Relic (permanent meta-progression item) on Floor 10. Reaching Floor 10 at all should feel like a 1-in-20-runs event.

### Procedural generation notes
Each floor assembled from 8–12 hand-built room tiles per theme, connected by a constraint solver (elevator entry + exit always on opposite ends, min 2 loot rooms, exactly 1 security office that can disable cameras for 30s). Guard counts scale with player count: 2 + (players × 1.5), rounded down.

## Economy

### Currencies
- **CASH (run currency)** — Earned from banked loot. Spent between runs on consumables (smoke bombs, lockpick kits, decoy dummies) and cosmetic gacha rolls. Resets never, but consumables are the sink.
- **RELICS (meta currency)** — Only from Floor 10 clears or rare Floor 7+ drops. Unlock permanent crew perks: +1 bag capacity, faster uncuff, elevator vote timer +5s, start with 1 gadget. Hard cap: 12 relic slots total, forcing build choices.
- **STYLE (cosmetic-only)** — From dailies, funny deaths (get cuffed 3 ways in one run), and Robux. Hats, skins, victory dances, police-van customization. ZERO gameplay effect — hard rule.

### Monetization (Robux)
Cosmetics only for anything power-adjacent. Sellable: cosmetic gacha keys, battle-pass-style 'Heist Season' track (cosmetic tiers + Style currency), crew name/tag customization, emotes. NOT sellable ever: relics, consumables, run revives, alarm reduction, loot multipliers. Push-your-luck games die instantly if you can buy your way out of consequences — the consequence IS the product.

> **NOTE:** The live build (v0.1.2) ships Self-Revive (25 R$) and Save My Loot (75 R$) dev products, which conflict with this section. See DIVERGENCES.md — needs an official ruling.

### Payout math (needs tuning)
Base bag = 100 cash. Floor multiplier = 1 + 0.5×(floor−1). Banking 6 bags from Floor 4 = 6×100×2.5 = 1,500. Consumable prices anchor around ~1/3 of an average successful run (target: avg run banks ~1,200 cash, smoke bomb = 400). Lockdown escapes paying 50% keeps 'greedy failure' above 'never pushed at all' — greed must never feel strictly stupid, only risky.

## The Risk Dial (pre-run wager)
Before each run, the crew sets a shared Risk Dial with four settings. It's a bet on your own performance:
- **CASUAL (0.8× payout)** — Alarm rises 25% slower, guards have shorter vision. For chill sessions and onboarding. Slightly reduced payout so it's never optimal for farming.
- **STANDARD (1.0×)** — Baseline experience as described in this doc.
- **WANTED (1.5×)** — Alarm decay halved, +1 guard per floor, cameras can't be disabled. Elevator vote timer drops to 10s.
- **INFAMOUS (2.5× + exclusive cosmetic drops)** — No alarm decay at all, Curator-class guards start on Floor 3, ONE shared uncuff per run for the whole crew, lockdown timer 30s instead of 45s. Designed to be clip bait — most Infamous runs should end in glorious disaster.

### Why a dial instead of difficulty modes?
It frames difficulty as a wager, not a setting — consistent with the greed pillar. Also gives streamers a built-in 'we're going Infamous' moment and gives the matchmaking pool a soft skill-sort without visible ranks.

### Dial + Relic interaction
Relic perks apply at all dial settings EXCEPT Infamous, where all relics are disabled (level playing field for the leaderboard + keeps exclusive cosmetics prestige-pure). Weekly Infamous leaderboard resets Mondays; top 100 crews get an animated hat.

## Open Questions (v0.3 — need answers before vertical slice)
1. **Unanimous banking — genius or griefer magnet?** The whole design bets on elevator arguments being fun. But one troll can force a 4-stack into busts forever. Mitigations to test: vote-kick? 'cash out alone at 60% value' escape hatch? Reputation system?
2. **Solo viability.** Everything is tuned for co-op chaos. Does solo need its own alarm tuning, or an AI companion, or do we just accept solo is hard mode? Roblox data says huge % of sessions are solo.
3. **Loot bag physics griefing.** Bags are physical objects — players WILL yeet teammates' bags into molten gold. Feature (funny) or bug (rage-quits)? Possible rule: bags become soul-bound after 10s carried.
4. **Floor 10 frequency.** Is 1-in-20 runs the right rarity for the Mythic Vault? Too rare = most players never see the coolest content. Too common = relics flood the meta.
5. **Heat vs Alarm redundancy.** Floor Heat meter and crew Alarm meter may be one system too many. Playtest whether players understand both or whether Heat should just feed Alarm directly.
6. **Roblox technical:** can we do 4-player synced physics bags + 8 guards + camera raycasts at 60fps on a mid-tier phone? Need a perf spike THIS SPRINT before committing to physical loot.
7. **Session length honesty.** 8–15 min target assumes ~90s floors. Real players dawdle. If real sessions hit 25 min, do we cut to 8 floors? Mobile session data says most Roblox sessions < 20 min.
