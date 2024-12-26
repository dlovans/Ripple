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
    @EnvironmentObject var locationService: LocationService
    
    var locationEnabled: Bool {
        locationService.locationAuthorized == .authorizedAlways || locationService.locationAuthorized == .authorizedWhenInUse
    }
    
    @State var username: String = ""
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea()
            VStack {
                if locationEnabled {
                    Text("Settings")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView {
                        VStack {
                            UsernameView(newUser: false)
                        }
                        Divider()
                            .overlay(.white)
                            .frame(width: 300)
                        Button {
                            let logoutStatus = authViewModel.logout()
                            if logoutStatus {
                                userViewModel.destroyUserLocally()
                            }
                        } label: {
                            Text("Logout")
                                .foregroundStyle(.textcolor)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                    .scrollIndicators(.hidden)
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

        }
    }
}

#Preview {
    SettingsView()
}
