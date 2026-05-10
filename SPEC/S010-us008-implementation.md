# S010 — US-008 typed thought capture implementation

## Request
Implement US-008 as a first typed-capture slice: the user can type a thought, submit it, and see it persist in a local list. Keep this slice focused on thoughts only: no audio, no LLM extraction, no task list, no transcript sentinel fields.

## Original plan
# Plan: AGENTS.md process upgrade + US-008 typed thought capture

## Context

Two bundled deliverables:

**A — Process meta-change**  
Expand SPEC file format and add YAGNI principle to AGENTS.md, so any future agent has:
- A richer SPEC as handoff document (original plan, implementation decisions, affected stories with statuses)
- A standing rule to design for current story needs, not hypothetical future ones

**B — US-008 implementation**  
First implementation slice: user types text → saves → sees persistent list of thoughts.  
No audio, no LLM extraction, no tasks list.  
`Thought` model (not `Transcript`), `thoughts` table (not `transcripts`), no sentinel fields.  
Per S009: one `AppFeature` target replaces the `SomeLib` placeholder.

Sequence: (A) lands as its own commit, then (B).

---

## Phase 1 — Update AGENTS.md

**File:** `AGENTS.md` (CLAUDE.md is a symlink to it — one edit covers both)

### 1a. New SPEC format rule (replaces the existing single-bullet SPEC instruction)

Replace:
> Track every change in `SPEC/` as `S###-*.md` (sequential, append-only). New change → new file; small follow-up → update its file. Include the request (paraphrased), affected files, and relevant `REQ-###` / `US-###` IDs. Keep concise.

With:
```
- Track every change in `SPEC/` as `S###-*.md` (sequential, append-only). New change → new file;
  small follow-up → update its file.

  Required sections (in order):
  1. `## Request` — what was asked, paraphrased.
  2. `## Original plan` — **IMMUTABLE after creation.** Full plan as written during plan mode.
     Set once, never edited — this is the handoff anchor for future agents.
  3. `## Implementation decisions` — design choices, rejected alternatives, surprises encountered;
     fill incrementally during implementation.
  4. `## Affected stories` — each touched ID with a status: `implemented`, `modified`, or `deferred`.
     Example: `- US-008: implemented`, `- US-003: deferred (no LLM in this slice)`.
  5. `## Affected files` — list of files changed.

  **When to create:** during plan mode, before implementation begins.
  Write `## Request` and `## Original plan` (verbatim from the plan file) at creation time.
  Fill the remaining sections during and after implementation.

  Reference IDs in spec files and commit messages.
```

### 1b. YAGNI principle (new section in AGENTS.md)

Add a new `## Design principles` section (or append to an existing principles section if one exists):

```markdown
## Design principles

- **Design for now, not for later.** Implement only what the current story requires.
  Schema fields, sentinel values, or abstractions that exist solely for a future story should
  wait until that story is implemented. Planned-but-unimplemented entries in `DOC/` are ideas,
  not implementation contracts.
```

---

## Phase 2 — Create S010 in new format

**New file:** `SPEC/S010-us008-implementation.md`

Create during plan mode (right after AGENTS.md is updated) with:
- `## Request` — implementing US-008: typed thought capture with persistence
- `## Original plan` — verbatim copy of the plan in `~/.claude/plans/linked-petting-sutton.md` (the full plan text, embedded once, never edited)
- `## Implementation decisions` — empty placeholder; agent fills during implementation
- `## Affected stories`:
  - US-008: implemented
  - REQ-025: implemented
  - US-003: deferred (no LLM in this slice)
- `## Affected files` — placeholder; fill after implementation

---

## Phase 3 — US-008 implementation

### 3a. Package.swift

**File:** `SlushKit/Package.swift`

- Add dependencies: TCA (`https://github.com/pointfreeco/swift-composable-architecture`) and SQLiteData (verify URL + version 1.6.1 with `pfw-sqlite-data` skill before writing)
- Remove `SomeLib` product, target, and source files (`Sources/SomeLib/SomeEnum.swift`)
- Remove `SomeLibTests` target and test files (`Tests/SomeLibTests/SomeEnumTests.swift`)
- Add `AppFeature` library product and target, linking TCA + SQLiteData
- Add `AppFeatureTests` test target linking `AppFeature`

### 3b. Thought model

**New file:** `SlushKit/Sources/AppFeature/Thought.swift`

- `struct Thought` conforming to SQLiteData's `Table`
- Columns: `id: UUID`, `text: String`, `createdAt: Date`
- Table name: `thoughts`
- Static `all` query: ordered by `created_at DESC`

### 3c. AppFeature TCA reducer

**New file:** `SlushKit/Sources/AppFeature/AppFeature.swift`

- `@DependencyClient` `DatabaseClient` for writes (`insert(_: Thought)`)
- `@FetchAll(Thought.all)` in `State` for live read observation
- State: `thoughts` (via `@FetchAll`), `inputText: String`
- Actions: `inputChanged(String)`, `submitTapped`
- `submitTapped`: guard non-empty input → insert `Thought` → clear `inputText`

### 3d. ThoughtsView SwiftUI

**New file:** `SlushKit/Sources/AppFeature/ThoughtsView.swift`

- `Store<AppFeature>` as input
- `TextField` bound to `inputText` with `.onSubmit` sending `.submitTapped`
- `List` of `store.thoughts` showing `text` and `createdAt`
- `#Preview` with in-memory database via `.dependencies { ... }`

### 3e. App host wiring

**Modified files:**
- `App/Client/SlushApp.swift`: replace `import SomeLib` → `import AppFeature`; init `Store`, pass to `ThoughtsView`
- `App/Client/ContentView.swift`: remove (use `ThoughtsView` directly in `SlushApp`)
- `App/Slush.xcodeproj/project.pbxproj`: update linked framework `SomeLib` → `AppFeature`

### 3f. Tests

**New file:** `SlushKit/Tests/AppFeatureTests/AppFeatureTests.swift`

Using TCA `TestStore` + in-memory SQLiteData database:
- `submitTapped` with non-empty text → thought inserted, `inputText` cleared
- `submitTapped` with empty text → no-op
- `inputChanged` → updates `inputText`

---

## Phase 4 — Post-implementation

- Fill `## Implementation decisions` and `## Affected files` in S010
- After implementation, update `ARCHITECTURE.md` schema to reflect `thoughts` table (supersedes planned `transcripts` schema). **Requires explicit user confirmation before editing** (per CLAUDE.md changed-behavior rule). Surface during implementation.
- Remove the memory file `/Users/andrei/.claude/projects/-Users-andrei-Developer-ai-first-Slush/memory/feedback_yagni_design.md` and its pointer in `/Users/andrei/.claude/projects/-Users-andrei-Developer-ai-first-Slush/memory/MEMORY.md` once the YAGNI rule lives in AGENTS.md (avoids two sources of truth)
  > Note: both files are in Claude Code's private per-project memory directory (outside the git repo)

---

## Verification

1. Build succeeds with no Swift 6 concurrency warnings
2. `AppFeatureTests` pass
3. App launches on iOS Simulator: type a thought, submit, appears in list
4. Kill and relaunch — thought persists
5. Empty submit does nothing

## Implementation decisions
- The implemented slice follows the corrected plan: `AppFeature` owns typed input and submit intent, while SQLiteData observation lives in `ThoughtsView` through `@FetchAll(Thought.all)`.
- `SomeLib`/`SomeLibTests` were removed and replaced with a single `AppFeature` package product, target, and test target.
- Persistence is bootstrapped by `DependencyValues.bootstrapDatabase(path:)`, which installs a `thoughts` migration before the app renders.
- `Thought.createdAt` is stored as `Date.UnixTimeRepresentation` in the `created_at` column, and `Thought.all` returns rows newest-first.
- Writes go through a narrow `DatabaseClient` dependency so reducer tests can record inserts without opening SQLite; the persistence test explicitly opts into the live SQLite insert behavior.
- `SlushApp` calls `prepareDependencies { try! $0.bootstrapDatabase() }` and displays `ThoughtsView` directly.
- `DOC/ARCHITECTURE.md` was updated under the user's explicit implementation request to describe the current `thoughts` slice and keep transcript/LLM/task behavior deferred.
- `DOC/PRD.md` stayed unchanged because `US-008` and `REQ-025` already cover the slice; full LLM extraction remains deferred.
- Xcode required local macro trust entries for `swift-structured-queries` at revision `8da8818fccd9959bd683934ddc62cf45bb65b3c8`; the exact Xcode test command passes after adding those entries to the local SwiftPM security file.
- Follow-up: compacted the `AGENTS.md` SPEC and YAGNI wording without changing the operating rules, so the agent instructions stay short.
- Follow-up: moved the voice-dictation prompt note out of repo `AGENTS.md` and into `/Users/andrei/.config/agents/AGENTS.md`, because it is user-specific rather than project-wide.
- Follow-up: added an `AGENTS.md` rule to keep agent instructions compact and move detailed rationale/history into `SPEC/` or `DOC/`.
- No staging, commits, or PR text were created.

## Affected stories
- US-008: implemented
- REQ-025: implemented for typed thought persistence only; LLM extraction remains deferred.
- US-003: deferred (no LLM in this slice).

## Affected files
- `AGENTS.md`
- `App/Client/ContentView.swift` (removed)
- `App/Client/SlushApp.swift`
- `App/Slush.xcodeproj/project.pbxproj`
- `App/Slush.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
- `App/Tests.xctestplan`
- `DOC/ARCHITECTURE.md`
- `README.md`
- `SlushKit/Package.resolved`
- `SlushKit/Package.swift`
- `SlushKit/Sources/AppFeature/AppFeature.swift`
- `SlushKit/Sources/AppFeature/DatabaseClient.swift`
- `SlushKit/Sources/AppFeature/Schema.swift`
- `SlushKit/Sources/AppFeature/Thought.swift`
- `SlushKit/Sources/AppFeature/ThoughtsView.swift`
- `SlushKit/Sources/SomeLib/SomeEnum.swift` (removed)
- `SlushKit/Tests/AppFeatureTests/AppFeatureTests.swift`
- `SlushKit/Tests/SomeLibTests/SomeEnumTests.swift` (removed)
- `/Users/andrei/.claude/projects/-Users-andrei-Developer-ai-first-Slush/memory/MEMORY.md`
- `/Users/andrei/.claude/projects/-Users-andrei-Developer-ai-first-Slush/memory/feedback_yagni_design.md` (removed)
- `/Users/andrei/.config/agents/AGENTS.md`
- `/Users/andrei/Library/org.swift.swiftpm/security/macros.json`
