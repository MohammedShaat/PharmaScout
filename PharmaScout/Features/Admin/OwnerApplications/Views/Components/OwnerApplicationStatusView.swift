//
//  OwnerApplicationStatusView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct OwnerApplicationStatusView: View {
    let status: OwnerApplicationStatus
    
    var body: some View {
        HStack {
            switch status {
            case .pending: Image(systemName: "clock")
            case .approved: Image(systemName: "checkmark.circle")
            case .issued: Image(systemName: "key")
            case .rejected: Image(systemName: "xmark.circle")
            case .revoked: Image(systemName: "circle.slash")
            }
            
            Text(status.title)
        }
        .foregroundStyle(status.color)
        .capsuleBackground(background: status.surfaceColor)
    }
}

extension OwnerApplicationStatus {
    var color: Color {
        switch self {
        case .approved: .theme.green
        case .issued: .theme.staleGray
        case .rejected: .theme.red
        case .pending: .theme.goldenBrown
        case .revoked: .theme.blueGray
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .approved: .theme.greenBackground
        case .issued: .theme.staleGrayBackground
        case .rejected: .theme.redBackground
        case .pending: .theme.goldenBrownBackground
        case .revoked: .theme.offWhite
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        OwnerApplicationStatusView(status: .approved)
        OwnerApplicationStatusView(status: .pending)
        OwnerApplicationStatusView(status: .issued)
        OwnerApplicationStatusView(status: .rejected)
        OwnerApplicationStatusView(status: .revoked)
    }
}
