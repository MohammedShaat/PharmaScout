//
//  CreateOrEditWorkingHoursViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/21/26.
//

import Foundation

@Observable
class CreateOrEditWorkingHoursViewModel {
    var workingHours: [WorkingHour]
    
    var selectedDays: Set<DayOfWeek> {
        Set(workingHours.map { $0.day })
    }
    var workingHourError: WorkingHourError?
    
    init(workingHours: [WorkingHour]) {
        self.workingHours = workingHours
    }
    
    func addWorkingHour() {
        let newWorkingHour = WorkingHour(
            id: UUID().uuidString,
            day: .init(from: .random(in: 1...7)),
            opensAt: .startOfToday,
            closesAt: .startOfToday
        )
        workingHours.append(newWorkingHour)
    }
    
    func deleteWorkingHour(_ workingHour: WorkingHour) {
        workingHours.removeAll { $0.id == workingHour.id }
    }
    
    func checkWorkingHours() -> Bool {
        workingHourError = getFirstValidationError()
        return workingHourError == nil
    }
    
    private func getFirstValidationError() -> WorkingHourError? {
        return workingHours.compactMap(\.validationError).first
    }
}
