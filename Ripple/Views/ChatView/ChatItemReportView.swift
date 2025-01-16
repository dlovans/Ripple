//
//  ChatReportView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-01.
//

import SwiftUI

struct ChatItemReportView: View {
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @EnvironmentObject private var reportViewModel: ReportViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    let chatId: String
    let chatName: String
    let reportAgainstUserId: String
    let reportByUserId: String
    
    @Binding var displayChatReport: Bool
    
    @State private var reportCategory: ReportCategory = .offensiveContent
    @State private var reportDescription: String = ""
    @State private var disableButtons: Bool = false
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack (spacing: 20) {
                HStack (spacing: 5) {
                    Text("Reporting:")
                        .fontWeight(.bold)
                        .foregroundStyle(.textcolor)
                    Text(chatName)
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Report Category")
                        .foregroundStyle(.textcolor)
                    Spacer()
                    Picker("", selection: $reportCategory) {
                        ForEach(ReportCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category)
                                .foregroundStyle(.textcolor)
                        }
                    }
                    .tint(.textcolor)
                    .preferredColorScheme(.dark)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.stone)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.emerald, lineWidth: 2)
                }
                
                TextField("Why are you reporting this chat?", text: $reportDescription, axis: .vertical)
                    .lineLimit(10, reservesSpace: true)
                    .padding()
                    .background(.stone)
                    .foregroundStyle(.textcolor)
                    .preferredColorScheme(.dark)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.emerald, lineWidth: 2)
                    }
                
                HStack {
                    Button {
                        Task {
                            await reportViewModel.createChatReport(chatId: chatId, chatCreatedById: reportAgainstUserId, reportById: userViewModel.user?.id ?? "", reportContent: reportDescription, reportType: ReportType.chat)
                        }
                    } label: {
                        Text("Report")
                    }
                    .disabled(reportDescription.isEmpty || disableButtons)
                    
                    
                    Button {
                        displayChatReport = false
                    } label: {
                        Text("Close")
                    }
                    .disabled(disableButtons)
                    
                }
            }
            .padding()
            .padding(.top, 40)
            .frame(maxHeight: .infinity, alignment: .top)
            .onDisappear {
                reportDescription = ""
            }
        }
    }
}
