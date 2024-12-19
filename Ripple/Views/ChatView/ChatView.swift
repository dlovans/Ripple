//
//  ChatView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-22.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    var body: some View {
        VStack {
            // Temporary logout button.
            Button("Logout") {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Failed to logout")
                }
            }
            Text("Edingekroken")
                .foregroundStyle(.white)
            ScrollView {
                LazyVStack {
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
