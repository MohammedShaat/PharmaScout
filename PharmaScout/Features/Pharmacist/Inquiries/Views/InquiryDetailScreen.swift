//
//  InquiryDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/3/26.
//

import SwiftUI

struct InquiryDetailScreen: View {
    private let drugService: DrugService
    
    @State private var vm: InquiryDetailViewModel
    @State private var responseTask: Task<Void, Never>?
    
    init(
        inquiryService: InquiryService,
        drugService: DrugService,
        inquiry: Inquiry
    ) {
        self.drugService = drugService
        let viewModel = InquiryDetailViewModel(
            inquiryService: inquiryService,
            inquiry: inquiry
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                infoSection
                
                if vm.canRespond {
                    responseSection
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavigationDestination(for: SearchRoute.self) { route in
            switch route {
            case .addDrug:
                DrugSelectionScreen(
                    drugService: drugService,
                    selectedFormulationIds: [vm.inquiry.drugFormulation.id]) { selectedDrug in
                        vm.onSubstituteSelected(selectedDrug)
                    }
                
            case .editDrug(let selectedDrug):
                DrugSelectionScreen(
                    drugService: drugService,
                    editingSelectedDrug: selectedDrug,
                    selectedFormulationIds: [vm.inquiry.drugFormulation.id]
                )
            }
            
        }
        .refreshable(action: vm.refresh)
        .task {
            await vm.refresh()
        }
        .onDisappear {
            responseTask?.cancel()
        }
    }
    
    private var infoSection: some View {
        LoadingContentView(
            LoadingState: vm.refreshLoadingState,
            isEmpty: false,
            emptyMessage: "") {
                VStack {
                    Text("\(vm.inquiry.genericName) \(vm.inquiry.drugFormulation.title)")
                    
                    HStack {
                        Text("Status: \(vm.inquiry.status.rawValue)")
                            .foregroundStyle(vm.inquiry.status == .answered ? .theme.success : .theme.textTertiary)
                        Spacer()
                        Text("Response: \(vm.inquiry.response?.rawValue ?? "no response")")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Sent: \(vm.inquiry.createdAt.formattedDateTime)")
                        
                        if let respondedAt = vm.inquiry.respondedAt{
                            Text("Responded: \(respondedAt.formattedDateTime)")
                        }
                    }
                }
            }
    }
    
    private var responseSection: some View {
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
            
            // MARK: - Response button
            PrimaryButtonView(
                title: "Respond",
                isDisabled: !vm.responseIsValid,
                isLoading: vm.responseLoadingState.status != .idle) {
                    responseTask?.cancel()
                    responseTask = Task {
                        await vm.sendResponse()
                    }
                }
        }
        .padding(.vertical, DesignSystem.Spacing.large)
    }
}

#Preview {
    CustomNavStack {
        InquiryDetailScreen(
            inquiryService: MockInquiryService.sample,
            drugService: MockDrugService.sample,
            inquiry: .samples[2]
        )
    }
}
