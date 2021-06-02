import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    @Published var loginSignupPushed = false
    let title = "Settings"
    
    private var cancellables: [AnyCancellable] = []
    private var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tappedItem(at index: Int) {
        switch itemViewModels[index].type {
        case .account:
            guard userService.currentUser?.email == nil else { return }
            loginSignupPushed = true
        case .mode:
            isDarkMode = !isDarkMode
            buildItems()
        case .logout:
            logout()
        case .privacy:
            print("privacy")
        }
    }
    
    private func logout() {
        userService.logout().sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case let .failure(error):
                print(error.localizedDescription)
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)

    }
    
    private func buildItems() {
        itemViewModels = [
            .init(title: userService.currentUser?.email ?? "Create account", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Light" : "Dark") Mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy)
        ]
        
        if userService.currentUser?.email != nil {
            itemViewModels.append(.init(title: "Logout", iconName: "arrowshape.turn.up.left", type: .logout))
        }
    }
    
    func onAppear() {
        buildItems()
    }
    
}
