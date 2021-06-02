import Combine

final class ChallengeListViewModel: ObservableObject {
    
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellables: [AnyCancellable] = []
    @Published private(set) var itemViewModels: [ChallengeItemViewModel] = []
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    @Published var showingCreateModal = false
    
    let title = "Challenges"
    
    enum Action {
        case retry
        case create
        case timeChange
    }
    
    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
        observeChallenges()
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observeChallenges()
        case .create:
            showingCreateModal = true
        case .timeChange:
            cancellables.removeAll()
            observeChallenges()
        }
    }
    
    private func observeChallenges() {
        isLoading = true
        userService.currentUserPublisher()
            .compactMap { $0?.uid }
            .flatMap { [weak self] userID -> AnyPublisher<[Challenge], IncrementError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher() }
                return self.challengeService.observeChallenges(userID: userID)
            }.sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                switch completion {
                case .finished:
                    print("finished")
                case let .failure(error):
                    self.error = error
                }
            } receiveValue: { [weak self] challenges in
                guard let self = self else { return }
                
                self.isLoading = false
                self.error = nil
                self.showingCreateModal = false
                self.itemViewModels = challenges.map { challenge in
                    .init(
                        challenge,
                        onDelete: { [weak self] id in
                            self?.deleteChallenge(at: id)
                        },
                        onToggleComplete: { [weak self] id, activities in
                            self?.updateChallenge(id: id, activities: activities)
                        }
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func deleteChallenge(at challengeID: String) {
        challengeService.delete(challengeID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.error = error
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func updateChallenge(id: String, activities: [Activity]) {
        challengeService.updateChallenge(id, activities: activities)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.error = error
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
}
