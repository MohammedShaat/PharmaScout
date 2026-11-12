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
        CustomSegmentPickerView(
            selection: .init(
                get: { response },
                set: { newValue in
                    if let newValue { onResponseChanged(newValue) }
                }
            ),
            options: InquiryResponse.allCases
        ) { response in
            VStack(spacing: DesignSystem.Spacing.medium) {
                InquiryResponseIconView(response: response)
                
                Text(response.title)
            }
        }
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
    @State @Previewable var response: InquiryResponse? = nil
    
    InquiryResponseFlowView(
        response: response,
        onResponseChanged: { response = $0 },
        substituteSelectedDrug: nil,
        onChooseSubstituteTapped: {},
        onSubstituteSelectedDrugTapped: {}
    )
}
