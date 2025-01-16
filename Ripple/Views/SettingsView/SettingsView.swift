//
//  SettingsView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var locationService: LocationService
    @FocusState private var usernameIsFocused: Bool
    @State private var logoutText: String = "Logout"
    @State private var disableInputs: Bool = false
    @State private var navigateToBlockList: Bool = false
    
    var locationEnabled: Bool {
        locationService.locationAuthorized == .authorizedAlways || locationService.locationAuthorized == .authorizedWhenInUse
    }
    
    @State var username: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.stone
                    .ignoresSafeArea()
                VStack {
                    if locationEnabled {
                        Text("Settings")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.textcolor)
                        ScrollView {
                            VStack {
                                BlockListButtonView(disableInputs: $disableInputs, navigateToBlockList: $navigateToBlockList)
                                    .navigationDestination(isPresented: $navigateToBlockList) {
                                        BlockListView()
                                            .navigationBarBackButtonHidden(true)
                                    }
                            }
                            
                            Divider()
                                .overlay(.white)
                                .frame(width: 300)
                                                    
                            Button {
                                Task { @MainActor in
                                    self.disableInputs = true
                                    let logoutStatus = authViewModel.logout()
                                    if logoutStatus {
                                        chatViewModel.stopListeningToChat()
                                        chatViewModel.stopFetchingChats()
                                        userViewModel.destroyUser()
                                    } else {
                                        logoutText = "Failed to logout. Try again later."
                                    }
                                }
                            } label: {
                                Text(logoutText)
                                    .foregroundStyle(.textcolor)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(disableInputs ? Color.gray : Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(disableInputs)
                        }
                        .scrollIndicators(.hidden)
                        .scrollDismissesKeyboard(.interactively)
                    } else {
                        Button{
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                            }
                        } label: {
                            Text("Enable Location to use this app!")
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.emerald)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                }
                .frame(alignment: locationEnabled ? .top : .center)
                .padding()
                
                if !userViewModel.userLoaded {
                    SpinnerView()
                }
            }

        }
    }
}

#Preview {
    SettingsView()
}
