//
//  StartPromptView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct StartPromptView: View {
    var body: some View {
        NavigationLink("Start") {
            ChatView()
                .navigationBarBackButtonHidden(true)
        }
        .foregroundStyle(.emerald)
    }
}

#Preview {
    StartPromptView()
}
