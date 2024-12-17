//
//  AuthProviderButton.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-17.
//

import SwiftUI

struct AuthProviderView: View {
    let authProvider: AuthProvider
    let authType: AuthType
    let iconPath: String
    
    var body: some View {
        Button {
            print("auth")
        } label: {
            HStack (spacing: 15) {
                Image("\(iconPath)")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("\(authType == .login ? "Sign in with" : "Sign up with") \(authProvider)")
                    .foregroundStyle(.white)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading], 20)
            .padding(.vertical, 10)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AuthProviderView(authProvider: .Apple, authType: .login, iconPath: "Apple")
}
