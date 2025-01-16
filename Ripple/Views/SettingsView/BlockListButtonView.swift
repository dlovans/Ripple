//
//  BlockListButtonView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-15.
//

import SwiftUI

struct BlockListButtonView: View {
    @Binding var disableInputs: Bool
    @Binding var navigateToBlockList: Bool
    
    var body: some View {
        Button {
            navigateToBlockList = true
        } label: {
            HStack {
                Group {
                    Spacer()
                    Text("Blocked Users")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.textcolor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(disableInputs ? .gray : .orange)
            .disabled(disableInputs)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
