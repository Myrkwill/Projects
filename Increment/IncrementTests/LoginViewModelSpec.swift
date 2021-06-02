import XCTest
@testable import Increment

class LoginViewModelSpec: XCTestCase {
    
    var viewModel: LoginSignupViewModel!
    var mockUserService: MockUserService!

    override func setUp() {
        mockUserService = MockUserService()
        viewModel = .init(mode: .login, userService: mockUserService)
    }
    
    func testLoginWithCorrectDetailsSetsSuccessPresentedToTrue() {
        viewModel.tappedActionButton()
        
        XCTAssertTrue()
    }


}
