//
//  StartedSearchView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import SwiftUI

struct StartedSearchView: View {
    let distance: Double
    let selectedDrugs: [SelectedDrug]
    var onViewSearchTapped: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            CheckIconView()
            Spacer()
            
            descriptionSection
            
            listSection
            
            Spacer()
            Spacer()
            viewSearchButton
        }
        .padding(DesignSystem.Spacing.large)
    }
    
    private var descriptionSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            Text("Search started")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
            
            Text(
                """
                We're asking pharmacies within \(distance.formattedDistance) about \(selectedDrugs.count) medicines. We'll notify you as soon as they respond.
                """
            )
            .foregroundStyle(.theme.textSecondary)
            .multilineTextAlignment(.center)
        }
    }
    
    private var listSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            ForEach(selectedDrugs) { selectedDrug in
                Text(selectedDrug.genericDrug.genericName)
                    .foregroundStyle(.theme.textPrimary)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                if selectedDrug.id != selectedDrugs.last?.id {
                    DividerView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.large)
        .roundedBackground()
    }
    
    private var viewSearchButton: some View {
        PrimaryButtonView(title: "View search", action: onViewSearchTapped)
    }
}

#Preview {
    CustomNavStack {
        StartedSearchView(
            distance: 5_000,
            selectedDrugs: Array(SelectedDrug.samples.prefix(3)),
        )
            .padding()
    }
}
