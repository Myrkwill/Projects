import SwiftUI
import Firebase

@main
struct IncrementApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabContainerView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                LandingView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       FirebaseApp.configure()
       return true
     }
    
}

class AppState: ObservableObject {
    
    @Published private(set) var isLoggedIn = false
    
    private var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        userService
            .observeAuthChanges()
            .map { $0 != nil }
            .assign(to: &self.$isLoggedIn)
    }
    
}
