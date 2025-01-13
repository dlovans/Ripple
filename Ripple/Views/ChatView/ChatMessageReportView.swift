//
//  ChatMessageReportView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-03.
//

import SwiftUI

struct ChatMessageReportView: View {
    let chatId: String
    let chatName: String
    let messageId: String
    let againstUserId: String
    let byUserId: String
    let reportAgainstUsername: String
    
    @Binding var displayMessageReport: Bool
    
    @EnvironmentObject private var reportViewModel: ReportViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @State private var reportCategory: ReportCategory = .offensivecontent
    @State private var reportDescription: String = ""
    @State private var disableButtons: Bool = false
    @State private var disableReportButton: Bool = false
    @State private var reportButtonText: String = "Report"
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack (spacing: 20) {
                HStack (spacing: 5) {
                    Text("Reporting:")
                        .fontWeight(.bold)
                    Text("@\(reportAgainstUsername)")
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Report Category")
                        .foregroundStyle(.textcolor)
                    Spacer()
                    Picker("Report Category", selection: $reportCategory) {
                        ForEach(ReportCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category)
                                .foregroundStyle(.textcolor)
                        }
                    }
                    .tint(.textcolor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.stone)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.emerald, lineWidth: 2)
                }
                
                TextField("Why are you reporting this user?", text: $reportDescription, axis: .vertical)
                    .lineLimit(8, reservesSpace: true)
                    .background(Color.stone)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.emerald, lineWidth: 2)
                    }
                
                VStack {
                    Button {
                        Task {
                            disableButtons = true
                            disableReportButton = true
                            let status = await reportViewModel.createMessageReport(chatId: chatId, messageId: messageId, againstUserId: againstUserId, byUserId: byUserId, reportContent: reportDescription, reportType: .message)
                            reportButtonText = status.rawValue
                            if status == .reportsuccess {
                                disableButtons = false
                            } else {
                                disableButtons = false
                            }
                        }
                    } label: {
                        Text(reportButtonText)
                            .foregroundStyle(.textcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(disableButtons || disableReportButton || reportDescription.isEmpty ? .gray : .emerald)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(disableReportButton || disableButtons || reportDescription.isEmpty)

                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .foregroundStyle(.textcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(disableButtons ? .gray : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(disableButtons)
                }
            }
            .padding()
            .padding(.top, 40)
            .frame(maxHeight: .infinity, alignment: .top)
            .onDisappear {
                reportDescription = ""
                disableButtons = false
                disableReportButton = false
                reportButtonText = "Report"
                displayMessageReport = false
            }
            
        }
    }
}
