//
//  WorkingHour.swift
//  PharmaScout
//
//  Created by Mohammed on 9/23/26.
//

import Foundation

struct WorkingHour: Codable, Identifiable {
    let id: String
    var day: DayOfWeek
    var opensAt: Date
    var closesAt: Date
}

enum DayOfWeek: String, Codable, CaseIterable, Identifiable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var id: String { rawValue }
}




// MARK: - DayOfWeek index conversion
extension DayOfWeek {
    init(from index: Int) {
        switch index {
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        default: self = .sunday
        }
    }
    
    func toIndex() -> Int {
        switch self {
        case .monday: 1
        case .tuesday: 2
        case .wednesday: 3
        case .thursday: 4
        case .friday: 5
        case .saturday: 6
        case .sunday: 7
        }
    }
}


// MARK: - WorkingHour encoder & decoder
extension WorkingHour {
    enum CodingKeys: String, CodingKey {
        case id
        case day
        case opensAt
        case closesAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        let dayInt = try container.decode(Int.self, forKey: .day)
        self.day = .init(from: dayInt)

        let opensAtStr = try container.decode(String.self, forKey: .opensAt)
        self.opensAt = opensAtStr.toDateFromTime() ?? .startOfToday

        let closesAtStr = try container.decode(String.self, forKey: .closesAt)
        self.closesAt = closesAtStr.toDateFromTime() ?? .startOfToday
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        let dayIndex = self.day.toIndex()
        try container.encode(dayIndex, forKey: .day)
        
        let opensAtStr = self.opensAt.timeString
        try container.encode(opensAtStr, forKey: .opensAt)
        
        let closesAtStr = self.closesAt.timeString
        try container.encode(closesAtStr, forKey: .closesAt)
    }
}
