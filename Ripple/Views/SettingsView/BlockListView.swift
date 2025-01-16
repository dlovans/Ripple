//
//  BlockListView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-14.
//

import SwiftUI

struct BlockListView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var usernames: [String: String] = [:]
    @State private var usernamesLoading: Bool = true
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(edges: .all)
            if usernamesLoading {
                SpinnerView()
            } else {

                VStack (spacing: 30) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        if usernames.isEmpty {
                            Text("No blocked users found")
                                .foregroundStyle(.textcolor)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(usernames.keys.sorted(), id: \.self) { blockedUserId in
                                        HStack {
                                            if let username = usernames[blockedUserId] {
                                                Text(username)
                                                    .foregroundStyle(.stone)
                                            } else {
                                                Text("Unknown User")
                                            }
                                            Spacer()
                                            Button {
                                                Task { @MainActor in
                                                    await userViewModel.unblockUser(userId: userViewModel.user?.id ?? "", blockedUserId: blockedUserId)
                                                }
                                            } label: {
                                                Text("Unblock")
                                                    .foregroundStyle(.stone)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal)
                                                    .background(.orange)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(10)
                                        .background(.emerald)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: usernames.isEmpty ? .center : .top)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
        .onAppear {
            Task { @MainActor in
                self.usernames = await userViewModel.getBlockedUsernames()
                usernamesLoading = false
            }
        }
        .onChange(of: userViewModel.user?.blockedUserIds) {_, newValue in
            Task { @MainActor in
                self.usernames = await userViewModel.getBlockedUsernames()
            }
        }
    }
}

#Preview {
    BlockListView()
}
