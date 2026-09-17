# DIVERGENCES — GDD v0.3 vs Build v0.1.2
> Log of conflicts between design doc intent and the live build. Each needs an official ruling from Jake + Cam. Rulings get a dated file in `docs/decisions/`.

| # | Topic | GDD v0.3 says | Build v0.1.2 has | Status |
|---|-------|---------------|------------------|--------|
| 1 | Monetization | NOT sellable ever: run revives, pay-to-keep-loot ("the consequence IS the product") | Self-Revive (25 R$), Save My Loot (75 R$) dev products | **OPEN** — Jake says Cam changed direction; needs official ruling + GDD update. Airis's position: the GDD is right; monetizing the death penalty before validating that death feels fair is high-risk. |
| 2 | Combat/death model | No player death; guards tackle-and-cuff; teammate uncuff (4s) | Melee tools, HP, downed/revive/bleed-out, death at 0 HP | **RESOLVED per Jake (Sept 17):** HP/death model is official. GDD needs updating. |
| 3 | Elevator vote | Unanimous to bank; no vote = push; 15s timer | Majority vote; tie extracts; bottom floor extract-only | **OPEN** — playtest both. Likely a config-level change. The unanimous version is the spicier design bet (GDD Open Question #1). |
| 4 | Scale | 10 floors, 5 themes, 8–12 room tiles per theme (40–60 rooms) | 3 floors, 10 rooms, 1 theme | **NOT A CONFLICT** — build is the MVP slice of the doc's vision. Confirm the phased path. |
| 5 | Loot physics | Loot spawns as physical bags, carry-slow, dropped-bag noise | Crates (4 tiers) + backpack with drop/pickup | **OPEN** — different loot models. Perf spike (GDD OQ #6) should inform this. |
| 6 | Alarm system | Shared 0–100 Alarm meter with lockdown escape sequence | No alarm meter; guards + crew wipe are the fail state | **OPEN** — Alarm/lockdown is arguably the strongest unbuilt drama system, directly relevant to the "bland" playtest verdict. |

## First playtest verdict (Sept 17, Jake + Cam)
"Fun and cool but bland and boring." Skeleton works; failure is escalation/drama, not systems. Fix directions under discussion: floor-to-floor escalation, game feel/juice (detection stings, klaxons, loud failures), rooms that force micro-decisions.
