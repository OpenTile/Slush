- Track every change in `SPEC/` as `S###-*.md` (sequential, append-only). New change → new file; small follow-up → update its file. Include the request (paraphrased), affected files, and relevant `REQ-###` / `US-###` IDs. Keep concise.
- Keep `DOC/` in sync with every change:
	- New behavior → append a new `US-###` / `REQ-###` / `OUT-###` to `DOC/PRD.md`; update `DOC/ARCHITECTURE.md` if modules, data flow, schema, or external contracts change. (`MET-###` is retired — measurable targets live inside `REQ`s.)
	- Changed behavior → propose the edit and **ask for explicit user confirmation** before mutating an existing entry.
	- IDs are append-only and never reused. Removed items are **moved** to the **Removed / superseded** section at the bottom of `DOC/PRD.md` (not left tombstoned in their original list), with a note in the relevant spec.
	- Reference IDs in spec files and commit messages.
- Keep `README.md` in sync: update it when status, platforms, principles, or top-level entry points change. Keep it concise — it's a landing page, not a duplicate of `DOC/`.

## Requirements vs. User Stories

- **Requirement** (`REQ-###`): a system property or constraint — architectural, NFR, measurable target. Global scope, not estimated. Example: "All data stored locally; no cloud sync."
- **User Story** (`US-###`): a discrete user action — something the user does in the product. Sprintable, estimable. Example: "User can capture a thought by speaking."
- **Relationship**: requirements are constraints; stories are work items. One requirement can gate many stories.
- When in doubt: if there's no visible user action, it's a `REQ`, not a `US`.
- Measurable targets (latency, throughput, footprint) live **inside the relevant `REQ`**, not in a separate metrics section. Slush is small — one section is enough.
