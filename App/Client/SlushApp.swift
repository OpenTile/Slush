// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import SomeLib
import SwiftUI

@main
struct SlushApp: App {
  init() {
    _ = SomeEnum.identifier
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
