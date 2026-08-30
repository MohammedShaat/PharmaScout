//
//  PrimaryButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct PrimaryButtonLabelView: View {
    let title: String
    var isDisabled: Bool = false
    var isLoading: Bool = false
    
    var body: some View {
        HStack(spacing: Spacing.large) {
            RingProgressView(isActive: isLoading)
                .tint(.theme.onPrimary)
                .opacity(isLoading ? 1 : 0)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(isDisabled ? .theme.disabledContent : .theme.onPrimary)
                .fixedSize()
                .frame(maxWidth: .infinity)
            
            Text("")
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(isDisabled ? .theme.disabledBackground : .theme.primary)
        .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
        .opacity(isLoading ? 0.89 : 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButtonLabelView(title: "Get Started")
        
        PrimaryButtonLabelView(title: "Get Started", isDisabled: true)
        
        PrimaryButtonLabelView(title: "Get Started", isLoading: true)
    }
        .padding()
}
