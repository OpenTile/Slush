# S001 — Initial PRD, Architecture docs, and docs-sync rule

## Request
Seed the repo with two foundational living documents for the Slush MVP — a concise PRD and a technical architecture overview — and establish how docs stay in sync going forward. Slush is a brain-dump capture tool: global hotkey on macOS / button tap on iOS → record audio → on-device transcription → LLM extracts tasks → tasks land in a local list. The PRD must use stable IDs (so requirements can be referenced from specs, commits, and code) and include user stories. `CLAUDE.md` must require that any future change keeps `docs/` updated, with explicit user confirmation before mutating existing entries.

## Decisions locked during planning
- **Speech**: Apple `SpeechAnalyzer` / `SpeechTranscriber` (iOS/macOS 26+, on-device).
- **LLM output**: structured JSON via OpenAI `response_format: json_schema`, falling back to `json_object`. Schema = `{ tasks: [{ title, detail? }] }`.
- **Schema**: `tasks(id, title, detail?, created_at, completed_at?, source_transcript_id)` + `transcripts(id, text, created_at, duration_seconds)`.
- **macOS hotkey**: default `⌃⌥Space`, user-configurable in Settings.
- **Stack**: TCA throughout, SQLiteData 1.6.1, Keychain for API key, no backend, no sync.
- **PRD ID scheme**: `US-###` (user stories), `REQ-###` (in-scope requirements), `OUT-###` (non-goals), `MET-###` (success metrics). Append-only; never reused; removed items marked `~~ID~~ (removed)`.

## IDs introduced
- User stories: US-001 .. US-007.
- Requirements: REQ-001..003 (iOS), REQ-011..013 (macOS), REQ-021..024 (shared).
- Non-goals: OUT-001..008.
- Success metrics: MET-001..003.

## Affected files
- `docs/PRD.md` (new) — Conventions, user stories, IDs on every entry.
- `docs/ARCHITECTURE.md` (new) — module layout, TCA reducers, data flow, LLM contract, SQLite schema.
- `CLAUDE.md` — appended docs-sync rule (append new IDs, confirm before edits, tombstone-not-reuse, reference IDs in specs/commits).
- `specs/S001-initial-docs.md` (this file).

## Status
Initial drafts written; docs-sync rule in place. Open questions captured at the bottom of `ARCHITECTURE.md` (partial-transcript display, recording length cap, default model). Implementation has not started.
