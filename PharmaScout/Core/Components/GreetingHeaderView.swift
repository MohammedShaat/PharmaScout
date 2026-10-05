//
//  GreetingHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/4/26.
//

import SwiftUI

struct GreetingHeaderView: View {
    let user: AppUser?
    let hasUnreadNotifications: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                    .foregroundStyle(.theme.textSecondary)
                
                HStack(spacing: 0) {
                    Text("Good \(Date.now.timeOfDay)")
                    
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
            
            BellView(hasUnreadNotifications: hasUnreadNotifications)
                .clickable()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let authService = MockAuthService.sample
    
    VStack {
        GreetingHeaderView(user: authService.authSession?.user, hasUnreadNotifications: true)
            .padding()
        Spacer()
    }
}
