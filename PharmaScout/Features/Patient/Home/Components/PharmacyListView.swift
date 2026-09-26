//
//  CardListView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct PharmacyListView: View {
    let pharmacies: [Pharmacy]
    let loadingState: LoadingState
    var onSeeAllClicked: (() -> Void)?
    var onPharmacyTapped: ((Pharmacy) -> Void)?
    
    var body: some View {
        VStack {
            SectionHeaderView(title: "Nearby pharmacies", onSeeAllClicked: onSeeAllClicked)
            
            list
        }
    }
    
    private var list: some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: pharmacies.isEmpty,
            emptyMessage: "Could not find nearby pharmacies") {
                VStack(spacing: DesignSystem.Spacing.large) {
                    ForEach(pharmacies) { pharmacy in
                        PharmacyCardView(name: pharmacy.name, distance: pharmacy.distanceMeters, isOpen: pharmacy.isOpen)
                            .clickable {
                                onPharmacyTapped?(pharmacy)
                            }
                    }
                }
            }
    }
    
    
}

#Preview {
    CustomNavStack {
        ScrollView {
            PharmacyListView(
                pharmacies: Array(Pharmacy.samples.prefix(10)),
                loadingState: LoadingState()
            )
            .padding()
            .customNavBarVisibility(false)
        }
    }
}
