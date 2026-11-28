
//  UserBasicInfo.swift
//  PharmaScout
//
//  Created by Mohammed on 11/11/26.
//

import SwiftUI

struct UserBasicInfoView: View {
    let user: AppUser
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.large) {
            UserProfileImageView(fullName: user.fullName)
                .frame(width: 80)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text(user.fullName ?? "User")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(user.email ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
            }
            Spacer()
        }
    }
}

#Preview {
    UserBasicInfoView(user: .samples[0])
}
