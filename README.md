# Slush

Speak your brain dump. Get actionable tasks. Zero ceremony.

**UX-driven. Snappy. Out of your way.** Slush exists to vanish — capture is supposed to feel instant, not like work.

Slush is a local-first capture tool for iOS and macOS: press, speak, release — your spoken thoughts are transcribed on-device and turned into discrete tasks via an OpenAI-compatible LLM endpoint of your choice.

## Status

Skeleton scaffolded; no product code yet. The thin app host and `SlushKit` package build under Swift 6 with the project's concurrency posture in place.

- [`App/Slush.xcodeproj`](App/Slush.xcodeproj/) — single `Slush` app target spanning iOS, iPadOS, and macOS
- [`App/Client`](App/Client/) — temporary thin app entry point, starter view, and resources
- [`App/Tests.xctestplan`](App/Tests.xctestplan) — app-scheme test plan; add every new `SlushKit` test target here
- [`SlushKit/`](SlushKit/) — single Swift package workspace; future modules grow as package targets
- [`DOC/PRD.md`](DOC/PRD.md) — product requirements (MVP scope, user stories, success metrics)
- [`DOC/ARCHITECTURE.md`](DOC/ARCHITECTURE.md) — modules, data flow, contracts, concurrency posture
- [`SPEC/`](SPEC/) — append-only change log (`S###-*.md`)

## Development

Install pre-commit and enable the repository hooks:

```sh
brew install pre-commit
pre-commit install
```

The pre-commit hook runs `swift-format` and may rewrite Swift files. Stage those changes before committing.

## Planned platforms

- **iOS 26+** — record screen, tasks list, settings
- **macOS 26 Tahoe+** — menubar app with global hotkey

## Principles

- **UX is the product.** Every interaction must feel instant — visible feedback within ~100 ms of any user action.
- **Stay out of the way.** No modals, no setup ceremony, no spinners that aren't justified by real I/O.
- On-device transcription; audio never leaves the device
- Local SQLite persistence; no accounts, no cloud sync
- Bring-your-own LLM via any OpenAI-compatible endpoint
