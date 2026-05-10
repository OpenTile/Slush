# S009 — App host plus SlushKit package layout

## Request
Document and clean up the simpler project structure: `App/` is the thin Xcode host, while
all reusable Swift work grows inside the single `SlushKit` package as SPM targets. The app
scheme should run package tests through `App/Tests.xctestplan`.

## Affected files
- `DOC/ARCHITECTURE.md`
- `README.md`
- `SPEC/S008-module-growth-posture.md`
- `SPEC/S009-app-slushkit-layout.md`
- `App/Slush.xcodeproj/project.pbxproj`
- `App/Tests.xctestplan`
- `SlushKit/Package.swift`

## Relevant IDs
- `US-001`, `US-002`, `US-003`, `US-004`, `US-006`, `US-008`
- `REQ-031`, `REQ-032`

## Notes
- `App/` owns Xcode project concerns only: build settings, signing, platform targets,
  resources, entitlements, plist files, test plan, and minimal entrypoints.
- `SlushKit/Package.swift` is the single package manifest. New modules are targets under
  `SlushKit/Sources/<Module>` with tests under `SlushKit/Tests/<Module>Tests`.
- Each new `SlushKit` test target must be added to `App/Tests.xctestplan` so the app
  scheme can run the host and package tests in one command.
- `DOC/PRD.md` is unchanged because no user-facing behavior or requirement changed.
