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
    
    @State private var vm: InquiriesViewModel
    @State private var loadMoreTask: Task<Void, Never>?
    
    init(
        authService: AuthService,
        inquiryService: InquiryService,
        drugService: DrugService
    ) {
        self.inquiryService = inquiryService
        self.drugService = drugService
        let viewModel = InquiriesViewModel(
            authService: authService,
            inquiryService: inquiryService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack {
                    
                    LoadingContentView(
                        LoadingState: vm.loadingState,
                        isEmpty: vm.inquiries.isEmpty,
                        emptyMessage: "No inquiries yet") {
                            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                                ForEach(vm.inquiries) { inquiry in
                                    inquiryItemView(inquiry)
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
                .customNavigationDestination(for: Inquiry.self) { inquiry in
                    InquiryDetailScreen(
                        inquiryService: inquiryService,
                        drugService: drugService,
                        inquiry: inquiry
                    )
                }
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
    
    private func inquiryItemView(_ inquiry: Inquiry) -> some View {
        CustomNavValueLink(value: inquiry) {
            VStack(alignment: .leading) {
                Text("\(inquiry.genericName) \(inquiry.drugFormulation.title)")
                
                HStack {
                    Text("Status: \(inquiry.status.rawValue)")
                        .foregroundStyle(inquiry.status == .answered ? .theme.success : .theme.textTertiary)
                    Spacer()
                    Text("Response: \(inquiry.response?.rawValue ?? "no response")")
                }
                
                VStack(alignment: .leading) {
                    Text("Sent: \(inquiry.createdAt.formattedDateTime)")
                    
                    if let respondedAt = inquiry.respondedAt{
                        Text("Responded: \(respondedAt.formattedDateTime)")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.2))
        }
    }
}

#Preview {
    InquiriesScreen(
        authService: MockAuthService.sample,
        inquiryService: MockInquiryService.sample,
        drugService: MockDrugService.sample
    )
}
