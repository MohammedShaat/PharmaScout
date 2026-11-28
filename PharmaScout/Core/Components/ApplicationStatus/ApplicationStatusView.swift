//
//  ApplicationStatusView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/19/26.
//

import SwiftUI

struct ApplicationStatusView<Content: View>: View {
    let title: String

    let mainIconSystemName: String
    let mainIconColor: Color
    let mainIconBgColor: Color
    
    let statusLabel: String
    let statusIconSystemName: String
    let statusIconColor: Color
    let statusIconBgColor: Color
    
    @ViewBuilder	 let content: Content
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            VStack(spacing: DesignSystem.Spacing.large) {
                BigIconView(
                    systemName: mainIconSystemName,
                    iconColor: mainIconColor,
                    bgColor: mainIconBgColor
                )
                
                Label(statusLabel, systemImage: statusIconSystemName)
                    .fontWeight(.semibold)
                    .foregroundStyle(statusIconColor)
                    .capsuleBackground(background: statusIconBgColor)
            }
            
            VStack(spacing: DesignSystem.Spacing.large) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                content
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ApplicationStatusView(
        title: "Your request is pending",
        
        mainIconSystemName: "clock",
        mainIconColor: .theme.primary,
        mainIconBgColor: .theme.mintTint,
        
        statusLabel: "Pending",
        statusIconSystemName: "clock",
        statusIconColor: .theme.primary,
        statusIconBgColor: .theme.mintTint,
    ) {
        
    }
}

