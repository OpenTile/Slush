# S003 — UX-driven emphasis + simplified PRD structure

## Request
Make it explicit across the docs that Slush is a **UX-driven** project: it must feel fast, snappy, and responsive, and stay out of the user's way. Fast feedback is the whole point. While there, tighten the user-story / requirement split (some existing `US`es read like NFRs) and **simplify the PRD** — for a small project, separate `Requirements` and `Success metrics` sections are over-structured. Cut a new branch (`docs/ux-emphasis`) from the previous docs branch.

## Decisions locked during planning
- UX emphasis lives as a top-level **Product principles** block in the PRD plus a `UX-driven. Snappy. Out of your way.` line in the README. It is not a user story (an NFR is not a discrete user action).
- Performance budget is **one** requirement (`REQ-031`) with a bullet list of measurable targets, not a fan-out of REQs/METs.
- The `MET-###` family is **retired**. Existing `MET-001..003` become tombstones; their substance folds into REQs.
- Authoring framework (`REQ` vs. `US`) is added to `AGENTS.md` so future entries land in the right bucket.
- US-003 stays as a story (user defended it as the core "speak → actionable tasks" promise).

## IDs introduced
- Requirements: **REQ-031** (UX performance budget), **REQ-032** (Local-only data), **REQ-033** (Failure recovery), **REQ-034** (Zero-friction onboarding).

## IDs modified (with explicit user approval)
- **US-002** reworded — drops the "with a global hotkey" mechanism; user value (never break flow) preserved. Mechanism remains in `REQ-012`.
- **US-006** reworded — drops the "OpenAI-compatible endpoint" mechanism; user value (not locked in) preserved. Mechanism remains in `REQ-022`.
- **US-007** reworded — narrows to the user action (retry without re-recording). Durability promoted to `REQ-033`.

## IDs removed / superseded (with explicit user approval)
- ~~**US-005**~~ → **REQ-032** (was an NFR not a discrete user action).
- ~~**MET-001**~~ → folded into **REQ-031**.
- ~~**MET-002**~~ → folded into **REQ-032**.
- ~~**MET-003**~~ → promoted to **REQ-034**.
- `MET-###` family retired going forward.

## Affected files
- `AGENTS.md` — new **Requirements vs. User Stories** section; `MET-###` removed from active types.
- `README.md` — UX-driven tagline; principles bullets for UX-first / out-of-the-way.
- `docs/PRD.md` — Conventions updated; **Product principles** section added; US rewordings + tombstone; new **Non-functional** REQ-031..034; `Success metrics` section removed; **Removed / superseded** section added.
- `docs/ARCHITECTURE.md` — new **UX implications (load-bearing)** section tying architectural choices to `REQ-031` / `REQ-033`.
- `specs/S003-ux-emphasis.md` (this file).

## Status
Docs only; no code yet. UX targets (`REQ-031`) become acceptance bars once implementation lands.
