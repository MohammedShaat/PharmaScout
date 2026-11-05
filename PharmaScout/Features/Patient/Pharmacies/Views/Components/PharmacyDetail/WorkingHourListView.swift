//
//  PharmacyWorkingHourView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct WorkingHourListView: View {
    let workingHours: [WorkingHour]
    
    private var workingDays: [WorkingDay] { workingDayFromWorkingHour(workingHours) }
    
    var body: some View {
        CustomList(
            items: workingDays,
            isLoadingMore: false
        ) { workingDay in
            HStack {
                // Day of week
                Text(workingDay.day.title)
                    .font(workingDay.isToday ? .headline : .body)
                // Today chip
                if workingDay.isToday {
                    Text("Today")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.theme.white)
                        .padding(.horizontal, DesignSystem.Spacing.small)
                        .padding(.vertical, DesignSystem.Spacing.xSmall)
                        .roundedBackground(background: .theme.secondaryStrong)
                }
                
                Spacer()
                
                // Times
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    ForEach(workingDay.hours) { hour in
                        Text("\(hour.opensAt) - \(hour.closesAt)")
                    }
                }
            }
            .foregroundStyle(.theme.textPrimary)
            .fontWeight(workingDay.isToday ? .bold : .regular)
            .padding(.horizontal, DesignSystem.Spacing.small)
            .padding(.vertical, workingDay.isToday ? DesignSystem.Spacing.medium : 0)
            .padding(.vertical, workingDay.isToday ? DesignSystem.Spacing.xSmall : 0)
            .roundedBackground(
                background: workingDay.isToday ? .theme.mintTint : .clear,
                radius: DesignSystem.Spacing.small
            )
        }
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        WorkingHourListView(workingHours: WorkingHour.samples)
            .padding()
//            .roundedBackground()
    }
}
