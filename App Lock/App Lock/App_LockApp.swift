//
//  App_LockApp.swift
//  App Lock
//
//  Created by Mark Nagibin on 03.06.2021.
//

import SwiftUI

@main
struct App_LockApp: App {
    
    @StateObject var viewModel = AppLockViewModel()
    @Environment(\.scenePhase) var scenePhase
    @State var blurRadius: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .blur(radius: blurRadius)
                .onChange(of: scenePhase) { value in
                    switch value {
                    case .active:
                        blurRadius = 0
                    case .background:
                        viewModel.isAppUnlocked = false
                    case .inactive:
                        blurRadius = 5
                    @unknown default:
                        print("unknown")
                    }
                }
        }
    }
}
