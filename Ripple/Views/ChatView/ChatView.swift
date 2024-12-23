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
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea()
            VStack {
                Text("Edingekroken")
                    .foregroundStyle(.textcolor)
                ScrollView {
                    LazyVStack {
                        // ForEach. isMe = userViewModel?.user.id == message.userId
                        
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
