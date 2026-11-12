//
//  SubstituteView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct SubstituteView: View {
    let genericName: String
    let strength: String
    let form: String
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            InquiryResponseIconView(response: .substitute)
                .foregroundStyle(.theme.blue)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                Text("Substitute medicine")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.blue)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(genericName)
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.primary)
                    
                    Text(strength)
                        .font(.callout)
                        .foregroundStyle(.theme.textPrimary)
                    
                    Text(form)
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                }
            }
        }
    }
}

#Preview {
    SubstituteView(genericName: "Amoxicillin", strength: "400 mg", form: "Tablet")
}
