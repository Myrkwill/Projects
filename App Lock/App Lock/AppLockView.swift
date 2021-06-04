import SwiftUI

struct AppLockView: View {
    
    @EnvironmentObject var viewModel: AppLockViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("App Lock")
                .font(.title)
            
            Button("Open") {
                viewModel.appLockValidation()
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black)
            )
        }
    }
    
}
