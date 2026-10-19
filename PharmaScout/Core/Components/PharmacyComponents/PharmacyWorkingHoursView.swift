//
//  PharmacyWorkingHoursView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyWorkingHoursView: View {
    let workingHours: [WorkingHour]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            ForEach(workingHours) { workinghour in
                VStack(alignment: .leading) {
                    Text(workinghour.day.rawValue.capitalized)
                    
                    HStack {
                        Text("Opens at: ")
                        Text(workinghour.opensAt.formattedTime)
                    }
                    
                    HStack {
                        Text("Closes at: ")
                        Text(workinghour.closesAt.formattedTime)
                    }
                }
                .background(.gray.opacity(0.2))
            }
        }
    }
}

#Preview {
    let workingHours = Array(WorkingHour.samples.prefix(7))
    
    PharmacyWorkingHoursView(workingHours: workingHours)
        .padding()
}
