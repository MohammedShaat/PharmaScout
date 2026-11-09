//
//  SearchStatusIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct SearchDrugStatusView: View {
    let status: SearchDrugStatus
    
    var body: some View {
        HStack {
            switch status {
            case .fulfilled: Image(systemName: "checkmark.circle")
            case .unfulfilled: Image(systemName: "xmark.circle")
            case .pending: Image(systemName: "clock")
            }
            
            Text(status.title)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .foregroundStyle(status.color)
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
        .roundedBackground(background: status.surfaceColor)
    }
}

extension SearchDrugStatus {
    var color: Color {
        switch self {
        case .fulfilled: .theme.green
        case .unfulfilled: .theme.red
        case .pending: .theme.blue
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .fulfilled: .theme.greenBackground
        case .unfulfilled: .theme.redBackground
        case .pending: .theme.blueBackground
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20) {
            SearchDrugStatusView(status: .fulfilled)
            SearchDrugStatusView(status: .pending)
            SearchDrugStatusView(status: .unfulfilled)
        }
    }
}
