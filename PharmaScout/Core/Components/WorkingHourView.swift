//
//  WorkingHourView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct WorkingHourView: View {
    @Binding var workingHour: WorkingHour
    let availableDays: Set<DayOfWeek>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Day")
                
                
                Picker("Day", selection: $workingHour.day) {
                    ForEach(daysToDisplay($workingHour.day.wrappedValue), id: \.self) { day in
                        Text(day.rawValue.capitalized)
                    }
                }
            }
            
            HStack {
                DatePicker("Opens", selection: $workingHour.opensAt, displayedComponents: .hourAndMinute)
                
                DatePicker("Closes", selection: $workingHour.closesAt, displayedComponents: .hourAndMinute)
            }
        }
    }
    
    private func daysToDisplay(_ currentDay: DayOfWeek) -> [DayOfWeek] {
        let days = availableDays.union([currentDay])
        return Array(days)
    }
}

#Preview {
    @State @Previewable var workingHour = WorkingHour.samples[0]
    
    WorkingHourView(
        workingHour: $workingHour,
        availableDays: [.monday, .tuesday, .wednesday]
    )
}
