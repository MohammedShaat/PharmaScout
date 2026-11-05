//
//  CustomeHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomeNavBarView: View {
    var title: String? = nil
    var showBackButton: Bool = true
    var style: NavBarStyle = .standard
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 0) {
            if style == .standard {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.theme.textPrimary)
                        .background(.red.opacity(0.001))
                }
                .buttonStyle(.plain)
    
                Spacer()
            }
            
            if let title{
                Text(title)
                    .foregroundStyle(.theme.textPrimary)
                    .font(style == .root ? .largeTitle : .body)
                    .fontWeight(style == .root ? .bold : .semibold)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Image(systemName: "chevron.left")
                .padding(.horizontal, DesignSystem.Spacing.xLarge)
                .font(.title2)
                .background(.red.opacity(0.001))
                .opacity(0)
        }
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

#Preview {
    VStack {
        CustomeNavBarView(title: "Nav Title", showBackButton: false)
        
        Spacer()
    }
}
