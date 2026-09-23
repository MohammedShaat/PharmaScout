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

                addressAndDistance
                
                contact
                
                workingHours
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavTitle(vm.pharmacy.name)
        .taskOnFirstAppear {
            await vm.loadContact()
            await vm.loadWorkingHours()
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
    
    private var addressAndDistance: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text(vm.pharmacy.address)
                Spacer()
                Text(vm.pharmacy.distanceMeters.meterToKilometer.formatted(.number.precision(.fractionLength(2))))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var contact: some View {
        switch vm.contactLoadingState.status {
        case .loading:
            RingProgressView()
            
        case .loadingMore, .idle, .refreshing:
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                ForEach(vm.contacts) { contact in
                    HStack {
                        Text("\(contact.title) : ")
                        Text(contact.value)
                    }
                    .background(.gray.opacity(0.2))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var workingHours: some View {
        switch vm.workingHoursLoadingState.status {
        case .loading:
            RingProgressView()
            
        case .loadingMore, .idle, .refreshing:
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                ForEach(vm.workingHours) { workinghour in
                    VStack {
                        Text("\(workinghour.day)")
                        HStack {
                            Text("Opens at: ")
                            Text(workinghour.opensAt.description)
                        }
                        HStack {
                            Text("Closes at: ")
                            Text(workinghour.closesAt.description)
                        }
                    }
                    .background(.gray.opacity(0.2))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
