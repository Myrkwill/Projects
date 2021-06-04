import Foundation
import LocalAuthentication


class AppLockViewModel: ObservableObject {
    
    @Published var isAppLockEnabled: Bool = false
    @Published var isAppUnlocked: Bool = false
    
    init() {
        appLockState()
    }
    
    func enableAppLock() {
        isAppLockEnabled = true
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isAppLockEnabled.rawValue)
    }
    
    func disableAppLock() {
        isAppLockEnabled = false
        UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isAppLockEnabled.rawValue)
    }
    
    func appLockState() {
        isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isAppLockEnabled.rawValue)
    }
    
    func checkIfBioMetricAvailable() -> Bool {
        var error: NSError?
        let laContext = LAContext()
        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            print(error.localizedDescription)
        }
        return isBiometricAvailable
    }
    
    func appLockStateChange(state appLockState: Bool) {
        let laContext = LAContext()
        
        if checkIfBioMetricAvailable() {
            var reason = ""
            if appLockState {
                reason = "Provide TouchID / FaceID to enable App Lock"
            } else {
                reason = "Provide TouchID / FaceID to disable App Lock"
            }
            
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    if appLockState {
                        DispatchQueue.main.async {
                            self.enableAppLock()
                            self.isAppUnlocked = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.disableAppLock()
                            self.isAppUnlocked = false
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func appLockValidation() {
        let laContext = LAContext()
        
        if checkIfBioMetricAvailable() {
            let reason = "Enable App Lock"
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.isAppUnlocked = true
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

extension UserDefaults {
    
    enum Keys: String {
        case isAppLockEnabled
    }
    
}
