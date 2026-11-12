//
//  InquiriesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct InquiriesScreen: View {
    private let inquiryService: InquiryService
    private let drugService: DrugService
    
    private var path: Binding<NavigationPath>
    @State private var vm: InquiriesViewModel
    @State private var inquiriesTask: Task<Void, Never>?
    
    init(
        path: Binding<NavigationPath>,
        staffMembership: StaffMembership,
        authService: AuthService,
        inquiryService: InquiryService,
        drugService: DrugService
    ) {
        self.path = path
        self.inquiryService = inquiryService
        self.drugService = drugService
        let viewModel = InquiriesViewModel(
            staffMembership: staffMembership,
            inquiryService: inquiryService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: path) {
            VStack(spacing: 0) {
                filterSection
                
                searchSection

                ScrollView {
                    VStack(spacing: 0) {
                        inquiryListSection
                    }
                    .refreshable(action: vm.refresh)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Inquiries")
            .customNavigationDestination(for: InquiryDetailRoute.self) { route in
                InquiryDetailScreen(
                    inquiryService: inquiryService,
                    drugService: drugService,
                    inquiryId: route.inquiryId,
                    inquiry: route.inquiry
                )
                .id(route.inquiryId)
            }
            .task(id: vm.searchText) {
                await vm.onSearchTextChanged()
            }
            .onDisappear {
                inquiriesTask?.cancel()
            }
            .onChange(of: vm.filter) {
                inquiriesTask?.cancel()
                inquiriesTask = Task {
                    await vm.onFilterChanged()
                }
            }
            .task {
                await vm.listenToChanges()
            }
        }
    }
    
    private var filterSection: some View {
        FilterView(
            selection: $vm.filter,
            title: vm.filter.title,
            pickerTitle: "Status",
            options: InquiryFilter.allCases
        ) { status in
            Text(status.title)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var searchSection: some View {
        SearchFieldView(text: $vm.searchText, placehodler: "Filter by medicine name or formulation")
            .padding(.vertical, DesignSystem.Spacing.large)
    }
    
    private var inquiryListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            showMessage: vm.inquiries.isEmpty,
            emptyTitle: "No inquiries",
            emptyMessage: "") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.inquiries) { inquiry in
                        CustomNavValueLink(value: InquiryDetailRoute(inquiryId: inquiry.id, inquiry: inquiry)) {
                            InquiryView(inquiry)
                        }
                        .onAppear {
                            if inquiry.isLast(vm.inquiries) {
                                inquiriesTask?.cancel()
                                inquiriesTask = Task {
                                    await vm.loadMore()
                                }
                            }
                        }
                        
                        if inquiry.isLast(vm.inquiries) && vm.loadingState.status == .loadingMore {
                            RingProgressView()
                        }
                    }
                }
            }
    }
}

#Preview {
    @State @Previewable var path = NavigationPath()
    
    InquiriesScreen(
        path: $path,
        staffMembership: .samples[0],
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample,
        drugService: MockDrugService.sample
    )
}
