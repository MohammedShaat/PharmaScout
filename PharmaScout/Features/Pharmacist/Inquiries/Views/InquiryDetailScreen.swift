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
            VStack {
                infoSection
                
                if vm.canRespond {
                    respondSection
                }
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .customNavigationDestination(for: SearchRoute.self) { route in
            if route == .addDrug {
                DrugSelectionScreen(
                    drugService: drugService,
                    selectedFormulationIds: []) { selectedDrug in
                        vm.onSubstituteSelected(selectedDrug)
                    }
            }
        }
        .refreshable(action: vm.refresh)
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
    
    private var respondSection: some View {
        VStack {
            Picker(selection: $vm.response) {
                ForEach(InquiryResponse.allCases, id: \.self) { response in
                    Text(response.rawValue)
                        .tag(response)
                }
            } label: {
                Text("Respond with")
            }
            .pickerStyle(.segmented)
        
        
            if vm.response == .substitute {
                if vm.selectedDrug == nil {
                    CustomNavValueLink(value: SearchRoute.addDrug) {
                        Text("Choose a substitute medicine")
                            .foregroundStyle(.theme.textPrimary)
                    }
                }
                
                if let selectedDrug = vm.selectedDrug {
                    Text(selectedDrug.genericDrug.genericName)
                    Text(selectedDrug.formulation.title)
                }
            }
        }
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
