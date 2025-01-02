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
                        .scrollIndicators(.hidden)
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
                        chatViewModel.stopFetchingChats()
                    }
                    .onChange(of: locationService.lastKnownLocation) { _, newValue in
                        if let newValue {
                            Task { @MainActor in
                                chatViewModel.startFetchingChats(center: newValue)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ChatSelectionView()
}
