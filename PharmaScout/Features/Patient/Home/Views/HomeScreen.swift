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
        pharmacyService: PharmacyService,
        searchRequestService: SearchRequestService
    ) {
        self.authService = authService
        self.drugService = drugService
        self.patientTabViewModel = patientTabViewModel
        let viewModel = HomeViewModel(
            authService: authService,
            locationService: locationService,
            pharmacyService: pharmacyService,
            searchRequestService: searchRequestService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    headerSection
                    
                    searchSection
                    
                    activeSearchesSection
                    
                    recentSection
                    
                    nearbyPharmaciesSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
            .onAppear(perform: vm.loadDataIfNeeded)
        }
    }
    
    private var headerSection: some View {
        GreetingHeaderView(user: vm.user, hasUnreadNotifications: vm.hasUnreadNotifications)
    }
    
    private var searchSection: some View {
        SearchCardView {
            patientTabViewModel.navigateToSearchTab()
        }
    }
    
    @ViewBuilder
    private var activeSearchesSection: some View {
        ActiveSearchesView(
            activeSearches: vm.activeSearches,
            loadingState: vm.activeSearchesloadingState
        ) { search in
            patientTabViewModel.navigateToSearchDetailScreen(for: search)
        }
        .frame(minHeight: 100, alignment: .top)
    }
    
    private var recentSection: some View {
        SearchListView(
            searches: vm.recentSearches,
            loadingState: vm.recentSearchesloadingState
        ) {
            patientTabViewModel.navigateToRecentSearchesTab()
        } onSearchTapped: { search in
            patientTabViewModel.navigateToSearchDetailScreen(for: search)
        }
        .frame(minHeight: 250, alignment: .top)
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
        pharmacyService: MockPharmacyService.sample,
        searchRequestService: MockSearchRequestService.sample
    )
}
