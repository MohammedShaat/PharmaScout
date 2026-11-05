//
//  ConfiguredSearchView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct ConfiguredSearchView: View {
    let selectedDrugs: [SelectedDrug]
    let canAdd: Bool
    var onAddTapped: (() -> Void)? = nil
    var onCancelTapped: ((String) -> Void)? = nil
    var onSelectedDrugTapped: ((SelectedDrug) -> Void)? = nil
    
    @Binding var acceptSubstitutes: Bool
    @Binding var fulfilmentMode: FulfilmentMode
    
    @Binding var distanceMeters: Double
    let minDistance: Double
    let maxDistance: Double
    
    let isCreatingSearchRequest: Bool
    let canStartSearch: Bool
    var onStartTapped: (() -> Void)? = nil
    
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xLarge) {
            selectedDrugListSection
            
            substituteSection
            
            fulfilmentModeSection
            
            distanceSection
            
            startSearchSection
        }
    }
    
    private var selectedDrugListSection: some View {
        VStack {
            SectionHeaderWithActionView(
                title: "MEDICINE · \(selectedDrugs.count)",
                actionName: "Add",
                isActionDisabled: !canAdd,
                icon: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.theme.textPrimary)
                },
                onActionTapped: onAddTapped
            )
            
            VStack(spacing: DesignSystem.Spacing.large) {
                ForEach(selectedDrugs) { selectedDrug in
                    SelectedDrugView(selectedDrug: selectedDrug) {
                        onCancelTapped?(selectedDrug.id)
                    }
                    .frame(maxWidth: .infinity)
                    .clickable {
                        onSelectedDrugTapped?(selectedDrug)
                    }
                }
            }
        }
    }
    
    private var substituteSection: some View {
        SectionHeaderView(title: "Preferences") {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Accept alternatives")
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textPrimary)
                
                Toggle(isOn: $acceptSubstitutes) {
                    Text("Pharmacies may suggest a similar medicine if the exact one is out of stock.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.theme.textSecondary)
                        .padding(.trailing)
                }
                .tint(.theme.secondary)
            }
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
        }
    }
    
    private var fulfilmentModeSection: some View {
        SectionHeaderView(title: "Where to get them") {
            RadioCardView(
                isSelected: fulfilmentMode == .singlePharmacy,
                title: "One Pharmacy",
                description: "Get everything from a single pharmacy. Best for convenience.",
                icon: { Image(.housePlus) }
            )
            .clickable { fulfilmentMode = .singlePharmacy }
            
            RadioCardView(
                isSelected: fulfilmentMode == .multiPharmacy,
                title: "Several pharmacies",
                description: "Split across pharmacies to find everything faster.",
                icon: { Image(.housePlusTwins) }
            )
            .clickable { fulfilmentMode = .multiPharmacy }
        }
    }
    
    private var distanceSection: some View {
        SectionHeaderView(title: "Maximum distance") {
            DistanceSliderView(distance: $distanceMeters, minDistance: minDistance, maxDistance: maxDistance)
        }
    }

    @ViewBuilder
    private var startSearchSection: some View {
        // MARK: - Start search
        if canStartSearch {
            PrimaryButtonView(title: "Start search", isLoading: isCreatingSearchRequest) {
                onStartTapped?()
            }
        }
    }
}

#Preview {
    @State @Previewable var fullfilmentMode: FulfilmentMode = .singlePharmacy
    
    CustomNavStack {
        ScrollView {
            ConfiguredSearchView(
                selectedDrugs: SelectedDrug.samples,
                canAdd: true,
                acceptSubstitutes: .constant(true),
                fulfilmentMode: $fullfilmentMode,
                distanceMeters: .constant(40_000.0),
                minDistance: 1_000,
                maxDistance: 100_000,
                isCreatingSearchRequest: false,
                canStartSearch: true,
            )
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Search")
        }
    }
}
	
