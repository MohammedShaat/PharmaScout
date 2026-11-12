//
//  CodeRequestSuccessView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/16/26.
//

import SwiftUI

struct CodeRequestSuccessView: View {
    let subtitle: String
    let copyableTitle: String?
    let copyableValue: String?
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            BigIconView(systemName: "checkmark", iconColor: .theme.green, bgColor: .theme.mintTint)
            
            Text("Request sent")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            Text(subtitle)
                .foregroundStyle(.theme.textSecondary)
            
            if let copyableTitle, let copyableValue {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
                        Text(copyableTitle)
                            .foregroundStyle(.theme.primaryPressed)
                        
                        Text(copyableValue)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.theme.textPrimary)
                    }
                    .font(.subheadline)
                    
                    Label("copy", systemImage: "doc.on.doc")
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.textPrimary)
                        .padding(DesignSystem.Spacing.small)
                        .roundedBackground(radius: DesignSystem.CornerRadius.small)
                        .clickable { UIPasteboard.general.string = copyableValue }
                }
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .theme.disabledBackground)
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
        .shadow(color: .theme.green, radius: 5)
    }
}

#Preview {
    CodeRequestSuccessView(
        subtitle: "Your application is under review. We’ll take you to your application status.",
        copyableTitle: "Your application ID",
        copyableValue: "PS-APP-8F3A21C4-9B7E-4D0A-A6E1-2C5B90F7D314"
    )
    .padding()
}


extension CodeRequestSuccessView {
    init(subtitle: String) {
        self.init(subtitle: subtitle, copyableTitle: nil, copyableValue: nil)
    }
}
