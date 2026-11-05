//
//  ChooseMedicineView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct EmptySearchView: View {
    var onChoosenMedicineTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack {
                Text("Find your medicine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                    .padding(.vertical, DesignSystem.Spacing.medium)
                
                Text("Tell us what you need and we'll ask nearby pharmacies if they have it in stock. Add one medicine or several, then choose how you'd like them sourced.")
                    .foregroundStyle(.theme.textSecondary)
            }
            .multilineTextAlignment(.center)
            
            VStack {
                Spacer()
                PrimaryButtonView(title: "Choose a medicine to start", action: onChoosenMedicineTapped)
            }
        }
    }
}

#Preview {
    CustomNavStack {
        EmptySearchView()
            .customNavBarVisibility(.root)
            .customNavTitle("Search")
            .padding(DesignSystem.Spacing.xLarge)
    }
}
