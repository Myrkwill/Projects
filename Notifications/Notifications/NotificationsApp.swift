import SwiftUI

@main
struct NotificationsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                NotificationListView()
                    .accentColor(.primary)
            }
        }
    }
}
