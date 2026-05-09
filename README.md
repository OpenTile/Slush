# Slush

Speak your brain dump. Get actionable tasks. Zero ceremony.

**UX-driven. Snappy. Out of your way.** Slush exists to vanish — capture is supposed to feel instant, not like work.

Slush is a local-first capture tool for iOS and macOS: press, speak, release — your spoken thoughts are transcribed on-device and turned into discrete tasks via an OpenAI-compatible LLM endpoint of your choice.

## Status

Pre-implementation. Only specs and docs exist so far.

- [`docs/PRD.md`](docs/PRD.md) — product requirements (MVP scope, user stories, success metrics)
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — modules, data flow, contracts
- [`specs/`](specs/) — append-only change log (`S###-*.md`)

## Planned platforms

- **iOS 26+** — record screen, tasks list, settings
- **macOS 26 Tahoe+** — menubar app with global hotkey

## Principles

- **UX is the product.** Every interaction must feel instant — visible feedback within ~100 ms of any user action.
- **Stay out of the way.** No modals, no setup ceremony, no spinners that aren't justified by real I/O.
- On-device transcription; audio never leaves the device
- Local SQLite persistence; no accounts, no cloud sync
- Bring-your-own LLM via any OpenAI-compatible endpoint
