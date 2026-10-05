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
                
                PharmacyContactView(contacts: vm.contacts, loadingState: vm.contactLoadingState)
                
                PharmacyWorkingHoursView(workingHours: vm.workingHours, loadingState: vm.workingHoursLoadingState)
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
