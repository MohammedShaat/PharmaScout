//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistHomeScreen: View {
    private let pharmacistTabViewModel: PharmacistTabViewModel
    @State private var vm: PharmacistHomeViewModel
    
    init(
        pharmacistTabViewModel: PharmacistTabViewModel,
        authService: AuthService,
        inquiryService: InquiryService
    ) {
        self.pharmacistTabViewModel = pharmacistTabViewModel
        let viewModel = PharmacistHomeViewModel(
            authService: authService,
            inquiryService: inquiryService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    
                    if !vm.isAuthorized {
                        notAuthorizedSection
                        
                    } else {
                        headerSection
                        
                        recentPendingInquiries
                        
                        todayActivitySection
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
            .onAppear(perform: vm.loadDataIfNeeded)
        }
    }
    
    private var notAuthorizedSection: some View {
        Text("Your're not authorized yet")
            .font(.largeTitle)
    }
    
    private var headerSection: some View {
        GreetingHeaderView(user: vm.authSession?.user, hasUnreadNotifications: vm.hasUnreadNotifications)
    }
    
    private var recentPendingInquiries: some View {
        VStack {
            SectionHeaderView(title: "Pending inquiries") {
                pharmacistTabViewModel.navigateToInquiriesTab()
            }
            
            LoadingContentView(
                LoadingState: vm.latestPendingInquiriesLoadingState,
                isEmpty: vm.latestPendingInquiries.isEmpty,
                emptyMessage: "No pending Inquiries") {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        ForEach(vm.latestPendingInquiries) { inquiry in
                            InquiryView(inquiry)
                                .clickable {
                                    pharmacistTabViewModel.navigateToInquiryDetailScreen(inquiry)
                                }
                        }
                    }
                }
        }
    }
    
    private var todayActivitySection: some View {
        VStack {
            HStack {
                Text("Today's activity")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                Spacer()
            }
            
            LoadingContentView(
                LoadingState: vm.todaysInquiriesCountLoadingState,
                isEmpty: vm.allTodaysInquiriesCount == 0,
                emptyMessage: "No inquiries today") {
                    VStack(alignment: .leading) {
                        Text("^[\(vm.allTodaysInquiriesCount) inquiry](inflect: true)")
                        Text("\(vm.answeredTodaysInquiriesCount) answered")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
        }
    }
}

#Preview {
    PharmacistHomeScreen(
        pharmacistTabViewModel: .sample,
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample
    )
}
