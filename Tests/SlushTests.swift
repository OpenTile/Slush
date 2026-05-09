// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import Testing
@testable import Slush

struct SlushTests {
  @MainActor
  @Test
  func contentViewCanBeInstantiated() {
    let view = ContentView()

    #expect(String(describing: type(of: view)) == "ContentView")
  }
}
