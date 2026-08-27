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
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(isDisabled ? .theme.disabledContent : .theme.onPrimary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isDisabled ? .theme.disabledBackground : .theme.primary)
            .clipShape(.rect(cornerRadius: DesignSystem.cornerRadius))
        
    }
}

#Preview {
    PrimaryButtonLabelView(title: "Get Started")
        .padding()
}
