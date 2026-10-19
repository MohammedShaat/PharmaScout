//
//  PharmacyDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import SwiftUI

struct PharmacyDetailScreen: View {
    
    @State private var vm: PharmacyDetailViewModel
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy) {
        let viewModel = PharmacyDetailViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                seeMap

                PharmacyAddressAndDistanceView(pharmacy: vm.pharmacy)
                
                LoadingContentView(
                    LoadingState: vm.contactLoadingState,
                    isEmpty: vm.contacts.isEmpty,
                    emptyMessage: "There is no contact info"
                ) {
                    PharmacyContactView(contacts: vm.contacts)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                LoadingContentView(
                    LoadingState: vm.workingHoursLoadingState,
                    isEmpty: vm.workingHours.isEmpty,
                    emptyMessage: "There is no working hours info"
                ) {
                    PharmacyWorkingHoursView(workingHours: vm.workingHours)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavTitle(vm.pharmacy.name)
        .onAppear {
            vm.loadContactAndWorkingHoursIfNeeded()
        }
    }
    
    private var seeMap: some View {
        CustomNavValueLink(value: PharmacyDestination.map(vm.pharmacy)) {
            HStack {
                Text("See location on map")
                Image(systemName: "globe")
            }
        }
    }
}

#Preview {
    CustomNavStack {
        PharmacyDetailScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacy: .samples[0]
        )
    }
}
