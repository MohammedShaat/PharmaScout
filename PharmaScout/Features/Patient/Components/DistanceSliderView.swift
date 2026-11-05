//
//  DistanceSliderView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import SwiftUI

struct DistanceSliderView: View {
    @Binding var distance: Double
    let minDistance: Double
    let maxDistance: Double
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text("Pharmacies within")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.theme.textSecondary)
                Spacer()
                Text(distance.formattedDistance)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
            }
            
            Slider(value: $distance, in: minDistance...maxDistance, step: 1_000)
                .tint(.theme.primary)

            HStack {
                Text(minDistance.formattedDistance)
                Spacer()
                Text(maxDistance.formattedDistance)
            }
            .font(.footnote)
            .foregroundStyle(.theme.textSecondary)
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
}

#Preview {
    @State @Previewable var distance = 5_000.0
    
    DistanceSliderView(distance: $distance, minDistance: 1_000, maxDistance: 5_000)
}
