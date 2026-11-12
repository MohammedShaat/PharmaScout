//
//  InquiryResponseFlowView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct InquiryResponseFlowView: View {
    let response: InquiryResponse?
    let onResponseChanged: (InquiryResponse) -> Void
    let substituteSelectedDrug: SelectedDrug?
    let onChooseSubstituteTapped: () -> Void
    let onSubstituteSelectedDrugTapped: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            responseOptions
            
            if response == .substitute {
                choosingSubstitute
            }
        }
        .padding(.vertical, DesignSystem.Spacing.large)
    }
    
    private var responseOptions: some View {
        HStack(spacing: 0) {
            ForEach(InquiryResponse.allCases) { responseCase in
                VStack(spacing: DesignSystem.Spacing.medium) {
                    InquiryResponseIconView(response: responseCase)
                    
                    Text(responseCase.title)
                }
                .font(.callout)
                .fontWeight(response == responseCase ? .bold : .regular)
                .foregroundStyle(response == responseCase ? .theme.textPrimary : .theme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(DesignSystem.Spacing.small)
                .roundedBackground(
                    background: response == responseCase ? .theme.surface : .clear,
                    radius: DesignSystem.CornerRadius.small
                )
                .clickable { onResponseChanged(responseCase) }
            }
        }
        .padding(DesignSystem.Spacing.xSmall)
        .roundedBackground(background: .theme.disabledBackground, radius: DesignSystem.CornerRadius.small)
    }
    
    @ViewBuilder
    private var choosingSubstitute: some View {
        if substituteSelectedDrug == nil {
            Text("Choose a substitute medicine")
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .disclosureIndicator()
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .theme.surface, radius: DesignSystem.CornerRadius.small)
                .clickable {
                    onChooseSubstituteTapped()
                }
        } else if let substituteSelectedDrug {
            HStack(spacing: 0) {
                SubstituteView(
                    genericName: substituteSelectedDrug.genericDrug.genericName,
                    strength: substituteSelectedDrug.formulation.strength,
                    form: substituteSelectedDrug.formulation.form
                )
                
                Spacer()
                Text("Change")
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(DesignSystem.Spacing.medium)
                    .capsuleBackground()
                    .clickable {
                        onSubstituteSelectedDrugTapped()
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(background: .theme.blueBackground, radius: DesignSystem.CornerRadius.small)
        }
    }
}

#Preview {
    InquiryResponseFlowView(
        response: nil,
        onResponseChanged: {_ in},
        substituteSelectedDrug: nil,
        onChooseSubstituteTapped: {},
        onSubstituteSelectedDrugTapped: {}
    )
}
