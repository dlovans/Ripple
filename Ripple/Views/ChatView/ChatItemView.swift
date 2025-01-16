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
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var navigateToChat: Bool
    @State var displayChatReport: Bool = false
    @State var messageId: String? = nil
    
    let title: String
    let connections: Int
    let maxConnections: Int
    let chatId: String
    let description: String
    let chatCreatedByUserId: String
    
    var body: some View {
        Button {
            chatViewModel.startListeningToChat(for: chatId)
            messageViewModel.subscribeToMessages(chatId: chatId, blockedUserIds: userViewModel.user?.blockedUserIds ?? [])
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
        .disabled(connections >= maxConnections || !chatViewModel.chatIsLoading)
        .frame(maxWidth: .infinity)
        .padding()
        .background(chatViewModel.chatIsLoading ? .emerald : Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $displayChatReport) {
            ChatItemReportView(chatId: chatId, chatName: title, reportAgainstUserId: chatCreatedByUserId, reportByUserId: userViewModel.user?.id ?? "", displayChatReport: $displayChatReport)
        }
        .contextMenu {
            if userViewModel.user?.id != chatCreatedByUserId {
                Button {
                    displayChatReport = true
                } label: {
                    Text("Report")
                }
            }
        }
    }
}
