//
//  LocationDetectionView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct LocationDetectionView: View {
    let isLocationDetected: Bool
    let timezone: String
    @Binding var address: String
    let minAddressLength: Int
    var onAddressChangedByUser: (() -> Void)? = nil
    var onOpenMapTapped: (() -> Void)? = nil
    var onChangeTapped: (() -> Void)? = nil
    
    @FocusState private var isAddressFocused: Bool
    
    var body: some View {
        Group {
            if isLocationDetected {
                VStack(spacing: 0) {
                    StaticMapPreview()
                        .frame(height: 130)
                        .frame(maxWidth: .infinity)
                        .background(.blue.opacity(0.2))
                        .overlay(alignment: .topTrailing) {
                                Label("Change", systemImage: "pencil")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.theme.green)
                                    .padding(.horizontal, DesignSystem.Spacing.large)
                                    .padding(.vertical, DesignSystem.Spacing.medium)
                                    .roundedBackground()
                                    .clickable(action: onChangeTapped)
                                    .padding(DesignSystem.Spacing.large)
                        }
                    
                    Label {
                        Text("Time zone ")
                            .fontWeight(.medium)
                        +
                        Text(timezone)
                            .fontWeight(.bold)
                            .foregroundStyle(.theme.textPrimary)
                    } icon: {
                        Image(systemName: "globe")
                    }
                    .foregroundStyle(.theme.blueGray)
                    .font(.subheadline)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.vertical, DesignSystem.Spacing.xLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .roundedBackground()
                
                LabeledEditableTextView(
                    text: $address,
                    label: "Address",
                    placeholder: "Type your parmacy's address",
                    minCharacters: minAddressLength,
                    minHeight: 100
                )
                .focused($isAddressFocused)
                .onChange(of: address) {
                    if isAddressFocused {
                        onAddressChangedByUser?()
                    }
                }
            } else {
                HStack(spacing: DesignSystem.Spacing.large) {
                    IconView(systemName: "map", size: 50, iconColor: .theme.green)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text("Open map to detect location")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundStyle(.theme.textPrimary)
                        
                        Text("Patients use this to find you and get directions.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.theme.blueGray)
                    }
                }
                .disclosureIndicator()
                .padding(DesignSystem.Spacing.large)
                .roundedBackground()
                .clickable(action: onOpenMapTapped)
            }
        }
    }
}

#Preview {
    @State @Previewable var address = ""
    
    LocationDetectionView(
        isLocationDetected: false,
        timezone: "Asia/Gaza",
        address: $address,
        minAddressLength: 40
    )
}
