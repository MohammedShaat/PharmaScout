//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistDashboardScreen: View {
    private let pharmacistTabViewModel: PharmacistTabViewModel
    @State private var vm: PharmacistDashboardViewModel
    
    init(
        pharmacistTabViewModel: PharmacistTabViewModel,
        staffMembership: StaffMembership,
        inquiryService: InquiryService,
        authService: AuthService
    ) {
        self.pharmacistTabViewModel = pharmacistTabViewModel
        
        let viewModel = PharmacistDashboardViewModel(
            staffMembership: staffMembership,
            inquiryService: inquiryService,
            authService: authService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    headerSection
                    
                    recentPendingInquiries
                    
                    todayActivitySection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refreshData)
            .onAppear(perform: vm.loadDataIfNeeded)
            .task {
                await vm.listenToChanges()
            }
        }
    }
    
    
    private var headerSection: some View {
        GreetingHeaderView(user: vm.user, hasUnreadNotifications: vm.hasUnreadNotifications)
    }
    
    private var recentPendingInquiries: some View {
        VStack {
            MoreSectionHeaderView(title: "Pending inquiries") {
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
                                    pharmacistTabViewModel.navigateToInquiryDetailScreenBy(inquiry)
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
    PharmacistDashboardScreen(
        pharmacistTabViewModel: .sample,
        staffMembership: .samples[0],
        inquiryService: MockInquiryService.sample,
        authService: MockAuthService.sample
    )
}
