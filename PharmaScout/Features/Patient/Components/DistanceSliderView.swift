//
//  DistanceSliderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/15/26.
//

import SwiftUI

struct DistanceSliderView: View {
    @Binding var distance: Double
    let minDistanceMeters: Double
    let maxDistanceMeters: Double
    let label: String
    var step: Double = DesignSystem.Distance.step
    
    var body: some View {
        VStack {
            Text("\(label) \(distance.formattedDistance)")
            
            
            Slider(value: $distance, in: minDistanceMeters...maxDistanceMeters, step: step) {
                Text("\(label) \(distance.formattedDistance)")
                    .foregroundStyle(.theme.primary)
            } minimumValueLabel: {
                Text(minDistanceMeters.formattedDistance)
            } maximumValueLabel: {
                Text(maxDistanceMeters.formattedDistance)
            }
        }
    }
}

#Preview {
    @State @Previewable var distance: Double = 40_000
    
    DistanceSliderView(
        distance: $distance,
        minDistanceMeters: 1_000,
        maxDistanceMeters: 100_000,
        label: "Distance to search within",
        step: 1_000
    )
}
