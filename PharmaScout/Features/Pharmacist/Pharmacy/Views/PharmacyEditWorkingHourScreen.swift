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
                Swipy(
                    isSwipingAnItem: $isSwipingAnItem,
                    swipeActionsMargin: SwipyHorizontalMargin(
                        leading: DesignSystem.Spacing.xSmall,
                        trailing: DesignSystem.Spacing.xSmall
                    ),
                    swipeBehavior: .straight
                ) { model in
                    contactItemView($workingHour)
                    
                } actions: {
                    SwipyAction { model in
                        Button(role: .destructive) {
                            vm.deleteWorkingHour(workingHour)
                            model.unswipe()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var addNewWorkingHourSection: some View {
        if vm.canAddWorkingHour {
            Text("Add day")
                .foregroundStyle(.theme.textPrimary)
                .padding(.vertical, DesignSystem.Spacing.small)
                .clickable(action: vm.addWorkingHour)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = vm.loadingState.error {
            Text(error.errorDescription)
        }
    }
    
    private func contactItemView(_ workingHour: Binding<WorkingHour>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Day")
                
                
                Picker("Day", selection: workingHour.day) {
                    ForEach(daysToDisplay(workingHour.day.wrappedValue), id: \.self) { day in
                        Text(day.rawValue.capitalized)
                    }
                }
            }
            
            HStack {
                DatePicker("Opens", selection: workingHour.opensAt, displayedComponents: .hourAndMinute)
                
                DatePicker("Closes", selection: workingHour.closesAt, displayedComponents: .hourAndMinute)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonSection: some View {
        PrimaryButtonView(
            title: "Save",
            isDisabled: !vm.canUpdate,
            isLoading: vm.loadingState.status != .idle) {
                updateTask?.cancel()
                updateTask = Task {
                    await vm.updateworkingHours {
                        dismiss()
                    }
                }
            }
    }
    
    private func daysToDisplay(_ currentDay: DayOfWeek) -> [DayOfWeek] {
        let days = vm.availableDays.union([currentDay])
        return Array(days)
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let workingHours = WorkingHour.samples.filter { $0.pharmacyId == pharmacy.id }
    
    PharmacyEditWorkingHourScreen(
        pharmacyService: MockPharmacyService.sample,
        pharmacy: pharmacy,
        workingHours: workingHours
    )
}
