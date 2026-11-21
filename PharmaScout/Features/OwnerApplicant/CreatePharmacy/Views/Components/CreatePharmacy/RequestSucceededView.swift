//
//  RequestSucceededView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/19/26.
//

import SwiftUI

struct RequestSucceededView: View {
    let title: String
    let subtitle: String
    var onDoneTapped: (() -> Void)? = nil
    
    @State private var sheetHeight: Double = 0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xLarge) {
            BigIconView(systemName: "checkmark.circle", iconColor: .theme.green, bgColor: .theme.greenBackground)
            
            VStack(spacing: DesignSystem.Spacing.large) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(subtitle)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.theme.blueGray)
            }
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            
            PrimaryButtonView(title: "Done", action: onDoneTapped)
        }
        .padding(DesignSystem.Spacing.xLarge)
        .readFrame { sheetHeight = $0.size.height }
        .presentationDetents([.height(sheetHeight)])
    }
}

#Preview {
    VStack {
        Text("")
            .sheet(isPresented: .constant(true)) {
                RequestSucceededView(
                    title: "Your request has been submitted",
                    subtitle: "An admin will review your pharmacy. We’ll show you the status on your Home screen."
                )
//                .presentationDetents([.height(330)])
            }
    }
}
