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
    @State private var reportCategory: ReportCategory = .offensivecontent
    @State private var reportDescription: String = ""
    
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
                    .preferredColorScheme(.dark)
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
                        // Create report
                    } label: {
                        Text("Report User")
                            .foregroundStyle(.textcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.emerald)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Button {
                        // Report and block user
                    } label: {
                        Text("Report and Block User")
                            .foregroundStyle(.textcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Button {
                        displayMessageReport = false
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.textcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
            }
            .padding()
            .padding(.top, 40)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
