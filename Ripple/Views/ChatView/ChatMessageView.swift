//
//  ChatMessageView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-29.
//

import SwiftUI

struct ChatMessageView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    let username: String
    let userId: String
    let message: String
    let isMe: Bool
    var isPremium = false
    let messageId: String
    let createdAt: String
    
    @State var displayMessageReport: Bool = false
    @State var displayAlert: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("@\(username)")
                    .foregroundStyle(isMe ? .black : .textcolor)
                    .font(.subheadline)
                Spacer()
                Text(createdAt)
                    .foregroundStyle(isMe ? .black : .textcolor)
                    .font(.caption)
            }
            Text(message)
                .foregroundStyle(isMe ? .black : .textcolor)
                .font(.callout)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isMe ? Color.emerald : Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $displayMessageReport) {
            ChatMessageReportView(
                chatId: chatViewModel.chat?.id ?? "",
                chatName: chatViewModel.chat?.chatName ?? "",
                messageId: messageId,
                againstUserId: userId,
                byUserId: userViewModel.user?.id ?? "",
                reportAgainstUsername: username,
                displayMessageReport: $displayMessageReport
            )
        }
        .contextMenu {
            Button {
                displayMessageReport = true
            } label: {
                Text("Report")
            }
            Button {
                displayAlert = true
            } label: {
                Text("Block")
            }
        }
        .alert("Are you sure you want to block @\(username)?", isPresented: $displayAlert) {
            Button("Yes", role: .none) {
                Task { @MainActor in
                    await userViewModel.blockUser(userId: userViewModel.user!.id, blockingUserId: userId)
                }
                
            }
            Button("Cancel", role: .cancel) {
                displayAlert = false
            }
        }
    }
}
