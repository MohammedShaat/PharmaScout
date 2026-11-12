//
//  GreetingHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/4/26.
//

import SwiftUI

struct GreetingHeaderView: View {
    let firstName: String?
    let isPharmacist: Bool
    
    private var timeOfDay: TimeOfDay { Date.now.timeOfDay }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            
            if isPharmacist {
                pharmacistLabel
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Label {
                Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                    .foregroundStyle(.theme.textSecondary)
            } icon: {
                timeIcon
            }
            .font(.callout)
            
            HStack(spacing: 0) {
                Text("Good \(timeOfDay.title)")
                
                if let firstName {
                    Text(", \(firstName)")
                }
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.theme.textPrimary)
            
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
    
    private var pharmacistLabel: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Image(systemName: "circle.fill")
                .font(.caption2)
                .foregroundStyle(.theme.green)
            
            Text("Pharmacist")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.theme.textPrimary)
        }
        .capsuleBackground(background: .theme.mintTint)
    }
}

#Preview {
    VStack (spacing: 50){
        GreetingHeaderView(firstName: "Mohammed")
            .padding()
        
        GreetingHeaderView(firstName: "Mohammed", isPharmacist: true)
            .padding()
    }
}


extension GreetingHeaderView {
    init(firstName: String?) {
        self.init(firstName: firstName, isPharmacist: false)
    }
}
