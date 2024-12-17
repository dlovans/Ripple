//
//  ChatMessageView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-29.
//

import SwiftUI

struct ChatMessageView: View {
    let username: String
    let message: String
    let isMe: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("@\(username)")
            Text(message)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(isMe ? Color.emerald : Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.1))
    }
}

#Preview {
    ChatMessageView(username: "Dlovan", message: "chop chop", isMe: false)
}
