//
//  AuthFieldView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-17.
//

import SwiftUI

struct AuthFieldsView: View {
    let authType: AuthType
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Text("Email:")
                    .foregroundStyle(.textcolor)
                TextField("", text: $email)
                    .foregroundStyle(.textcolor)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(.stone)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.emerald, lineWidth: 2)
            }
            
            HStack {
                Text("Password:")
                    .foregroundStyle(.textcolor)
                SecureField("", text: $password)
                    .foregroundStyle(.textcolor)
                    .keyboardType(.default)
            }
            .padding()
            .background(.stone)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.emerald, lineWidth: 2)
            }
            
            Button(
                action: {
                    if authType == .login {
                        authViewModel.loginWithEmailAndPassword(email: self.email, password: self.password) { result in
                            switch (result) {
                            case .success:
                                userViewModel.destroyUser()
                                userViewModel.attachUserListener()
                            case .failure:
                                // Display UI error message.
                                print("Failed to login user.")
                            }
                            
                        }
                    } else {
                        authViewModel.signupWithEmailAndPassword(email: self.email, password: self.password) { result in
                            switch (result) {
                            case .success:
                                Task {
                                    await userViewModel.createUserOnSignup()
                                    userViewModel.destroyUser()
                                    userViewModel.attachUserListener()
                                }
                            case .failure:
                                // Display UI error message.
                                print("Failed to signup user.")
                            }
                        }
                    }

                },
                label: {
                    Text(authType == .login ? "Login" : "Register")
                        .foregroundStyle(.textcolor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.emerald)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            )
            .frame(maxWidth: .infinity)
            .disabled(email.isEmpty && password.isEmpty)
        }
    }
}

#Preview {
    AuthFieldsView(authType: .login)
}
