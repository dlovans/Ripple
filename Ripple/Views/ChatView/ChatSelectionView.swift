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
    
    var body: some View {
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
                        ChatCreateView(isPresented: $displayCreateChat)
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
        }
        .onAppear {
            locationViewModel.startPeriodicLocationTask(locationMode: .chats, intervalInSeconds: 60)
        }
        .onDisappear {
            locationViewModel.stopPeriodicLocationTask()
        }
    }
}

#Preview {
    ChatSelectionView()
}
