import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppLockViewModel
    
    var body: some View {
        ZStack {
            if !viewModel.isAppLockEnabled || viewModel.isAppUnlocked {
                AppHomeView()
                    .environmentObject(viewModel)
            } else {
                AppLockView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            if viewModel.isAppLockEnabled {
                viewModel.appLockValidation()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
