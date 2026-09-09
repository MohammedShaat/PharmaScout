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
    
    @State private var vm: HomeViewModel
    @State private var path = NavigationPath()
    
    init(authService: AuthService, drugService: DrugService) {
        self.authService = authService
        self.drugService = drugService
        let viewModel = HomeViewModel(authService: authService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: $path) {
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
            .customNavigationDestination(for: Route.self, destination: { route in
                switch route {
                case .search:
                    SearchScreen(drugService: drugService)
                }
            })
            .task {
                await vm.loadUserData()
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
            path.append(Route.search)
        }
    }
    
    private var recentSection: some View {
        ListView()
    }
    
    private var nearbyPharmaciesSection: some View {
        CardListView()
    }
}

enum Route: Hashable {
    case search
}

#Preview {
    HomeScreen(
        authService: MockAuthService.sample,
        drugService: MockDrugService.sample
    )
}
