//
//  StartPromptView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct ChatSelectionView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
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
                    if locationViewModel.isLoading {
                        SpinnerView()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(locationViewModel.localizedChats) {chatItem in
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
                }
            }
            .onAppear {
                locationViewModel.startPeriodicLocationTask(locationMode: .chats)
            }
            .onDisappear {
                locationViewModel.stopPeriodicLocationTask()
            }
        }
    }
}

#Preview {
    ChatSelectionView()
}
