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
    
    @State private var showingDrugSelection: Bool = false
    @State private var selectedDrugToEdit: SelectedDrug?
    
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
        .customNavTitle("Inquiry Details")
        .sheet(isPresented: $showingDrugSelection) {
            if let inquiry = vm.inquiry {
                DrugSelectionScreen(
                    drugService: drugService,
                    selectedFormulationIds: [inquiry.drugFormulation.id]) { selectedDrug in
                        vm.onSubstituteSelected(selectedDrug)
                    }
            }
        }
        .sheet(item: $selectedDrugToEdit) { selectedDrug in
            if let inquiry = vm.inquiry {
                DrugSelectionScreen(
                    drugService: drugService,
                    editingSelectedDrug: selectedDrug,
                    selectedFormulationIds: [inquiry.drugFormulation.id]
                )
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
            showMessage: vm.inquiry == nil,
            emptyTitle: "Couldn't fetch the inquiry details",
            emptyMessage: ""
        ) {
            if let inquiry = vm.inquiry {
                InquiryDetailInfoView(inquiry: inquiry)
            }
        }
    }
    
    private var responseSection: some View {
        LoadingContentView(
            LoadingState: vm.editEligibilityLoadingState,
            showMessage: vm.editEligibilityLoadingState.error != nil,
            emptyTitle: "Couldn't check if you can respond",
            emptyMessage: ""
        ) {
            if vm.canCanResponse {
                VStack(spacing: DesignSystem.Spacing.xxLarge) {
                    InquiryResponseFlowView(
                        response: vm.response,
                        onResponseChanged: { vm.response = $0 },
                        substituteSelectedDrug: vm.substituteSelectedDrug,
                        onChooseSubstituteTapped: { showingDrugSelection = true },
                        onSubstituteSelectedDrugTapped: { selectedDrugToEdit = vm.substituteSelectedDrug }
                    )
                    
                    // MARK: Response error
                    if let responseError = vm.responseLoadingState.error {
                        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                            Image(systemName: "exclamationmark.circle")
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Couldn't send your response.")
                                Text(responseError.errorDescription)
                            }
                        }
                        .foregroundStyle(.theme.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(DesignSystem.Spacing.large)
                        .roundedBackground(background: .theme.redBackground, radius: DesignSystem.Spacing.small)
                    }
                    
                    // MARK: Response button
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
