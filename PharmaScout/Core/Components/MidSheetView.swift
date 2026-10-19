//
//  MidSheetView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/22/26.
//

import SwiftUI

struct MidSheetView: View {
    let title: String
    var actionTitle: String = "Ok"
    var onActionButtonTapped: (() -> Void)?
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundStyle(.theme.success)
                .font(.title2)
            
            PrimaryButtonView(title: actionTitle) {
                onActionButtonTapped?()
            }
        }
        .presentationDetents([.medium])
        .padding(DesignSystem.Spacing.xLarge)
    }
}

#Preview {
    MidSheetView(title: "Your request has been submitted successfully")
}
