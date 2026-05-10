# S008 — Module growth posture

## Request
Clarify the intended architecture growth path without creating empty modules or moving files yet.
Future app-specific SwiftUI views should live in app targets, while reusable behavior should move
into small feature/domain packages only when real code and import boundaries exist.

## Affected files
- `DOC/ARCHITECTURE.md`
- `SPEC/S008-module-growth-posture.md`

## Relevant IDs
- `US-001`, `US-002`, `US-003`, `US-004`, `US-006`, `US-008`
- `REQ-031`, `REQ-032`

## Notes
- This is an architecture-only clarification. No Swift APIs, package manifests, Xcode targets,
  or filesystem layout change in this spec.
- `S009-app-slushkit-layout` refines this posture after the repo moved to a concrete
  `App/` host plus single `SlushKit/Package.swift` package layout. Future modules are
  package targets inside `SlushKit`, not separate package directories by default.
- `DOC/PRD.md` is unchanged because no user-facing behavior or requirement changed.
- `README.md` is unchanged because the current repo status and entry points did not change.
