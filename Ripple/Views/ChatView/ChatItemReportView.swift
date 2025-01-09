//
//  ChatReportView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-01.
//

import SwiftUI

struct ChatItemReportView: View {
    @Binding var displayChatReport: Bool
    let chatId: String
    let reportAgainstUserId: String
        
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    Button {
                        // Create report
                    } label: {
                        Text("Report")
                    }

                    Button {
                        displayChatReport = false
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
    }
}
