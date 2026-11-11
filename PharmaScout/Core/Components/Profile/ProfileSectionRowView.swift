//
//  ProfileSessionRowView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/12/26.
//

import SwiftUI

struct ProfileSectionRowView: View {
    let title: String
    var description: String? = nil
    let systemName: String
    var color: Color = .theme.primary
    var isLoading: Bool = false
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            IconView(systemName: systemName, size: 45, iconColor: color)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                
                if let description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                }
            }
            
            Spacer()
            if isLoading {
                RingProgressView()
            }
        }
    }
}

#Preview {
    ProfileSectionRowView(
        title: "Log out",
        systemName: "rectangle.portrait.and.arrow.right",
        isLoading: false
    )
}
