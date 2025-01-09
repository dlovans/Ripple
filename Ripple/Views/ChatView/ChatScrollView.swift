//
//  ChatScrollView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-29.
//

import SwiftUI

struct ChatScrollView: View {
    @EnvironmentObject var messageViewModel: MessageViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var autoScroll: Bool = false
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack {
                    ForEach(messageViewModel.messages.indices, id: \.self) { index in
                        ChatMessageView(
                            username: messageViewModel.messages[index].username,
                            userId: messageViewModel.messages[index].userId,
                            message: messageViewModel.messages[index].message,
                            isMe: userViewModel.user?.id == messageViewModel.messages[index].userId,
                            isPremium: messageViewModel.messages[index].isPremium,
                            messageId: messageViewModel.messages[index].id ?? ""
                        )
                        .id(messageViewModel.messages[index].id)
                        .onAppear {
                            if index <= messageViewModel.messages.count - 13 {
                                autoScroll = false
                            } else {
                                autoScroll = true
                            }
                        }
                    }
                }
                .onChange(of: messageViewModel.messages) {
                    if let lastMessage = messageViewModel.messages.last {
                        if autoScroll {
                            scrollView.scrollTo(lastMessage.id)
                        }
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        .defaultScrollAnchor(.bottom)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    ChatScrollView()
}
