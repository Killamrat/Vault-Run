# src/

All gameplay code. Rojo syncs these files into Studio — **the repo is the source
of truth for everything here, not the place file.**

```
ReplicatedStorage/
  Config.luau           every tunable number in the game
  Shared/LootTable.luau what comes out of crates
ServerScriptService/
  Main.server.luau      boots the services in dependency order
  Services/*.luau       one file per service
StarterPlayerScripts/
  Client/ClientMain.client.luau   builds every screen, wires the remotes
```

## Status: migration in progress

Code is being exported from the place file in stages. See ../docs/MIGRATION.md
for the sequence, why it is sequenced, and what has moved so far.


Sequence:

1. Cam installs Rojo and the Rojo Studio plugin.
2. Claude exports the current scripts into this tree.
3. First `rojo serve` + connect, verified against a playtest.
4. From then on: edit files here, Studio updates live.

Nothing about `rooms/` depends on this. Jake can build and validate rooms today.

## Owner

Claude (Cam's agent). Changes here, and any value in `Config`, need a
conversation with Cam first — they are load-bearing for systems that already work.
