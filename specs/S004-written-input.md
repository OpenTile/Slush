# S004 — Written brain-dump as alternative input path

## Request
The product idea is **brain dump → tasks**, medium-agnostic. The MVP's *core loop* stays voice-iconic (`Press → speak → release → tasks appear`), but typed input should be a first-class alternative capture path. Likely the cheapest first slice to actually implement, since it skips the mic / permissions / `SpeechAnalyzer` / `AVAudioEngine` stack and exercises the LLM extraction → repository → tasks-list pipeline end-to-end.

## Decisions locked during planning
- US-003 reworded to drop "spoken" — the medium isn't part of the story.
- Typed input lives as one shared requirement (REQ-025), not platform-specific REQs. iOS and macOS surfaces inherit it via existing REQ-001 / REQ-011.
- Typed input rejoins the existing pipeline at the LLM extraction step. No new schema, no new client, no new repository. `Transcript` row uses `duration_seconds = 0` as a sentinel for "typed, not recorded".
- **Core loop stays voice.** Typed input is documented as an alternative, not part of the iconic interaction.
- LLM extraction prompt currently says "spoken brain dump"; left as-is for now — wording-level tweak deferred to implementation.

## IDs introduced
- User stories: **US-008** (type a brain dump).
- Requirements: **REQ-025** (text input as first-class alternative to speech).

## IDs modified (with explicit user approval)
- **US-003** reworded — "spoken dump" → "brain dump". Story is medium-agnostic; mechanism remains in REQ-022 / REQ-025.

## Affected files
- `docs/PRD.md` — US-003 reworded; US-008 appended; REQ-025 appended under Shared behavior.
- `docs/ARCHITECTURE.md` — mermaid diagram gains a Text input node feeding `RecordFeature`; Data flow gets a typed-input path note; `RecordFeature` responsibility broadened; UX implications gain a typed-path bullet; Verification gains a typed-input smoke.
- `specs/S004-written-input.md` (this file).

## Status
Docs only; implementation has not started. Typed input is the recommended first implementation slice once code work begins (delivers a working end-to-end pipeline without mic/transcription dependencies).
