//
//  ChatView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-22.
//

import SwiftUI

struct ChatView: View {    
    var body: some View {
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
        ChatBarView()
    }
}

#Preview {
    ChatView()
}
