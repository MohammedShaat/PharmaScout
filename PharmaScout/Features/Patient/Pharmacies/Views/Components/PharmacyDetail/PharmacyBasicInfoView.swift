//
//  PharmacyBackInfoView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct PharmacyBasicInfoView: View {
    let pharmac: Pharmacy
    var onSeeLocationTapped: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            openStatus
            
            addressAndDistanct
            
            staticMapPreview
            
            seeLocationButton
        }
        .padding(.vertical, DesignSystem.Spacing.large)
    }
    
    private var openStatus: some View {
        Label(
            pharmac.isOpen ? "Open now" : "Close" ,
            systemImage: pharmac.isOpen ? "checkmark.circle" : "moon"
        )
        .font(.subheadline)
        .fontWeight(.bold)
        .foregroundStyle(pharmac.isOpen ? .theme.green : .theme.red)
        .padding(DesignSystem.Spacing.small)
        .background(pharmac.isOpen ? .theme.greenBackground : .theme.redBackground)
        .clipShape(.capsule)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var addressAndDistanct: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            Label(pharmac.address, image: .location)
                .foregroundStyle(.theme.textPrimary)
            
            Label(
                title: {
                    Text("\(pharmac.distanceMeters.formattedDistance) away")
                        .fontWeight(.bold)
                },
                icon: { Image(systemName: "location") }
            )
            .foregroundStyle(.theme.green)
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var staticMapPreview: some View {
        VStack {
            Image(.location)
                .frame(width: 22)
                .foregroundStyle(.theme.onPrimary)
                .padding(DesignSystem.Spacing.large)
                .background(.theme.primary)
                .clipShape(.circle)
        }
        
        .frame(height: 112)
        .frame(maxWidth: .infinity)
        .background(.blue.opacity(0.2))
    }
    
    private var seeLocationButton: some View {
        HStack {
            Label {
                Text("See location on map")
                    .fontWeight(.bold)
            } icon: {
                Image(systemName: "map")
            }
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .foregroundStyle(.theme.green)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clickable(action: onSeeLocationTapped)
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 30) {
            PharmacyBasicInfoView(pharmac: .samples[0])
                .frame(maxWidth: .infinity)
                .roundedBackground()
            
            PharmacyBasicInfoView(pharmac: .samples[2])
                .frame(maxWidth: .infinity)
                .roundedBackground()
        }
        .padding()
    }
}
