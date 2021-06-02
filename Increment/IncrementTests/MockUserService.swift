import Combine
import FirebaseAuth

final class MockUserService: UserServiceProtocol {
    var currentUser: User?
    
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        return Future<User?, Never> { _ in }.eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, IncrementError> {
        return Future<User, IncrementError> { _ in }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        return Future<User?, Never> { _ in }.eraseToAnyPublisher()
    }
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { _ in }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { _ in }.eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { _ in }.eraseToAnyPublisher()
    }
    
    
}
