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
                
//                if userViewModel.user?.id != chatCreatedByUserId {
                    HStack {
                        Button {
                            Task { @MainActor in
                                chatViewModel.stopFetchingChats()
                                displayChatReport = true
                            }
                        } label: {
                            HStack (spacing: 0) {
                                Group {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(Color.orange)
                                    Text("Report")
                                        .foregroundStyle(Color.black)
                                }
                                .font(.footnote)
                                .opacity(0.5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
//                }
            }
        }
        .disabled(connections >= maxConnections)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.emerald)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $displayChatReport) {
            ChatItemReportView(chatId: chatId, chatName: title, reportAgainstUserId: chatCreatedByUserId, displayChatReport: $displayChatReport)
        }
    }
}
