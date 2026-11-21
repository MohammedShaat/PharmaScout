//
//  WorkingHourView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct WorkingHourEditView: View {
    @Binding var workingHour: WorkingHour
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text("Day")
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)

                Spacer()
                dayOfWeekPicker
            }
            
            HStack {
                timePicker(for: $workingHour.opensAt, label: "Opens")
                Spacer()
                timePicker(for: $workingHour.closesAt, label: "Closes")
            }
        }
    }
    
    private var dayOfWeekPicker: some View {
        Menu {
            Picker("Day", selection: $workingHour.day) {
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    Text(day.title)
                        .tag(day)
                }
            }
        } label: {
            HStack(spacing: DesignSystem.Spacing.small) {
                Label(workingHour.day.title, systemImage: "calendar")
                
                Image(systemName: "chevron.down")
                    .fontWeight(.regular)
                    .font(.callout)
            }
            .fontWeight(.bold)
            .foregroundStyle(.theme.green)
            .padding(DesignSystem.Spacing.medium)
            .roundedBackground(background: .theme.greenBackground)
        }
    }
    
    private func timePicker(for time: Binding<Date>, label: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.theme.blue)
            
            HStack(spacing: DesignSystem.Spacing.medium) {
                DatePicker("", selection: time, displayedComponents: .hourAndMinute)
                    .tint(.theme.textPrimary)
                    .labelsHidden()
                
                Image(systemName: "clock")
            }
            .padding(DesignSystem.Spacing.medium)
            .roundedBackground(background: .clear, radius: DesignSystem.CornerRadius.small, showBorder: true)
        }
    }
}

#Preview {
    @State @Previewable var workingHour = WorkingHour.samples[0]
    
    ZStack {	
        Color.theme.background.ignoresSafeArea()
        
        WorkingHourEditView(workingHour: $workingHour)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
            .padding()
    }
}
