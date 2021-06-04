import SwiftUI

struct AppHomeView: View {
    
    @EnvironmentObject var viewModel: AppLockViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $viewModel.isAppLockEnabled) {
                    Text("App Lock")
                }
                .onChange(of: viewModel.isAppLockEnabled) { value in
                    viewModel.appLockStateChange(state: value)
                }
            }
            .navigationTitle("Home")
        }
    }
    
}
