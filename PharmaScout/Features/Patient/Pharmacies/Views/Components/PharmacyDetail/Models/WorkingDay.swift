//
//  WorkingDay.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import Foundation

struct WorkingDay: Identifiable {
    let day: DayOfWeek
    let hours: [Hour]
    
    var id: DayOfWeek { day }
    
    var isToday: Bool {
        day.toIndex() == Calendar.current.component(.weekday, from: .now) + 6 - 7
    }
}

struct Hour: Identifiable {
    let opensAt: String
    let closesAt: String
    
    var id: String { UUID().uuidString }
    
    init(from workingHour: WorkingHour) {
        self.opensAt = workingHour.opensAt.hourMinute
        self.closesAt = workingHour.closesAt.hourMinute
    }
}

func workingDayFromWorkingHour(_ workingHours: [WorkingHour]) -> [WorkingDay] {
    let workingHoursDic = Dictionary(grouping: workingHours) { workingHour in
        workingHour.day
    }
    
    return workingHoursDic.map { pair in
        WorkingDay(
            day: pair.key,
            hours: pair.value.map(Hour.init)
        )
    }
}
