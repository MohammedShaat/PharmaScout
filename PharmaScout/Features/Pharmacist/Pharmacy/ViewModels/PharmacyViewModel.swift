//
//  PharmacyViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import Foundation

@Observable
class PharmacyViewModel {
    private let authService: AuthService
    private let pharmacyService: PharmacyService
    
    var authSession: AuthSession? { authService.authSession }
    var pharmacyId: String? { authSession?.pharmacyStaff?.pharmacyId }
    
    private(set) var pharmacy: Pharmacy?
    private(set) var contacts: [PharmacyContact] = []
    private(set) var workingHours: [WorkingHour] = []
    private(set) var pharmacyStaff: [PharmacyStaffMember] = []
    
    var isOwner: Bool { authSession?.pharmacyStaff?.role == .owner }
    
    private(set) var pharmacyLoadingState = LoadingState()
    private(set) var contactLoadingState = LoadingState()
    private(set) var workingHoursLoadingState = LoadingState()
    private(set) var staffLoadingState = LoadingState()
    
    private var hasStarted: Bool = false
    private var firstLoadTask: Task<Void, Never>?
    
    init(authService: AuthService, pharmacyService: PharmacyService) {
        self.authService = authService
        self.pharmacyService = pharmacyService
    }
    
    deinit {
        firstLoadTask?.cancel()
    }
    
    func loadDataIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        
        firstLoadTask = Task {
            async let loadPharmacy = loadPharmacy()
            async let loadContact = loadContact()
            async let loadWorkingHours = loadWorkingHours()
            async let loadStaff = loadStaff()
            
            _ = await (loadPharmacy, loadContact, loadWorkingHours, loadStaff)
        }
    }
    
    func refresh() async {
        async let loadPharmacy = loadPharmacy(refresh: true)
        async let loadContact = loadContact(refresh: true)
        async let loadWorkingHours = loadWorkingHours(refresh: true)
        async let loadStaff = loadStaff()
        
        _ = await (loadPharmacy, loadContact, loadWorkingHours, loadStaff)
    }
    
    
 
    private func loadPharmacy(refresh: Bool = false) async {
        guard let pharmacyId else {
            pharmacyLoadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        pharmacyLoadingState.startLoading(refresh: refresh)
        defer { pharmacyLoadingState.stopLoading() }
        
        do {
            let params = GetPharmacyDetailsParams(pharmacyId: pharmacyId, latitude: 0, longitude: 0)
            pharmacy = try await pharmacyService.getPharmacy(params)
            
        } catch {
            pharmacyLoadingState.fail(error)
            print("Failed to load pharmacy\n", error)
        }
    }
    
    private func loadContact(refresh: Bool = false) async {
        guard let pharmacyId else {
            contactLoadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        contactLoadingState.startLoading(refresh: refresh)
        defer { contactLoadingState.stopLoading() }
        
        do {
            contacts = try await pharmacyService.getContactInfo(for: pharmacyId)
            
        } catch {
            contactLoadingState.fail(error)
            print("Failed to get pharmacy contacts\n", error)
        }
    }
    
    private func loadWorkingHours(refresh: Bool = false) async {
        guard let pharmacyId else {
            workingHoursLoadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        workingHoursLoadingState.startLoading(refresh: refresh)
        defer { workingHoursLoadingState.stopLoading() }
        
        do {
            workingHours = try await pharmacyService.getWorkingHours(for: pharmacyId)

        } catch {
            workingHoursLoadingState.fail(error)
            print("Failed to get pharmacy working hours\n", error)
        }
    }
    
    private func loadStaff(refresh: Bool = false) async {
        guard let pharmacyId, isOwner else {
            staffLoadingState.fail(PharmacyStaffError.notFound)
            print("No pharmacy id")
            return
        }
        
        staffLoadingState.startLoading(refresh: refresh)
        defer { staffLoadingState.stopLoading() }
        
        do {
            pharmacyStaff = try await pharmacyService.getStaff(for: pharmacyId)

        } catch {
            staffLoadingState.fail(error)
            print("Failed to get pharmacy staff\n", error)
        }
    }
}
