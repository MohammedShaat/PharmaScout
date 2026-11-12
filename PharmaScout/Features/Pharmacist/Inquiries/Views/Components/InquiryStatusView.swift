//
//  InquiryStatusView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct InquiryStatusView: View {
    let status: InquiryStatus
    
    var body: some View {
        HStack {
            switch status {
            case .pending: Image(systemName: "clock")
            case .answered: Image(systemName: "checkmark.circle")
            case .expired: Image(systemName: "clock.badge.xmark")
            }
            
            Text(status.title)
        }
        .foregroundStyle(status.color)
        .capsuleBackground(background: status.surfaceColor)
    }
}

extension InquiryStatus {
    var color: Color {
        switch self {
        case .pending: .theme.goldenBrown
        case .answered: .theme.green
        case .expired: .theme.red
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .pending: .theme.goldenBrownBackground
        case .answered: .theme.greenBackground
        case .expired: .theme.redBackground
        }
    }
}

#Preview {
    ZStack {
        Color.theme.background
        
        VStack(spacing: 20) {
            InquiryStatusView(status: .answered)
            InquiryStatusView(status: .pending)
            InquiryStatusView(status: .expired)
        }
    }
}
