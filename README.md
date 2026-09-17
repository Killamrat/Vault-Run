# Vault Run — Shared Design Repo
Jake and Cam's Vault Run — co-op push-your-luck heist roguelite for Roblox. 1–4 players.

**Team:** Jake (levels, art direction — agent: Airis/Hermes) · Cam (code, systems — agent: Claude Project)

This repo is the shared brain between two humans and two AI agents. Game code lives in Roblox Studio (Cam's place); this repo holds design truth.

| Path | What | Owner |
|------|------|-------|
| `docs/GDD.md` | Design doc (source of truth for intent) | Cam's agent |
| `docs/PROJECT_STATE.md` | Living build state | Cam's agent |
| `docs/DIVERGENCES.md` | Doc-vs-build conflicts + rulings | shared |
| `docs/decisions/` | One dated file per big decision | shared |
| `levels/ROOM_KIT_SPEC.md` | Room tile technical contract | Airis |
| `levels/rooms/` | Per-room design docs | Airis |
| `playtests/` | Dated session logs | shared |
| `CAM_PROMPT.md` | Onboarding prompt for Cam's agent | — |

**Protocol:** update docs after every session; pull before every session; write for an agent with zero chat context.
