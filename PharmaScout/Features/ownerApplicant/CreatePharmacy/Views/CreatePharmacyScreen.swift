//
//  OwnerApplicantHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct CreatePharmacyScreen: View {
    private let geocodingService: GeocodingService
    private let placeSearchService: PlaceSearchService
    private let locationService: LocationService
    
    @State private var vm: CreatePharmacyViewModel
    @State private var path = NavigationPath()
    @FocusState private var isAddressFocused: Bool
    @State private var createPharmacyTask: Task<Void, Never>?
    
    init(
        pharmacyService: PharmacyService,
        ownerApplicationService: OwnerApplicationService,
        geocodingService: GeocodingService,
        placeSearchService: PlaceSearchService,
        locationService: LocationService
    ) {
        self.geocodingService = geocodingService
        self.placeSearchService = placeSearchService
        self.locationService = locationService
        
        let viewModel = CreatePharmacyViewModel(
            pharmacyService: pharmacyService,
            ownerApplicationService: ownerApplicationService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: $path) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    pharmacySection
                    
                    locationSection
                    
                    workingHoursSection

                    contactSection
                    
                    createPharmacyButtonSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customBackButtonVisibility(false)
            .customNavTitle("Create Pharmacy")
            .customNavigationDestination(for: CreatePharmacyRoute.self) { route in
                switch route {
                case .selectLocationOnMap:
                    SelectLocationScreen(
                        locationService: locationService,
                        geocodingService: geocodingService,
                        placeSearchService: placeSearchService,
                    ) { coordiante, resolvedPlace in
                        vm.onLocationConfirmed(coordiante, resolvedPlace)
                    }
                    
                case .createOrEditWorkingHours:
                    CreateOrEditWorkingHoursScreen(workingHours: vm.workingHours) { editedWorkingHours in
                        vm.onWorkingHoursEdited(editedWorkingHours)
                    }
                    
                case .createOrEditContacts:
                    CreateOrEditContactsScreen(contacts: vm.contacts) { editedContacts in
                        vm.onContactsEdited(editedContacts)
                    }
                }
            }
            .sheet(isPresented: $vm.showSuccessMessage) {
                MidSheetView(title: "Your request has been submitted successfully") {
                    vm.onSuccessMessageDismissed()
                }
            }
            .onDisappear {
                createPharmacyTask?.cancel()
            }
        }
    }
    
    private var pharmacySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionHeader("Pharmacy Info")
            
            LabeledTextFieldView(title: $vm.name, label: "Pharmacy name", placeholder: "Type your pharmacy's name")
            
            LabeledTextFieldView(title: $vm.address, label: "Address", placeholder: "Type your pharmacy's address")
        }
    }
    
    private var locationSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            sectionHeader("Location")
            
            if let coordinate = vm.coordinate {
                HStack {
                    Text("Latitude: \(coordinate.latitude)")
                    Text("Longitude: \(coordinate.longitude)")
                }
                
                LabeledTextFieldView(title: $vm.address, label: "Address", placeholder: "Type your pharmacy's address")
                    .focused($isAddressFocused)
                    .onChange(of: vm.address) {
                        if isAddressFocused {
                            vm.onAddressChangedByUser()
                        }
                    }
            }
            
            NavigationPromptView(
                value: CreatePharmacyRoute.selectLocationOnMap,
                actionTitle: "Open map to detect location"
            )
        }
    }
    
    private var workingHoursSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Working Hours") {
                path.append(CreatePharmacyRoute.createOrEditWorkingHours)
            }
            
            PharmacyWorkingHoursView(workingHours: vm.workingHours)
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Contact") {
                path.append(CreatePharmacyRoute.createOrEditContacts)
            }
            
            PharmacyContactView(contacts: vm.contacts)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.theme.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var createPharmacyButtonSection: some View {
        VStack {
            if let error = vm.loadingState.error {
                Text(error.errorDescription)
            }
            
            PrimaryButtonView(
                title: "Create Pharmacy",
                isDisabled: !vm.canCreatePharmacy,
                isLoading: vm.loadingState.status != .idle) {
                    createPharmacyTask?.cancel()
                    createPharmacyTask = Task {
                        await vm.createPharmacy()
                    }
                }
        }
    }
}

enum CreatePharmacyRoute {
    case selectLocationOnMap
    case createOrEditWorkingHours
    case createOrEditContacts
}

#Preview {
    CreatePharmacyScreen(
        pharmacyService: MockPharmacyService.sample,
        ownerApplicationService: MockOwnerApplicationService.sample,
        geocodingService: MockGeocodingService.sample,
        placeSearchService: MockPlaceSearchService.sample,
        locationService: MockLocationService.sample
    )
}
