import SwiftUI

@main
struct extra_cso_iosApp: App {
    @UIApplicationDelegateAdaptor(FAppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
