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
    let description: String
    
    var body: some View {
        Button {
            chatViewModel.startListeningToChat(for: chatId)
            messageViewModel.subscribeToMessages(chatId: chatId)
            navigateToChat = true
        } label: {
            VStack (spacing: 10) {
                HStack {
                    Text(title.count >= 15 ? title.prefix(15) + "..." : title)
                        .foregroundStyle(.black)
                        .font(.subheadline)
                    Spacer()
                    HStack (spacing: 0) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.black)
                            .font(.caption)
                        Text("\(connections)/\(maxConnections)")
                            .foregroundStyle(.black)
                            .font(.caption)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(Color.black)
                            .font(.caption)
                    }
                }
                Text(description)
                    .foregroundStyle(.black)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .disabled(connections >= maxConnections)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.emerald)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
