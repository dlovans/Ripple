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
    @State private var buttonText: String = "Update"
    @Binding var disableInputs: Bool
    
    private var validUsername: Bool {
        !username.contains(" ") && username.count >= 1 && username.count <= 20
    }
    private var buttonStatusText = "Successfully updated username!"
    
    var initialUsername: String {
        userViewModel.user?.username ?? ""
    }
    
    init(disableInputs: Binding<Bool>) {
        self._disableInputs = disableInputs
    }
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea()
            VStack (spacing: 20) {
                Text("Update your username:")
                    .foregroundStyle(.textcolor)
                    .font(.title2)
                
                HStack {
                    ZStack {
                        TextField("At least 1 character...", text: $username)
                            .padding()
                            .foregroundStyle(.textcolor)
                            .keyboardType(.default)
                            .disabled(disableInputs)
                            .overlay() {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.emerald, lineWidth: 2)
                            }
                            .onAppear {
                                username = userViewModel.user?.username ?? ""
                            }
                            .onChange(of: username) { oldValue, newValue in
                                if newValue != oldValue {
                                    if newValue.contains(" ") {
                                        buttonText = "Username cannot contain spaces!"
                                    } else if newValue.count >= 1 && newValue.count <= 20 {
                                        buttonText = "Update"
                                    } else if newValue.count < 1 {
                                        buttonText = "Username too short! At least 1 character."
                                    } else if newValue.count > 20 {
                                        buttonText = "Username too long! Max 13 characters."
                                    }
                                }
                            }
                        
                    }
                }
                .overlay(alignment: .leading) {
                    if username.isEmpty {
                        Text("At least 1 characters...")
                            .foregroundStyle(.textcolor)
                            .padding(.leading, 20)
                            .allowsHitTesting(false)
                    }
                }
                
                Button {
                    Task {
                        disableInputs = true
                        buttonText = "Updating..."
                        let status = await userViewModel.updateUsername(username: username)
                        if status {
                            buttonText = buttonStatusText
                        } else {
                            buttonText = "Failed to update username"
                        }
                        disableInputs = false
                    }
                } label: {
                    Text(buttonText)
                        .foregroundStyle(.textcolor)
                        .frame(maxWidth: .infinity)
                }
                .disabled(!validUsername || initialUsername == username || disableInputs)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(!validUsername || initialUsername == username ? Color.gray : .emerald)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//#Preview {
//    UsernameView()
//}
