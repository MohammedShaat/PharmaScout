//
//  ContinuationView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct ContinuationView: View {
    @Binding var distanceMeters: Double
    let minDistanceMeters: Double
    let maxDistanceMeters: Double
    let search: Search?
    let continueSearchLoadingState: LoadingState
    var onContinueSearchTapped: (() -> Void)? = nil
    
    @State private var showingExpandRadius: Bool = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xLarge) {
            // Info
            HStack(spacing: DesignSystem.Spacing.small) {
                Image(systemName: "arrow.right.circle")
                    .foregroundStyle(.theme.goldenBrown)
                    .padding(DesignSystem.Spacing.medium)
                    .roundedBackground(background: .theme.goldenBrownBackground)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Your reply is needed to continue")
                        .fontWeight(.heavy)
                        .foregroundStyle(.theme.textPrimary)
                    
                    Group {
                        if let search = search {
                            let radius = search.radiusMeters
                            let notFoundCount = search.drugsCount - search.fulfilledDrugsCount
                            Text("\(notFoundCount) medicines were not found within \(radius.formattedDistance)")
                        } else {
                            Text("some medicines were not found within the current radius.")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Distance slider
            if showingExpandRadius {
                DistanceSliderView(
                    distance: $distanceMeters,
                    minDistance: minDistanceMeters,
                    maxDistance: maxDistanceMeters
                )
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: .theme.mintTint, radius: DesignSystem.CornerRadius.small)
            } else {
                Text("Expand search distance?")
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.green)
                    .clickable { showingExpandRadius = true }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let error = continueSearchLoadingState.error {
                Text(error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Continue Search",
                isLoading: continueSearchLoadingState.status != .idle,
                action: onContinueSearchTapped
            )
        }
    }
}

#Preview {
    @State @Previewable var distance: Double = 6_000
    
    CustomNavStack {
        ContinuationView(
            distanceMeters: $distance,
            minDistanceMeters: 2_000,
            maxDistanceMeters: 50_000,
            search: .samples[0],
            continueSearchLoadingState: LoadingState(),
        )
        .padding()
    }
}
