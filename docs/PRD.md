# Slush — Product Requirements (MVP)

> Living document. Pinned to MVP scope; expand as the product evolves.

## Conventions
- Every entry has a stable ID:
  - `US-###` user story — a discrete user action
  - `REQ-###` requirement — system property/constraint, including measurable targets (latency, footprint, etc.)
  - `OUT-###` explicit non-goal
- IDs are append-only and **never reused**. Removed items move to the **Removed / superseded** section at the bottom (not left as tombstones inside their original list).
- Reference IDs from `specs/S###-*.md`, commit messages, and code comments where useful (e.g. `REQ-022: ...`).
- See `AGENTS.md` for the user-story / requirement framework.
- `MET-###` is retired — measurable targets now live inside the relevant `REQ`. Existing `MET` IDs remain as tombstones; see **Removed / superseded** at the bottom.

## Problem
Capture-friction kills brain dumps. Existing task apps demand typing and structuring up front, so half-formed thoughts never make it out of the user's head and into a list they can act on.

## Target user
Individuals who think out loud and want spoken thoughts to land as actionable tasks with zero ceremony — no projects, no fields, no friction.

## Product principles
Slush is **UX-driven**. The product only succeeds if it feels invisible — fast, snappy, out of the way. These principles are load-bearing; subordinate features are negotiable, the feel is not.

- **UX is the primary success criterion.** A feature that works but feels sluggish has failed.
- **Instant feedback.** Every user-visible action must show feedback within ~100 ms (button press, hotkey, partial transcript).
- **Never block the user.** Recording starts immediately on the user gesture; tasks render reactively; LLM extraction runs in the background.
- **Out of the way.** No projects, no fields, no nags — and no spinners that aren't justified by real network/IO.

## User stories
- **US-001** — As a user with a fleeting thought, I want to capture it by speaking instead of typing, so that I don't lose it to friction.
- **US-002** — As a macOS user mid-task in another app, I want to start recording without leaving my current app, so that I never break flow.
- **US-003** — As a user, I want my spoken dump to become discrete, actionable tasks automatically, so that I don't have to structure them myself.
- **US-004** — As a user, I want to come back later, review what was captured, and check tasks off, so that the dump turns into progress.
- **US-006** — As a user with a preferred LLM provider, I want to bring my own provider for task extraction, so that I am not locked in.
- **US-007** — As a user whose extraction just failed, I want to retry it without re-recording, so that I don't lose what I said.

## Core loop
Press → speak → release → tasks appear.

## MVP features

### iOS (iPhone, iOS 26+)
- **REQ-001** — Record screen with a single large record button and a status label (`idle` / `recording` / `transcribing` / `extracting` / `error`); tap to start, tap to stop. *(US-001, US-003)*
- **REQ-002** — Tasks screen listing captured tasks with title and optional one-line detail; swipe or tap to mark complete or delete. *(US-004)*
- **REQ-003** — Settings screen with LLM base URL, API key (masked, stored in Keychain), and model name. *(US-006)*

### macOS (menubar app, macOS 26 Tahoe+)
- **REQ-011** — Menubar icon; click opens a popover containing the record button and the most recent tasks. *(US-001, US-004)*
- **REQ-012** — Global hotkey starts/stops recording without bringing the app forward. Default `⌃⌥Space`, user-configurable in Settings. *(US-002)*
- **REQ-013** — Settings window with the same LLM fields as iOS plus a hotkey recorder. *(US-002, US-006)*

### Shared behavior
- **REQ-021** — On-device transcription; audio never leaves the device. *(REQ-032)*
- **REQ-022** — Task extraction via a single call to a user-configured OpenAI-compatible endpoint. *(US-003, US-006)*
- **REQ-023** — Local persistence of all tasks and transcripts in SQLite. *(REQ-032)*
- **REQ-024** — Offline operation up to the LLM call; LLM failure preserves the transcript so the user can retry. *(US-007)*

### Non-functional (UX, durability, footprint)
- **REQ-031** — UX performance budget. Slush must feel instant:
  - press → mic-active: p95 ≤ 100 ms
  - first partial transcript visible: p95 ≤ 500 ms after speech start
  - end-to-end voice → tasks visible: ≤ 10 s for a typical 20–30 s dump on a recent device
  - tasks list updates: ≤ 50 ms after LLM response (local DB observation)
  - menubar popover open: ≤ 100 ms; hotkey path bypasses popover entirely
  - UI never blocks on I/O; 60 fps sustained while recording

  *(Product principles, US-001, US-002, US-004; supersedes ~~MET-001~~)*
- **REQ-032** — Local-only data. Tasks and transcripts stored on-device in SQLite. No accounts, no cloud sync, no telemetry. The single LLM extraction call is the only required network egress. *(replaces ~~US-005~~, ~~MET-002~~)*
- **REQ-033** — Failure recovery. On LLM failure, the transcript is preserved on disk and extraction is retryable without re-recording. *(US-007; refines REQ-024)*
- **REQ-034** — Zero-friction onboarding. Usable immediately after entering base URL + API key + model — no other setup, no account, no permissions beyond mic/speech. *(supersedes ~~MET-003~~)*

## Out of scope (MVP)
- **OUT-001** — iCloud / CloudKit sync.
- **OUT-002** — Reminders.app integration.
- **OUT-003** — Widgets.
- **OUT-004** — Shortcuts / Siri integration.
- **OUT-005** — Editing existing tasks (only create + complete + delete are supported).
- **OUT-006** — Projects, tags, priorities, due dates.
- **OUT-007** — Multi-device sync.
- **OUT-008** — Accounts, login, server-side anything.

## Removed / superseded
Tombstones for IDs that have been retired. Kept here so references in `specs/` and commits stay resolvable.

- ~~**US-005**~~ — *(was: data on-device with no account/cloud sync)* — promoted to **REQ-032**; was an NFR, not a discrete user action. See `specs/S003`.
- ~~**MET-001**~~ — *(was: voice → tasks ≤ 10 s)* — folded into **REQ-031**. See `specs/S003`.
- ~~**MET-002**~~ — *(was: zero required network calls except the LLM request)* — folded into **REQ-032**. See `specs/S003`.
- ~~**MET-003**~~ — *(was: usable after entering base URL + API key + model)* — promoted to **REQ-034**. See `specs/S003`.
- The `MET-###` family is retired; future measurable targets live inside `REQ`s.
