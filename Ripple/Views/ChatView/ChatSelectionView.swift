//
//  StartPromptView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct ChatSelectionView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var locationService: LocationService
    @State private var displayCreateChat: Bool = false
    @State private var createChatTitle: String = ""
    @State private var navigateToChat: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.stone
                    .ignoresSafeArea(.all)
                VStack {
                    HStack {
                        Button {
                            displayCreateChat.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("New Chat")
                            }
                        }
                        .sheet(isPresented: $displayCreateChat) {
                            ChatCreateView(navigateToChat: $navigateToChat, isPresented: $displayCreateChat)
                        }
                    }
                    if chatViewModel.isLoading {
                        SpinnerView()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(chatViewModel.localizedChats) {chatItem in
                                    Text(chatItem.chatName)
                                        .foregroundStyle(.textcolor)
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding()
                .navigationDestination(isPresented: $navigateToChat) {
                    ChatView(navigateToChat: $navigateToChat)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .onAppear {
                locationService.startPeriodicLocationTask()
                Task { @MainActor in
                    chatViewModel.startFetchingChats(center: locationService.lastKnownLocation ?? nil)
                }
                print("created")
            }
            .onDisappear {
                locationService.stopPeriodicLocationTask()
                chatViewModel.stopFetchingChats()
                print("destroyed1111")
            }
            .onChange(of: locationService.lastKnownLocation) { oldValue, newValue in
                if oldValue != newValue {
                    print("location changed")
                    Task { @MainActor in
                        chatViewModel.startFetchingChats(center: locationService.lastKnownLocation ?? nil)
                    }
                }
            }
        }
    }
}

#Preview {
    ChatSelectionView()
}
