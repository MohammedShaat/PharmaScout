//
//  HomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import SwiftUI

struct HomeScreen: View {
    private let authService: AuthService
    private let drugService: DrugService
    private let patientTabViewModel: PatientTabViewModel
    
    @State private var vm: HomeViewModel
    
    init(
        authService: AuthService,
        drugService: DrugService,
        patientTabViewModel: PatientTabViewModel,
        locationService: LocationService,
        pharmacyService: PharmacyService
    ) {
        self.authService = authService
        self.drugService = drugService
        self.patientTabViewModel = patientTabViewModel
        let viewModel = HomeViewModel(
            authService: authService,
            locationService: locationService,
            pharmacyService: pharmacyService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    headerSection
                    
                    searchSection
                    
                    recentSection
                    
                    nearbyPharmaciesSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
            .taskOnFirstAppear {
                vm.getLocation()
                async let userData = await vm.loadUserData()
                async let nearbyPharmacies = await vm.loadNearbyPharmacies()
                
                _ = await (userData, nearbyPharmacies)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                    .foregroundStyle(.theme.textSecondary)
                
                HStack(spacing: 0) {
                    Text("Good \(Date.now.timeOfDay)")
                    
                    if let firstName = vm.user?.firstName {
                        Text(", \(firstName)")
                    }
                }
                .lineLimit(1)
                .foregroundStyle(.theme.textPrimary)
                .font(.title3)
                .fontWeight(.bold)
            }
            
            Spacer()
            
            BellView(hasUnreadNotifications: vm.hasUnreadNotifications)
                .clickable()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var searchSection: some View {
        SearchCardView {
            patientTabViewModel.navigateToSearchTab()
        }
    }
    
    private var recentSection: some View {
        SearchListView()
    }
    
    private var nearbyPharmaciesSection: some View {
        PharmacyListView(
            pharmacies: vm.nearbyPharmacies,
            loadingState: vm.nearbyPharmaciesLoadingState
        ) {
            patientTabViewModel.navigateToPharmaciesTab()
        } onPharmacyTapped: { pharmacy in
            patientTabViewModel.navigateToPharmacyDetailScreen(for: pharmacy)
        }
    }
}

#Preview {
    HomeScreen(
        authService: MockAuthService.sample,
        drugService: MockDrugService.sample,
        patientTabViewModel: PatientTabViewModel.sample,
        locationService: MockLocationService.sample,
        pharmacyService: MockPharmacyService.sample
    )
}
