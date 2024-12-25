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
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
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
                    Spacer()

                    Text("Connections: \(chatViewModel.chat?.connections ?? 1)")
                        .foregroundStyle(.textcolor)
                }
                .padding()
                ScrollView {
                    LazyVStack {
                        // ForEach. isMe = userViewModel?.user.id == message.userId
                        
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whasfffgoin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whasfffgoin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whasfffgoin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                        ChatMessageView(username: "Pablito", message: "Whasfffgoin on", isMe: true)
                    }
                }
                .defaultScrollAnchor(.bottom)
                .scrollIndicators(.hidden)
                ChatFieldView()
            }
            .padding()
        }
    }
}

#Preview {
    ChatView()
}
