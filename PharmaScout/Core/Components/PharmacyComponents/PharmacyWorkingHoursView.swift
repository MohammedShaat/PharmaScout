//
//  PharmacyWorkingHoursView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyWorkingHoursView: View {
    let workingHours: [WorkingHour]
    let loadingState: LoadingState
    
    var body: some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: workingHours.isEmpty,
            emptyMessage: "There is no working hours info"
        ) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    let pharmacy = Pharmacy.samples[0]
    let workingHours = WorkingHour.samples.filter { $0.pharmacyId == pharmacy.id }
    
    PharmacyWorkingHoursView(
        workingHours: workingHours,
        loadingState: LoadingState()
    )
    .padding()
}
