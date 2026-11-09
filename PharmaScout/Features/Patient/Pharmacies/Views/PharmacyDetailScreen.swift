//
//  PharmacyDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import SwiftUI

struct PharmacyDetailScreen: View {
    let pharmacy: Pharmacy
    let onSeeLocationTapped: (() -> Void)?
    @State private var vm: PharmacyDetailViewModel
    
    init(
        pharmacyService: PharmacyService,
        pharmacy: Pharmacy,
        onSeeLocationTapped: (() -> Void)? = nil
    ) {
        self.pharmacy = pharmacy
        self.onSeeLocationTapped = onSeeLocationTapped
        
        let viewModel = PharmacyDetailViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.xLarge) {
                Text(pharmacy.name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                PharmacyBasicInfoView(pharmac: pharmacy, onSeeLocationTapped: onSeeLocationTapped)
                    .roundedBackground()
                
                contactsSection
                
                workingHoursSection
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .onAppear {
            vm.loadContactAndWorkingHoursIfNeeded()
        }
    }
    
    private var contactsSection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Text("Contact")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                LoadingState: vm.contactLoadingState,
                showMessage: vm.contacts.isEmpty,
                emptyMessage: "There is no contact info",
                showIcon: false
            ) {
                CustomList(
                    items: vm.contacts,
                    isLoadingMore: false
                ) { contact in
                    PharmacyContactView(contact: contact)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var workingHoursSection: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Text("Wokring hours")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                LoadingState: vm.workingHoursLoadingState,
                showMessage: vm.workingHours.isEmpty,
                emptyMessage: "There is no working hours info",
            ) {
                // Working hours
                WorkingHourListView(workingHours: vm.workingHours)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Timezone info
                VStack(spacing: DesignSystem.Spacing.medium) {
                    DividerView()
                    Label(
                        "Times shown in \(TimeZone.current.territory ?? "") time (\(TimeZone.current.timeFromGMT))",
                        systemImage: "clock"
                    )
                        .foregroundStyle(.theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, DesignSystem.Spacing.large)
                .padding(.horizontal, DesignSystem.Spacing.medium)
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
