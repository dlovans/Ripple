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
                if locationService.isLoading {
                    SpinnerView()
                } else {
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
                        ScrollView {
                            LazyVStack {
                                ForEach(chatViewModel.chats) {chatItem in
                                    if chatItem.connections < chatItem.maxConnections {
                                        ChatItemView(
                                            navigateToChat: $navigateToChat,
                                            title: chatItem.chatName,
                                            connections: chatItem.connections,
                                            maxConnections: chatItem.maxConnections,
                                            chatId: chatItem.id,
                                            description: chatItem.description
                                        )
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
                    .onAppear {
                        Task {
                            chatViewModel.startFetchingChats(center: locationService.lastKnownLocation ?? nil)
                        }
                    }
                    .onDisappear {
                        print("ChatSelectionView destroyed.")
                        locationService.stopPeriodicLocationTask()
                        chatViewModel.stopFetchingChats()
                    }
                    .onChange(of: locationService.lastKnownLocation) { oldValue, newValue in
                        if let oldValue, let newValue {
                            let tolerance = 0.000001

                            if abs(oldValue.latitude - newValue.latitude) > tolerance || abs(oldValue.longitude - newValue.longitude) > tolerance {
                                print("Updating location: latitude: \(locationService.lastKnownLocation?.latitude ?? 0), longitude: \(locationService.lastKnownLocation?.longitude ?? 0)")
                                Task { @MainActor in
                                    chatViewModel.startFetchingChats(center: locationService.lastKnownLocation ?? nil)
                                }
                            }

                        }
                    }
                }
            }
        }
        .onAppear {
            Task { @MainActor in
                locationService.startPeriodicLocationTask()
            }
        }
    }
}

#Preview {
    ChatSelectionView()
}
