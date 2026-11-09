//
//  SearchStatusIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct InquiryResponseView: View {
    let response: InquiryResponse
    var title: String? = nil
    
    var body: some View {
        HStack {
            switch response {
            case .available: Image(systemName: "checkmark.circle")
            case .unavailable: Image(systemName: "xmark.circle")
            case .substitute: Image(systemName: "arrow.left.arrow.right")
            }
            
            Text(title ?? response.title)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .foregroundStyle(response.color)
    }
}

extension InquiryResponse {
    var color: Color {
        switch self {
        case .available: .theme.green
        case .unavailable: .theme.red
        case .substitute: .theme.blue
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .available: .theme.greenBackground
        case .unavailable: .theme.redBackground
        case .substitute: .theme.blueBackground
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20) {
            InquiryResponseView(response: .available)
            InquiryResponseView(response: .unavailable)
            InquiryResponseView(response: .substitute)
        }
    }
}
