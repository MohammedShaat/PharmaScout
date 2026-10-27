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
    
    private(set) var loadingState = LoadingState()
    
    init(pharmacyService: PharmacyService, pharmacy: Pharmacy, workingHours: [WorkingHour]) {
        self.pharmacyService = pharmacyService
        self.pharmacy = pharmacy
        self.workingHours = workingHours
    }
    
    func updateworkingHours(onSuccess: () -> Void) async {
        
        do {
            try checkWorkingHoursAreValid()
            
            loadingState.startLoading()
            defer { loadingState.stopLoading() }

            let request = UpdateOrCreatePharmacyHoursRequest(
                hours: workingHours.map { UpdatePharmacyHour($0, pharmacyId: pharmacy.id)  }
            )
            async let createOrUpdateWokringHours = pharmacyService.createOrUpdateWokringHours(request)
            async let deleteWokringHours = pharmacyService.deleteWokringHours(ids: deletedworkingHourIds)
            
            _ = try await (createOrUpdateWokringHours, deleteWokringHours)
            
            onSuccess()
            
        } catch {
            loadingState.fail(error)
            print("Failed to update pharmacy working hours\n", error)
        }
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
        deletedworkingHourIds.append(workingHour.id)
    }
    
    private func checkWorkingHoursAreValid() throws {
        try workingHours.forEach { workingHour in
            if let error = workingHour.validationError {
                throw error
            }
        }
    }
}
