//
//  RippleApp.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-19.
//

import SwiftUI
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct RippleApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var chatViewModel = ChatViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var messageViewModel = MessageViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            OrientationLockedView()
                .environmentObject(authViewModel)
                .environmentObject(userViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(locationViewModel)
                .environmentObject(messageViewModel)
        }
    }
}
