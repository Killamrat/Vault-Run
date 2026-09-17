# Workflow

Two people and two agents working on one Roblox game, asynchronously.

## The split

| Path | Owner | Sign-off needed? |
| --- | --- | --- |
| `rooms/`, art assets | Jake + Airis | No — anything that passes validation |
| `src/`, `tools/`, `docs/ARCHITECTURE.md` | Claude | Raise it with Cam |
| `Config` values, prices, scope | Cam | Cam decides |

Drawn so nobody edits the same file as anybody else.

## Branches

`main` is what the published game is built from. Keep it working.

For anything bigger than a single room, branch:

```
room/vent-crawl
feat/practice-vault
fix/guard-pathing
```

Single rooms that pass validation can go straight to `main`.

## Commits

Prefix by area, then say what actually changed:

```
room: add Vent Crawl (52 long, 5 crates, vertical)
room: fix Catwalk exit blocked by railing
feat: practice vault onboarding run
fix: guard falls through floor when ragdolled
docs: update room spec for terminal rooms
```

The three facts that matter for a room are length, crate count, and what makes
it different. Put them in the message so a review does not need the file open.

## Before you commit a room

```lua
require(game.ServerStorage.ValidateRooms).Run()
```

Errors block a merge. Warnings are judgement calls.

## Rojo

Code lives here as text and syncs into Studio. The Studio place is **not** the
source of truth for anything under `src/` — the repo is.

```
rojo serve
```

then connect from the Rojo plugin in Studio.

Rojo manages only the paths named in `default.project.json`. It does not touch
Workspace, the Hub, or anything else in the place. That is deliberate: a Rojo
sync that owned a whole service could delete hand-built content.

## Publishing

Cam publishes. Alt+P in Studio. Nothing reaches players until he does.

## When the spec and the code disagree

The code is what players get, so the code wins and the spec gets fixed. Say
something rather than building against a document that has drifted — that is the
main failure mode of working this way.
