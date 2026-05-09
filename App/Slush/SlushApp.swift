// © 2026 Andrei Chenchik. All rights reserved.
// Unauthorized using, copying, distribution, or modification prohibited.

import SlushKit
import SwiftUI

@main
struct SlushApp: App {
    init() {
        _ = SlushKit.identifier
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
