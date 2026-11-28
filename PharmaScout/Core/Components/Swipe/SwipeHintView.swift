//
//  SwipeHintView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct SwipeHintView: View {
    @State private var showHint: Bool = false
    
    var body: some View {
        HStack {
            Label("Swipe left on an item to delete it", systemImage: "arrow.left.to.line")
            
            Image(systemName: "xmark")
                .clickable { showHint = false }
        }
        .foregroundStyle(.theme.textTertiary)
        .padding(DesignSystem.Spacing.medium)
        .roundedBackground(background: .theme.disabledBackground)
        .opacity(showHint ? 1 : 0)
        .animation(.default, value: showHint)
        .task {
            try? await Task.sleep(for: .seconds(0.5))
            showHint = true
        }
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        SwipeHintView()
    }
}
