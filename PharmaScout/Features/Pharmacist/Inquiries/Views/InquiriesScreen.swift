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
    
    private var path: Binding<[Inquiry]>
    @State private var vm: InquiriesViewModel
    @State private var loadMoreTask: Task<Void, Never>?
    
    init(
        path: Binding<[Inquiry]>,
        authService: AuthService,
        inquiryService: InquiryService,
        drugService: DrugService
    ) {
        self.path = path
        self.inquiryService = inquiryService
        self.drugService = drugService
        let viewModel = InquiriesViewModel(
            authService: authService,
            inquiryService: inquiryService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack(path: path) {
            ScrollView {
                VStack {
                    
                    LoadingContentView(
                        LoadingState: vm.loadingState,
                        isEmpty: vm.inquiries.isEmpty,
                        emptyMessage: "No inquiries yet") {
                            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                                ForEach(vm.inquiries) { inquiry in
                                    CustomNavValueLink(value: inquiry) {
                                        InquiryView(inquiry)
                                    }
                                    .onAppear {
                                        if inquiry.id == vm.inquiries.last?.id {
                                            loadMoreTask?.cancel()
                                            loadMoreTask = Task {
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
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavigationDestination(for: Inquiry.self) { inquiry in
                InquiryDetailScreen(
                    inquiryService: inquiryService,
                    drugService: drugService,
                    inquiry: inquiry
                )
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
            .onAppear {
                vm.loadInquiriesIfNeeded()
            }
            .onDisappear {
                loadMoreTask?.cancel()
            }
        }
    }
}

#Preview {
    @State @Previewable var path: [Inquiry] = []
    
    InquiriesScreen(
        path: $path,
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample,
        drugService: MockDrugService.sample
    )
}
