//
//  AddressAndDistance.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyAddressAndDistanceView: View {
    let pharmacy: Pharmacy
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text(pharmacy.address)
                Spacer()
                Text(pharmacy.distanceMeters.meterToKilometer.formatted(.number.precision(.fractionLength(2))))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PharmacyAddressAndDistanceView(pharmacy: .samples[0])
}
