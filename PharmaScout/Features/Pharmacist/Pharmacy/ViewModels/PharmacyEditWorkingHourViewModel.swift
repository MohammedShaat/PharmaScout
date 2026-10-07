//
//  PharmacyEditWorkingHourViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/7/26.
//

import Foundation

@Observable
class PharmacyEditWorkingHourViewModel {
    private let pharmacyService: PharmacyService
    private let pharmacy: Pharmacy
    var workingHours: [WorkingHour]
    
    var deletedworkingHourIds: [String] = []
    
    var selectedDays: Set<DayOfWeek> {
        Set(workingHours.map { $0.day })
    }
    var availableDays: Set<DayOfWeek> {
        Set(DayOfWeek.allCases.filter { selectedDays.doesNotContain($0) })
    }
    
    var canAddWorkingHour: Bool { workingHours.count < 7 }
    var canUpdate: Bool { areHoursValid() }
    
    private(set) var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy, workingHours: [WorkingHour]) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
        self.workingHours = workingHours
    }
    
    func updateworkingHours(onSuccess: () -> Void) async {
        guard canUpdate else {
            print("Pharmacy working hours are invalid")
            return
        }
        
        loadingState.startLoading()
        defer { loadingState.stopLoading() }
        
        do {
            async let createOrUpdateWokringHours = pharmacyService.createOrUpdateWokringHours(workingHours: workingHours)
            async let deleteWokringHours = pharmacyService.deleteWokringHours(ids: deletedworkingHourIds)
            
            _ = try await (createOrUpdateWokringHours, deleteWokringHours)
            
            onSuccess()
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy working hours\n", error)
        }
    }
    
    func addWorkingHour() {
        guard let day = availableDays.first else {
            print("No available days")
            return
        }
        
        let newWorkingHour = WorkingHour(
            id: UUID().uuidString,
            pharmacyId: pharmacy.id,
            day: day,
            opensAt: .startOfToday,
            closesAt: .startOfToday
        )
        workingHours.append(newWorkingHour)
    }
    
    func deleteWorkingHour(_ workingHour: WorkingHour) {
        workingHours.removeAll { $0.id == workingHour.id }
        deletedworkingHourIds.append(workingHour.id)
    }
}

extension PharmacyEditWorkingHourViewModel {
    private func areHoursValid() -> Bool {
        workingHours.allSatisfy { workingHour in
            workingHour.opensAt < workingHour.closesAt
        }
    }
}
