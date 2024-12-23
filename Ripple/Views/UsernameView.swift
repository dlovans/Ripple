//
//  UsernameView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username: String = ""
    @State private var updateClicked: Bool = false
    
    var initialUsername: String {
        userViewModel.user?.username ?? ""
    }
    
    var newUser: Bool = true
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea()
            VStack (spacing: 20) {
                Text(newUser ? "Enter your username to get started:" : "Update your username:")
                    .foregroundStyle(.textcolor)
                    .font(.title2)
                
                HStack {
                    TextField("At least 5 characters...", text: $username)
                        .padding()
                        .foregroundStyle(.textcolor)
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.emerald, lineWidth: 2)
                        }
                        .onAppear {
                            username = userViewModel.user?.username ?? ""
                        }
                }
                .overlay(alignment: .leading) {
                    if username.isEmpty {
                        Text("At least 5 characters...")
                            .foregroundStyle(.textcolor)
                            .padding(.leading, 20)
                            .allowsHitTesting(false)
                    }
                }
                
                
                Button("Update") {
                    updateClicked.toggle()
                    Task {
                        await userViewModel.updateUsername(username: username)
                    }
                    updateClicked.toggle()
                }
                .disabled(username.count < 5 || updateClicked || initialUsername == username)
                .foregroundStyle(.textcolor)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(username.count < 5 || updateClicked || initialUsername == username ? Color.gray : .emerald)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    UsernameView()
}
