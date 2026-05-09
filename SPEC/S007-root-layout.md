# S007 — Root layout documentation sync

## Request
Check the files after the root layout move, make the new structure canonical, and update the current docs accordingly while preserving older specs as historical records.

## Decisions
- `Slush.xcodeproj`, `Sources/`, `Tests/`, `SlushKit/`, `DOC/`, and `SPEC/` are the canonical top-level structure.
- Historical specs `S001` through `S006` are not rewritten just to replace old path references.
- This is repository structure and documentation work only; it introduces no product behavior or public API changes.

## IDs introduced
None. This is repository structure and documentation work, not product behavior.

## IDs modified
None. No PRD entries change.

## Affected files
- `Slush.xcodeproj/project.pbxproj` — local `SlushKit` package reference updated for the root project location.
- `.gitignore` — removed obsolete `Packages/*` SPM cache ignores now covered by root cache rules.
- `README.md` — root layout and current doc/spec links updated.
- `AGENTS.md` — doc-sync instructions updated to `DOC/` and `SPEC/`.
- `DOC/PRD.md` — current spec cross-references updated to `SPEC/`.
- `DOC/ARCHITECTURE.md` — repo layout, synchronized groups, package location, and skeleton verification commands updated.
- `Tests/SlushTests.swift` — placeholder test replaced with an app module smoke test.
- `SPEC/S007-root-layout.md` — this file.

## Verification
- `cd SlushKit && swift package clean`
- `cd SlushKit && swift test`
- `swift-format lint --configuration .swift-format --recursive Sources Tests SlushKit/Sources SlushKit/Tests --strict`
- `xcodebuild -project Slush.xcodeproj -scheme Slush -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.4.1' test`
- `rg 'App/|Packages/SlushKit|docs/|specs/' README.md AGENTS.md DOC`
- `git status --short --untracked-files=all`
