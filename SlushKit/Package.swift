// swift-tools-version: 6.0
import PackageDescription

// `GlobalActorIsolatedTypesUsability` is already enabled in Swift 6 mode and is omitted here.
let swiftSettings: [SwiftSetting] = [
  .enableUpcomingFeature("MemberImportVisibility"),
  .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
  .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
  name: "SlushKit",
  platforms: [.iOS("26.4"), .macOS("26.4")],
  products: [
    .library(name: "SomeLib", targets: ["SomeLib"])
  ],
  targets: [
    .target(name: "SomeLib", swiftSettings: swiftSettings),
    .testTarget(name: "SomeLibTests", dependencies: ["SomeLib"], swiftSettings: swiftSettings),
  ],
  swiftLanguageModes: [.v6]
)
