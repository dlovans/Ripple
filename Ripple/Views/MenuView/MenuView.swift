//
//  MenuView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var selection: Int = 1
    
    var locationEnabled: Bool {
        locationViewModel.locationAuthorized == .authorizedAlways || locationViewModel.locationAuthorized == .authorizedWhenInUse
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                Color.stone
                    .ignoresSafeArea(.all)
                
                VStack {
                    VStack {
                        if selection == 0 {
                            Text("Events coming soon!")
                                .foregroundStyle(.textcolor)
                        } else if selection == 1 {
                            ChatSelectionView()
                        } else if selection == 2 {
                            SettingsView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                    if locationEnabled {
                        HStack {
                            //                        Spacer()
                            //                        MenuItemView(menuItem: 0,menuItemText: "Events", menuItemImage: "EventsIcon", selection: $selection)
                            Spacer()
                            MenuItemView(menuItem: 1,menuItemText: "Chat", menuItemImage: "ChatIcon", selection: $selection)
                            Spacer()
                            MenuItemView(menuItem: 2,menuItemText: "Settings", menuItemImage: "SettingsIcon", selection: $selection)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    }
                }
            }
        }
        .onAppear {
            if locationViewModel.locationAuthorized == .denied || locationViewModel.locationAuthorized == .restricted {
                selection = 2
            } else {
                selection = 1
            }
        }
        .onChange(of: locationViewModel.locationAuthorized, { _, newValue in
            if newValue == .denied || newValue == .restricted {
                selection = 2
            } else {
                selection = 1
            }
        })
    }
}

#Preview {
    MenuView()
}
