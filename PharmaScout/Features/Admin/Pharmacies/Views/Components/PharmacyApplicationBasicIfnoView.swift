//
//  PharmacyApplicationDetailIfnoView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct PharmacyApplicationBasicIfnoView: View {
    let pharmacyApplication: PharmacyApplication
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            statusAndIcon
            
            nameAddressTimezone
            
            staticMapPreview
        }
    }
    
    private var statusAndIcon: some View {
        HStack {
            IconView(size: 44) {
                Image(.pharmacy)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            PharmacyStatusView(status: pharmacyApplication.status)
                .font(.callout)
                .fontWeight(.bold)
        }
        .padding(DesignSystem.Spacing.large)
    }
    
    private var nameAddressTimezone: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text(pharmacyApplication.name)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
            
            Group {
                Label {
                    Text(pharmacyApplication.address)
                } icon: {
                    Image(.location)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                
                Label {
                    if let territory = pharmacyApplication.timezone.lastAfterSlash {
                        Text("\(territory) time")
                            .foregroundStyle(.theme.textPrimary)
                            .fontWeight(.bold)
                        +
                        Text(" · \(pharmacyApplication.timezone)")
                            .foregroundStyle(.theme.staleGray)
                    } else {
                        Text(pharmacyApplication.timezone)
                    }
                } icon: {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundStyle(.theme.staleGray)
                }
            }
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.theme.textPrimary)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DesignSystem.Spacing.large)
    }
    
    private var staticMapPreview: some View {
        StaticMapPreview()
            .frame(height: 112)
            .frame(maxWidth: .infinity)
            .background(.blue.opacity(0.2))
    }
}

#Preview {
    let pharmacyApplication = PharmacyApplication.samples[0]
    
    CustomNavStack {
        PharmacyApplicationBasicIfnoView(pharmacyApplication: pharmacyApplication)
            .roundedBackground(
                showBorder: true,
                borderColor: pharmacyApplication.status == .pending ? PharmacyStatus.pending.color : .theme.disabledBackground
            )
            .padding()
    }
}
