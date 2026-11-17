//
//  PharmacyRejectionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct PharmacyRejectionView: View {
    let pharmacyName: String
    @Binding var selection: PharmacyRejectionReason?
    @Binding var explanation: String
    let minCharacters: Int
    let isDisabled: Bool
    let isLoading: Bool
    var onRejectTapped: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                SheetHeaderView(title: pharmacyName) { dismiss() }
                
                instruction
                
                options
                
                if selection == .other {
                    explanationTextField
                }

                Spacer()
                rejectButton
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
    }
    
    private var instruction: some View {
        Text("Explain why this application is being rejected. The pharmacy may use this information to correct its application and resubmit.")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.theme.staleGray)
    }
    
    private var options: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            ForEach(PharmacyRejectionReason.allCases) { reason in
                RadioView(title: reason.title, isSelected: selection == reason) {
                    selection = reason
                }
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(
                    radius: DesignSystem.CornerRadius.small,
                    showBorder: true,
                    borderColor: selection == reason ? .theme.primary : .theme.disabledBackground,
                    borderWidth: selection == reason ? 3 : 1.5
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var rejectButton: some View {
        PrimaryButtonView(title: "Reject", isDisabled: isDisabled, isLoading: isLoading,bgColor: .theme.red , action: onRejectTapped)
    }
    
    private var explanationTextField : some View {
        VStack(spacing: DesignSystem.Spacing.xxSmall) {
            TextFieldView(title: $explanation, placeholder: "Explain the reason of rejection", axis: .vertical, minHeight: 150)
            
            Text("Minimum \(minCharacters) characters")
                .font(.footnote)
                .foregroundStyle(.theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    @State @Previewable var reason: PharmacyRejectionReason?
    @State @Previewable var explanation: String = ""
    
    VStack {
        Text("")
            .sheet(isPresented: .constant(true)) {
                PharmacyRejectionView(
                    pharmacyName: "Al-Shifa Pharmacy",
                    selection: $reason,
                    explanation: $explanation,
                    minCharacters: 10,
                    isDisabled: false,
                    isLoading: false
                )
            }
    }
}
