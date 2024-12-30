//
//  ChatItemView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-28.
//

import SwiftUI

struct ChatItemView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    @Binding var navigateToChat: Bool
    
    let title: String
    let connections: Int
    let maxConnections: Int
    let chatId: String
    
    var body: some View {
        Button {
            chatViewModel.startListeningToChat(for: chatId)
            messageViewModel.subscribeToMessages(chatId: chatId)
            navigateToChat = true
        } label: {
            HStack {
                Text(title.count >= 20 ? title.prefix(20) + "..." : title)
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "person.fill")
                    .foregroundStyle(.black)
                Text("\(connections)/\(maxConnections)")
                    .foregroundStyle(.black)
                Image(systemName: "arrow.right")
                    .foregroundStyle(Color.black)
            }
        }
        .disabled(connections >= maxConnections)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.emerald)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
