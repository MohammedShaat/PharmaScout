//
//  PharmacyApplication+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import Foundation

extension PharmacyApplication {
    static let samples = [
        PharmacyApplication(
            id: "app-001",
            name: "Al-Shifa Pharmacy",
            latitude: 31.5286,
            longitude: 34.4521,
            address: "Al-Nasr Street, Gaza City",
            timezone: "Asia/Gaza",
            status: .pending,
            createdAt: Date.now,
            reviewedBy: nil,
            reviewedAt: nil,
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-002",
            name: "Al-Hayat Pharmacy",
            latitude: 31.9029,
            longitude: 35.2045,
            address: "Rafidia Street, Nablus",
            timezone: "Asia/Hebron",
            status: .approved,
            createdAt: Date.now.addingTimeInterval(-86400 * 10),
            reviewedBy: "admin-001",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 8),
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-003",
            name: "Al-Amal Pharmacy",
            latitude: 31.5326,
            longitude: 34.4875,
            address: "Omar Al-Mukhtar Street, Gaza City",
            timezone: "Asia/Gaza",
            status: .rejected,
            createdAt: Date.now.addingTimeInterval(-86400 * 15),
            reviewedBy: "admin-002",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 12),
            rejectionReason: "Incomplete pharmacy license documentation."
        ),
        PharmacyApplication(
            id: "app-004",
            name: "Al-Noor Pharmacy",
            latitude: 31.9522,
            longitude: 35.2332,
            address: "Al-Bireh Main Street, Al-Bireh",
            timezone: "Asia/Hebron",
            status: .pending,
            createdAt: Date.now.addingTimeInterval(-86400 * 2),
            reviewedBy: nil,
            reviewedAt: nil,
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-005",
            name: "Al-Rahma Pharmacy",
            latitude: 31.7054,
            longitude: 35.2024,
            address: "Bethlehem Main Street, Bethlehem",
            timezone: "Asia/Hebron",
            status: .approved,
            createdAt: Date.now.addingTimeInterval(-86400 * 30),
            reviewedBy: "admin-001",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 28),
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-006",
            name: "Al-Aqsa Pharmacy",
            latitude: 31.7767,
            longitude: 35.2345,
            address: "Salah al-Din Street, Jerusalem",
            timezone: "Asia/Hebron",
            status: .suspended,
            createdAt: Date.now.addingTimeInterval(-86400 * 60),
            reviewedBy: "admin-003",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 5),
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-007",
            name: "Al-Wafa Pharmacy",
            latitude: 32.2211,
            longitude: 35.2544,
            address: "City Center, Tulkarm",
            timezone: "Asia/Hebron",
            status: .pending,
            createdAt: Date.now.addingTimeInterval(-86400 * 4),
            reviewedBy: nil,
            reviewedAt: nil,
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-008",
            name: "Al-Basma Pharmacy",
            latitude: 32.4609,
            longitude: 35.3000,
            address: "City Center, Jenin",
            timezone: "Asia/Hebron",
            status: .rejected,
            createdAt: Date.now.addingTimeInterval(-86400 * 20),
            reviewedBy: "admin-002",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 18),
            rejectionReason: "The submitted pharmacy details could not be verified."
        ),
        PharmacyApplication(
            id: "app-009",
            name: "Al-Fajr Pharmacy",
            latitude: 31.3448,
            longitude: 34.3063,
            address: "Khan Younis Main Street, Khan Younis",
            timezone: "Asia/Gaza",
            status: .approved,
            createdAt: Date.now.addingTimeInterval(-86400 * 45),
            reviewedBy: "admin-001",
            reviewedAt: Date.now.addingTimeInterval(-86400 * 42),
            rejectionReason: nil
        ),
        PharmacyApplication(
            id: "app-010",
            name: "Al-Balsam Pharmacy",
            latitude: 31.4167,
            longitude: 34.3333,
            address: "City Center, Deir al-Balah",
            timezone: "Asia/Gaza",
            status: .pending,
            createdAt: Date.now.addingTimeInterval(-3600 * 6),
            reviewedBy: nil,
            reviewedAt: nil,
            rejectionReason: nil
        )
    ]
}
