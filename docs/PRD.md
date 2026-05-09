# Slush — Product Requirements (MVP)

> Living document. Pinned to MVP scope; expand as the product evolves.

## Conventions
- Every requirement, user story, non-goal, and success metric has a stable ID:
  - `US-###` user story
  - `REQ-###` in-scope requirement
  - `OUT-###` explicit non-goal
  - `MET-###` success metric
- IDs are append-only and **never reused**. A removed item stays in the doc as `~~ID~~ (removed)`.
- Reference IDs from `specs/S###-*.md`, commit messages, and code comments where useful (e.g. `REQ-022: ...`).

## Problem
Capture-friction kills brain dumps. Existing task apps demand typing and structuring up front, so half-formed thoughts never make it out of the user's head and into a list they can act on.

## Target user
Individuals who think out loud and want spoken thoughts to land as actionable tasks with zero ceremony — no projects, no fields, no friction.

## User stories
- **US-001** — As a user with a fleeting thought, I want to capture it by speaking instead of typing, so that I don't lose it to friction.
- **US-002** — As a macOS user mid-task in another app, I want to trigger recording with a global hotkey, so that I never break flow to open Slush.
- **US-003** — As a user, I want my spoken dump to become discrete, actionable tasks automatically, so that I don't have to structure them myself.
- **US-004** — As a user, I want to come back later, review what was captured, and check tasks off, so that the dump turns into progress.
- **US-005** — As a privacy-conscious user, I want my data to live on-device with no account or cloud sync, so that I retain control.
- **US-006** — As a user with a preferred LLM provider, I want to point Slush at any OpenAI-compatible endpoint (cloud or local), so that I am not locked in.
- **US-007** — As a user whose LLM call just failed, I want my transcript preserved and the extraction retryable, so that I don't lose what I said.

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
- **REQ-021** — On-device transcription; audio never leaves the device. *(US-005)*
- **REQ-022** — Task extraction via a single call to a user-configured OpenAI-compatible endpoint. *(US-003, US-006)*
- **REQ-023** — Local persistence of all tasks and transcripts in SQLite. *(US-005)*
- **REQ-024** — Offline operation up to the LLM call; LLM failure preserves the transcript so the user can retry. *(US-007)*

## Out of scope (MVP)
- **OUT-001** — iCloud / CloudKit sync.
- **OUT-002** — Reminders.app integration.
- **OUT-003** — Widgets.
- **OUT-004** — Shortcuts / Siri integration.
- **OUT-005** — Editing existing tasks (only create + complete + delete are supported).
- **OUT-006** — Projects, tags, priorities, due dates.
- **OUT-007** — Multi-device sync.
- **OUT-008** — Accounts, login, server-side anything.

## Success metrics
- **MET-001** — Latency: voice → tasks visible in under 10 s on a recent device for a typical 20–30 s dump.
- **MET-002** — Network footprint: zero required network calls except the single LLM request.
- **MET-003** — Onboarding: usable after entering base URL + API key + model — no other setup.
