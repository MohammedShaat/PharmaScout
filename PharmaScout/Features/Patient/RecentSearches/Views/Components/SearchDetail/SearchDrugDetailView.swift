//
//  SearchDrugDetailView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct SearchDrugDetailView: View {
    let searchDrugDetail: SearchDrugDetail
    var onPharmacyTapped: ((Pharmacy) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchDrugStatusView(status: searchDrugDetail.status)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Generic name & formulation
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text(searchDrugDetail.genericName)
                    .foregroundStyle(.theme.textPrimary)
                    .fontWeight(.heavy)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Form: \(searchDrugDetail.drugFormulation.strength)")
                    Text("Route: \(searchDrugDetail.drugFormulation.route)")
                }
                .foregroundStyle(.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Response & Pharmacy info
            if let response = searchDrugDetail.response,
               let pharmacyResponse = response.pharmacyResponse {
                // Response
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    InquiryResponseView(
                        response: pharmacyResponse,
                        title: pharmacyResponse == .substitute ? "Substitute Offered" : nil
                    )
                    .font(.headline)
                    .fontWeight(.bold)
                    
                    // When the response is substitute
                    if let substituteGenericName = response.substituteGenericName,
                     let substituteDrugFormulation = response.substituteDrugFormulation {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            Text(substituteGenericName)
                                .fontWeight(.heavy)
                                .foregroundStyle(.theme.textPrimary)
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                Text(substituteDrugFormulation.strength)
                                Text(substituteDrugFormulation.route)
                            }
                            .font(.subheadline)
                            .foregroundStyle(.theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(DesignSystem.Spacing.medium)
                        .roundedBackground(radius: DesignSystem.CornerRadius.small)
                    }
                    
                    DividerView(color: .theme.disabledContent)
                    
                    // Pharmacy
                    HStack(spacing: DesignSystem.Spacing.medium) {
                        Image(.location)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17)
                        Text(response.pharmacy.name)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .foregroundStyle(.theme.green)
                    .clickable {
                        onPharmacyTapped?(response.pharmacy)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: pharmacyResponse.surfaceColor, radius: DesignSystem.CornerRadius.small)
            }
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
}

#Preview {
    CustomNavStack {
        SearchDrugDetailView(searchDrugDetail: .samples[0])
            .padding()
    }
}
