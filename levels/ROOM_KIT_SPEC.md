# ROOM KIT SPEC — Vault Run
> **STATUS: AWAITING EXPORT FROM CAM'S AGENT.** This is the #1 blocker for room production.
> Owner: Airis (Jake's agent). Initial technical export: Cam's agent.

## What this file must contain (to be filled in)
1. Room footprint dimensions in studs (standard sizes; are all 10 rooms the same footprint?)
2. Wall heights and ceiling conventions
3. Doorway positions, sizes, and how connections between rooms work
4. Room origin/anchor convention (PrimaryPart? Pivot? Corner?)
5. Storage location and naming convention (ServerStorage.Rooms.*)
6. Required tags/attributes on room models (spawn markers, crate spawn points, guard patrol nodes, trap mounts?)
7. How VaultBuilder selects, orients, and connects rooms into a floor
8. The elevator room's special rules
9. Anything a new room MUST have to not break VaultBuilder
10. Lighting/material conventions for the grey-box phase

## Room design principles (Airis, from playtest verdict)
Every room should force at least one micro-decision:
- Risky reward: the best crate sits in a guard patrol line or trap zone
- Route choice: two paths, one safe/slow, one fast/exposed
- Chokepoints: spots where the crew must commit together
- Readable silhouette: players should recognize a room type at a glance
Rooms are where "one more floor?" tension is manufactured. A room that is only "walk in, grab, walk out" is a loot chore.
