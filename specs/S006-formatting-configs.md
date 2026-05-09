# S006 — Formatting configs and pre-commit hook

## Request
Add root `.swift-format` and `.editorconfig` files based on the requested upstream configs, align all line-length settings to 100, add a `swift-format` pre-commit hook, and document how to install it.

## Decisions
- `.swift-format` is based on `OpenTile/robe`'s `frontend/.swift-format`, with `lineLength` changed from 90 to 100.
- `.editorconfig` is based on Point-Free's `swift-composable-architecture` config and keeps `max_line_length = 100`.
- `.pre-commit-config.yaml` uses the upstream `swift-format` hook pinned to `602.0.0`, matching the local formatter version used for this change.
- Existing Swift sources are reformatted so the new formatter policy passes immediately.

## IDs introduced
None. This is repository tooling, not product behavior.

## IDs modified
None. No PRD entries change.

## Affected files
- `.swift-format` — new Swift formatter configuration.
- `.editorconfig` — new editor defaults.
- `.pre-commit-config.yaml` — new pre-commit hook configuration.
- `README.md` — new pre-commit installation instructions.
- `App/` and `Packages/` Swift sources — reformatted by `swift-format`.

## Verification
- `swift-format lint --configuration .swift-format --recursive App Packages --strict`
- `pre-commit install`
- `.git/hooks/pre-commit`
- `pre-commit run --all-files`
- `cd Packages/SlushKit && swift test`
- `xcodebuild -project App/Slush.xcodeproj -scheme Slush -destination 'platform=iOS Simulator,name=iPhone 17' test`
- `git diff --check`
