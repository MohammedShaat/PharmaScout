
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
            initialLetters
            
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
    
    private var initialLetters: some View {
        Circle()
            .fill(.theme.mintTint)
            .frame(width: 80)
            .overlay {
                if let fullName = user.fullName {
                    Text(initials(from: fullName))
                        .font(.system(size: 36))
                        .fontWeight(.heavy)
                        .foregroundStyle(.theme.textPrimary)
                } else {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 60))
                        .padding(DesignSystem.Spacing.small)
                        .foregroundStyle(.theme.textPrimary)
                }
            }
    }
    
    func initials(from fullName: String) -> String {
        fullName
            .split(separator: " ")
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }
}

#Preview {
    UserBasicInfoView(user: .samples[0])
}
