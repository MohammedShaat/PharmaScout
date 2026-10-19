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
        ScrollView {
            workingHourListSection
            
            addNewWorkingHourSection
            
            buttonSection
        }
        .padding(DesignSystem.Spacing.xLarge)
        .scrollDisabled(isSwipingAnItem)
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
    
    private func workingHourItemView(_ workingHour: Binding<WorkingHour>) -> some View {
        WorkingHourView(workingHour: workingHour, availableDays: vm.availableDays)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonSection: some View {
        PrimaryButtonView(title: "Save") {
            onSaveTapped?(vm.workingHours)
            dismiss()
        }
    }
}

#Preview {
    let workingHours = Array(WorkingHour.samples.prefix(7))
    
    CreateOrEditWorkingHoursScreen(workingHours: workingHours)
}
