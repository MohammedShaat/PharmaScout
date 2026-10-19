//
//  PharmacyEditWorkingHourScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import SwiftUI
import Swipy

struct PharmacyEditWorkingHourScreen: View {
    @State private var vm: PharmacyEditWorkingHourViewModel
    @State private var updateTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy, workingHours: [WorkingHour]) {
        let viewModel = PharmacyEditWorkingHourViewModel(
            pharmacyService: pharmacyService,
            pharmacy: pharmacy,
            workingHours: workingHours
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            workingHourListSection
            
            addNewWorkingHourSection
            
            errorSection
            
            buttonSection
        }
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .onDisappear {
            updateTask?.cancel()
        }
    }
    
    private var workingHourListSection: some View {
        VStack(spacing: DesignSystem.Spacing.xxLarge) {
            ForEach($vm.workingHours) { $workingHour in
                SwipyView(
                    isSwipingAnItem: $isSwipingAnItem) {
                        workingHourItemView($workingHour)
                    } onDeleteTapped: {
                        vm.deleteWorkingHour(workingHour)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var addNewWorkingHourSection: some View {
        if vm.canAddWorkingHour {
            ActionPromptView(actionTitle: "Add day", action: vm.addWorkingHour)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = vm.loadingState.error {
            Text(error.errorDescription)
        }
    }
    
    private func workingHourItemView(_ workingHour: Binding<WorkingHour>) -> some View {
        WorkingHourView(workingHour: workingHour, availableDays: vm.availableDays)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonSection: some View {
        PrimaryButtonView(
            title: "Save",
            isLoading: vm.loadingState.status != .idle) {
                updateTask?.cancel()
                updateTask = Task {
                    await vm.updateworkingHours {
                        dismiss()
                    }
                }
            }
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let workingHours = Array(WorkingHour.samples.prefix(7))
    
    PharmacyEditWorkingHourScreen(
        pharmacyService: MockPharmacyService.sample,
        pharmacy: pharmacy,
        workingHours: workingHours
    )
}
