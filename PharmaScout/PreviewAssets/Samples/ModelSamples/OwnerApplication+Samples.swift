//
//  OwnerApplication+Samples.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import Foundation

extension OwnerApplication {
    static let samples = [
        OwnerApplication(
            id: "a1000001-0000-4000-8000-000000000001",
            code: "OWN7K2",
            createdBy: "b1000001-0000-4000-8000-000000000001",
            applicantId: nil,
            status: .issued,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-19T14:00:00Z")!,
            redeemedAt: nil,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-18T14:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000002-0000-4000-8000-000000000002",
            code: "OWN9M4",
            createdBy: "b1000001-0000-4000-8000-000000000001",
            applicantId: "c1000001-0000-4000-8000-000000000001",
            status: .pending,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-20T10:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-18T10:00:00Z")!,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-17T10:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000003-0000-4000-8000-000000000003",
            code: "OWN3P8",
            createdBy: "b1000002-0000-4000-8000-000000000002",
            applicantId: "c1000002-0000-4000-8000-000000000002",
            status: .approved,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-15T12:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-12T12:00:00Z")!,
            reviewedBy: "d1000001-0000-4000-8000-000000000001",
            reviewedAt: ISO8601DateFormatter().date(from: "2026-10-13T09:00:00Z")!,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-11T12:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000004-0000-4000-8000-000000000004",
            code: "OWN5R6",
            createdBy: "b1000002-0000-4000-8000-000000000002",
            applicantId: "c1000003-0000-4000-8000-000000000003",
            status: .rejected,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-16T08:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-14T08:00:00Z")!,
            reviewedBy: "d1000001-0000-4000-8000-000000000001",
            reviewedAt: ISO8601DateFormatter().date(from: "2026-10-15T11:30:00Z")!,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-13T08:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000005-0000-4000-8000-000000000005",
            code: "OWN8T1",
            createdBy: "b1000001-0000-4000-8000-000000000001",
            applicantId: nil,
            status: .revoked,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-21T16:00:00Z")!,
            redeemedAt: nil,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-18T16:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000006-0000-4000-8000-000000000006",
            code: "OWN2V7",
            createdBy: "b1000003-0000-4000-8000-000000000003",
            applicantId: nil,
            status: .issued,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-19T09:30:00Z")!,
            redeemedAt: nil,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-18T09:30:00Z")!
        ),
        OwnerApplication(
            id: "a1000007-0000-4000-8000-000000000007",
            code: "OWN4N9",
            createdBy: "b1000003-0000-4000-8000-000000000003",
            applicantId: "c1000004-0000-4000-8000-000000000004",
            status: .pending,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-22T13:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-17T13:00:00Z")!,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-16T13:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000008-0000-4000-8000-000000000008",
            code: "OWN6W3",
            createdBy: "b1000002-0000-4000-8000-000000000002",
            applicantId: "c1000005-0000-4000-8000-000000000005",
            status: .approved,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-14T15:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-10T15:00:00Z")!,
            reviewedBy: "d1000002-0000-4000-8000-000000000002",
            reviewedAt: ISO8601DateFormatter().date(from: "2026-10-11T10:00:00Z")!,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-09T15:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000009-0000-4000-8000-000000000009",
            code: "OWN1X5",
            createdBy: "b1000003-0000-4000-8000-000000000003",
            applicantId: "c1000006-0000-4000-8000-000000000006",
            status: .rejected,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-18T11:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-17T11:00:00Z")!,
            reviewedBy: "d1000002-0000-4000-8000-000000000002",
            reviewedAt: ISO8601DateFormatter().date(from: "2026-10-18T08:30:00Z")!,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-16T11:00:00Z")!
        ),
        OwnerApplication(
            id: "a1000010-0000-4000-8000-000000000010",
            code: "OWN0Z2",
            createdBy: "b1000001-0000-4000-8000-000000000001",
            applicantId: "c1000007-0000-4000-8000-000000000007",
            status: .pending,
            expiresAt: ISO8601DateFormatter().date(from: "2026-10-23T17:00:00Z")!,
            redeemedAt: ISO8601DateFormatter().date(from: "2026-10-18T17:00:00Z")!,
            reviewedBy: nil,
            reviewedAt: nil,
            createdAt: ISO8601DateFormatter().date(from: "2026-10-17T17:00:00Z")!
        )
    ]
}
