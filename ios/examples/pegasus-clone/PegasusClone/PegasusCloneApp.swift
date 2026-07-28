import SwiftUI

@main
struct PegasusCloneApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            BadRootView()
                .environmentObject(state)
        }
    }
}
