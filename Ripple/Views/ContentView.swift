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
    @EnvironmentObject private var locationService: LocationService
    
    var body: some View {
        VStack {
            if authViewModel.isLoading || userViewModel.isLoading {
                SpinnerView()
            } else {
                VStack {
                    if authViewModel.isAuthenticated {
                        if userViewModel.userLoaded {
                            if let user = userViewModel.user {
                                if user.isBanned {
                                    ZStack {
                                        Color.stone
                                            .ignoresSafeArea()
                                        VStack {
                                            Text("You have been banned.")
                                            Text("Ban reason: \(user.banMessage)")
                                            HStack {
                                                Text("Ban will be lifted on: ")
                                                Text(user.banLiftDate ?? Date(), format: .dateTime)
                                            }
                                        }
                                    }
                                } else {
                                    if !user.username.isEmpty {
                                        MenuView()
                                    } else {
                                        NewUserView()
                                    }
                                }
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
