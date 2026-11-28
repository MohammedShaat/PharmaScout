//
//  PharmacyStatusView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct PharmacyStatusView: View {
    let status: PharmacyStatus
    
    var body: some View {
        HStack {
            switch status {
            case .approved: Image(systemName: "checkmark.circle")
            case .rejected: Image(systemName: "xmark.circle")
            case .pending: Image(systemName: "clock")
            case .suspended: Image(systemName: "pause.circle")
            case .closed: Image(systemName: "lock")
            }
            
            Text(status.title)
        }
        .foregroundStyle(status.color)
        .capsuleBackground(background: status.surfaceColor)
    }
}


extension PharmacyStatus {
    var color: Color {
        switch self {
        case .approved: .theme.green
        case .pending: .theme.goldenBrown
        case .rejected: .theme.red
        case .suspended: .theme.orange
        case .closed: .theme.blueGray
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .approved: .theme.greenBackground
        case .pending: .theme.goldenBrownBackground
        case .rejected: .theme.redBackground
        case .suspended: .theme.orangeBackground
        case .closed: .theme.offWhite
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        PharmacyStatusView(status: .approved)
        PharmacyStatusView(status: .pending)
        PharmacyStatusView(status: .rejected)
        PharmacyStatusView(status: .suspended)
        PharmacyStatusView(status: .closed)
    }
}
