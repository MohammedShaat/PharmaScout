//
//  PharmacyStaffMemeberView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyStaffMemeberView: View {
    let member: PharmacyStaffMember
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
            // Profile icon
            UserProfileImageView(fullName: member.userInfo.fullName)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                // Name & email
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
                    Text(member.userInfo.fullName ?? "")
                        .fontWeight(.bold)
                        .foregroundStyle(.theme.textPrimary)
                    
                    Text(member.userInfo.email ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                }
                
                // Role & status
                HStack(spacing: DesignSystem.Spacing.medium) {
                    StaffMemeberRoleView(role: member.role)
                        .fontWeight(member.role == .owner ? .bold : .regular)

                    if isCurrentUser {
                        Text("You")
                            .foregroundStyle(.theme.green)
                            .capsuleBackground(background: .clear, showBorder: true, borderColor: .theme.green)
                    } else {
                        StaffMemeberStatusView(status: member.status)
                    }
                }
                .font(.subheadline)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        PharmacyStaffMemeberView(member: .samples[0], isCurrentUser: false)
        
        PharmacyStaffMemeberView(member: .samples[1], isCurrentUser: false)
        
        PharmacyStaffMemeberView(member: .samples[0], isCurrentUser: true)
    }
    .padding()
}
