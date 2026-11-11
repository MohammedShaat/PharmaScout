//
//  GreetingHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/4/26.
//

import SwiftUI

struct GreetingHeaderView: View {
    let user: AppUser?
    
    private var timeOfDay: TimeOfDay { Date.now.timeOfDay }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                HStack(spacing: DesignSystem.Spacing.xSmall) {
                    timeIcon
                    	
                    Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                        .foregroundStyle(.theme.textSecondary)
                }
                
                HStack(spacing: 0) {
                    Text("Good \(timeOfDay.title)")
                    
                    if let firstName = user?.firstName {
                        Text(", \(firstName)")
                    }
                }
                .lineLimit(1)
                .foregroundStyle(.theme.textPrimary)
                .font(.title3)
                .fontWeight(.bold)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var timeIcon: some View {
        switch timeOfDay {
        case .morning:
            Image(systemName: "sunrise.fill")
                .foregroundStyle(.theme.amber)
            
        case .afternoon:
                Image(systemName: "sun.max.fill")
                .foregroundStyle(.theme.goldenYellow)
            
        case .evening:
            Image(systemName: "moon.stars.fill")
                .foregroundStyle(.theme.mutedLavender)
        }
    }
}

#Preview {
    VStack {
        GreetingHeaderView(user: .samples[0])
            .padding()
        Spacer()
    }
}
