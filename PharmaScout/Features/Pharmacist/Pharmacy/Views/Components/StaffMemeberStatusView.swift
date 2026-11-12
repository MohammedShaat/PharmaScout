//
//  StaffMemeberStatusView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct StaffMemeberStatusView: View {
    let status: PharmacyStaffStatus
    
    var body: some View {
        HStack {
            switch status {
            case .approved: Image(systemName: "checkmark.circle")
            case .rejected: Image(systemName: "xmark.circle")
            case .pending: Image(systemName: "clock")
            case .suspended: Image(systemName: "pause.circle")
            }
            
            Text(status.title)
        }
        .foregroundStyle(status.color)
        .capsuleBackground(background: status.surfaceColor)
    }
}

extension PharmacyStaffStatus {
    var color: Color {
        switch self {
        case .approved: .theme.green
        case .pending: .theme.goldenBrown
        case .rejected: .theme.red
        case .suspended: .theme.orange
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .approved: .theme.greenBackground
        case .pending: .theme.goldenBrownBackground
        case .rejected: .theme.redBackground
        case .suspended: .theme.orangeBackground
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20) {
            StaffMemeberStatusView(status: .pending)
            StaffMemeberStatusView(status: .approved)
            StaffMemeberStatusView(status: .suspended)
            StaffMemeberStatusView(status: .rejected)
        }
    }
}
