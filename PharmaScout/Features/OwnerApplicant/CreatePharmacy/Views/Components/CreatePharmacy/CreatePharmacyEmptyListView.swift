//
//  CreatePharmacyEmptyListView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct CreatePharmacyEmptyListView: View {
    let systemName: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let onButtonTapped: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            IconView(systemName: systemName, size: 44, iconColor: .theme.blueGray)
            
            Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.theme.blueGray)
            
            SecondaryButtonView(title: buttonTitle, systemName: "plus", color: .theme.textPrimary, action: onButtonTapped)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
}

#Preview {
    CreatePharmacyEmptyListView(
        systemName: "phone",
        title: "No contact info yet",
        subtitle: "Add a phone number, email, or website so patients can reach you.",
        buttonTitle: "Add contact",
        onButtonTapped: {}
    )
}
