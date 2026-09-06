//
//  PharmaScoutLabelView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct PharmaScoutLabelView: View {
    var isLarge: Bool = true
    
    var body: some View {
        HStack(spacing: Spacing.large) {
            Image(.pill)
                .resizable()
                .scaledToFit()
                .frame(width: isLarge ? 15 : 10)
                .shadow(radius: 3)
            
            Text("PharmaScout")
                .font(isLarge ? .title : .body)
                .fontWeight(.bold)
                .foregroundStyle(.theme.primary)
        }
    }
}

#Preview {
    VStack {
        PharmaScoutLabelView()
        PharmaScoutLabelView(isLarge: false)
    }
}
