//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistDashboardScreen: View {
    private let user: AppUser
    private let pharmacistTabViewModel: PharmacistTabViewModel
    @State private var vm: PharmacistDashboardViewModel
    
    init(
        user: AppUser,
        pharmacistTabViewModel: PharmacistTabViewModel,
        staffMembership: StaffMembership,
        inquiryService: InquiryService,
    ) {
        self.user = user
        self.pharmacistTabViewModel = pharmacistTabViewModel
        
        let viewModel = PharmacistDashboardViewModel(
            staffMembership: staffMembership,
            inquiryService: inquiryService,
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
            .customNavBarVisibility(.hidden)
            .refreshable(action: vm.refreshData)
            .onAppear(perform: vm.loadDataIfNeeded)
            .task {
                await vm.listenToChanges()
            }
        }
    }
    
    
    private var headerSection: some View {
        GreetingHeaderView(firstName: user.firstName, isPharmacist: true)
    }
    
    private var recentPendingInquiries: some View {
        VStack {
            MoreSectionHeaderView(title: "Pending inquiries") {
                pharmacistTabViewModel.navigateToInquiriesTab()
            }
            
            LoadingContentView(
                loadingState: vm.latestPendingInquiriesLoadingState,
                showMessage: vm.latestPendingInquiries.isEmpty,
                emptyTitle: "No pending inquiries",
                emptyMessage: "You're all caught up. New requests will appear here.",
                errorTitle: "Couldn't load pending inquiries"
            ) {
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.latestPendingInquiries) { inquiry in
                        DashboardPendingInquiryView(inquiry: inquiry)
                            .padding(DesignSystem.Spacing.large)
                            .roundedBackground(showBorder: true, borderColor: InquiryStatus.pending.color)
                            .clickable {
                                pharmacistTabViewModel.navigateToInquiryDetailScreenBy(inquiry)
                            }
                    }
                }
            }
        }
    }
    
    private var todayActivitySection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            Text("Today's activity")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                loadingState: vm.todaysInquiriesCountLoadingState,
                showMessage: vm.allTodaysInquiriesCount == 0,
                emptyTitle: "No inquiries today",
                emptyMessage: "New inquiries will show up here as they come in.",
                errorTitle: "Couldn't load today's activity"
            ) {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    Group {
                        statisticCard(title: "Answered", count: vm.answeredTodaysInquiriesCount)
                        
                        statisticCard(title: "Received", count: vm.allTodaysInquiriesCount)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(DesignSystem.Spacing.large)
                    .roundedBackground()
                }
            }
        }
    }
    
    private func statisticCard(title: String, count: Int) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.theme.textPrimary)
            
            Text("\(count)")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.textPrimary)
        }
    }
}

#Preview {
    PharmacistDashboardScreen(
        user: .samples[0],
        pharmacistTabViewModel: .sample,
        staffMembership: .samples[0],
        inquiryService: MockInquiryService.sample,
    )
}
