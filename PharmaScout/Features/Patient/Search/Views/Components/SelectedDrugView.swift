//
//  SelectedDrugView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct SelectedDrugView: View {
    let selectedDrug: SelectedDrug
    var onCancelTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            PillIconView()
                .font(.system(size: 17))
                .fontWeight(.medium)
                .foregroundStyle(.theme.textPrimary)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(selectedDrug.genericDrug.genericName)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .lineLimit(1)
                
                Text("\(selectedDrug.formulation.strength) · \(selectedDrug.formulation.form)")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
            }
            Spacer()
            Image(.trash)
                .foregroundStyle(.theme.error)
                .padding(DesignSystem.Spacing.medium)
                .background(.theme.background.opacity(0.0001))
                .clickable(action: onCancelTapped)
        }
        .padding(DesignSystem.Spacing.medium)
        .background(.theme.surface)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
    }
}

#Preview {
    SelectedDrugView(selectedDrug: .samples[0])
}
