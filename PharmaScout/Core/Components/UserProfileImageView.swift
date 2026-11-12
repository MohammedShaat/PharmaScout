//
//  UserProfileImageView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct UserProfileImageView: View {
    let fullName: String?
    
    @State private var size: Double = 0
    
    var body: some View {
        Circle()
            .fill(.theme.mintTint)
            .readFrame { size = min($0.size.width, $0.size.height) }
            .overlay {
                if let fullName = fullName {
                    Text(initials(from: fullName))
                        .font(.system(size: size / 2.3))
                        .fontWeight(.heavy)
                        .foregroundStyle(.theme.textPrimary)
                } else {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: size / 1.2))
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
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        VStack(spacing: 50) {
            Group {
                UserProfileImageView(fullName: "Yusuf Masour")
                    .frame(width: 80, height: 80)
                
                UserProfileImageView(fullName: "Yusuf Masour")
                    .frame(width: 50, height: 50)
                
                UserProfileImageView(fullName: nil)
                    .frame(width: 80, height: 80)
            }
            .background(.red.opacity(0.2))
        }
    }
}
