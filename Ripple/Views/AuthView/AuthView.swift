//
//  AuthView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-17.
//

import SwiftUI

struct AuthView: View {
    @State private var authType: AuthType
    @EnvironmentObject private var authViewModel: AuthViewModel

    init(authType: AuthType) {
        _authType = State(initialValue: authType)
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            Color.stone
                .ignoresSafeArea()
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text(authType == .login ? "Welcome Back!" : "Get started with Ripple!")
                        .font(.title)
                        .foregroundStyle(.textcolor)
                    Text(authType == .login ? "Login to start chatting." : "Join and start chatting.")
                        .font(.title2)
                        .foregroundStyle(.textcolor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                AuthFieldsView(authType: authType)
                
                VStack {
                    AuthProviderView(authProvider: .Apple, authType: authType, iconPath: "Apple")
                    AuthProviderView(authProvider: .Google, authType: authType, iconPath: "Google")
                }
                .padding(.top, 40)
                
                HStack {
                    Text("\(authType == .login ? "Don't have an account?" : "Already got an account?")")
                        .foregroundStyle(Color.gray)
                    Button {
                        if authType == .login {
                            authType = .register
                        } else {
                            authType = .login
                        }
                    } label: {
                        Text("\(authType == .login ? "Join" : "Login")")
                            .foregroundStyle(.emerald)
                    }
                }
                .padding(.top, 15)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    AuthView(authType: .register)
}
