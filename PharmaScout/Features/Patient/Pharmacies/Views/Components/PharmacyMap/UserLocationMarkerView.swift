//
//  UserLocationMarkerView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct UserLocationMarkerView<Label: View>: View {
    @ViewBuilder let label: Label
    
    @State private var pinSize: CGSize = .zero
    @State private var labelSize: CGSize = .zero

    var body: some View {
        ZStack {
            userPin
                .readFrame { pinSize = $0.size }
            
            label
                .readFrame { labelSize = $0.size }
                .foregroundStyle(.theme.brightBlue)
                .offset(
                    x: -(labelSize.width),
                    y: labelSize.height + labelSize.height * 0.5
                )
        }
    }
    
    private var userPin: some View {
        Circle()
            .fill(.theme.brightBlue.opacity(0.2))
            .frame(width: 45)
            .padding(-15)
            .overlay {
                Circle()
                    .fill(.theme.white)
                    .padding(-3)
                    .overlay {
                        Circle()
                            .fill(.theme.brightBlue)
                    }
            }
    }
}

#Preview {
    UserLocationMarkerView {
        Text("Me")
    }
}
