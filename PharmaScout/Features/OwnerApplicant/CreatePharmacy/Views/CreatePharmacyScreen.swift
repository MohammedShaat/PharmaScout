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
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xxLarge) {
                        basicInfoSection
                        
                        locationSection
                        
                        workingHoursSection

                        contactSection
                    }
                    .padding(DesignSystem.Spacing.xLarge)
                }
                
                DividerView()
                createPharmacyButtonSection
            }
            .customNavBarVisibility(.root)
            .customNavTitle("Create Pharmacy")
            .customNavigationDestination(for: CreatePharmacyRoute.self) { route in
                switch route {
                case .selectLocationOnMap:
                    SelectLocationScreen(
                        locationService: locationService,
                        geocodingService: geocodingService,
                        placeSearchService: placeSearchService,
                    ) { coordiante, resolvedPlace in
                        vm.onLocationConfirmed(coordiante, 	resolvedPlace)
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
            .errorAlert(title: "Pharmacy creation failed", loadingState: $vm.loadingState)
            .sheet(isPresented: $vm.showSuccessMessage, onDismiss: vm.onSuccessMessageDismissed) {
                RequestSucceededView(
                    title: "Your request has been submitted",
                    subtitle: "An admin will review your pharmacy. We’ll show you the status on your Home screen."
                ) {
                    vm.onSuccessMessageDismissed()
                }
            }
            .onDisappear {
                createPharmacyTask?.cancel()
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: "Pharmacy Info")
            
            LabeledTextFieldView(title: $vm.name, label: "Pharmacy name", placeholder: "Type your pharmacy's name")
        }
    }
    
    private var locationSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: "Location")

            LocationDetectionView(
                isLocationDetected: vm.coordinate != nil,
                timezone: vm.timezone,
                address: $vm.address,
                minAddressLength: vm.minAddressLength,
                onAddressChangedByUser: { vm.onAddressChangedByUser() },
                onOpenMapTapped: { path.append(CreatePharmacyRoute.selectLocationOnMap) },
                onChangeTapped: { path.append(CreatePharmacyRoute.selectLocationOnMap) }
            )
        }
    }
    
    private var workingHoursSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Working Hours", showAction: vm.workingHours.isNotEmpty) {
                path.append(CreatePharmacyRoute.createOrEditWorkingHours)
            }
            
            if vm.workingHours.isNotEmpty {
                WorkingHourListView(workingHours: vm.workingHours)
            } else {
                CreatePharmacyEmptyListView(
                    systemName: "clock",
                    title: "No working hours yet",
                    subtitle: "Add opening times so patients know when to visit.",
                    buttonTitle: "Set working hours",
                    onButtonTapped: { path.append(CreatePharmacyRoute.createOrEditWorkingHours) }
                )
            }
        }
    }
    
    private var contactSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            EditSectionHeaderView(title: "Contact", showAction: vm.contacts.isNotEmpty) {
                path.append(CreatePharmacyRoute.createOrEditContacts)
            }
            
            if vm.contacts.isNotEmpty {
                CustomList(items: vm.contacts, isLoadingMore: false) { contact in
                    PharmacyContactView(contact: contact)
                }
            } else {
                CreatePharmacyEmptyListView(
                    systemName: "phone",
                    title: "No contact info yet",
                    subtitle: "Add a phone number, email, or website so patients can reach you.",
                    buttonTitle: "Add contact",
                    onButtonTapped: { path.append(CreatePharmacyRoute.createOrEditContacts) }
                )
            }
        }
    }
    
    private var createPharmacyButtonSection: some View {
        PrimaryButtonView(
            title: "Create Pharmacy",
            isDisabled: !vm.canCreatePharmacy,
            isLoading: vm.loadingState.status != .idle
        ) {
            createPharmacyTask?.cancel()
            createPharmacyTask = Task {
                await vm.createPharmacy()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.top, DesignSystem.Spacing.small)
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
