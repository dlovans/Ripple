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
        VStack {
            // Temporary logout button.
            Button("Logout") {
                let logoutStatus = authViewModel.logout()
                if logoutStatus {
                    userViewModel.destroyUserLocally()
                }
            }
            Text("Edingekroken")
                .foregroundStyle(.white)
            ScrollView {
                LazyVStack {
                    // ForEach. isMe = userViewModel?.user.id == message.userId
                    
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: false)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whas goin on", isMe: true)
                    ChatMessageView(username: "Pablito", message: "Whasfffgoin on", isMe: true)
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            ChatFieldView()
        }
    }
}

#Preview {
    ChatView()
}
