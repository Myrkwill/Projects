import SwiftUI

struct CardDetailTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        return content
            .font(.custom("Avenir-Medium", size: 18))
            .foregroundColor(Color(.systemGray))
    }
    
}
