//
//  SwipyView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI
import Swipy

struct SwipyView<Content: View>: View {
    @Binding var isSwipingAnItem: Bool
    @ViewBuilder var content: Content
    var onDeleteTapped: (() -> Void)? = nil
    
    var body: some View {
        Swipy(
            isSwipingAnItem: $isSwipingAnItem,
            swipeActionsMargin: SwipyHorizontalMargin(
                leading: DesignSystem.Spacing.xSmall,
                trailing: DesignSystem.Spacing.xSmall
            ),
            swipeBehavior: .straight
        ) { model in
            content
            
        } actions: {
            SwipyAction { model in
                Button(role: .destructive) {
                    onDeleteTapped?()
                    model.unswipe()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    VStack {
        ForEach(0...5, id:\.self) { i in
            SwipyView(
                isSwipingAnItem: .constant(false)) {
                    Text("Item \(i + 1)")
                } onDeleteTapped: {
                    
                }
        }
    }
    
}
