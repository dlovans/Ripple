//
//  NewUserView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-29.
//

import SwiftUI

struct NewUserView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username: String = ""
    @State private var updateClicked: Bool = false
    @State private var validUsername: Bool = false
    @State private var buttonText: String = "Username must be at least 1 character"
    @State private var usernameAvailable: Bool = false
    @State private var task: Task<Void, Never>? = nil
    
    private var computedValidUsername: Bool {
        username.count >= 1 && username.count <= 13 && !username.contains(" ")
    }
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack (spacing: 20) {
                Text("Enter your username to get started")
                    .foregroundStyle(.textcolor)
                    .font(.title3)
                
                HStack {
                    ZStack {
                        TextField("", text: $username)
                            .padding()
                            .foregroundStyle(.textcolor)
                            .keyboardType(.default)
                            .disabled(updateClicked)
                            .overlay() {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.emerald, lineWidth: 2)
                            }
                            .onAppear {
                                username = userViewModel.user?.username ?? ""
                            }
                            .onChange(of: username) { oldValue, newValue in
                                if let task {
                                    task.cancel()
                                }
                                
                                if newValue != oldValue {
                                    if newValue.contains(" ") {
                                        buttonText = "No spaces allowed!"
                                        validUsername = false
                                    } else if newValue.count < 1 {
                                        buttonText = "Username must be at least 1 character"
                                        validUsername = false
                                    } else if newValue.count > 13 {
                                        buttonText = "Username can be max 13 characters"
                                        validUsername = false
                                    } else if newValue.count >= 1 && newValue.count <= 13 && !newValue.contains(" ") {
                                        validUsername = true
                                        if validUsername {
                                            task = Task(priority: .high) { @MainActor in
                                                let isAvailable = await userViewModel.usernameAvailable(username: username)
                                                if isAvailable == .unavailable {
                                                    buttonText = "Username already taken!"
                                                    usernameAvailable = false
                                                } else if isAvailable == .available {
                                                    buttonText = "Update"
                                                    usernameAvailable = true
                                                } else {
                                                    buttonText = "Failed to check availability...Try again later!"
                                                    usernameAvailable = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
                .overlay(alignment: .leading) {
                    if username.isEmpty {
                        Text("At least 1 character...")
                            .foregroundStyle(.textcolor)
                            .padding(.leading, 20)
                            .allowsHitTesting(false)
                    }
                }
                
                Button {
                    Task {
                        updateClicked.toggle()
                        buttonText = "Updating..."
                        let status = await userViewModel.updateUsername(username: username)
                        if status == .success {
                            buttonText = "Successfully updated username"
                        } else if status == .failure {
                            buttonText = "Failed to update username...Try again later!"
                            updateClicked.toggle()
                        } else if status == .unavailable {
                            buttonText = "Username was taken while updating :("
                            updateClicked.toggle()
                        }
                    }
                } label: {
                    Text(buttonText)
                        .foregroundStyle(.textcolor)
                        .frame(maxWidth: .infinity)
                }
                .disabled(!validUsername || updateClicked || !usernameAvailable)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(!validUsername || updateClicked || !usernameAvailable ? Color.gray : .emerald)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
