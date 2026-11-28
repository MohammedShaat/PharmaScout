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
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                SwipeHintView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                workingHourListSection
                
                addNewWorkingHourSection
            }
            
            if let error = vm.loadingState.error {
                ErrorView(title: "Couldn't update the working hours", description: error.errorDescription)
            }
            
            saveButton
        }
        .customNavTitle("Working Hours")
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
        .onDisappear {
            updateTask?.cancel()
        }
    }
    
    private var workingHourListSection: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            ForEach($vm.workingHours) { $workingHour in
                SwipyView(
                    isSwipingAnItem: $isSwipingAnItem) {
                        WorkingHourEditView(workingHour: $workingHour)
                            .padding(DesignSystem.Spacing.large)
                            .roundedBackground()
                    } onDeleteTapped: {
                        vm.deleteWorkingHour(workingHour)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var addNewWorkingHourSection: some View {
        SecondaryButtonView(title: "Add working hour", systemName: "plus", action: vm.addWorkingHour)
            .padding(DesignSystem.Spacing.large)
    }
    
    private var saveButton: some View {
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
    
    CustomNavStack {
        PharmacyEditWorkingHourScreen(
            pharmacyService: MockPharmacyService.sample,
            pharmacy: pharmacy,
            workingHours: workingHours
        )
    }
}
