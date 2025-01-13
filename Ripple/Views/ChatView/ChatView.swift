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
                        .frame(width: 40, alignment: .leading)
                        Spacer()
                        Text(
                            (chatViewModel.chat?.chatName.prefix(15) ?? "Unknown") +
                            ((chatViewModel.chat?.chatName.count ?? 0) >= 15 ? "..." : "")
                        )
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        Spacer()
                        HStack (spacing: 0) {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.textcolor)
                                .font(.caption2)
                            Text("\(chatViewModel.chat?.connections ?? 1)")
                                .foregroundStyle(.textcolor)
                                .font(.caption2)
                        }
                        .frame(width: 40, alignment: .trailing)

                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    ChatMessagesListView()
                    ChatFieldView()
                }
                .padding()
                .onAppear {
                    Task { @MainActor in
                        messageViewModel.subscribeToMessages(chatId: chatViewModel.chat?.id ?? "", blockedUserIds: userViewModel.user?.blockedUserIds ?? [])
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
                .onChange(of: chatViewModel.chat) { _, newValue in
                    if let active = newValue?.active {
                        if !active {
                            dismiss()
                        }
                    }
                }
                .onChange(of: userViewModel.user!.blockedUserIds) { _, newValue in
                    Task { @MainActor in
                        messageViewModel.subscribeToMessages(chatId: chatViewModel.chat?.id ?? "", blockedUserIds: newValue)
                    }
                }
            }
        }
    }
}
