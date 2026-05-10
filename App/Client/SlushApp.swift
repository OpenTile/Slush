// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import AppFeature
import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct SlushApp: App {
  private let store: StoreOf<AppFeature>

  init() {
    prepareDependencies {
      try! $0.bootstrapDatabase()
    }
    store = Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  }

  var body: some Scene {
    WindowGroup {
      ThoughtsView(store: store)
    }
  }
}
