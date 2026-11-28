//
//  SearchStatusIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct SearchStatusView: View {
    let status: SearchStatus
    
    var body: some View {
        HStack {
            switch status {
            case .fulfilled: Image(systemName: "checkmark.circle")
            case .awaitingContinuation: Image(systemName: "arrow.right.circle")
            case .partiallyFulfilled: Image(systemName: "circle.lefthalf.filled")
            case .unfulfilled: Image(systemName: "xmark.circle")
            case .pending: Image(systemName: "clock")
            }
            
            Text(status.title)
        }
        .foregroundStyle(status.color)
        .capsuleBackground(background: status.surfaceColor)
    }
}

extension SearchStatus {
    var color: Color {
        switch self {
        case .fulfilled: .theme.green
        case .awaitingContinuation: .theme.goldenBrown
        case .unfulfilled: .theme.red
        case .pending: .theme.blue
        default: .theme.primary
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .fulfilled: .theme.greenBackground
        case .awaitingContinuation: .theme.goldenBrownBackground
        case .unfulfilled: .theme.redBackground
        case .pending: .theme.blueBackground
        default: .theme.disabledBackground
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20) {
            SearchStatusView(status: .fulfilled)
            SearchStatusView(status: .pending)
            SearchStatusView(status: .unfulfilled)
            SearchStatusView(status: .awaitingContinuation)
            SearchStatusView(status: .partiallyFulfilled)
        }
    }
}
