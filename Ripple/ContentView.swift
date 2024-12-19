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
        ZStack {
            Color(.stone)
                .ignoresSafeArea()

            VStack {
                if authViewModel.isAuthenticated {
                    ChatView()
                } else {
                    AuthView(authType: .login)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
