//
//  InquiryDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import SwiftUI

struct InquiryDetailRoute: Hashable {
    let inquiryId: String
    var inquiry: Inquiry? = nil
}

struct InquiryDetailScreen: View {
    private let drugService: DrugService
    
    @State private var vm: InquiryDetailViewModel
    @State private var responseTask: Task<Void, Never>?
    
    init(
        inquiryService: InquiryService,
        drugService: DrugService,
        inquiryId: String,
        inquiry: Inquiry?
    ) {
        self.drugService = drugService
        let viewModel = InquiryDetailViewModel(
            inquiryService: inquiryService,
            inquiryId: inquiryId,
            inquiry: inquiry
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                infoSection
                
                responseSection
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavigationDestination(for: SearchRoute.self) { route in
            if let inquiry = vm.inquiry {
                switch route {
                case .addDrug:
                    DrugSelectionScreen(
                        drugService: drugService,
                        selectedFormulationIds: [inquiry.drugFormulation.id]) { selectedDrug in
                            vm.onSubstituteSelected(selectedDrug)
                        }
                    
                case .editDrug(let selectedDrug):
                    DrugSelectionScreen(
                        drugService: drugService,
                        editingSelectedDrug: selectedDrug,
                        selectedFormulationIds: [inquiry.drugFormulation.id]
                    )
                }
            }
        }
        .refreshable(action: vm.refresh)
        .onAppear(perform: vm.loadDataIfNeeded)
        .onDisappear {
            responseTask?.cancel()
        }
        .task(vm.listenToChanges)
    }
    
    private var infoSection: some View {
        LoadingContentView(
            LoadingState: vm.inquiryLoadingState,
            isEmpty: vm.inquiry == nil,
            emptyMessage: "") {
                if let inquiry = vm.inquiry {
                    VStack {
                        Text("\(inquiry.genericName) \(inquiry.drugFormulation.title)")
                        
                        HStack {
                            Text("Status: \(inquiry.status.rawValue)")
                                .foregroundStyle(inquiry.status == .answered ? .theme.success : .theme.textTertiary)
                            Spacer()
                            Text("Response: \(inquiry.response?.rawValue ?? "no response")")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Sent: \(inquiry.createdAt.formattedDateTime)")
                            
                            if let respondedAt = inquiry.respondedAt {
                                Text("Responded: \(respondedAt.formattedDateTime)")
                            }
                        }
                    }
                }
            }
    }
    
    private var responseSection: some View {
        LoadingContentView(
            LoadingState: vm.editEligibilityLoadingState,
            isEmpty: vm.editEligibilityLoadingState.error != nil,
            emptyMessage: "") {
                if vm.canCanResponse {
                    VStack(spacing: DesignSystem.Spacing.xxLarge) {
                        // MARK: - Response options
                        Picker(selection: $vm.response) {
                            ForEach(InquiryResponse.allCases, id: \.self) { response in
                                Text(response.rawValue)
                                    .tag(response)
                            }
                        } label: {
                            Text("Respond with")
                        }
                        .pickerStyle(.segmented)
                        
                        
                        // MARK: - Substitute search
                        if vm.response == .substitute {
                            if vm.substituteSelectedDrug == nil {
                                CustomNavValueLink(value: SearchRoute.addDrug) {
                                    Text("Choose a substitute medicine")
                                        .foregroundStyle(.theme.textPrimary)
                                }
                            }
                            
                            if let selectedDrug = vm.substituteSelectedDrug {
                                CustomNavValueLink(value: SearchRoute.editDrug(selectedDrug)) {
                                    VStack {
                                        Text(selectedDrug.genericDrug.genericName)
                                        Text(selectedDrug.formulation.title)
                                    }
                                }
                            }
                        }
                        
                        // MARK: - Response error
                        if let responseError = vm.responseLoadingState.error {
                            Text(responseError.errorDescription)
                        }
                        
                        // MARK: - Response button
                        if let inquiry = vm.inquiry{
                            PrimaryButtonView(
                                title: inquiry.status == .pending ? "Respond" : "Update",
                                isDisabled: !vm.responseIsValid,
                                isLoading: vm.responseLoadingState.status != .idle) {
                                    responseTask?.cancel()
                                    responseTask = Task {
                                        await vm.sendResponse()
                                    }
                                }
                        }
                    }
                    .padding(.vertical, DesignSystem.Spacing.large)
                }
            }
    }
}

#Preview {
    let inquiry = Inquiry.samples[0]
    
    CustomNavStack {
        InquiryDetailScreen(
            inquiryService: MockInquiryService.sample,
            drugService: MockDrugService.sample,
            inquiryId: inquiry.id,
            inquiry: inquiry
        )
    }
}
