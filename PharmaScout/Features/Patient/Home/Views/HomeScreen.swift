//
//  HomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import SwiftUI

struct HomeScreen: View {
    let authService: AuthService
    @State private var vm: HomeViewModel = HomeViewModel()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: Spacing.xxLarge) {
                    headerSection
                    
                    searchSection
                    
                    recentSection
                    
                    nearbyPharmaciesSection
                }
                .padding(Spacing.xLarge)
            }
            .customNavBarVisibility(false)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                    .foregroundStyle(.theme.textSecondary)
                
                HStack(spacing: 0) {
                    Text("Good Morning, ")
                    Text(vm.userName)
                }
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
        SearchCardView()
    }
    
    private var recentSection: some View {
        ListView()
    }
    
    private var nearbyPharmaciesSection: some View {
        CardListView()
    }
}

#Preview {
    HomeScreen(authService: MockAuthService.sample)
}
