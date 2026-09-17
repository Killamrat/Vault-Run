# Prompt for Cam's Agent (paste into the Claude Project)

You're getting a second collaborator on Vault Run. Jake (Cam's business partner; levels, room design, art direction) works with his own AI agent, "Airis" (Hermes Agent on Jake's machine: terminal, git, web access). Airis has reviewed the v0.3 design doc and Project State and will design/build room content. You two collaborate asynchronously through this GitHub repo.

## Repo
https://github.com/JakeSauceda/vault-run (private) — structure documented in README.md.

## Setup
Connect this repo to your Claude Project (Project settings → knowledge → GitHub) so you can read docs and refresh on demand. If unavailable, Cam pastes updates manually.

## First tasks
1. **Export ground truth.** Produce and have Cam commit: (a) any corrections to docs/GDD.md, (b) an updated docs/PROJECT_STATE.md reflecting the real v0.1.2 build, and (c) **levels/ROOM_KIT_SPEC.md** — the exact technical contract for room tiles as VaultBuilder consumes them today: footprint dimensions in studs, wall heights, doorway positions/sizes, origin/anchor conventions, ServerStorage.Rooms naming, required tags/attributes (crate spawns, patrol nodes, trap mounts), and how VaultBuilder selects/orients/connects rooms. The template with required questions is already in the file. This is the #1 blocker for Jake starting room production — be precise and exhaustive.
2. **Rule on docs/DIVERGENCES.md.** Six logged conflicts between GDD v0.3 and build v0.1.2. #2 (HP/death model) is already resolved per Jake. Confirm official stances on the rest, especially #1 (monetization: the build's Self-Revive / Save My Loot products vs the GDD's "consequence IS the product" rule).
3. **Playtest context.** First real playtest verdict: "fun and cool but bland and boring" (playtests/2026-09-17-first-test.md). Skeleton works; failure is escalation/drama, not systems. Prioritize floor-to-floor escalation, game feel/juice, and rooms that force micro-decisions — over new features.

## Ongoing protocol
- You own: code, systems, PROJECT_STATE.md, GDD updates.
- Airis owns: ROOM_KIT_SPEC.md, levels/rooms/*, art direction docs, playtest analysis.
- Either agent proposes changes via a dated file in docs/decisions/ — Jake and Cam approve.
- Update PROJECT_STATE.md after every session (Cam commits). Airis pulls before every session. Write for an agent with zero chat context.

Acknowledge, then start with Task 1 — ROOM_KIT_SPEC.md is the highest-priority deliverable.
