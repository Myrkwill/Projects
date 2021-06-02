import SwiftUI
import Combine

typealias UserID = String

final class CreateChallengeViewModel: ObservableObject {
    
    enum Action {
        case createChallenge
    }
    
    @Published var exerciseDropdowns = ChallengePartViewModel(type: .exercise)
    @Published var startAmountDropdowns = ChallengePartViewModel(type: .startAmount)
    @Published var increaseDropdowns = ChallengePartViewModel(type: .increase)
    @Published var lengthDropdowns = ChallengePartViewModel(type: .length)
    
    @Published var error: IncrementError?
    @Published var isLoading: Bool = false
    
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserID().flatMap { userID -> AnyPublisher<Void, IncrementError> in
                return self.createChallenge(userID: userID)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

        }
    }
    
    private func createChallenge(userID: UserID) -> AnyPublisher<Void, IncrementError> {
        guard let exercise = exerciseDropdowns.text,
              let startAmount = startAmountDropdowns.number,
              let increase = increaseDropdowns.number,
              let length = lengthDropdowns.number
        else {
            return Fail(error: .default()).eraseToAnyPublisher()
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        
        let challenge = Challenge(
            exercise: exercise,
            startAmount: startAmount,
            increase: increase,
            length: length,
            userID: userID,
            startDate: startDate,
            activities: (0..<length).compactMap { dayNum in
                if let dayForDayNum = Calendar.current.date(byAdding: .day, value: dayNum, to: startDate) {
                    return .init(date: dayForDayNum, isComplete: false)
                } else {
                    return nil
                }
            }
        )
        
        return challengeService.create(challenge).eraseToAnyPublisher()
    }
    
    private func currentUserID() -> AnyPublisher<UserID, IncrementError> {
        print("getting user id")
        return userService.currentUserPublisher()
            .flatMap { user -> AnyPublisher<UserID, IncrementError> in
//                return Fail(error: .auth(description: "Some firebase auth error")).eraseToAnyPublisher()
                if let userID = user?.uid {
                    return Just(userID)
                        .setFailureType(to: IncrementError.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.userService
                        .signInAnonymously()
                        .map { $0.uid }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
}

extension CreateChallengeViewModel {
    
    struct ChallengePartViewModel: DropdownItemProtocol {
        
        var selectedOption: DropdownOption
        var options: [DropdownOption]
        var headerTitle: String { type.rawValue }
        var dropdownTitle: String { selectedOption.formatted }
        
        var isSelected: Bool = false
        
        private let type: ChallengePartType
        
        init(type: ChallengePartType) {
            switch type {
            case .exercise:
                options = ExerciseOption.allCases.map { $0.toDropdownOption }
            case .startAmount:
                options = StartOption.allCases.map { $0.toDropdownOption }
            case .increase:
                options = IncreaseOption.allCases.map { $0.toDropdownOption }
            case .length:
                options = LengthOption.allCases.map { $0.toDropdownOption }
            }
            
            self.type = type
            self.selectedOption = options.first!
        }
        
        enum ChallengePartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Starting  Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExerciseOption: String, CaseIterable, DropdownOptionProtocol {
            case pullups
            case pushups
            case situps
        
            var toDropdownOption: DropdownOption {
                .init(
                    type: .text(rawValue),
                    formatted: rawValue.capitalized
                )
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
        
            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "\(rawValue)"
                )
            }
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
        
            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "+ \(rawValue)"
                )
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28
        
            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "\(rawValue) days"
                )
            }
        }
        
    }
    
}

extension CreateChallengeViewModel.ChallengePartViewModel {
    
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        } else {
            return nil
        }
    }
    
    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        } else {
            return nil
        }
    }
    
}
