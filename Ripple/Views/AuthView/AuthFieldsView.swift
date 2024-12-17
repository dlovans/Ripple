//
//  AuthFieldView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-17.
//

import SwiftUI

struct AuthFieldsView: View {
    var authType: AuthType
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Text("Email:")
                    .foregroundStyle(.white)
                TextField("", text: $email)
                    .foregroundStyle(.white)
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
                    .foregroundStyle(.white)
                SecureField("", text: $password)
                    .foregroundStyle(.white)
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
                    print("Hello")
                },
                label: {
                    Text(authType == .login ? "Login" : "Register")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.emerald)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            )
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    AuthFieldsView(authType: .login)
}
