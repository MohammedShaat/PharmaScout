//
//  EmptyIconVIew.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import SwiftUI

struct EmptyIconView<Icon: View>: View {
    @ViewBuilder let emptyIcon: Icon
    
    var body: some View {
        Group {
            if Icon.self == EmptyView.self {
                Image(.magnifyingglassCross)
                    .resizable()
                    .scaledToFit()
            } else {
                emptyIcon
            }
        }
        .frame(width: 34)
        .padding(14)
        .roundedBackground(showBorder: true)
        .padding(6)
        .overlay {
            Circle()
                .stroke(
                    .theme.disabledContent,
                    style: .init(lineWidth: 1, dash: [3])
                )
        }
        .padding(18)
        .overlay {
            Circle()
                .stroke(
                    .theme.disabledContent,
                    style: .init(lineWidth: 1, dash: [3])
                )
        }
    }
}

#Preview {
    EmptyIconView()
}


extension EmptyIconView {
    init() where Icon == EmptyView {
        self.init(emptyIcon: { EmptyView() })
    }
}
