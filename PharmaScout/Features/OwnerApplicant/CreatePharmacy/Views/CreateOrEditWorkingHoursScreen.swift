//
//  CreateOrEditWorkingHoursScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import SwiftUI
import Swipy

struct CreateOrEditWorkingHoursScreen: View {
    private let onSaveTapped: (([WorkingHour]) -> Void)?
    
    @State private var vm: CreateOrEditWorkingHoursViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSwipingAnItem = false
    
    init(workingHours: [WorkingHour], onSaveTapped: (([WorkingHour]) -> Void)? = nil) {
        self.onSaveTapped = onSaveTapped
        
        let viewModel = CreateOrEditWorkingHoursViewModel(workingHours: workingHours)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            ScrollView {
                VStack {
                    if vm.workingHours.isNotEmpty {
                        SwipeHintView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        workingHourListSection
                        
                        addNewWorkingHourSection
                    } else {
                        startSection
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            
            DividerView()
            
            saveSection
        }
        .customNavTitle("Working Hours")
        .scrollDisabled(isSwipingAnItem)
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
    
    private func workingHourItemView(_ workingHour: Binding<WorkingHour>) -> some View {
        WorkingHourEditView(workingHour: workingHour)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var startSection: some View {
        CreatePharmacyEmptyListView(
            systemName: "clock",
            title: "No working hours yet",
            subtitle: "Add opening times so patients know when to visit.",
            buttonTitle: "Set working hours",
            onButtonTapped: { vm.addWorkingHour() }
        )
    }
    
    private var saveSection: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            if let error = vm.workingHourError {
                ErrorView(title: "Couldn't save the working hours", description: error.errorDescription)
            }
            
            PrimaryButtonView(title: "Save", isDisabled: !vm.canSubmit) {
                if vm.checkWorkingHours() {
                    onSaveTapped?(vm.workingHours)
                    dismiss()
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xLarge)
        .padding(.top, DesignSystem.Spacing.small)
    }
}

#Preview {
    let workingHours = Array(WorkingHour.samples.prefix(0))
    
    CreateOrEditWorkingHoursScreen(workingHours: workingHours)
}
