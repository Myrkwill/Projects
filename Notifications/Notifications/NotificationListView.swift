import SwiftUI

struct NotificationListView: View {
    
    @StateObject private var notificationManager = NotificationManager()
    @State private var isCreatePresented = false
    
    private static var notificationDateFormatter: DateFormatter  = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    private func timeDisplayText(from notification: UNNotificationRequest) -> String {
        guard let nextTrigger = notification.trigger as? UNCalendarNotificationTrigger,
              let nextTriggerDate = nextTrigger.nextTriggerDate()
        else { return "" }
        
        return Self.notificationDateFormatter.string(from: nextTriggerDate)
    }
    
    @ViewBuilder
    var infoOverlayView: some View {
        switch notificationManager.authorizationStatus {
        case .authorized where notificationManager.notifications.isEmpty:
            InfoOverlayView(
                infoMessage: "No notifications yet",
                buttonTitle: "Create",
                systemImageName: "plus.circle",
                action: { isCreatePresented = true }
            )
        case .denied:
            InfoOverlayView(
                infoMessage: "Please enable notification permission in settings",
                buttonTitle: "Settings",
                systemImageName: "gear",
                action: {
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:] , completionHandler: nil)
                    }
                }
            )
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        List {
            ForEach(notificationManager.notifications, id: \.identifier) { notification in
                HStack {
                    Text(notification.content.title)
                        .fontWeight(.semibold)
                    Text(timeDisplayText(from: notification))
                        .fontWeight(.bold)
                    Spacer()
                }
                
            }
            .onDelete(perform: delete)
        }
        .listStyle(InsetGroupedListStyle())
        .overlay(infoOverlayView)
        .navigationTitle("Notifications")
        .onAppear(perform: notificationManager.reloadAuthorizationStatus)
        .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
            switch authorizationStatus {
            case .notDetermined:
                notificationManager.requestAuthorization()
            case .authorized:
                notificationManager.reloadLocalNotifications()
            default:
                break
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            notificationManager.reloadAuthorizationStatus()
        }
        .navigationBarItems(trailing: Button {
            isCreatePresented = true
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        })
        .sheet(isPresented: $isCreatePresented) {
            NavigationView {
                CreateNotificationView(
                    notificationManager: notificationManager,
                    isPresented: $isCreatePresented
                )
            }
            .accentColor(.primary)
            
        }
    }
    
}

extension NotificationListView {
    
    func delete( _ indexSet: IndexSet) {
        let identifiers = indexSet.map { notificationManager.notifications[$0].identifier }
        notificationManager.deleteLocalNotifications(identifiers: identifiers)
        notificationManager.reloadLocalNotifications()
    }
    
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}
