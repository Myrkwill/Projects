import SwiftUI

final class LandingViewModel: ObservableObject {
    
    @Published var loginSignupPushed = false
    @Published var createPushed = false
    
    let title = "Increment"
    let createButtonTitle = "Create a challenge"
    let createButtonImageName = "plus.circle"
    let alreadyButtonTitle = "I already have an account"
    let backgroundImageName = "pullups"
    
}
