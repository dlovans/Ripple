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
    @State private var buttonText: String = "Update"
    @FocusState.Binding var usernameIsFocused: Bool
    
    private var buttonStatusText = "Successfully updated username!"
    
    var initialUsername: String {
        userViewModel.user?.username ?? ""
    }
        
    init(usernameIsFocused: FocusState<Bool>.Binding) {
        self._usernameIsFocused = usernameIsFocused
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
                        TextField("At least 5 characters...", text: $username)
                            .padding()
                            .foregroundStyle(.textcolor)
                            .focused($usernameIsFocused)
                            .keyboardType(.default)
                            .overlay() {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.emerald, lineWidth: 2)
                            }
                            .onAppear {
                                username = userViewModel.user?.username ?? ""
                            }
                            .onChange(of: username) { oldValue, newValue in
                                if buttonText == buttonStatusText && newValue != oldValue {
                                    buttonText = "Update"
                                }
                            }
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
                
                Button {
                    Task {
                        updateClicked.toggle()
                        buttonText = "Updating..."
                        await userViewModel.updateUsername(username: username)
                        updateClicked.toggle()
                        buttonText = buttonStatusText
                    }
                } label: {
                    Text(buttonText)
                        .foregroundStyle(.textcolor)
                        .frame(maxWidth: .infinity)
                }
                .disabled(username.count < 5 || updateClicked || initialUsername == username)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(username.count < 5 || updateClicked || initialUsername == username ? Color.gray : .emerald)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    if username.count >= 5 && initialUsername != username {
                        usernameIsFocused = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//#Preview {
//    UsernameView()
//}
