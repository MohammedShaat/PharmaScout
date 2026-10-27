//
//  WorkingHourView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct WorkingHourView: View {
    @Binding var workingHour: WorkingHour
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Day")
                
                
                Picker("Day", selection: $workingHour.day) {
                    ForEach(DayOfWeek.allCases) { day in
                        Text(day.rawValue.capitalized)
                            .tag(day)
                    }
                }
            }
            
            HStack {
                DatePicker("Opens", selection: $workingHour.opensAt, displayedComponents: .hourAndMinute)
                
                DatePicker("Closes", selection: $workingHour.closesAt, displayedComponents: .hourAndMinute)
            }
        }
    }
}

#Preview {
    @State @Previewable var workingHour = WorkingHour.samples[0]
    
    WorkingHourView(workingHour: $workingHour)
        .padding()
}
