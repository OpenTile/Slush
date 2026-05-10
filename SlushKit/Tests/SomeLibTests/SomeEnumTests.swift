// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import Testing
@testable import SomeLib

struct SomeEnumTests {
  @Test
  func moduleExists() {
    _ = SomeEnum.self
  }
}
