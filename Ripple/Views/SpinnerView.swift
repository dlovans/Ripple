//
//  ProgressView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-21.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(edges: .all)
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .emerald))
              .scaleEffect(2.0, anchor: .center)
        }
    }
}

#Preview {
    SpinnerView()
}
