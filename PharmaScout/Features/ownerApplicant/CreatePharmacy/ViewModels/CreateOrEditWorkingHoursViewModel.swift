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
    var availableDays: Set<DayOfWeek> {
        Set(DayOfWeek.allCases.filter { selectedDays.doesNotContain($0) })
    }
    
    var canAddWorkingHour: Bool { workingHours.count < 7 }
    
    init(workingHours: [WorkingHour]) {
        self.workingHours = workingHours
    }
    
    func addWorkingHour() {
        guard let day = availableDays.first else {
            print("No available days")
            return
        }
        
        let newWorkingHour = WorkingHour(
            id: UUID().uuidString,
            day: day,
            opensAt: .startOfToday,
            closesAt: .startOfToday
        )
        workingHours.append(newWorkingHour)
    }
    
    func deleteWorkingHour(_ workingHour: WorkingHour) {
        workingHours.removeAll { $0.id == workingHour.id }
    }
}
