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
            ScrollView {
                VStack {
                    filterSection
                    
                    searchSection
                    
                    inquiryListSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavigationDestination(for: InquiryDetailRoute.self) { route in
                InquiryDetailScreen(
                    inquiryService: inquiryService,
                    drugService: drugService,
                    inquiryId: route.inquiryId,
                    inquiry: route.inquiry
                )
                .id(route.inquiryId)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
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
        Menu(vm.filter.title, systemImage: "line.3.horizontal.decrease") {
            Picker("Analytics type", selection: $vm.filter) {
                ForEach(InquiryFilter.allCases) { status in
                    Text(status.title)
                        .tag(status)
                }
            }
        }
    }
    
    private var searchSection: some View {
        TextField("type here", text: $vm.searchText)
            .padding()
            .background(.theme.disabledBackground)
    }
    
    private var inquiryListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            isEmpty: vm.inquiries.isEmpty,
            emptyMessage: "No inquiries yet") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.inquiries) { inquiry in
                        CustomNavValueLink(value: InquiryDetailRoute(inquiryId: inquiry.id, inquiry: inquiry)) {
                            InquiryView(inquiry)
                        }
                        .onAppear {
                            if inquiry.id == vm.inquiries.last?.id {
                                inquiriesTask?.cancel()
                                inquiriesTask = Task {
                                    await vm.loadMore()
                                }
                            }
                        }
                        
                        if inquiry.id == vm.inquiries.last?.id && vm.loadingState.status == .loadingMore {
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
