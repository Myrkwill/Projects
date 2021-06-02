import SwiftUI

struct TabContainerView: View {
    
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        TabView(selection: $tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        Text(viewModel.title)
                    }
                    .tag(viewModel.type)
            }
        }
        .accentColor(.primary)
    }
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("log")
        case .challengeList:
            NavigationView {
                ChallengeListView()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        case .settings:
            NavigationView {
                SettingsView()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
        }
    }
    
}

final class TabContainerViewModel: ObservableObject {
    
    @Published var selectedTab: TabItemViewModel.TabItemType = .challengeList
    
    let tabItemViewModels = [
        TabItemViewModel(imageName: "book", title: "Activity Log", type: .log),
        .init(imageName: "list.bullet", title: "Challenges", type: .challengeList),
        .init(imageName: "gear", title: "Settings", type: .settings)
    ]
    
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case challengeList
        case settings
    }
    
}
