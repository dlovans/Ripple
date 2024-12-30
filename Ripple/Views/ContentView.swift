//
//  ContentView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        if authViewModel.isLoading || userViewModel.isLoading {
            SpinnerView()
        } else {
            VStack {
                if authViewModel.isAuthenticated {
                    if userViewModel.userLoaded {
                        if let username = userViewModel.user?.username, !username.isEmpty {
                            MenuView()
                        } else {
                            NewUserView()
                        }
                    } else {
                        SpinnerView()
                    }
                } else {
                    AuthView(authType: .login)
                }
            }
        }
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

//#Preview {
//    ContentView()
//}
