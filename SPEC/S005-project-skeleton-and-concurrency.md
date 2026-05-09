# S005 — Project skeleton, concurrency posture, and first SPM module

## Request
"Check new project setup, propose changes. Bootstrap first kit module. Rename `Slush/` → `App/`. Document the project + module creation. Document settings for future modules so they all mirror them."

## Project bootstrap (recorded after the fact)
The user created the Xcode project manually before this spec. Captured here so the bootstrap is part of the spec log:

- **Toolchain:** Xcode 26.4.1, SwiftUI app template.
- **Deployment targets:** iOS 26.4, macOS 26.4 (`IPHONEOS_DEPLOYMENT_TARGET` / `MACOSX_DEPLOYMENT_TARGET = 26.4`, `XROS_DEPLOYMENT_TARGET = 26.4`).
- **Targets:** single `Slush` app target spanning iPhone + iPad + Mac (`SUPPORTED_PLATFORMS = "iphoneos iphonesimulator macosx"`, `TARGETED_DEVICE_FAMILY = "1,2"`, `SUPPORTS_MACCATALYST = NO`); plus `SlushTests` (Swift Testing). The Xcode-template-generated `SlushUITests` target is removed in this change — UI testing will be reintroduced when a feature actually needs it.
- **Sandbox / signing:** `ENABLE_APP_SANDBOX = YES`, `ENABLE_HARDENED_RUNTIME = YES`, `REGISTER_APP_GROUPS = YES`, `ENABLE_USER_SELECTED_FILES = readonly`, `ENABLE_USER_SCRIPT_SANDBOXING = YES`, automatic code signing, dev team `UM3QPHF8E3`, bundle id `me.chenchik.Slush`.
- **Source organization:** `PBXFileSystemSynchronizedRootGroup` for app and test sources — files added under `App/Slush/`, `App/SlushTests/`, `App/SlushUITests/` are picked up by the target automatically; no manual project-file edits needed for new sources.

## Decisions locked during planning
1. **Repo layout:** rename `Slush/` → `App/`; future Swift packages live under `Packages/`.
2. **Swift 6 language mode** project-wide. (No `6.2` *language* mode exists; the Xcode 26 compiler is version 6.2 with language mode `6`.)
3. **Lift concurrency-relevant build settings to the project level** of the Xcode project, removing the redundant per-target copies. Future targets inherit by default.
4. **Drop `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`.** TCA's `@Reducer` / `@ObservableState` macros break under default-MainActor isolation, and the maintainer recommends against the setting ([pointfreeco/swift-composable-architecture#3808](https://github.com/pointfreeco/swift-composable-architecture/issues/3808)). The "main actor only formats view state, infra is non-main" requirement (`REQ-031`) is met via TCA conventions, not project-wide default isolation.
5. **Tests stay nonisolated by default.** Opt in to `@MainActor` per `@Test` when needed.
6. **Bootstrap `Packages/SlushKit/`** as the first Swift package; link it into the Slush app target; codify the chosen settings in `docs/ARCHITECTURE.md` so future modules mirror them.

## Final concurrency posture (canonical)

| Setting | Xcode key | SPM equivalent in `swiftSettings` |
|---|---|---|
| Swift 6 mode | `SWIFT_VERSION = 6.0` | `// swift-tools-version: 6.0` + `swiftLanguageModes: [.v6]` |
| Approachable Concurrency | `SWIFT_APPROACHABLE_CONCURRENCY = YES` | `.enableUpcomingFeature("NonisolatedNonsendingByDefault")` + `.enableUpcomingFeature("InferIsolatedConformances")` |
| Member-import visibility | `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES` | `.enableUpcomingFeature("MemberImportVisibility")` |
| Default isolation | **unset** (intentionally — TCA) | omit `.defaultIsolation(...)` |

`GlobalActorIsolatedTypesUsability` (SE-0434) is part of "Approachable Concurrency" but is already enabled by default in Swift 6 mode — listing it in SPM `swiftSettings` triggers a compiler warning, so it is intentionally omitted there. Strict concurrency at level `complete` is implicit under Swift 6.

## IDs introduced
None. This is implementation posture under existing `REQ-031` (60 fps recording / non-main infra).

## IDs modified
None. No PRD entries change.

## Affected files
- `Slush/` → `App/` — directory rename via `git mv`.
- `App/Slush.xcodeproj/project.pbxproj` — concurrency knobs lifted to project level; `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` removed; redundant per-target copies deleted; `XCLocalSwiftPackageReference` + `XCSwiftPackageProductDependency` + `PBXBuildFile` added to link `Packages/SlushKit`; `SlushUITests` target and its references removed.
- `App/SlushUITests/` — directory and template files deleted.
- `Packages/SlushKit/Package.swift` — new, canonical shape for future packages.
- `Packages/SlushKit/Sources/SlushKit/SlushKit.swift` — new, placeholder `enum SlushKit` with `static let identifier` (referenced by the app so the linker keeps the dependency).
- `Packages/SlushKit/Tests/SlushKitTests/SlushKitTests.swift` — new, Swift Testing stub.
- `App/Slush/SlushApp.swift` — `import SlushKit` + `init { _ = SlushKit.identifier }` to verify linkage.
- `docs/ARCHITECTURE.md` — new "Concurrency & module posture" section; new "Repo layout (today)" subsection under "Module breakdown".

## Verification
- `xcodebuild -project App/Slush.xcodeproj -scheme Slush -destination 'platform=iOS Simulator,name=iPhone 17' build` → BUILD SUCCEEDED with `import SlushKit` resolved.
- `cd Packages/SlushKit && swift test` → 1 test passes.
- `xcodebuild -showBuildSettings` confirms the three concurrency knobs come from project-level configs and `SWIFT_DEFAULT_ACTOR_ISOLATION` is unset on every target.

## Open follow-ups
- When `MenuBarExtra` / `GlobalHotkeyService` work begins, split the combined `Slush` target into `SlushiOS` + `SlushMac` (already described in `docs/ARCHITECTURE.md`).
- The placeholder `enum SlushKit { static let identifier }` is replaced with the first real type (likely a domain model or protocol) when implementation starts.

## Status
Docs and skeleton only; no product code yet. Pipeline ready for the first US implementation.
