//
//  ChatView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-22.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    @Binding var navigateToChat: Bool
    
    @State private var chatId: String = ""
    @State private var autoScroll: Bool = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if chatViewModel.chatIsLoading {
                SpinnerView()
            } else {
                Color.stone
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundStyle(.emerald)
                        }
                        .frame(width: 80, alignment: .leading)
                        Spacer()
                        Text(chatViewModel.chat?.chatName ?? "Unknown")
                            .frame(maxWidth: .infinity)
                        Spacer()
                        Text("\(chatViewModel.chat?.connections ?? 0)/\(chatViewModel.chat?.maxConnections ?? 100)")
                            .foregroundStyle(.textcolor)
                            .frame(width: 80, alignment: .trailing)
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    ChatScrollView()
                    ChatFieldView()
                }
                .padding()
                .onAppear {
                    chatId = chatViewModel.chat?.id ?? ""
                    Task {
                        await chatViewModel.incrementConnection()
                    }
                }
                .onDisappear {
                        Task { @MainActor in
                            navigateToChat = false
                            await chatViewModel.decrementConnection()
                            messageViewModel.unsubscribeFromMessages()
                            chatViewModel.stopListeningToChat()
                        }
                    }
            }
        }
    }
}
