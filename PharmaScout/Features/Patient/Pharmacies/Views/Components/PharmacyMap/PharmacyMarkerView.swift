//
//  UserLocationMarkerView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct PharmacyMarkerView<Label: View>: View {
    @ViewBuilder let label: Label
    
    @State private var pinSize: CGSize = .zero
    @State private var labelSize: CGSize = .zero

    var body: some View {
        ZStack {
            pharmacyPin
                .readFrame { pinSize = $0.size }
            
            label
                .readFrame { labelSize = $0.size }
                .foregroundStyle(.theme.brightBlue)
                .offset(y: -(labelSize.height + labelSize.height * 0.5))
        }
    }
    
    private var pharmacyPin: some View {
        Image(.pinPlus)
            .resizable()
            .scaledToFill()
            .frame(width: 34)
    }

}

#Preview {
    PharmacyMarkerView {
        Text("Future Pharmacy")
    }
}
