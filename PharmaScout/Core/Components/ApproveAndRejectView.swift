//
//  ApproveAndRejectView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

struct ApproveAndRejectView: View {
    @Binding var selection: Bool?
    let approveSubtitle: String
    let rejectSubtitle: String
    let isDisabled: Bool = false
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.large) {
            item(
                systemName: "checkmark.circle",
                title: "Approve",
                subtitle: approveSubtitle,
                isSelected: selection == true,
                color: .theme.green
            )
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(
                background: .background.opacity(0.001),
                showBorder: true,
                borderColor: selection == true ? .theme.green : .theme.disabledBackground,
                borderWidth: selection == true ? 3 : 1.5
            )
            .clickable(isDisabled: isDisabled) {
                selection = true
            }
            
            item(
                systemName: "xmark.circle",
                title: "Reject",
                subtitle: rejectSubtitle,
                isSelected: selection == false,
                color: .theme.red
            )
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(
                background: .background.opacity(0.001),
                showBorder: true,
                borderColor: selection == false ? .theme.red : .theme.disabledBackground,
                borderWidth: selection == false ? 3 : 1.5
            )
            .clickable(isDisabled: isDisabled) {
                selection = false
            }
        }
    }
    
    private func item(
        systemName: String,
        title: String,
        subtitle: String,
        isSelected: Bool,
        color: Color,
    ) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            VStack(spacing: DesignSystem.Spacing.small) {
                if isSelected {
                    Label("Selected", systemImage: "checkmark")
                        .font(.caption)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Image(systemName: systemName)
                    .foregroundStyle(isSelected ? color : .theme.textPrimary)
                    .circleBackground(background: .theme.mintTint, padding: DesignSystem.Spacing.small)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .fontWeight(.semibold)
            
            Text(title)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
            
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.theme.staleGray)
        }
    }
}

#Preview {
    let approveSubtitle = "The applicant becomes a pharmacy owner."
    let rejectSubtitle = "The applicant won't become a pharmacy owner."
    
    CustomNavStack {
        ScrollView {
            VStack(spacing: 70){
                ApproveAndRejectView(selection: .constant(true), approveSubtitle: approveSubtitle, rejectSubtitle: rejectSubtitle)
                
                ApproveAndRejectView(selection: .constant(false), approveSubtitle: approveSubtitle, rejectSubtitle: rejectSubtitle)
                
                ApproveAndRejectView(selection: .constant(nil), approveSubtitle: "", rejectSubtitle: "")
            }
        }
        .padding()
    }
}

