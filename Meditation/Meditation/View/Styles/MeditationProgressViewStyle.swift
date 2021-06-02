import SwiftUI

struct MeditationProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGroupedBackground))
                .frame(height: 10)
            ProgressView(configuration)
                .accentColor(Color(.systemBlue))
                .scaleEffect(x: 1, y: 2.5)
        }
    }
    
}
