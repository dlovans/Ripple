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
    
    @State var displayMessageReport: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("@\(username)")
                .foregroundStyle(isMe ? .black : .textcolor)
                .font(.subheadline)
            Text(message)
                .foregroundStyle(isMe ? .black : .textcolor)
                .font(.callout)
            //            if userViewModel.user?.id != userId {
            HStack {
                Button {
                    displayMessageReport = true
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
            //            }
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
    }
}
